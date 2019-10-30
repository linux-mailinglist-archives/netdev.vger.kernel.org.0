Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE8E9A74
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 11:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfJ3Kz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 06:55:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:9010 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfJ3Kz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 06:55:29 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 47352k62rMz9vC12;
        Wed, 30 Oct 2019 11:55:26 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=XPYljseg; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id uu25dTN3YMcD; Wed, 30 Oct 2019 11:55:26 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 47352k4xR0z9vC0y;
        Wed, 30 Oct 2019 11:55:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1572432926; bh=HBlLtJ215+QvNQV7weZ8681fHhQDwH2De/MKiJrOgxs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=XPYljsegKvIoZZ73/DxSEYx5OsvSxbA+Hd6P+HQiQ3ZUh4+jo5s+sZzSK7NK4s9yC
         JLx4+RhY6mEPpHzgt4+APDzn6+yfkVGrNWrsLyZBWSsZZ/Qmu0xyZ6GN7pHcx2b0b6
         fTiwtAD8hBNHVYODKxDOn6blIOsbkSbkX7ginzsA=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D07E58B7C8;
        Wed, 30 Oct 2019 11:55:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id W6nV1hCwWHCU; Wed, 30 Oct 2019 11:55:27 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D23078B86A;
        Wed, 30 Oct 2019 11:55:25 +0100 (CET)
Subject: Re: [PATCH v2 19/23] net: ethernet: freescale: make UCC_GETH
 explicitly depend on PPC32
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Qiang Zhao <qiang.zhao@nxp.com>, Li Yang <leoyang.li@nxp.com>
Cc:     linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Scott Wood <oss@buserror.net>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        netdev@vger.kernel.org
References: <20191018125234.21825-1-linux@rasmusvillemoes.dk>
 <20191025124058.22580-1-linux@rasmusvillemoes.dk>
 <20191025124058.22580-20-linux@rasmusvillemoes.dk>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <a8b52b7f-9a96-7f7e-1360-7e4ed723d286@c-s.fr>
Date:   Wed, 30 Oct 2019 11:55:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025124058.22580-20-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 25/10/2019 à 14:40, Rasmus Villemoes a écrit :
> Currently, QUICC_ENGINE depends on PPC32, so this in itself does not
> change anything. In order to allow removing the PPC32 dependency from
> QUICC_ENGINE and avoid allmodconfig build failures, add this explicit
> dependency.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   drivers/net/ethernet/freescale/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/freescale/Kconfig b/drivers/net/ethernet/freescale/Kconfig
> index 6a7e8993119f..97d27c7740d4 100644
> --- a/drivers/net/ethernet/freescale/Kconfig
> +++ b/drivers/net/ethernet/freescale/Kconfig
> @@ -75,6 +75,7 @@ config FSL_XGMAC_MDIO
>   config UCC_GETH
>   	tristate "Freescale QE Gigabit Ethernet"
>   	depends on QUICC_ENGINE
> +	depends on PPC32

I think it would be more obvious to have:
	depends on QUICC_ENGINE && PPC32

Christophe

>   	select FSL_PQ_MDIO
>   	select PHYLIB
>   	---help---
> 
