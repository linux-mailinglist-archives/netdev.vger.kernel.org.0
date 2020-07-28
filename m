Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1AE230E9A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgG1P7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730977AbgG1P7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:59:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732D9C061794;
        Tue, 28 Jul 2020 08:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sCLxp6AUq1KmYBCwLzSeRjYy8jCk/8A7PYbEtgGG+qY=; b=FBdfJX7RXHbQPC7Lt8l5KLv3H
        5jw/LPb2H4Mg8qL/wp+zku+Lj2h55sF0Y6agIQNJrTBNjuBM9YOt0dEfgsWwBqWZVZPVj/yy7mrgK
        xaURIu7OaaysamVAf538TZYDzlKIjek98q5EwLJwpAnb5XnhO0tA+qbCsqBVf2rDg4yGWQPNYc79o
        8EeRnwjSAsDHAgWqCyMhXAMEBJQ+/QqPObuLXw25uaqcWjM9VtAKN9zl04D1Dp9ltFZNmpAx1Od0x
        DuDxhjZIZG6j4Ee3Rmiuk9h5s+heolj6SGeBoLaIjNjlSGOngJEv4YF1wECBdZ2vOJZgqM4ysAKd0
        ZPvrb1+JQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45296)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0S0S-0004SE-PO; Tue, 28 Jul 2020 16:59:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0S0O-0004n3-Kl; Tue, 28 Jul 2020 16:59:04 +0100
Date:   Tue, 28 Jul 2020 16:59:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     linux-mediatek@lists.infradead.org,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        linux-kernel@vger.kernel.org, Mark Lee <Mark-MC.Lee@mediatek.com>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3] net: ethernet: mtk_eth_soc: fix mtu warning
Message-ID: <20200728155904.GT1551@shell.armlinux.org.uk>
References: <20200728122743.78489-1-frank-w@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200728122743.78489-1-frank-w@public-files.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 02:27:43PM +0200, Frank Wunderlich wrote:
> From: Landen Chao <landen.chao@mediatek.com>
> 
> in recent Kernel-Versions there are warnings about incorrect MTU-Size
> like these:

Can the above also be fixed for incorrect capitalisation and improper
hyphernation please?

Thanks.

> 
> eth0: mtu greater than device maximum
> mtk_soc_eth 1b100000.ethernet eth0: error -22 setting MTU to include DSA overhead
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Fixes: 72579e14a1d3 ("net: dsa: don't fail to probe if we couldn't set the MTU")
> Fixes: 7a4c53bee332 ("net: report invalid mtu value via netlink extack")
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 85735d32ecb0..a1c45b39a230 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -2891,6 +2891,8 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
>  	eth->netdev[id]->irq = eth->irq[0];
>  	eth->netdev[id]->dev.of_node = np;
> 
> +	eth->netdev[id]->max_mtu = MTK_MAX_RX_LENGTH - MTK_RX_ETH_HLEN;
> +
>  	return 0;
> 
>  free_netdev:
> --
> 2.25.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
