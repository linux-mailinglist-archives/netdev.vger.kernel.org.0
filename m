Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE902C7322
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgK1VuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:01 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:49838 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387687AbgK1UWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 15:22:15 -0500
Received: from relay4-d.mail.gandi.net (unknown [217.70.183.196])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id D5B113A05FE
        for <netdev@vger.kernel.org>; Sat, 28 Nov 2020 20:10:54 +0000 (UTC)
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 89999E0003;
        Sat, 28 Nov 2020 20:07:51 +0000 (UTC)
Date:   Sat, 28 Nov 2020 21:07:50 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128200750.GK1296649@piout.net>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128193707.GP1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128193707.GP1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 28/11/2020 19:37:07+0000, Russell King - ARM Linux admin wrote:
> On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
> > > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > > +				      unsigned int mode,
> > > +				      const struct phylink_link_state *state)
> > > +{
> > > +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > > +	struct sparx5_port_config conf;
> > > +	int err = 0;
> > > +
> > > +	conf = port->conf;
> > > +	conf.autoneg = state->an_enabled;
> > > +	conf.pause = state->pause;
> > > +	conf.duplex = state->duplex;
> > > +	conf.power_down = false;
> > > +	conf.portmode = state->interface;
> > > +
> > > +	if (state->speed == SPEED_UNKNOWN) {
> > > +		/* When a SFP is plugged in we use capabilities to
> > > +		 * default to the highest supported speed
> > > +		 */
> > 
> > This looks suspicious.
> > 
> > Russell, please could you look through this?
> 
> Maybe if I was copied on the patch submission... I don't have the
> patches, and searching google for them is a faff, especially
> when
> 
> site:kernel.org 20201127133307.2969817-1-steen.hegelund@microchip.com
> 
> gives:
> 
>    Your search - site:kernel.org
>    20201127133307.2969817-1-steen.hegelund@microchip.com - did not
>    match any documents. Suggestions: Make sure that all words are
>    spelled correctly. Try different keywords. Try more general
>    keywords.
> 

http://lore.kernel.org/r/20201127133307.2969817-1-steen.hegelund@microchip.com
does the right redirect.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
