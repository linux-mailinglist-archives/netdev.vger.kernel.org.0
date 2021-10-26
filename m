Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D3E43B027
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhJZKir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbhJZKiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 06:38:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FE2C061745;
        Tue, 26 Oct 2021 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zFxsPJg3WPcNJY0FhnIZ6abtZyzPYauR+kJ9zIn0VPo=; b=pA2T6nRAYNHMFL+mB1vnyeWcBH
        rCb31LMoADZXZUodL/NTT76iO4ALgVY4m/QC3ke4px0pvJOL0qHKAiFMS+lw4P38P0iJEy7Z7+rOR
        VNKIUXXejHKAuXVRQzza6fqFK9v+H8COMJD3f5B/opCbJmRWBc2cCd4pI07LwH88uJsjRlVAm+kQc
        umxxnAfj1uVHAiKt+bF9ywqTJCebMYYAyzw0EulAO46DXiGLkOwAqqMeaDGOZtYhg7cqlrwlx/1XY
        GuRwzVXRjoXf0TBiZlSfxzP5eANvcZawER0S2wJLqk/RglUua+7mjVnS1aqZqJZYHXaY6vvNvlOLe
        GaDj/vrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55306)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mfJo2-0005FZ-ND; Tue, 26 Oct 2021 11:35:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mfJo1-0006ft-BB; Tue, 26 Oct 2021 11:35:45 +0100
Date:   Tue, 26 Oct 2021 11:35:45 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: fixed warning: Function parameter not described
Message-ID: <YXfaAfSfPTaTTpVf@shell.armlinux.org.uk>
References: <20211026102957.17100-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026102957.17100-1-luoj@codeaurora.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 06:29:57PM +0800, Luo Jie wrote:
> Fixed warning: Function parameter or member 'enable' not
> described in 'genphy_c45_fast_retrain'
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/phy-c45.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index b01180e1f578..db709d30bf84 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -614,6 +614,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_loopback);
>  /**
>   * genphy_c45_fast_retrain - configure fast retrain registers
>   * @phydev: target phy_device struct
> + * @enable: enable fast retrain or not
>   *
>   * Description: If fast-retrain is enabled, we configure PHY as
>   *   advertising fast retrain capable and THP Bypass Request, then

Patch itself is fine, but I wonder why we've started getting
Description: prefixes on new functions in this file whereas the
bulk of the descriptions in the file do not use that prefix.

In any case, for this patch:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
