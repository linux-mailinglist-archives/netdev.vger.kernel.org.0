Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 719E19667D
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730330AbfHTQeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:34:36 -0400
Received: from vps.xff.cz ([195.181.215.36]:35884 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729888AbfHTQef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566318873; bh=3EWCt3iq/B/vjAGtGo7IXhuRxxDcIZbWkjIAdRe7UbM=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=py9/BlWS5YpsBC+Ob1OADS/v6gNrFJh+2R35taWE4l0I08LKPhR6sIH0qcyRfrwtM
         D+LAbXmPoRgIIHlVbnEhG9sWzKZjHzCiCDJvoT0n1SFpumVjMj9nJcsicSkkJYd2KT
         z9lPeAk6WE7kRV2NWjKB/Q62TU5tZqBALJK8kweQ=
Date:   Tue, 20 Aug 2019 18:34:33 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 2/6] dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply
 property
Message-ID: <20190820163433.sr4lvjxmmhjtbtcb@core.my.home>
Mail-Followup-To: Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-3-megous@megous.com>
 <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:20:22AM -0500, Rob Herring wrote:
> On Tue, Aug 20, 2019 at 9:53 AM <megous@megous.com> wrote:
> >
> > From: Ondrej Jirman <megous@megous.com>
> >
> > Some PHYs require separate power supply for I/O pins in some modes
> > of operation. Add phy-io-supply property, to allow enabling this
> > power supply.
> 
> Perhaps since this is new, such phys should have *-supply in their nodes.

Yes, I just don't understand, since external ethernet phys are so common,
and they require power, how there's no fairly generic mechanism for this
already in the PHY subsystem, or somewhere?

It looks like other ethernet mac drivers also implement supplies on phys
on the EMAC nodes. Just grep phy-supply through dt-bindings/net.

Historical reasons, or am I missing something? It almost seems like I must
be missing something, since putting these properties to phy nodes
seems so obvious.

thank you and regards,
	Ondrej

> >
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml    | 4 ++++
> >  1 file changed, 4 insertions(+)
