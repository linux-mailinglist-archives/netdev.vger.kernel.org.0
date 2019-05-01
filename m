Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8DE10C72
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfEARvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:51:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54300 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfEARvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:51:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41HYH1t123589;
        Wed, 1 May 2019 17:51:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OXBx6DYwRcii4bmGU1wJbSki8qBSriUFZSz+lmwynY8=;
 b=WAWoHVC0duYbvJ3LfcG71vHT7LJqdCppmPjlEw7SS/OUQUG+bJjIHI6I0Zui7cgdQZSW
 8TMkCVYs4CqFFDYJu7dcG4edGG1cxu+HS/t+burPudGNetQGrDPQ/aDBNwEMsi7Vo9li
 Ueaooha16KdSmEAVs2kqjbIRHUkZh2+bZ1sYOMc8oo7WvVBuy8Kfn1LS/R57H6DmTLQL
 AJFIyYY259pamUrIW9LxRmVOl6IMthrMiZrQLDsvF8viei8Ikk+nzSPfjYma4dNHxEaz
 rlMjkYXLG2MiO6+0DOHfqwBHLDh2plT0z5ZZ3FJcLakh84hhMaRC4SAEnjb4RvpOWYgE PQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2s6xhym52x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 17:51:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41HolS9050701;
        Wed, 1 May 2019 17:51:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2s6xhgctnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 17:51:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x41HpAuS023051;
        Wed, 1 May 2019 17:51:10 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 10:51:09 -0700
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074415.GB7676@mtr-leonro.mtl.com>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <2829f9d8-0383-d141-46c3-f2a09cd542b2@oracle.com>
Date:   Wed, 1 May 2019 10:54:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190501074415.GB7676@mtr-leonro.mtl.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905010109
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9244 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/2019 12:44 AM, Leon Romanovsky wrote:
> On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
>> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>
>> RDS doesn't support RDMA on memory apertures that require On Demand
>> Paging (ODP), such as FS DAX memory. User applications can try to use
>> RDS to perform RDMA over such memories and since it doesn't report any
>> failure, it can lead to unexpected issues like memory corruption when
>> a couple of out of sync file system operations like ftruncate etc. are
>> performed.
>>
>> The patch adds a check so that such an attempt to RDMA to/from memory
>> apertures requiring ODP will fail.
>>
>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>> ---
>>   net/rds/rdma.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
>> index 182ab84..e0a6b72 100644
>> --- a/net/rds/rdma.c
>> +++ b/net/rds/rdma.c
>> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>>   {
>>   	int ret;
>>
>> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
>> -
>> +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
>> +	ret = get_user_pages_longterm(user_addr, nr_pages,
>> +				      write, pages, NULL);
> 
> I'm not RDS expert, but from what I see in net/rds/rdma.c and this code,
> you tried to mimic ib_umem_get() without protection, checks and native
> ODP, FS and DAX supports.
>
> The real way to solve your ODP problem will require to extend
> ib_umem_get() to work for kernel ULPs too and use it instead of
> get_user_pages(). We are working on that and it is in internal review now.
>
Yes am aware of it. For FS_DAX like memory,  get_user_pages_longterm()
fails and then using ib_reg_user_mr() the memory is registered as
ODP regsion. This work is not ready yet and without above check,
one can do RDMA on FS DAX memory with Fast Reg or FMR memory
registration which is not safe and hence need to fail the operation.

Once the support is added to RDS, this code path will make that
registration go through.

Hope it clarifies.

Regards,
Santosh

