# internetweek2018-ansible

環境構築にDockerを利用します(このイメージはAnsible等の環境構築に利用するツールがはじめからインストールされています）
```shell
docker run -it --name iw2018-linklight irixjp/iw2018-ansible-handson:latest bash
```

AWS環境の認証情報を設定します。
```shell
mkdir ~/.aws/
vim ~/.aws/credentials
```

アクセスキーとシークレットキーを設定。
```
[default]
aws_access_key_id = XXXXXXXXXXXXXX
aws_secret_access_key = YYYYYYYYYYYYYYY
```

動作確認
```shell
ansible localhost -c local -m ec2_instance_facts -a 'region=us-east-1'
```

以下のようにSUCCESSとなれば成功です。NGの場合はアクセスキーとシークレットキーの設定が間違っているか、アカウントに権限がありません。
```
localhost | SUCCESS => {
    "changed": false,
    "instances": []
}
```


ハンズオン環境の設定
```shell
cd
git clone https://github.com/network-automation/linklight.git
cd linklight/provisioner/
cp sample_workshops/sample-vars-networking.yml .

vim sample-vars-networking.yml
```

以下のように編集します。
```yaml
ec2_region: ap-northeast-1   # リージョンを指定
ec2_name_prefix: IW2018      # 作成されるリソースのプレフィックス
student_total: 1             # 作成する環境数（=受講者数）
## Optional Variables
admin_password: ansible      # 環境へのログインパスワード
create_login_page: false     # false のまま
networking: true             # true のまま
```

プロビジョニングの実行
```shell
ansible-playbook provision_lab.yml -e @sample-vars-networking.yml
```

インスタンスの作成でエラーが出る場合があります。これは利用するイメージに追加の課金が発生するイメージでを利用しているためです。AWSにログインしてから表示されるURLへアクセスして「Subscrible」を行ってください。エラーを解消したら、もう一回プロビジョニングを実行してください。

配布する情報は以下のようにstudentX-instances.txt として作成されます。
```shell
# ll IW2018/
total 16
-r-------- 1 root root 1674 Nov  2 05:06 IW2018-private.pem
-rw-r--r-- 1 root root  295 Nov  2 05:08 instructor_inventory.txt
-rw-r--r-- 1 root root  239 Nov  2 05:08 student1-etchosts.txt
-rw-r--r-- 1 root root  444 Nov  2 05:08 student1-instances.txt
```

演習を行うには、studentX-instances.txt に書かれた[control]セクションの、ansible_hostのIPアドレスへSSH接続する。ユーザー名は studentX (Xは数字)、パスワードは ansible です。



環境を削除する
```shell
ansible-playbook teardown_lab.yml -e @sample-vars-networking.yml
```
