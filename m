Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49C1A0FF
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfEJQLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 12:11:05 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfEJQLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 12:11:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AG8lmW039453;
        Fri, 10 May 2019 16:11:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=SJW2t7q6LCugySZzeeSHG/+hvg8aHUkhoYUqb/lJxgg=;
 b=p6JsOSZ1HJJ1hSDosO/M3UXcEvDYKglNLyshpf0Ao0sJFGIwe2KX6qIG+v4Hu9EaUj1h
 ckbtkv0IKINZX19gcsoj4T8RqHZ1yB4+jl6kjLUvAJKKlaMwaiRbdiGy+2tiBgP0QFUp
 SgnRqF4YJlcNddgvDN3JFvfcOAb+f7aR65qyHl2Px6i2J03WLryQuhjNiR9NVdcTbAQ2
 Ckg+32V5VAjN2XD3S93sFyfIST4Vi7Fa7mQM33HgyZV+7GXwPGp+1nBJ8AKfmfDpYhS5
 AXMyNMWz8A5mUfGl4+yjb2adYac364gwPxeWsR6gq1cSllaIRd/XAqbK5ABOuohX5Y1o tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2s94b6j636-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 16:11:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4AG97Zk157689;
        Fri, 10 May 2019 16:11:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2scpy6bfu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 May 2019 16:11:01 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4AGB04L025393;
        Fri, 10 May 2019 16:11:01 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 May 2019 09:11:00 -0700
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
 <20190510130222.GA16285@ziepe.ca>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <bde43e4f-3fbb-9814-632c-db62ba96adea@oracle.com>
Date:   Fri, 10 May 2019 09:13:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190510130222.GA16285@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905100110
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905100110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/10/2019 6:02 AM, Jason Gunthorpe wrote:
> On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
>> RDS doesn't support RDMA on memory apertures that require On Demand
>> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
>> whether RDMA requiring ODP is supported.
>>
>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>   net/rds/ib.h        | 1 +
>>   net/rds/ib_sysctl.c | 8 ++++++++
>>   2 files changed, 9 insertions(+)
>>
>> diff --git a/net/rds/ib.h b/net/rds/ib.h
>> index 67a715b..80e11ef 100644
>> +++ b/net/rds/ib.h
>> @@ -457,5 +457,6 @@ unsigned int rds_ib_stats_info_copy(struct rds_info_iterator *iter,
>>   extern unsigned long rds_ib_sysctl_max_unsig_bytes;
>>   extern unsigned long rds_ib_sysctl_max_recv_allocation;
>>   extern unsigned int rds_ib_sysctl_flow_control;
>> +extern unsigned int rds_ib_sysctl_odp_support;
>>   
>>   #endif
>> diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
>> index e4e41b3..7cc02cd 100644
>> +++ b/net/rds/ib_sysctl.c
>> @@ -60,6 +60,7 @@
>>    * will cause credits to be added before protocol negotiation.
>>    */
>>   unsigned int rds_ib_sysctl_flow_control = 0;
>> +unsigned int rds_ib_sysctl_odp_support;
>>   
>>   static struct ctl_table rds_ib_sysctl_table[] = {
>>   	{
>> @@ -103,6 +104,13 @@
>>   		.mode		= 0644,
>>   		.proc_handler	= proc_dointvec,
>>   	},
>> +	{
>> +		.procname       = "odp_support",
>> +		.data           = &rds_ib_sysctl_odp_support,
>> +		.maxlen         = sizeof(rds_ib_sysctl_odp_support),
>> +		.mode           = 0444,
>> +		.proc_handler   = proc_dointvec,
>> +	},
>>   	{ }
>>   };
> 
> using a read-only sysctl as a capability negotiation scheme seems
> horrible to me
>
Do you have a suggestion ? Was thinking of adding a socketopt but
didn't pursue it further.

Regards,
Santosh

