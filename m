Return-Path: <netdev+bounces-7791-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FFC72186D
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 18:07:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08892281168
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:06:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD051101C0;
	Sun,  4 Jun 2023 16:06:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AA45CB9
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 16:06:56 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D80B3;
	Sun,  4 Jun 2023 09:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3OUxATfYl8ZN5l6qgZVR1LuysKVqRTNjYsPk18jqhKc=; b=1ov/WgLqcog5fY90id+eITKa6U
	K9a/bVdYZUI3ir9CehaZnXEIUNWlfbPpTG8V30H4lpNg2kexsIzRxsEY0vgYyoahYOnqKdYjPtXNb
	tGtsvaYE5oEaQAxdUWKxWYt895f1AtUW483oebCgkIdr5fiQU6n/2krIX5dv4tErc07iK+6loaPYu
	5OgrM5bUeejQ2/6lqqb3QbfpIrNwtJkYO0hXegPvsxLe8JR5mxJuFGr41mACgP1UlPsB6QQ8ij9v+
	seCwohkM0SxhHdi1gwRRQfqziljeOyCz259ilbTA0Wmnkfh13VPHf679cLV0Qb20XXGygVZdO9xgu
	j6KMVNkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46988)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q5qFc-0002m4-Qf; Sun, 04 Jun 2023 17:06:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q5qFZ-0005Bo-Aq; Sun, 04 Jun 2023 17:06:37 +0100
Date: Sun, 4 Jun 2023 17:06:37 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Vladimir Oltean <olteanv@gmail.com>, Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 08/30] net: dsa: mt7530: change p{5,6}_interface
 to p{5,6}_configured
Message-ID: <ZHy2jQLesdYFMQtO@shell.armlinux.org.uk>
References: <20230526130145.7wg75yoe6ut4na7g@skbuf>
 <7117531f-a9f2-63eb-f69d-23267e5745d0@arinc9.com>
 <ZHsxdQZLkP/+5TF0@shell.armlinux.org.uk>
 <826fd2fc-fbf8-dab7-9c90-b726d15e2983@arinc9.com>
 <ZHyA/AmXmCxO6YMq@shell.armlinux.org.uk>
 <20230604125517.fwqh2uxzvsa7n5hu@skbuf>
 <ZHyMezyKizkz2+Wg@shell.armlinux.org.uk>
 <d269ac88-9923-c00c-8047-cc8c9f94ef2c@arinc9.com>
 <ZHyqI2oOI4KkvgB8@shell.armlinux.org.uk>
 <ZHy1C7wzqaj5KCmy@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZHy1C7wzqaj5KCmy@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 05:00:11PM +0100, Russell King (Oracle) wrote:
