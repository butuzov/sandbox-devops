#!/usr/bin/env python3

import boto3, json, sys, logging, re, time
from botocore.exceptions import ClientError


#### Handler ###################################################################

def main(event, context):
    """ Our Handler """
    ec2 = boto3.resource('ec2')
    Instances( ec2=ec2 , Logged=False )
    Images( ec2=ec2, Logged=False )

#### Fucntionality #############################################################
class Logger(object):
    """ logging wraper """

    def __init__(self, is_logged):

        self.logging = is_logged
        self.__main__()

    def __main__(self):
        """ handler """

        if self.logging is False:
            return

        self.logger = logging.getLogger()
        self.logger.setLevel(logging.INFO)

        ch = logging.StreamHandler(sys.stdout)
        ch.setLevel(logging.DEBUG)
        self.logger.addHandler(ch)

    def log(self, debug, message ):
        """ Logging """

        if self.logging is False:
            return

        if debug == "info":
            self.logger.info( message )

        if debug == "warning":
            self.logger.warning( message )


class Instances(object):

    """ Create Images (AMI) or Instances """
    def __init__(self, ec2, Logged=False):
        self.ec2 = ec2
        self.logger = Logger(Logged)

        # running backup procedure
        self.__main__()

    def __main__(self):
        """ Create instances (with tag `backup`) AMI Images"""
        filters = [ { 'Name': 'tag-key', 'Values': ['backup'] } ]
        [ self.backup(i) for i in self.ec2.instances.filter(Filters=filters) ]


    def backup(self, instance):
        """ Performs a backup operation for ec2 instance"""

        # Looking for Name tag value
        names = [ i.get('Value', None) for i in instance.tags if i.get('Key', None) == 'Name' ]

        # Without checking adding instance ID
        names.append( instance.id )

        date = time.strftime('%Y-%m-%d')

        descr = f"Backup of the {instance.id} made on {date}"
        name  = f"{names[0]}-{date}"

        logtype = "info"
        message = f"Instance [{instance.id}]: Backup Created [{name}]"

        try :
            instance.create_image(
                DryRun=False,
                Name=name,
                Description=descr,
                NoReboot=False
            )
        except ClientError as e:
            message = f"Instance Backup Error [{instance.id}]: {e}"
            logtype="warning"

        self.logger.log( logtype, message)

class Images(object):

    """ AMI snapshots """
    def __init__(self, ec2, Logged=False):
        self.ec2 = ec2
        self.logger = Logger(Logged)

        # running backup procedure
        self.__main__()

    def __main__(self):

        """ Getting a dict ([id]ec2::ami) of available images """
        filters = [ { 'Name': 'state', 'Values': ['available'] } ]
        self.images = { i.id : i for i in self.ec2.images.filter(Owners=['self'], Filters=filters)
        }

        self.process(self.groups())

    def groups(self ):
        """ Filters and Sorts images based on date patterned name """

        if len(self.images) < 1:
            self.logger.log('info', 'There are no images to cleanup' )
            return dict({})

        # regular expression that matches the ending -2001-01-10 pattern
        regex = re.compile('(.*?)-(\d{4}-\d{2}-\d{2})$')

        # return object/dictionary
        groups = dict();
        for idkey, image in self.images.items():

            matches = regex.match( image.name )
            if matches is None:
                """ Skip undated images"""
                continue

            list_of_dates = groups.get( matches[1], {})
            list_of_dates.update({ idkey : int(matches[2].replace("-", "")) })
            groups.update({ matches[1] : list_of_dates })

        return groups

    def process(self, groups ):
        """ Performing Keep/Delete Operation"""

        if len(self.images) < 1:
            self.logger.log('info', 'There are no images to cleanup' )

        for group, id_dates_dict in groups.items():
            dates = list( id_dates_dict.values() )
            dates.sort(reverse=True)
            self.logger.log('info', f"Working with images [{group}]" )

            # # one on a top is keep-backup
            for date in dates[:1]:
                image_id = [ img_id for img_id, value in id_dates_dict.items() if value == date]
                self.logger.log( 'info', f"Keep:  Group [{group}] - Image [{image_id[0]}]" )

            # # the rest are ready to be deleted
            for date in dates[1:]:
                image_id = [ img_id for img_id, value in id_dates_dict.items() if value == date]
                self.logger.log( 'info', f"Delete : Group [{group}] - Image [{image_id[0]}]" )
                self.delete( self.images.get( image_id[0] ) )

    def delete(self, image ):
        """ Actually performe delete operation"""

        snapshots = []
        for block_device in image.block_device_mappings:
            snapshot_id = block_device.get("Ebs", {}).get('SnapshotId', None)
            if snapshot_id is not None:
                snapshots.append(snapshot_id)

        """ actual delete """
        try:
            image.deregister(DryRun=False)
        except ClientError as e:
            message = f"Instance AMI {image.id} DeRegister Error"
            logtype="warning"
            self.logger.log( logtype, message)

        # snapshots
        for snapshot in snapshots:
            try:
                snapshot = self.ec2.Snapshot(snapshot).delete(DryRun=False)
            except ClientError as e:
                message = f"Snapshot deletion failed {snapshot}"
                logtype="warning"
                self.logger.log( logtype, message)


if __name__ == "__main__":
    main(None, None)
