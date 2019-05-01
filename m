Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01A10C79
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfEARwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:52:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55244 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfEARwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:52:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41HYe43123772;
        Wed, 1 May 2019 17:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=adGDDE0Cc02np1XqpKb9erskB1eAaIcWMkt5+C0bEi8=;
 b=zklpRKqgiIOb8ALk6+7zOmtkZozEg1eFD1/p5urLasnqJ8NuRLfxrqzqPmckBylrfPOo
 gk87XQfSqqf5mGN55FdYIWiL9HmOexQ88Daf2UVSyct4bwMvJBckjgN2sDTXM7DjjH15
 JYI0I1PfUB35vEiIFFwtE/G2xajO5lLWv6ar/YNHUf1706QQBhN/rLJxA6Z5AieW5TG5
 0r1Sn71DKUeiMFVmscBU/NXxGpipFHo2bNNEa3cEPk3cS/Uxip8aEwSPwFFX7D8Cy/MM
 QRWApKUUOpdtBSBufNPYuJw5mUWQAQISDu0uGCF9oM1FA9319DZ+pAk99aKdUe3J/knQ zQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s6xhym59j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 17:52:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x41HohSc186420;
        Wed, 1 May 2019 17:52:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2s7f16h7mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 May 2019 17:52:01 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x41Hq0MZ004614;
        Wed, 1 May 2019 17:52:00 GMT
Received: from [10.209.243.127] (/10.209.243.127)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 May 2019 10:52:00 -0700
Subject: Re: [net-next][PATCH v2 2/2] rds: add sysctl for rds support of
 On-Demand-Paging
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-3-git-send-email-santosh.shilimkar@oracle.com>
 <20190501074500.GC7676@mtr-leonro.mtl.com>
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
Organization: Oracle Corporation
Message-ID: <81e6e4c1-a57c-0f66-75ad-90f75417cc4a@oracle.com>
Date:   Wed, 1 May 2019 10:54:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190501074500.GC7676@mtr-leonro.mtl.com>
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
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905010109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/1/2019 12:45 AM, Leon Romanovsky wrote:
> On Mon, Apr 29, 2019 at 04:37:20PM -0700, Santosh Shilimkar wrote:
>> RDS doesn't support RDMA on memory apertures that require On Demand
>> Paging (ODP), such as FS DAX memory. A sysctl is added to indicate
>> whether RDMA requiring ODP is supported.
>>
>> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>> ---
>>   net/rds/ib.h        | 1 +
>>   net/rds/ib_sysctl.c | 8 ++++++++
>>   2 files changed, 9 insertions(+)
> 
> This sysctl is not needed at all
> 
Its needed for application to check the support of the ODP support
feature which in progress. Failing the RDS_GET_MR was just one path
and we also support inline MR registration along with message request.

Basically application runs on different kernel versions and to be
portable, it will check if underneath RDS support ODP and then only
use RDMA. If not it will fallback to buffer copy mode. Hope
it clarifies.


Regards,
Santosh
