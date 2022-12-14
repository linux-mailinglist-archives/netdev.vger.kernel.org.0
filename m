Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2E964C9A4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbiLNNDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 08:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238398AbiLNNCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 08:02:43 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F215FCE5;
        Wed, 14 Dec 2022 05:02:22 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1p5ROp-0007VE-7T; Wed, 14 Dec 2022 14:02:15 +0100
Date:   Wed, 14 Dec 2022 13:02:11 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH net v2] net: dsa: mt7530: remove reduntant assignment
Message-ID: <Y5nJU9ymV59TdOyK@makrotopia.org>
References: <Y5ksCg/Rt/2ELVOG@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5ksCg/Rt/2ELVOG@makrotopia.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frank Wunderlich has reported a typo in the commit title, and he is
right: reduntant => redundant

Please either fix this while merging or wait until I'll post v3
tomorrow.

On Wed, Dec 14, 2022 at 01:51:06AM +0000, Daniel Golle wrote:
> Russell King correctly pointed out that the MAC_2500FD capability is
> already added for port 5 (if not in RGMII mode) and port 6 (which only
> supports SGMII) by mt7531_mac_port_get_caps. Remove the reduntant
> setting of this capability flag which was added by a previous commit.
> 
> Fixes: e19de30d2080 ("net: dsa: mt7530: add support for in-band link status")
> Reported-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/net/dsa/mt7530.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e74c6b406172..908fa89444c9 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2919,9 +2919,6 @@ static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
>  	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
>  				   MAC_10 | MAC_100 | MAC_1000FD;
>  
> -	if ((priv->id == ID_MT7531) && mt753x_is_mac_port(port))
> -		config->mac_capabilities |= MAC_2500FD;
> -
>  	/* This driver does not make use of the speed, duplex, pause or the
>  	 * advertisement in its mac_config, so it is safe to mark this driver
>  	 * as non-legacy.
> 
> base-commit: 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91
> -- 
> 2.39.0
> 
> 
