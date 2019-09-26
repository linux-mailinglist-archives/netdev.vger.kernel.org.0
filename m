Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA09BE96B
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 02:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbfIZASq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 20:18:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52542 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387802AbfIZASp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 20:18:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lrbC+Xl/MubhNlELr1KrZaP5CEBCrFK63dZxZb/R6VI=; b=TezixmWo5ebCVN86WH3eKc39c
        sGt+jGo0zSnGticJxdym5sm3kYOz1+OA9dPQliAOiTFe7RiRBFvjFew81RUqHlvntUXhpOPSWA49V
        hjzWZrPQfx9dpRaHGHOCpToMkPZpwx9g3cek1YehdHFrXJju2coyNZmshRQXA3xXXd26rQm4FQCVq
        vAHujAOx5YuoydRNtbkGx1KXCUuNu5Zc8ZTQzquwtMPRiDIN0xJdvQRU707x1GOnLPY06cARrzjlC
        ugvX1pSarSjBksziyP3LjYu9JOD/INbjmgEYwll0p2TG77/BeXVCNMmR16uJIQrrFWndOTzhNYrIs
        g635Kx/eg==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iDHUa-0003wx-5i; Thu, 26 Sep 2019 00:18:44 +0000
Subject: Re: [PATCH v2] dimlib: make DIMLIB a hidden symbol
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <uwe@kleine-koenig.org>,
        Tal Gilboa <talgi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190924.164528.724219923520816886.davem@davemloft.net>
 <20190924160259.10987-1-uwe@kleine-koenig.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <979eebb6-1cd5-2d11-3797-b47700c5d454@infradead.org>
Date:   Wed, 25 Sep 2019 17:18:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924160259.10987-1-uwe@kleine-koenig.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 9:02 AM, Uwe Kleine-König wrote:
> According to Tal Gilboa the only benefit from DIM comes from a driver
> that uses it. So it doesn't make sense to make this symbol user visible,
> instead all drivers that use it should select it (as is already the case
> AFAICT).
> 
> Signed-off-by: Uwe Kleine-König <uwe@kleine-koenig.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
> Hello David,
> 
> On Tue, Sep 24, 2019 at 04:45:28PM +0200, David Miller wrote:
>> Since this doesn't apply due to the moderation typo being elsewhere, I'd
>> really like you to fix up this submission to properly be against 'net'.
> 
> I thought it would be possible to git-apply my patch with the -3 option.
> I even tested that, but obviously it only applies to my tree that has
> the git object with the typo fixed. Sorry for the extra effort I'm
> forcing on you. This patch applies to your public tree from just now.
> 
> Best regads
> Uwe
> 
>  lib/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 4e6b1c3e4c98..d7fc9eb33b9b 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -555,8 +555,7 @@ config SIGNATURE
>  	  Implementation is done using GnuPG MPI library
>  
>  config DIMLIB
> -	bool "DIM library"
> -	default y
> +	bool
>  	help
>  	  Dynamic Interrupt Moderation library.
>  	  Implements an algorithm for dynamically change CQ modertion values
> 


-- 
~Randy
