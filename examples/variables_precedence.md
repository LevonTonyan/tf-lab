# Terraform Variables Precedence

There are several ways to define and re-define variables in Terraform. If the same variable is assigned multiple values, Terraform uses the last value it finds, overriding any previous values. Note that the same variable cannot be assigned multiple values within a single source.

Lets look on possible options from the less precedent values to the most one.

For the example we will use simple module that only returns the `name` output.

```[../modules/my_name/main.tf]

output "result_name" {

  value = var.name
}

variable "name" {
  default = "batman"
}

```


## 10. Module defaults
