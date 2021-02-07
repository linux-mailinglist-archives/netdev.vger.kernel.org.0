Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FCF31278C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 22:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBGVay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 16:30:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGVau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 16:30:50 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l8rd5-004iEQ-BC; Sun, 07 Feb 2021 22:30:03 +0100
Date:   Sun, 7 Feb 2021 22:30:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     stefanc@marvell.com
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, rmk+kernel@armlinux.org.uk,
        atenart@kernel.org, devicetree@vger.kernel.org, robh+dt@kernel.org,
        sebastian.hesselbarth@gmail.com, gregory.clement@bootlin.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 net-next 01/15] doc: marvell: add CM3 address space
 and PPv2.3 description
Message-ID: <YCBb2xWGXjNqBWPl@lunn.ch>
References: <1612723137-18045-1-git-send-email-stefanc@marvell.com>
 <1612723137-18045-2-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612723137-18045-2-git-send-email-stefanc@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 07, 2021 at 08:38:43PM +0200, stefanc@marvell.com wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Patch adds CM3 address space PPv2.3 description.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> ---
>  Documentation/devicetree/bindings/net/marvell-pp2.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell-pp2.txt b/Documentation/devicetree/bindings/net/marvell-pp2.txt
> index b783976..1eb480a 100644
> --- a/Documentation/devicetree/bindings/net/marvell-pp2.txt
> +++ b/Documentation/devicetree/bindings/net/marvell-pp2.txt
> @@ -1,5 +1,6 @@
>  * Marvell Armada 375 Ethernet Controller (PPv2.1)
>    Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
> +  Marvell CN913X Ethernet Controller (PPv2.3)
>  
>  Required properties:
>  
> @@ -12,7 +13,7 @@ Required properties:
>  	- common controller registers
>  	- LMS registers
>  	- one register area per Ethernet port
> -  For "marvell,armada-7k-pp2", must contain the following register
> +  For "marvell,armada-7k-pp2" used by 7K/8K and CN913X, must contain the following register
>    sets:
>  	- packet processor registers
>  	- networking interfaces registers

Hi Stefan

Shouldn't there be an entry here describing what the third register
set is?
