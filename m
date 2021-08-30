Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48BC3FB4B5
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236522AbhH3Lky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbhH3Lkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 07:40:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6504C061575;
        Mon, 30 Aug 2021 04:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=olFWSyursi1tndR4gL2jA2gcoq/zLkojRZ8FRs3OKHc=; b=ciSk/hhS1CWRvrPL14tgpUNf1
        iNWZN/P/OB+zchktLlH4LB6xfCXK56yY0Mq/b5FNlsqcSGBzxDI8bSET2K70HSRIwyWYIvr0sOBOZ
        U2LESDm4YTF8fqRuG0IIPtqCguZDN/XDLUd8O1yuCMAahUdtGcjSmKJp7MgIVVkxZJvtJ2vriL6Rc
        L9O21M/tX630hf9CduizKY+YewG0LLpavrB2Y+FpOf6JWl/VNosaJHW3mX6kKbVcPwTIOg47TxP+E
        wUnUUH+JwGSu53nq8FjzSDi+w5jZk6HkA04TE2NiTnHQAdZhxGoYjXm3Y+FqSdhkWojRqG22RoXh7
        o1Axxsw8A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47872)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mKfdo-00051Z-7A; Mon, 30 Aug 2021 12:39:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mKfdm-0004rR-Rl; Mon, 30 Aug 2021 12:39:50 +0100
Date:   Mon, 30 Aug 2021 12:39:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v1 2/3] net: phy: add qca8081 ethernet phy driver
Message-ID: <20210830113950.GX22278@shell.armlinux.org.uk>
References: <20210830110733.8964-1-luoj@codeaurora.org>
 <20210830110733.8964-3-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830110733.8964-3-luoj@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 07:07:32PM +0800, Luo Jie wrote:
> +/* AN 2.5G */
> +#define QCA808X_FAST_RETRAIN_2500BT		BIT(5)
> +#define QCA808X_ADV_LOOP_TIMING			BIT(0)
> 
> +/* Fast retrain related registers */
> +#define QCA808X_PHY_MMD1_FAST_RETRAIN_CTL	0x93
> +#define QCA808X_FAST_RETRAIN_CTRL_VALUE		0x1

These are standard 802.3 defined registers bits - please add
definitions for them to uapi/linux/mdio.h.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
