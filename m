Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF3F6D94AE
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbjDFLHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbjDFLHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:07:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A607A9D;
        Thu,  6 Apr 2023 04:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=29DiQcJ+NesR4bzlrgSGDb6JnN91qFQawEIe6tNxYUo=; b=BaTEkyAhdN5dw6cCUs02xo/plw
        WLCS1AwOw7Zev1BLZKXfHyhlnjjP4ozYoeSUWRONWbmN0kba+V79CUy1Jbd7mClSdQvOmm+DeKbF9
        QOgTs7KK1c0Y1EvvPS9742xOwiQ+ehUMnp9kMAfP6KIc6NCR7kwM+lsRFHvBII9EYFbKGZqnuVvpk
        WsRwArejLCyVoakKWoeGXIFdfT2za2hfvRhiJfZaz0u5hp+5h6b6SWAdw9AOGikDrBObt7z+PXTfe
        jazufLNrIJMXtIDEZSWaGiw3XZ2UHf2CnxFB1+BRLVDOySv5sNwEVGNnVEVoHmEt5FTgJ3o4LFSnS
        /rlKe9rQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46406)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pkNSN-0006ry-9H; Thu, 06 Apr 2023 12:07:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pkNSH-0007R0-4o; Thu, 06 Apr 2023 12:07:01 +0100
Date:   Thu, 6 Apr 2023 12:07:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next] net: dsa: mt7530: fix port specifications
 for MT7988
Message-ID: <ZC6n1XAGyZFlxyXx@shell.armlinux.org.uk>
References: <20230406100445.52915-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230406100445.52915-1-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 01:04:45PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> On the switch on the MT7988 SoC, there are only 4 PHYs. There's only port 6
> as the CPU port, there's no port 5. Split the switch statement with a check
> to enforce these for the switch on the MT7988 SoC. The internal phy-mode is
> specific to MT7988 so put it for MT7988 only.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
> 
> Daniel, this is based on the information you provided me about the switch.
> I will add this to my current patch series if it looks good to you.
> 
> Arınç
> 
> ---
>  drivers/net/dsa/mt7530.c | 67 ++++++++++++++++++++++++++--------------
>  1 file changed, 43 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 6fbbdcb5987f..f167fa135ef1 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2548,7 +2548,7 @@ static void mt7988_mac_port_get_caps(struct dsa_switch *ds, int port,
>  	phy_interface_zero(config->supported_interfaces);
>  
>  	switch (port) {
> -	case 0 ... 4: /* Internal phy */
> +	case 0 ... 3: /* Internal phy */
>  		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
>  			  config->supported_interfaces);
>  		break;
> @@ -2710,37 +2710,56 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	struct mt7530_priv *priv = ds->priv;
>  	u32 mcr_cur, mcr_new;
>  
> -	switch (port) {
> -	case 0 ... 4: /* Internal phy */
> -		if (state->interface != PHY_INTERFACE_MODE_GMII &&
> -		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
> -			goto unsupported;
> -		break;
> -	case 5: /* Port 5, a CPU port. */
> -		if (priv->p5_interface == state->interface)
> +	if (priv->id == ID_MT7988) {
> +		switch (port) {
> +		case 0 ... 3: /* Internal phy */
> +			if (state->interface != PHY_INTERFACE_MODE_INTERNAL)

How do these end up with PHY_INTERFACE_MODE_INTERNAL ? phylib defaults
to GMII mode without something else being specified in DT.

Also note that you should *not* be validating state->interface in the
mac_config() method because it's way too late to reject it - if you get
an unsupported interface here, then that is down to the get_caps()
method being buggy. Only report interfaces in get_caps() that you are
prepared to handle in the rest of the system.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
