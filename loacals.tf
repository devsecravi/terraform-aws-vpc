locals {

     common_tags = {
          Project = var.project
          Environment = var.environment
          Terraform = true
     }
     vpc2_final_tags= merge(
        local.common_tags,
            {
            Name = "${var.project}-${var.environment}"
            },
            var.vpc_tags
       )

      igw_final_tags= merge(
        local.common_tags,
            {
            Name = "${var.project}-${var.environment}"
            },
            var.igw_tags
        )
      sb_final_tags_us_east_1a = merge(
             local.common_tags,
             {
                Name = "${var.project}-${var.environment}"
             }
             ,
             var.sb_tags_us_east_1a
      )

      sb_final_tags_us_east_1a = merge(
             local.common_tags,
             {
                Name = "${var.project}-${var.environment}-public"
             }
             ,
             var.sb_tags_us_east_1b
      )
}