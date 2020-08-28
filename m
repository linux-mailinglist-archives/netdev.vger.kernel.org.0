Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066F12558F3
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 12:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgH1K5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 06:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbgH1K4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 06:56:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEEFC061236;
        Fri, 28 Aug 2020 03:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VvK78WVDOB3813Y9VLnOVQrDFYwjVa9aFCav/Nofmnw=; b=W2SRH6AOPaKUfD9lJTMH/8ZOW
        1iE6bQ42dKp3h1cxCL1qnFCgb+OmMljBByQ9uGG2E4Cf5eopnJkHU24G2GWXk3QTeoLLNzVwA4Frl
        WjJHzCPTILWzgvGb/ZA2iEuG4mZFI2QZwWQNOIv/WT4FUKmvsu8oTLxRVLfxC4Mx/k3S4RseDs1yo
        C8Y3GVQlaHe818nHBnIdW021cefuYbuWfIXKhprFK2rzIW2TR6IVB2W9uGoZs93Rx9si6cfy4OSLN
        A7HffXipNvMdJbtccxSA1uMGdmCAbvPnQORy2mOM8y77xROqGywyoqswsb4uYbzJEbja9DTKietQd
        5I1QMHkFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58158)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kBc20-0005uF-Hw; Fri, 28 Aug 2020 11:54:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kBc1u-00034A-V9; Fri, 28 Aug 2020 11:54:46 +0100
Date:   Fri, 28 Aug 2020 11:54:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, dqfext@gmail.com,
        frank-w@public-files.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, opensource@vdorst.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net v2] net: dsa: mt7530: fix advertising unsupported
 1000baseT_Half
Message-ID: <20200828105446.GK1551@shell.armlinux.org.uk>
References: <20200828105244.9839-1-landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828105244.9839-1-landen.chao@mediatek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 06:52:44PM +0800, Landen Chao wrote:
> Remove 1000baseT_Half to advertise correct hardware capability in
> phylink_validate() callback function.
> 
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
> v1->v2
>   - fix the commit subject spilled into the commit message
> ---
>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 8dcb8a49ab67..238417db26f9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1501,7 +1501,7 @@ static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
>  		phylink_set(mask, 100baseT_Full);
>  
>  		if (state->interface != PHY_INTERFACE_MODE_MII) {
> -			phylink_set(mask, 1000baseT_Half);
> +			/* This switch only supports 1G full-duplex. */
>  			phylink_set(mask, 1000baseT_Full);
>  			if (port == 5)
>  				phylink_set(mask, 1000baseX_Full);
> -- 
> 2.17.1
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
