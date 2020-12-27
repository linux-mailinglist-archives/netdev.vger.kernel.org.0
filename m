Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192662E31BA
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 16:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgL0P5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 10:57:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726179AbgL0P5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 10:57:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ktYP2-00EUHN-5T; Sun, 27 Dec 2020 16:56:16 +0100
Date:   Sun, 27 Dec 2020 16:56:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     dftxbs3e@free.fr
Cc:     irusskikh@marvell.com, netdev@vger.kernel.org, trivial@kernel.org,
        =?iso-8859-1?B?TOlv?= Le Bouter <lle-bout@zaclys.net>
Subject: Re: [PATCH] atlantic: enable compilation for PPC64
Message-ID: <X+iuoLDI63CBXnfJ@lunn.ch>
References: <20201227154238.1293-1-dftxbs3e@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201227154238.1293-1-dftxbs3e@free.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 27, 2020 at 04:42:38PM +0100, dftxbs3e@free.fr wrote:
> From: Léo Le Bouter <lle-bout@zaclys.net>
> 
> This was tested on a RaptorCS Talos II with IBM POWER9 DD2.2 CPUs and an
> ASUS XG-C100F PCI-e card without any issue. Speeds of ~8Gbps could be
> attained with not-very-scientific (wget HTTP) both-ways measurements on
> a local network. No warning or error reported in kernel logs.
> 
> Signed-off-by: Léo Le Bouter <lle-bout@zaclys.net>
> ---
>  drivers/net/ethernet/aquantia/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/Kconfig b/drivers/net/ethernet/aquantia/Kconfig
> index efb33c078a3c..c7b410e031a3 100644
> --- a/drivers/net/ethernet/aquantia/Kconfig
> +++ b/drivers/net/ethernet/aquantia/Kconfig
> @@ -19,7 +19,7 @@ if NET_VENDOR_AQUANTIA
>  config AQTION
>  	tristate "aQuantia AQtion(tm) Support"
>  	depends on PCI
> -	depends on X86_64 || ARM64 || COMPILE_TEST
> +	depends on X86_64 || ARM64 || PPC64 || COMPILE_TEST

Maybe remove the architecture depends all together?  At some point
RISCV is going to want it, etc...

      Andrew
