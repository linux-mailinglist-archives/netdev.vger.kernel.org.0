Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2369366118
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhDTUrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:47:53 -0400
Received: from gateway30.websitewelcome.com ([192.185.184.48]:21519 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233682AbhDTUrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:47:52 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 16:47:52 EDT
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 75BA31B51F
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:24:14 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Ywusldxyh1cHeYwusllkvE; Tue, 20 Apr 2021 15:24:14 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9YUTPA5Ok3BrBYNC0Dh7n9d5iaJCdFrQ2Xsk4P+rUY4=; b=AF9vOvKsFc70HxWbjBMc8iBvUR
        9W3NKtHd28oZAs8Z/D9ESAUgAyHDZWklzlZdN+89dclI86/ec7yK8dzU02GdJfnAk0LiB6ox1i4uQ
        7yqN3fPdgMW7AODlUekCHWqxyTtGuTwxZ3EVGoTqjNFyBLINHDy8YkMvb96Y1Aqrnmu/J/V1xJkiE
        hp4Gq4ctsLihrrce6fU/KXDoRgPlNuew+0x+aU0TJSpxdC1NITkuXKCftRzG1SjrdIlOgn09LV1/y
        croRnyDr15vj0L1B8//Vh55tUf48eNazsrMT45UGZFW9fjJbO7QXy2LvjBNmUMGtx/J9Qke/eUP1W
        3flgBZgQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49032 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwuo-0031M1-8m; Tue, 20 Apr 2021 15:24:10 -0500
Subject: Re: [PATCH RESEND][next] net/mlx4: Fix fall-through warnings for
 Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305084847.GA138343@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <808373f4-25d0-9e7e-fe16-f8b279d1ebab@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:24:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305084847.GA138343@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1lYwuo-0031M1-8m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49032
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 164
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 02:48, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> index a99e71bc7b3c..771b92019af1 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
> @@ -2660,6 +2660,7 @@ int mlx4_FREE_RES_wrapper(struct mlx4_dev *dev, int slave,
>  	case RES_XRCD:
>  		err = xrcdn_free_res(dev, slave, vhcr->op_modifier, alop,
>  				     vhcr->in_param, &vhcr->out_param);
> +		break;
>  
>  	default:
>  		break;
> 
