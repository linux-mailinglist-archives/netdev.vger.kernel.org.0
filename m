Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC8D32723
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFCEI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:08:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbfFCEI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 00:08:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x533woA6038839;
        Mon, 3 Jun 2019 04:08:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=0zpR9rEIAG3te1kwJxUIvUthSABVNqzMGkJNMU8O2vA=;
 b=oJvCkCdX4D0iM0CoYbQsqgsGpSOBtMSPxffFwD6LKuLoYUmtYgKwa0tFtwPz0zRNHg66
 zsN331ootGuvpMuZMexT39/QcexUKOKxHEsxUSvdBvotQkYWf5pg09X8zJVp9xVWcsC2
 BrCW+j/NXp7XUCjz9VZlpKO+aPvWc8T1q8dIMn8SFQnm8lUUGH9PvlV1Zqk025VXHQPS
 FlbAW4flnmU8h/GcoxM++1CKBmGUbNAnAF8TniUiI0xgAzcUoWi/13lGaPLM+gEnvNKB
 SaRAMau735BVsiigqsypFxuolg49feIwr8hZ+RKxCqBQ6jInT4uvOuIQuT6HEMNuEl0B bA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugst4ek7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 04:08:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5348Gl1061418;
        Mon, 3 Jun 2019 04:08:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2svnn82frn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 04:08:16 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x5348FAL061405;
        Mon, 3 Jun 2019 04:08:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2svnn82frc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jun 2019 04:08:15 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5348Ev2005113;
        Mon, 3 Jun 2019 04:08:14 GMT
Received: from [10.182.69.170] (/10.182.69.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 02 Jun 2019 21:08:14 -0700
Subject: Re: [PATCH 1/1] net: rds: add per rds connection cache statistics
To:     "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
References: <1559375674-17913-1-git-send-email-yanjun.zhu@oracle.com>
 <c9164a0b-fb6f-b3ab-1d38-76413e4820b2@oracle.com>
From:   Yanjun Zhu <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <3552e6e4-7dde-51c7-aee6-005fbccfbf4e@oracle.com>
Date:   Mon, 3 Jun 2019 12:08:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <c9164a0b-fb6f-b3ab-1d38-76413e4820b2@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9276 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906030027
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/3 11:03, santosh.shilimkar@oracle.com wrote:
> On 6/1/19 12:54 AM, Zhu Yanjun wrote:
>> The variable cache_allocs is to indicate how many frags (KiB) are in one
>> rds connection frag cache.
>> The command "rds-info -Iv" will output the rds connection cache
>> statistics as below:
>> "
>> RDS IB Connections:
>>        LocalAddr RemoteAddr Tos SL  LocalDev RemoteDev
>>        1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 
>> fe80::2:c903:a:7a31
>>        send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
>>        rdma_mr_size=257, cache_allocs=12
>> "
>> This means that there are about 12KiB frag in this rds connection frag
>>   cache.
>>
>> Tested-by: RDS CI <rdsci_oslo@no.oracle.com>
> Please add some valid email id or drop above. Its expected
> that with SOB, patches are tested before testing.

Thanks for review.

OK. I will remove this in V2.

>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> ---
>>   include/uapi/linux/rds.h | 2 ++
>>   net/rds/ib.c             | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
>> index 5d0f76c..fd6b5f6 100644
>> --- a/include/uapi/linux/rds.h
>> +++ b/include/uapi/linux/rds.h
>> @@ -250,6 +250,7 @@ struct rds_info_rdma_connection {
>>       __u32        rdma_mr_max;
>>       __u32        rdma_mr_size;
>>       __u8        tos;
>> +    __u32        cache_allocs;
> Some of this header file changes, how is taking care of backward
> compatibility with tooling ? 

Just now I made tests with rds-tools.

In this commit

"

commit 6c03b61e9097098d35b4c2be16d0f0f9f8357112
Author: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Date:   Wed Mar 9 04:30:48 2016 -0800

     rds-tools: sync up sources with 2.0.7-1.16
"

cache_allocs is added into rds-tools. The diff is as below.

"

@@ -176,6 +191,9 @@ struct rds_info_rdma_connection {
         uint32_t        max_send_sge;
         uint32_t        rdma_mr_max;
         uint32_t        rdma_mr_size;
+       uint8_t         tos;
+       uint8_t         sl;
+       uint32_t        cache_allocs;
  };
"
Then this cache_allocs does not exist in rds-tools 2.0.6 and rds-tools 
2.0.5.

I made tests with 2.0.5 and 2.0.6

"

rds-info -V
rds-info: Invalid option '-V'
rds-info version 2.0.5

[root@ca-dev14 rds-tools]# rds-info -Iv

RDS IB Connections:
       LocalAddr      RemoteAddr LocalDev                        RemoteDev
        1.1.1.14        1.1.1.14 fe80::2:c903:a:7a31              
fe80::2:c903:a:7a31  send_wr=256, recv_wr=1024, send_sge=8, 
rdma_mr_max=4096, rdma_mr_size=257
"

"

[root@ca-dev14 rds-tools]# rds-info -V
rds-info: Invalid option '-V'
rds-info version 2.0.6

[root@ca-dev14 rds-tools]# rds-info -Iv

RDS IB Connections:
       LocalAddr      RemoteAddr LocalDev                        RemoteDev
        1.1.1.14        1.1.1.14 fe80::2:c903:a:7a31              
fe80::2:c903:a:7a31  send_wr=256, recv_wr=1024, send_sge=8, 
rdma_mr_max=4096, rdma_mr_size=257
"

 From output of rds-tools 2.0.5 and 2.0.6, cache_allocs does not appear 
since cache_allocs does not exist in struct rds_info_rdma_connection.

But in rds-tools 2.0.7, cache_allocs exists in struct 
rds_info_rdma_connection.

"

[root@ca-dev14 rds-tools]# rds-info -V
rds-info: invalid option -- 'V'

rds-info version 2.0.7

[root@ca-dev14 rds-tools]# rds-info -Iv

RDS IB Connections:
       LocalAddr      RemoteAddr  Tos  SL 
LocalDev                        RemoteDev
        1.1.1.14        1.1.1.14    5 255 
fe80::2:c903:a:7a31              fe80::2:c903:a:7a31  send_wr=256, 
recv_wr=1024, send_sge=8, rdma_mr_max=4096, rdma_mr_size=257, 
cache_allocs=12
"

So do not worry about backward compatibility.  This commit will work 
well with older rds-tools2.0.5 and 2.0.6.

I will send V2 soon.

Thanks

Zhu Yanjun

> This was one of the reason, the
> all the fields are not updated.
>
> Regards,
> Santosh
