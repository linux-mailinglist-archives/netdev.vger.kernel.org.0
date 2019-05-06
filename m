Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524A7151BC
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEFQfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:35:16 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60366 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbfEFQfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 12:35:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GYTpZ181675;
        Mon, 6 May 2019 16:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=iZ5THHAxssDblbKSPUAsvLOGOez7i4Ghuzpt5C3NiLs=;
 b=voeFYptHz99POXm8A++RkHKr2DnqQYbZVMP+mJvbNGA9txTjIz0sNX/VhmjlTuQd+AcC
 v1T71LE62LRd8Fkdbb2Osr88VixAmnSFVTq6NOsmNvk3eE9VksIyx/5T47/eUWOPvqz8
 LccgN4WU3r611XRc2zjprDvcYQvO5UtUN+3tCK3bOBTvn5GC0kvznkwuSiX/klQYqeaF
 FchQBG4usCGR34ycGyDpVW3noFWau/v735Yw+liz+tYIeamI3l5TRWe3+j1avSZU2Czn
 s7e7rBeiHqZUZncM+VSZX9NoiXYpBPcMDI0Bm0TvatdrptlPTzDXCsfYCR0wy2FutXiO XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 2s94b5qt1a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 16:35:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x46GYvFq067799;
        Mon, 6 May 2019 16:35:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2s94b90ces-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 May 2019 16:35:04 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x46GZ3Bd009525;
        Mon, 6 May 2019 16:35:03 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 May 2019 09:35:03 -0700
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Moni Shoua <monis@mellanox.com>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074500.GC7676@mtr-leonro.mtl.com>
 <81e6e4c1-a57c-0f66-75ad-90f75417cc4a@oracle.com>
 <20190502061800.GL7676@mtr-leonro.mtl.com>
 <6560f4e5-8ded-6fb3-dd2b-d4733633addc@oracle.com>
 <20190505062250.GA6938@mtr-leonro.mtl.com>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <49449b7a-2bd0-ef1e-edbe-0fade54f1862@oracle.com>
Date:   Mon, 6 May 2019 09:37:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190505062250.GA6938@mtr-leonro.mtl.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905060141
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9249 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905060141
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

5/4/2019 11:22 PM, Leon Romanovsky wrote:
> On Thu, May 02, 2019 at 10:59:58AM -0700, Santosh Shilimkar wrote:
>>
>>
>> On 5/1/2019 11:18 PM, Leon Romanovsky wrote:
>>> On Wed, May 01, 2019 at 10:54:50AM -0700, Santosh Shilimkar wrote:
>>>> On 5/1/2019 12:45 AM, Leon Romanovsky wrote:
>>>>> On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
>>>>>> RDS doesn't support RDMA on memory apertures that require On Demand
>>>>>> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
>>>>>> whether RDMA requiring ODP is supported.
>>>>>>
>>>>>> Reviewed-by: H??kon Bugge <haakon.bugge@oracle.com>
>>>>>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>>>>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>>>>> ---
>>>>>>     net/rds/ib.h        | 1 +
>>>>>>     net/rds/ib_sysctl.c | 8 ++++++++
>>>>>>     2 files changed, 9 insertions(+)
>>>>>
>>>>> This sysctl is not needed at all
>>>>>
>>>> Its needed for application to check the support of the ODP support
>>>> feature which in progress. Failing the RDS_GET_MR was just one path
>>>> and we also support inline MR registration along with message request.
>>>>
>>>> Basically application runs on different kernel versions and to be
>>>> portable, it will check if underneath RDS support ODP and then only
>>>> use RDMA. If not it will fallback to buffer copy mode. Hope
>>>> it clarifies.
>>>
>>> Using ODP sysctl to determine if to use RDMA or not, looks like very
>>> problematic approach. How old applications will work in such case
>>> without knowledge of such sysctl?
>>> How new applications will distinguish between ODP is not supported, but
>>> RDMA works?
>>>
>> Actually this is not ODP sysctl but really whether RDS supports
>> RDMA on fs_dax memory or not. I had different name for sysctl but
>> in internal review it got changed.
>>
>> Ignoring the name of the sysctl, here is the application logic.
>> - If fs_dax sysctl path doesn't exist, no RDMA on FS DAX memory(this
>> will cover all the older kernels, which doesn't have this patch)
>> - If fs_dax sysctl path exist and its value is 0, no RDMA on FS
>> DAX. This will cover kernels which this patch but don't have
>> actual support for ODP based registration.
>> - If fs_dax sysctl path exist and its value is 1, RDMA can be
>> issued on FS DAX memory. This sysctl will be updated to value 1
>> once the support gets added.
>>
>> Hope it clarifies better now.
> 
> Santosh,
> 
> Thanks for explanation, I have one more question,
> 
> If I'm author of hostile application and write code to disregard that
> new sysctl, will any of combinations of kernel/application cause to
> kernel panic? If not, we don't really need to expose this information,
> if yes, this sysctl is not enough.
> 
It Won't panic. Thats why the other patch also makes the call fail when
tried to register FS DAX memory with RDS.


