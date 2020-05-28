Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88011E6C65
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407043AbgE1UVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:21:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57550 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406966AbgE1UVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 16:21:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SKBfvb120316;
        Thu, 28 May 2020 20:21:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=eWfOLK+JWOjw/sInZQyPb6SBSNK+JbSeG6TrByezY/k=;
 b=v7oeBN8rWa8IubPcqVl8LeXQmGsoyWF0mqZqamu3Rn4dsBVkEsfq9b63qTOyHGOi9vFS
 QwKJGHWJJoG5YMxiewd2IwLt3U7d1bWJWf4Vax4bqMyz1mEj9k+AG2XMH+GXEwnvsvk7
 5qqOaof13r+U9EtTnTPB5wKTMjk6rN/ZKJmJsPJEadpaEgPcvc6JlOUUO5yVVlQ6T94K
 2u3r5T+ZatcwVy9Uy8GGF1/K6bQOxBmmeBX6lHnbk/mzuVwA9PYm56e3dycTE8XEgbkz
 ruk0lyk/WhyUxIITlCS5LpRgDjBUhykdEBx6c98W/dtCtL4x4IgxY0vHUXZPJOrBZIoV +A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 316u8r74gt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 20:21:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SK7e1n148116;
        Thu, 28 May 2020 20:21:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 317j5wanwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 20:21:37 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04SKLa7f031371;
        Thu, 28 May 2020 20:21:36 GMT
Received: from [10.74.106.237] (/10.74.106.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 13:21:35 -0700
Subject: Re: [PATCH v3 03/13] RDMA/rds: Remove FMR support for memory
 registration
To:     Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     aron.silverton@oracle.com, Max Gurtovoy <maxg@mellanox.com>,
        oren@mellanox.com, shlomin@mellanox.com, vladimirk@mellanox.com
References: <3-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <27824c0c-06ba-40dd-34c2-2888fe8db5c8@oracle.com>
Date:   Thu, 28 May 2020 13:21:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <3-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9635 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=0
 phishscore=0 clxscore=1011 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005280132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 12:45 PM, Jason Gunthorpe wrote:
> From: Max Gurtovoy <maxg@mellanox.com>
> 
> Use FRWR method for memory registration by default and remove the ancient
> and unsafe FMR method.
> 
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

> ---
>   net/rds/Makefile  |   2 +-
>   net/rds/ib.c      |  20 ++--
>   net/rds/ib.h      |   2 -
>   net/rds/ib_cm.c   |   4 +-
>   net/rds/ib_fmr.c  | 269 ----------------------------------------------
>   net/rds/ib_frmr.c |   4 +-
>   net/rds/ib_mr.h   |  14 +--
>   net/rds/ib_rdma.c |  28 ++---
>   8 files changed, 21 insertions(+), 322 deletions(-)
>   delete mode 100644 net/rds/ib_fmr.c
> 
Patch looks accurate to me Jason/Max. I wanted to get few regression
tests run with it before providing the ack. Will send a note once
its tested ok.

Regards,
Santosh
