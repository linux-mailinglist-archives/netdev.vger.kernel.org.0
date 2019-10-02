Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF5FC8971
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfJBNSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:18:11 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48276 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbfJBNSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 09:18:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92DEIDE023643;
        Wed, 2 Oct 2019 13:17:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=kXMcu5VQ15D9xKnPxBh3+Ftt1CqLJTYpiEFrjq4TfAg=;
 b=oXPd2+g7d2yTwj+5qSOr+7FRpGcabuyFeGEeo2TA05LUJIHKm1JRRDqEB5FtshMTcpFa
 1c1OSWe2ssUMcoExnFOnbQDKLWj+LuqnMrEiIf+omI+z693lrOTngxgec+1+GeKNnagq
 V4R205JA2fpUTMxyG4VK04yN1a+FGkxX+hXUIw/HFyVVaosgi/jT893FdKdLoMMSKlWb
 Aky/+5/KdbHU/SIzqqxRaLV1k/Fl0mUz0Sb7/+CS+8EkRuKf74l37X6bOxiKzaM1Baka
 GiOz1kXcQr+5tq4m7Bd0DNeReTgxfPvf5HrFOaGx9Rw2mYGQ7DGcHI5Ku3kjPyvWlZgD ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2va05rvs48-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 13:17:47 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x92DEAjg161263;
        Wed, 2 Oct 2019 13:17:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vbsm3ugxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Oct 2019 13:17:46 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x92DHhbE013341;
        Wed, 2 Oct 2019 13:17:43 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Oct 2019 06:17:43 -0700
Date:   Wed, 2 Oct 2019 16:17:35 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        Lubomir Rintel <lkundrak@v3.sk>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libertas: remove redundant assignment to variable ret
Message-ID: <20191002131734.GN22609@kadam>
References: <20191002101517.10836-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002101517.10836-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910020127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9397 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910020127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added Lubomir Rintel to the CC list.

On Wed, Oct 02, 2019 at 11:15:17AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being assigned a value that is never read and is
> being re-assigned a little later on. The assignment is redundant and hence
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/marvell/libertas/mesh.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
> index 2747c957d18c..44c8a550da4c 100644
> --- a/drivers/net/wireless/marvell/libertas/mesh.c
> +++ b/drivers/net/wireless/marvell/libertas/mesh.c
> @@ -1003,7 +1003,6 @@ static int lbs_add_mesh(struct lbs_private *priv)
>  	if (priv->mesh_tlv) {
>  		sprintf(mesh_wdev->ssid, "mesh");
>  		mesh_wdev->mesh_id_up_len = 4;
> -		ret = 1;
>  	}

Removing this is fine.  "ret = 1" is a mistake.

This was copy and pasted in commit 2199c9817670 ("libertas: use
mesh_wdev->ssid instead of priv->mesh_ssid").  The return value was
never used so it's not clear what returning 1 vs 0 was supposed to mean.

lbs_init_mesh() should just be a void function.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
