Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3165B8DC94
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfHNSBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:01:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNSBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:01:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EHs11E120570;
        Wed, 14 Aug 2019 18:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=a8dXjAtLDdqx3ZGsF/d52+0/GxR+4THaJned2ZodEzI=;
 b=IWh43ZiLi7NDq3vQP7PEPXK/Hn9aD8+nuF+Yusox6NALAklZnj9XHt94MiIq0M+UFjDz
 Z+NXZxiu9sEVUtnepAv36oSrmGZ/RsA9hiEkVslSfMv1PxOyHkDZQbE7QKULGssgzBa3
 UVSuBE9PRNUh46CVpuZx53eyIi9IMN2p+HZEaVlhxwZ7HVjy3CGA3bcWEwXY8O6MyL/W
 PcERxoKZPLLgLXmKueTrja1KgzIydjgkY4iO8t0UubBzznXNSM4CjmGnWq9oxYVc+Kgt
 +QJ2wam/PwD+8PawrSebsy3/MhkmI538Z6Q+H1+y8ZtHOiPEC4SUspwEtDB8/hovyy7t yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u9nvpeg58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 18:01:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7EHwO8P127813;
        Wed, 14 Aug 2019 18:01:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2ubwrhjh9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Aug 2019 18:01:38 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x7EI0AIY135531;
        Wed, 14 Aug 2019 18:01:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2ubwrhjh9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Aug 2019 18:01:37 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7EI1boS029531;
        Wed, 14 Aug 2019 18:01:37 GMT
Received: from [10.209.243.59] (/10.209.243.59)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Aug 2019 11:01:36 -0700
Subject: Re: [PATCH net-next 1/5] RDS: Re-add pf/sol access via sysctl
To:     Doug Ledford <dledford@redhat.com>,
        Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
Cc:     David Miller <davem@davemloft.net>
References: <e0397d30-7405-a7af-286c-fe76887caf0a@oracle.com>
 <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <a7d09f3a-d01e-7cdb-98ec-8165b6312ffe@oracle.com>
Date:   Wed, 14 Aug 2019 11:01:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <53b40b359d18dd73a6cf264aa8013d33547b593f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9349 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908140161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/14/19 8:56 AM, Doug Ledford wrote:
> On Tue, 2019-08-13 at 11:20 -0700, Gerd Rausch wrote:
>> From: Andy Grover <andy.grover@oracle.com>
>> Date: Tue, 24 Nov 2009 15:35:51 -0800
>>
>> Although RDS has an official PF_RDS value now, existing software
>> expects to look for rds sysctls to determine it. We need to maintain
>> these for now, for backwards compatibility.
>>
>> Signed-off-by: Andy Grover <andy.grover@oracle.com>
>> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
>> ---
>>   net/rds/sysctl.c | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
>> index e381bbcd9cc1..9760292a0af4 100644
>> --- a/net/rds/sysctl.c
>> +++ b/net/rds/sysctl.c
>> @@ -49,6 +49,13 @@ unsigned int  rds_sysctl_max_unacked_bytes = (16 <<
>> 20);
>>   
>>   unsigned int rds_sysctl_ping_enable = 1;
>>   
>> +/*
>> + * We have official values, but must maintain the sysctl interface
>> for existing
>> + * software that expects to find these values here.
>> + */
>> +static int rds_sysctl_pf_rds = PF_RDS;
>> +static int rds_sysctl_sol_rds = SOL_RDS;
>> +
>>   static struct ctl_table rds_sysctl_rds_table[] = {
>>   	{
>>   		.procname       = "reconnect_min_delay_ms",
>> @@ -68,6 +75,20 @@ static struct ctl_table rds_sysctl_rds_table[] = {
>>   		.extra1		= &rds_sysctl_reconnect_min_jiffies,
>>   		.extra2		= &rds_sysctl_reconnect_max,
>>   	},
>> +	{
>> +		.procname       = "pf_rds",
>> +		.data		= &rds_sysctl_pf_rds,
>> +		.maxlen         = sizeof(int),
>> +		.mode           = 0444,
>> +		.proc_handler   = &proc_dointvec,
>> +	},
>> +	{
>> +		.procname       = "sol_rds",
>> +		.data		= &rds_sysctl_sol_rds,
>> +		.maxlen         = sizeof(int),
>> +		.mode           = 0444,
>> +		.proc_handler   = &proc_dointvec,
>> +	},
>>   	{
>>   		.procname	= "max_unacked_packets",
>>   		.data		= &rds_sysctl_max_unacked_packets,
> 
> Good Lord...RDS was taken into the kernel in Feb of 2009, so over 10
> years ago.  The patch to put PF_RDS/AF_RDS/SOL_RDS was taken into
> include/linux/socket.h Feb 26, 2009.  The RDS ports were allocated by
> IANA on Feb 27 and May 20, 2009.  And you *still* have software that
> needs this?  The only software that has ever used RDS was Oracle
> software.  I would have expected you guys to update your source code to
> do the right thing long before now.  In fact, I would expect you were
> ready to retire all of the legacy software that needs this by now.  As
> of today, does your current build of Oracle software still require this,
> or have you at least fixed it up in your modern builds?
> 
Some of the application software was released before 2009 and ended up
using these proc entries from downstream kernel. The newer lib/app
using RDS don't use these. Unfortunately lot of customer still use
Oracle 9, 10, 11 which were released before 2007 and run these apps
on modern kernels.

Regards,
Snatosh
