Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA8C1EA317
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFALvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:51:38 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:38185 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgFALvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 07:51:38 -0400
Received: from localhost (lfbn-lyo-1-15-81.w86-202.abo.wanadoo.fr [86.202.110.81])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 4F74F240004;
        Mon,  1 Jun 2020 11:51:31 +0000 (UTC)
Date:   Mon, 1 Jun 2020 13:51:31 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: Re: [PATCH v3 net-next 01/13] regmap: add helper for per-port
 regfield initialization
Message-ID: <20200601115131.GA3720@piout.net>
References: <20200531122640.1375715-1-olteanv@gmail.com>
 <20200531122640.1375715-2-olteanv@gmail.com>
 <20200601105430.GB5234@sirena.org.uk>
 <CA+h21hqp92JBchpesxT8spZs7P7nmW_Vf0tev_Li4hjWw2_vUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqp92JBchpesxT8spZs7P7nmW_Vf0tev_Li4hjWw2_vUw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/06/2020 14:12:38+0300, Vladimir Oltean wrote:
> Hi Mark,
> 
> On Mon, 1 Jun 2020 at 13:54, Mark Brown <broonie@kernel.org> wrote:
> >
> > On Sun, May 31, 2020 at 03:26:28PM +0300, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > Similar to the standalone regfields, add an initializer for the users
> > > who need to set .id_size and .id_offset in order to use the
> > > regmap_fields_update_bits_base API.
> > >
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > Link: https://lore.kernel.org/r/20200527234113.2491988-2-olteanv@gmail.com
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> >
> > Please either just wait till after the merge window or ask for a pull
> > request like I said when I applied the patch.
> 
> The trouble with waiting is that I'll then have to wait for another
> release cycle until I can send device tree patches to Shawn Guo's
> devicetree branch. So this seemed to me as the path of least friction.

You can actually have the device tree changes and the driver changes in
the same release as there is no build time dependency.

> In my mind I am not exactly sure what the pull request does to improve
> the work flow. My simplified idea was that you would send a pull
> request upstream, then David would send a pull request upstream (or
> the other way around), and poof, this common commit would disappear
> from one of the pull requests.

No, this would make you commit appear twice in the history with
different hashes. If you want to have what you suggest, Dave needs to
first take Mark's PR so both PR will have the same commit hash.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
