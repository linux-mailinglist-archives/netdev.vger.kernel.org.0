Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C48112160
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 19:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEBR5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 13:57:20 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:48930 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfEBR5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 13:57:20 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x42Hs6ub072533;
        Thu, 2 May 2019 17:57:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=JR0XBTYriJZkxU/hUSRi6iAQTlKAN5vJQzdI8eSqNVw=;
 b=WZp2wpvFk/kuwaL/YRc/55Y+ORjYM2N8u8IheYgGktur5ZFsp0JIdsi4Lq6tPznuoiAm
 5zoCN8EPEancHB+IOYhW5DtZhz15G0GHvQKhyDVtdddmdsJPDY78qhAlzA2LaA2GVsUd
 7wHrnZ0xdV1fHqTMZ3FQCArqejwzwPTvLha+ZMMnk0qlA9hHhcEb/Ut2Y03wpGK+FluH
 YF88DMGYUk4SX3TZVSWxa+rwifCffb6QlQGw/vE2xA3Fe8jZDPAV2UB3bzHMIZ+8LY8y
 PAhmHu0DGWqoNysrG32OD1C5SmrhskM4z5bZDpYDDnj+lw6A2Jj3iZk2LzZhI8HqCwAG 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2s6xhyjcq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 17:57:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x42Hv6jc164249;
        Thu, 2 May 2019 17:57:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2s6xhh73jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 May 2019 17:57:10 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x42Hv9tH024799;
        Thu, 2 May 2019 17:57:09 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 May 2019 10:57:09 -0700
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
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <6560f4e5-8ded-6fb3-dd2b-d4733633addc@oracle.com>
Date:   Thu, 2 May 2019 10:59:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190502061800.GL7676@mtr-leonro.mtl.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905020115
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905020115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/1/2019 11:18 PM, Leon Romanovsky wrote:
> On Wed, May 01, 2019 at 10:54:50AM -0700, Santosh Shilimkar wrote:
>> On 5/1/2019 12:45 AM, Leon Romanovsky wrote:
>>> On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
>>>> RDS doesn't support RDMA on memory apertures that require On Demand
>>>> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
>>>> whether RDMA requiring ODP is supported.
>>>>
>>>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>>>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>>>> ---
>>>>    net/rds/ib.h        | 1 +
>>>>    net/rds/ib_sysctl.c | 8 ++++++++
>>>>    2 files changed, 9 insertions(+)
>>>
>>> This sysctl is not needed at all
>>>
>> Its needed for application to check the support of the ODP support
>> feature which in progress. Failing the RDS_GET_MR was just one path
>> and we also support inline MR registration along with message request.
>>
>> Basically application runs on different kernel versions and to be
>> portable, it will check if underneath RDS support ODP and then only
>> use RDMA. If not it will fallback to buffer copy mode. Hope
>> it clarifies.
> 
> Using ODP sysctl to determine if to use RDMA or not, looks like very
> problematic approach. How old applications will work in such case
> without knowledge of such sysctl?
> How new applications will distinguish between ODP is not supported, but
> RDMA works?
> 
Actually this is not ODP sysctl but really whether RDS supports
RDMA on fs_dax memory or not. I had different name for sysctl but
in internal review it got changed.

Ignoring the name of the sysctl, here is the application logic.
- If fs_dax sysctl path doesn't exist, no RDMA on FS DAX memory(this
will cover all the older kernels, which doesn't have this patch)
- If fs_dax sysctl path exist and its value is 0, no RDMA on FS
DAX. This will cover kernels which this patch but don't have
actual support for ODP based registration.
- If fs_dax sysctl path exist and its value is 1, RDMA can be
issued on FS DAX memory. This sysctl will be updated to value 1
once the support gets added.

Hope it clarifies better now.

Regards,
Santosh
