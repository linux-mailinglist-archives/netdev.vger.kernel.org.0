Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B000351D67
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237258AbhDAS2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbhDASVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:21:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C3DC00F7EE;
        Thu,  1 Apr 2021 08:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NW9iR6zGvMABtC5sP1r/GglS9DsvmYxxu6+q/ZLVfFY=; b=Gd5OQxSHGkplwdLtJ00KgV6/U
        d9TmtLXaqXV55UHlwIpxZFJGVgUq/sqig6OErVwj1T5Y0dwY/kZWxiqhFfcwjZxQkQwu20ZhtQTNV
        9KRmXM07/v/EP5FtGjKaQwMcPq2aFv7GlYbMop8kgp0bY8HLW9b4KWWFCXVjXWSy0P/fM609FiAtu
        jj4eew3oCzkaJqFojYfmfqvlUg7JpTvd0Pg29miWo0rQDggtehBWJNU0RpOcY494b673y9GLw3PWB
        jW4RLmey/kvNt+9+srpqf7xH4KOgngNjbChjwnQfn0yvKCRBNodHFbmuzWSufsO8yMIgkLfprrmWK
        T1Wc7LBFg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52012)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lRyy8-0003LM-9t; Thu, 01 Apr 2021 16:10:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lRyy4-00050Q-AM; Thu, 01 Apr 2021 16:10:44 +0100
Date:   Thu, 1 Apr 2021 16:10:44 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, weifeng.voon@intel.com,
        boon.leong.ong@intel.com, qiangqing.zhang@nxp.com,
        vee.khee.wong@intel.com, fugang.duan@nxp.com,
        kim.tatt.chuah@intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com
Subject: Re: [PATCH net-next 1/2] net: stmmac: enable 2.5Gbps link speed
Message-ID: <20210401151044.GZ1463@shell.armlinux.org.uk>
References: <20210401150152.22444-1-michael.wei.hong.sit@intel.com>
 <20210401150152.22444-2-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401150152.22444-2-michael.wei.hong.sit@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 11:01:51PM +0800, Michael Sit Wei Hong wrote:
> +	/* 2.5G mode only support 2500baseT full duplex only */
> +	if (priv->plat->has_gmac4 && priv->plat->speed_2500_en) {
> +		phylink_set(mac_supported, 2500baseT_Full);
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Half);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseKX_Full);

Why? This seems at odds to the comment above?

What about 2500baseX_Full ?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
