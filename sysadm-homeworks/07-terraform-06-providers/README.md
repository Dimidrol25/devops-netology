### Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."  


## Задача 1.

1. [resource](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L867-L1984), [data_source](https://github.com/hashicorp/terraform-provider-aws/blob/341ef9448ff56250ca3ed9d6b69600d42f4251b6/internal/provider/provider.go#L412-L865)  


2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`.  

- `name` конфликтует с `name_prefix` - [source](https://github.com/hashicorp/terraform-provider-aws/blob/6e6e4bed78f29b0addd5b33fd733b67f85bb4dc3/internal/service/sqs/queue.go#L87)  

- Максимальная длина имени равна 80 символам.  

- Регулярное выражение: `^[a-zA-Z0-9_-]`.
