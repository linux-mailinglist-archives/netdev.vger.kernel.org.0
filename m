Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FCC69BA16
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 03:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbfHXBcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 21:32:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45092 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbfHXBcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 21:32:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O1SZ2D009992;
        Sat, 24 Aug 2019 01:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=wVYM8SIHh0BX2RB1/iach074DbGsv22U7hnJzm9lb+Q=;
 b=YcO7tPYPVde8/7OZ2p1W5df1Ek/kQQe15bLmylgmy7rf3r7clvxyPQgQSomMU6PoywJW
 9mfjEXcvoFoIZ3l1E/mXUuvgit4izGGBIAa9Q0drC5esDzOhgvoT9TvVpLgeLIhJgkVR
 IPFzLvg1/O1sJkhPTzn8OznRG6+XgksKkYlxrzLVrUu2OSrCCKc4gXZB6sQoheNQX2wV
 hfboxG7O/sDTEPvZpwg8LDM/2QIieWkMX4EwW5rL1RM7n5Vjm7ccyTpDMQx5JRT6mlYD
 fFelxwkwVc7iJTdfFu57BtFRqqdzmqnbaNb0YUEUUec3+CM/Qql+/kBkxCTBzmkizRqe rQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ue90u7sjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 01:32:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7O1TYcT065045;
        Sat, 24 Aug 2019 01:32:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 2ujca8qg6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 24 Aug 2019 01:32:42 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7O1WglZ070403;
        Sat, 24 Aug 2019 01:32:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2ujca8qg6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Aug 2019 01:32:42 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7O1Wfgj005848;
        Sat, 24 Aug 2019 01:32:41 GMT
Received: from [10.182.71.192] (/10.182.71.192)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 18:32:41 -0700
Subject: Re: [PATCHv2 1/1] net: rds: add service level support in rds-info
To:     santosh.shilimkar@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, gerd.rausch@oracle.com
References: <1566608656-30836-1-git-send-email-yanjun.zhu@oracle.com>
 <6e5bc371-d613-e8f7-7b57-0b1bc2e10e9d@oracle.com>
From:   Zhu Yanjun <yanjun.zhu@oracle.com>
Organization: Oracle Corporation
Message-ID: <176504c9-b75e-cc82-b262-3b90425c09b8@oracle.com>
Date:   Sat, 24 Aug 2019 09:36:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6e5bc371-d613-e8f7-7b57-0b1bc2e10e9d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908240014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/24 9:25, santosh.shilimkar@oracle.com wrote:
> On 8/23/19 6:04 PM, Zhu Yanjun wrote:
>>  From IB specific 7.6.5 SERVICE LEVEL, Service Level (SL)
>> is used to identify different flows within an IBA subnet.
>> It is carried in the local route header of the packet.
>>
>> Before this commit, run "rds-info -I". The outputs are as
>> below:
>> "
>> RDS IB Connections:
>>   LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
>> 192.2.95.3  192.2.95.1  2   0  fe80::21:28:1a:39 fe80::21:28:10:b9
>> 192.2.95.3  192.2.95.1  1   0  fe80::21:28:1a:39 fe80::21:28:10:b9
>> 192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39 fe80::21:28:10:b9
>> "
>> After this commit, the output is as below:
>> "
>> RDS IB Connections:
>>   LocalAddr  RemoteAddr Tos SL  LocalDev               RemoteDev
>> 192.2.95.3  192.2.95.1  2   2  fe80::21:28:1a:39 fe80::21:28:10:b9
>> 192.2.95.3  192.2.95.1  1   1  fe80::21:28:1a:39 fe80::21:28:10:b9
>> 192.2.95.3  192.2.95.1  0   0  fe80::21:28:1a:39 fe80::21:28:10:b9
>> "
>>
>> The commit fe3475af3bdf ("net: rds: add per rds connection cache
>> statistics") adds cache_allocs in struct rds_info_rdma_connection
>> as below:
>> struct rds_info_rdma_connection {
>> ...
>>          __u32           rdma_mr_max;
>>          __u32           rdma_mr_size;
>>          __u8            tos;
>>          __u32           cache_allocs;
>>   };
>> The peer struct in rds-tools of struct rds_info_rdma_connection is as
>> below:
>> struct rds_info_rdma_connection {
>> ...
>>          uint32_t        rdma_mr_max;
>>          uint32_t        rdma_mr_size;
>>          uint8_t         tos;
>>          uint8_t         sl;
>>          uint32_t        cache_allocs;
>> };
>> The difference between userspace and kernel is the member variable sl.
>> In the kernel struct, the member variable sl is missing. This will
>> introduce risks. So it is necessary to use this commit to avoid this 
>> risk.
>>
>> Fixes: fe3475af3bdf ("net: rds: add per rds connection cache 
>> statistics")
>> CC: Joe Jin <joe.jin@oracle.com>
>> CC: JUNXIAO_BI <junxiao.bi@oracle.com>
>> Suggested-by: Gerd Rausch <gerd.rausch@oracle.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> ---
>> V1->V2: fix typos in commit logs.
>> ---
> I did ask you when ypu posted the patch about whether you did
> backward compatibility tests for which you said, you did all the
> tests and said "So do not worry about backward compatibility. This
> commit will work well with older rds-tools2.0.5 and 2.0.6."
>
> https://www.spinics.net/lists/netdev/msg574691.html
>
> I was worried about exactly such issue as described in commit.

Sorry. My bad. I will make more work to let rds robust.

Thanks a lot for your Ack.

Zhu Yanjun

>
> Anyways thanks for the fixup patch. Should be applied to stable
> as well.
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>
> Regards,
> Santosh
>
>