> On Sun, Jun 04, 2023 at 04:13:39PM +0100, Russell King (Oracle) wrote:
> > On Sun, Jun 04, 2023 at 04:14:31PM +0300, Arınç ÜNAL wrote:
> > > On 4.06.2023 16:07, Russell King (Oracle) wrote:
> > > > On Sun, Jun 04, 2023 at 03:55:17PM +0300, Vladimir Oltean wrote:
> > > > > On Sun, Jun 04, 2023 at 01:18:04PM +0100, Russell King (Oracle) wrote:
> > > > > > I don't remember whether Vladimir's firmware validator will fail for
> > > > > > mt753x if CPU ports are not fully described, but that would be well
> > > > > > worth checking. If it does, then we can be confident that phylink
> > > > > > will always be used, and those bypassing calls should not be necessary.
> > > > > 
> > > > > It does, I've just retested this:
> > > > > 
> > > > > [    8.469152] mscc_felix 0000:00:00.5: OF node /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 of CPU port 4 lacks the required "phy-handle", "fixed-link" or "managed" properties
> > > > > [    8.494571] mscc_felix 0000:00:00.5: error -EINVAL: Failed to register DSA switch
> > > > > [    8.502151] mscc_felix: probe of 0000:00:00.5 failed with error -22
> > > > 
> > > > ... which isn't listed in dsa_switches_apply_workarounds[], and
> > > > neither is mt753x. Thanks.
> > > > 
> > > > So, that should be sufficient to know that the CPU port will always
> > > > properly described, and thus bypassing phylink in mt753x for the CPU
> > > > port should not be necessary.
> > > 
> > > Perfect! If I understand correctly, there's this code - specific to MT7531
> > > and MT7988 ports being used as CPU ports - which runs in addition to what's
> > > in mt753x_phylink_mac_config():
> > > 
> > > 	mt7530_write(priv, MT7530_PMCR_P(port),
> > > 		     PMCR_CPU_PORT_SETTING(priv->id));
> > > 
> > > This should be put on mt753x_phylink_mac_config(), under priv->id ==
> > > ID_MT7531, priv->id == ID_MT7988, and dsa_is_cpu_port(ds, port) checks?
> > 
> > Please remember that I have very little knowledge of MT753x, so in
> > order to answer this question, I've read through the mt7530 driver
> > code.
> > 
> > Looking at mt7530.h:
> > 
> > #define  PMCR_CPU_PORT_SETTING(id)      (PMCR_FORCE_MODE_ID((id)) | \
> >                                          PMCR_IFG_XMIT(1) | PMCR_MAC_MODE | \
> >                                          PMCR_BACKOFF_EN | PMCR_BACKPR_EN | \
> >                                          PMCR_TX_EN | PMCR_RX_EN | \
> >                                          PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
> >                                          PMCR_FORCE_SPEED_1000 | \
> >                                          PMCR_FORCE_FDX | PMCR_FORCE_LNK)
> > 
> > This seems to be some kind of port control register that sets amongst
> > other things parameters such as whether flow control is enabled, the
> > port speed, the duplex setting, whether link is forced up, etc.
> > 
> > Looking at what mt753x_phylink_mac_link_up() does:
> > 
> > 1. it sets PMCR_RX_EN | PMCR_TX_EN | PMCR_FORCE_LNK.
> > 2. it sets PMCR_FORCE_SPEED_1000 if speed was 1000Mbps, or if using
> >    an internal, TRGMII, 1000base-X or 2500base-X phy interface mode.
> > 3. it sets PMCR_FORCE_FDX if full duplex was requested.
> > 4. it sets PMCR_TX_FC_EN if full duplex was requested with tx pause.
> > 5. it sets PMCR_RX_FC_EN if full duplex was requested with rx pause.
> > 
> > So, provided this is called with the appropriate parameters, for a
> > fixed link, that will leave the following:
> > 
> > 	PMCR_FORCE_MODE_ID(id)
> > 	PMCR_IFG_XMIT(1)
> > 	PMCR_MAC_MODE
> > 	PMCR_BACKOFF_EN
> > 	PMCR_BACKPR_EN
> > 
> > If we now look at mt753x_phylink_mac_config(), this sets
> > PMCR_IFG_XMIT(1), PMCR_MAC_MODE, PMCR_BACKOFF_EN, PMCR_BACKPR_EN,
> > and PMCR_FORCE_MODE_ID(priv->id), which I believe is everything that
> > PMCR_CPU_PORT_SETTING(priv->id) is doing.
> > 
> > So, Wouldn't a fixed-link description indicating 1Gbps, full duplex
> > with pause cause phylink to call both mt753x_phylink_mac_config() and
> > mt753x_phylink_mac_link_up() with appropriate arguments to set all
> > of these parameters in PMCR?
> > 
> > Now, I'm going to analyse something else. mt7531_cpu_port_config()
> > is called from mt753x_cpu_port_enable(), which is itself called from
> > mt7531_setup_common(). That is ultimately called from the DSA switch
> > ops .setup() method.
> > 
> > This method is called from dsa_switch_setup() for each switch in the
> > DSA tree. dsa_tree_setup_switches() calls this, and is called from
> > dsa_tree_setup().  Once dsa_tree_setup_switches() finishes
> > successfully, dsa_tree_setup_ports() will be called. This will then
> > setup DSA and CPU ports, which will then setup a phylink instance
> > for these ports. phylink will parse the firmware description for
> > the port. DSA will then call dsa_port_enable().
> > 
> > dsa_port_enable() will then call any port_enable() method in the
> > mt7530.c driver, which will be mt7530_port_enable(). This then...
> > 
> >         mt7530_clear(priv, MT7530_PMCR_P(port), PMCR_LINK_SETTINGS_MASK);
> > 
> > which is:
> > 
> > #define  PMCR_LINK_SETTINGS_MASK        (PMCR_TX_EN | PMCR_FORCE_SPEED_1000 | \
> >                                          PMCR_RX_EN | PMCR_FORCE_SPEED_100 | \
> >                                          PMCR_TX_FC_EN | PMCR_RX_FC_EN | \
> >                                          PMCR_FORCE_FDX | PMCR_FORCE_LNK | \
> >                                          PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100)
> > 
> > So it wipes out all the PMCR settings that mt7531_cpu_port_config()
> > performed - undoing *everything* below that switch() statement in
> > mt7531_cpu_port_config()!
> > 
> > Once the port_enable() method returns, DSA will then call
> > phylink_start(), which will trigger phylink to bring up the link
> > according to the settings it has, which will mean phylink calls
> > the mac_config(), pcs_config(), pcs_link_up() and mac_link_up()
> > with the appropriate parameters for the firmware described link.
> > 
> > So I think I have the answer to my initial thought: do the calls in
> > mt7531_cpu_port_config() to the phylink methods have any use what so
> > ever? The answer is no, they are entirely useless. The same goes for
> > the other cpu_port_config() methods that do something similar. The
> > same goes for the PMCR register write that's changing any bits
> > included in PMCR_LINK_SETTINGS_MASK.
> > 
> > What that means is that mt7988_cpu_port_config() can be entirely
> > removed, it serves no useful purpose what so ever. For
> > mt7531_cpu_port_config(), it only needs to set priv->p[56]_interface
> > which, as far as I can see, probably only avoids mac_config() doing
> > any pad setup (that's a guess.)
> > 
> > At least that's what I gather from reading through the driver and
> > DSA code. It may be I've missed something, but currently, I think
> > that these cpu_port_config() functions aren't doing too much that
> > is actually useful work.
> 
> Essentially, I think this change will have no effect at all on the
> driver, because any effect this code has is totally undone when the
> driver's port_enable() method is called:
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 9bc54e1348cb..447e63d74e0c 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2859,8 +2859,6 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
>  {
>  	struct mt7530_priv *priv = ds->priv;
>  	phy_interface_t interface;
> -	int speed;
> -	int ret;
>  
>  	switch (port) {
>  	case 5:
> @@ -2880,36 +2878,6 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
>  		return -EINVAL;
>  	}
>  
> -	if (interface == PHY_INTERFACE_MODE_2500BASEX)
> -		speed = SPEED_2500;
> -	else
> -		speed = SPEED_1000;
> -
> -	ret = mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
> -	if (ret)
> -		return ret;
> -	mt7530_write(priv, MT7530_PMCR_P(port),
> -		     PMCR_CPU_PORT_SETTING(priv->id));
> -	mt753x_phylink_pcs_link_up(&priv->pcs[port].pcs, MLO_AN_FIXED,
> -				   interface, speed, DUPLEX_FULL);
> -	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
> -				   speed, DUPLEX_FULL, true, true);
> -
> -	return 0;
> -}
> -
> -static int
> -mt7988_cpu_port_config(struct dsa_switch *ds, int port)
> -{
> -	struct mt7530_priv *priv = ds->priv;
> -
> -	mt7530_write(priv, MT7530_PMCR_P(port),
> -		     PMCR_CPU_PORT_SETTING(priv->id));
> -
> -	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED,
> -				   PHY_INTERFACE_MODE_INTERNAL, NULL,
> -				   SPEED_10000, DUPLEX_FULL, true, true);
> -
>  	return 0;
>  }
>  
> @@ -3165,7 +3133,6 @@ const struct mt753x_info mt753x_table[] = {
>  		.phy_read_c45 = mt7531_ind_c45_phy_read,
>  		.phy_write_c45 = mt7531_ind_c45_phy_write,
>  		.pad_setup = mt7988_pad_setup,
> -		.cpu_port_config = mt7988_cpu_port_config,
>  		.mac_port_get_caps = mt7988_mac_port_get_caps,
>  		.mac_port_config = mt7988_mac_config,
>  	},

... and with that patch we can remove the definition of
PMCR_CPU_PORT_SETTING() as well!

There is one possibility why we may not be able to remove this code -
whether there's something in this which requires the CPU port to be
setup prior to something else. Only someone knowledgeable of the
hardware, or who has the hardware in front and can test would be able
to work that out.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

