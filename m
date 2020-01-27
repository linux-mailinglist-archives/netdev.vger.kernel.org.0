Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B142714A2EC
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbgA0LVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:21:12 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34594 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgA0LVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 06:21:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=oN9jrHITT8NXPApGR5IdI2zdZsOhyn/YSoMnNfuDNDA=; b=FchA0Pz8WrdNQTx9TZOkxLvOV
        /1bPeZn17gBYrAnfgHxUyFM+fIwkwlPcSETRQsHKFtGdf/R6kuK/uS9C0sWK6/kqPwDWSqgyX0iRr
        ei5VsfhNvh19TG4oOweCY0FW4J8QLNV8hggyiAw8kUz43sr89Jf/eVHUJb1YW5O33vmcu/FMTeAEl
        kRgTZBW/EiOuHnEkSLpSeQQsafpyaWFF/bVML1fC39Md6ZZtWx1LZEBJxH6VhTjuelj9dYus0xoAX
        jCAux7AN6nGMMTeyciG2N+Wvc5oMPbtvuthIHCiN8AwnUisyPlZZpm1shEZLxINlYAM+s634ybDDO
        byc/CulpA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60526)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iw2S1-0000u0-5S; Mon, 27 Jan 2020 11:21:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iw2Ry-0001M9-7w; Mon, 27 Jan 2020 11:21:02 +0000
Date:   Mon, 27 Jan 2020 11:21:02 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 6/8] net: phylink: Configure MAC/PCS when link is
 up without PHY
Message-ID: <20200127112102.GT25745@shell.armlinux.org.uk>
References: <cover.1580122909.git.Jose.Abreu@synopsys.com>
 <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a2136885d9a892ff170be88fdffeda82c778a10.1580122909.git.Jose.Abreu@synopsys.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 12:09:11PM +0100, Jose Abreu wrote:
> When we don't have any real PHY driver connected and we get link up from
> PCS we shall configure MAC and PCS for the desired speed and also
> resolve the flow control settings from MAC side.

This is certainly the wrong place for it.  Please hold off on this patch
for the time being.  Thanks.

> 
> Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
> 
> ---
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/net/phy/phylink.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 4174d874b1f7..75dbaf80d7a5 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -533,10 +533,20 @@ static void phylink_resolve(struct work_struct *w)
>  
>  	if (link_changed) {
>  		pl->old_link_state = link_state.link;
> -		if (!link_state.link)
> +		if (!link_state.link) {
>  			phylink_mac_link_down(pl);
> -		else
> +		} else {
> +			/* If no PHY is connected, we still need to configure
> +			 * MAC/PCS for flow control and speed.
> +			 */
> +			if (!pl->phydev) {
> +				phylink_resolve_flow(pl, &link_state);
> +				phylink_mac_config(pl, &link_state);
> +			}
> +
>  			phylink_mac_link_up(pl, link_state);
> +		}
> +
>  	}
>  	if (!link_state.link && pl->mac_link_dropped) {
>  		pl->mac_link_dropped = false;
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
