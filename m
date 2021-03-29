Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4204234C37E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 08:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC2GFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 02:05:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34364 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhC2GFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 02:05:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12T5reg2107765;
        Mon, 29 Mar 2021 06:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=tS7z0CuO74FovWAcjBdZdSdavDQLzDTbvMKP+eFw5r8=;
 b=RBdv8O6ZYWO0qbK8BT437HvzzY4RrjtdCJmpAikAi3xeO9EwS2Hy/ThRbP2K9tXIhx0S
 ESegPiZkxtdwE1VOs3ApcRpaa84lCGUU8haelsXgzlQW1RcQeNUKMfIfoPjjQeFebo++
 /lpIWR6dea95E9CcCOAwFoBM7IF2Fp3nK30vxA6kDlwG1lBsxJbthH7MavScdVshAR8a
 IL9inEBhEWPk1C5MuDorn6GhrElAQutC/7pDqx5IKtIH1pb9qBDXcimFqf7pnVWe5tWr
 JsxHoN7W+sQdzwDJ0nevejB6dsW34Ls854Nx148EeM9UFiTUvpHuEkMhYpgzvG+a4G3I cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37hvnm2bc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 06:04:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12T5uc9B144359;
        Mon, 29 Mar 2021 06:04:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 37jefqa3gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 06:04:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12T64nKX010017;
        Mon, 29 Mar 2021 06:04:49 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 29 Mar 2021 06:04:48 +0000
Date:   Mon, 29 Mar 2021 09:04:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_router: remove redundant
 initialization of variable force
Message-ID: <20210329060441.GI1717@kadam>
References: <20210327223334.24655-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210327223334.24655-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290047
X-Proofpoint-GUID: lyzIJdyFaiK-NlX62eQkmGcXXV8Nb9Ai
X-Proofpoint-ORIG-GUID: lyzIJdyFaiK-NlX62eQkmGcXXV8Nb9Ai
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9937 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 27, 2021 at 10:33:34PM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable force is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> index 6ccaa194733b..ff240e3c29f7 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
> @@ -5059,7 +5059,7 @@ mlxsw_sp_nexthop_obj_bucket_adj_update(struct mlxsw_sp *mlxsw_sp,
>  {
>  	u16 bucket_index = info->nh_res_bucket->bucket_index;
>  	struct netlink_ext_ack *extack = info->extack;
> -	bool force = info->nh_res_bucket->force;
> +	bool force;
>  	char ratr_pl_new[MLXSW_REG_RATR_LEN];
>  	char ratr_pl[MLXSW_REG_RATR_LEN];
>  	u32 adj_index;

Reverse Christmas tree.

regards,
dan carpenter

