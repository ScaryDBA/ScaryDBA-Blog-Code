## create an option group
aws rds create-option-group `
    --option-group-name hsroptiongroup `
    --engine-name sqlserver-ex `
    --major-engine-version "14.00" `
    --option-group-description "Option Group to customize SQL Server hsr"


## add option to option group
## security set up based on this https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/SQLServer.Procedural.Importing.html
aws rds add-option-to-option-group `
    --apply-immediately `
    --option-group-name hsroptiongroup `
    --options "OptionName=SQLSERVER_BACKUP_RESTORE, OptionSettings=[{Name=IAM_ROLE_ARN,Value=arn:aws:iam::xxx:role/sqlbackup}]"




## associate option group with RDS instance
aws rds modify-db-instance `
    --db-instance-identifier hsr `
    --option-group-name hsroptiongroup `
    --apply-immediately

