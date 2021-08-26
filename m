Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39233F8A6A
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 16:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242886AbhHZOvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 10:51:09 -0400
Received: from smtprelay0034.hostedemail.com ([216.40.44.34]:43974 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234773AbhHZOvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 10:51:09 -0400
Received: from omf12.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 9051618404103;
        Thu, 26 Aug 2021 14:50:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 7BC6C240235;
        Thu, 26 Aug 2021 14:50:19 +0000 (UTC)
Message-ID: <6d8179f45f7139ecc8172c2d2c4988b943393c1e.camel@perches.com>
Subject: Re: [PATCH] cxgb4: clip_tbl: Fix spelling mistake "wont" -> "won't"
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Raju Rangoju <rajur@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 26 Aug 2021 07:50:17 -0700
In-Reply-To: <20210826120108.12185-1-colin.king@canonical.com>
References: <20210826120108.12185-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5ptjmk6diszyt9z5pqmgpgwus9pnkghq
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 7BC6C240235
X-Spam-Status: No, score=0.10
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18UPfb51wV8xQD+e1IM8UtNepePynaPDYc=
X-HE-Tag: 1629989419-260293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-08-26 at 13:01 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are spelling mistakes in dev_err and dev_info messages. Fix them.
[]
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
[]
> @@ -120,7 +120,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
>  				write_unlock_bh(&ctbl->lock);
>  1 file changed, 2 insertions(+), 2 deletions(-)
>  				dev_err(adap->pdev_dev,
>  					"CLIP FW cmd failed with error %d, "
> -					"Connections using %pI6c wont be "
> +					"Connections using %pI6c won't be "
>  					"offloaded",
>  					ret, ce->addr6.sin6_addr.s6_addr);
>  				return ret;
> @@ -133,7 +133,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
>  	} else {
>  		write_unlock_bh(&ctbl->lock);
>  		dev_info(adap->pdev_dev, "CLIP table overflow, "
> -			 "Connections using %pI6c wont be offloaded",
> +			 "Connections using %pI6c won't be offloaded",
>  			 (void *)lip);

This is an unnecessary cast.
And these could coalesce the format fragments and add newlines too.


