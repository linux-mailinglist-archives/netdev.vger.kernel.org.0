Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7564F3D9CFB
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 07:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhG2FCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 01:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2FCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 01:02:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2567FC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 22:02:14 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m8yBQ-0002va-Ke; Thu, 29 Jul 2021 07:02:12 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m8yBN-0007pz-GV; Thu, 29 Jul 2021 07:02:09 +0200
Date:   Thu, 29 Jul 2021 07:02:09 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Alexandru Tachici <alexandru.tachici@analog.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 7/7] dt-bindings: adin1100: Add binding for ADIN1100
 Ethernet PHY
Message-ID: <20210729050209.5eo5hgimb5xctdn3@pengutronix.de>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
 <20210712130631.38153-8-alexandru.tachici@analog.com>
 <20210727055329.7y23ob7kir3te2e4@pengutronix.de>
 <CAL_JsqJXAPW7KRAdJac+uje95Nk-b6ojjow8VEzkF=PZvbDvnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL_JsqJXAPW7KRAdJac+uje95Nk-b6ojjow8VEzkF=PZvbDvnA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:01:31 up 238 days, 19:07, 12 users,  load average: 0.04, 0.04,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:23:12AM -0600, Rob Herring wrote:
> On Mon, Jul 26, 2021 at 11:53 PM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> >
> > On Mon, Jul 12, 2021 at 04:06:31PM +0300, alexandru.tachici@analog.com wrote:
> > > From: Alexandru Tachici <alexandru.tachici@analog.com>
> > >
> > > DT bindings for the ADIN1100 10BASE-T1L Ethernet PHY.
> > >
> > > Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> > > ---
> > >  .../devicetree/bindings/net/adi,adin1100.yaml | 45 +++++++++++++++++++
> > >  1 file changed, 45 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/adi,adin1100.yaml b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > > new file mode 100644
> > > index 000000000000..14943164da7a
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/adi,adin1100.yaml
> > > @@ -0,0 +1,45 @@
> > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/adi,adin1100.yaml#
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Analog Devices ADIN1100 PHY
> > > +
> > > +maintainers:
> > > +  - Alexandru Tachici <alexandru.tachici@analog.com>
> > > +
> > > +description:
> > > +  Bindings for Analog Devices Industrial Low Power 10BASE-T1L Ethernet PHY
> > > +
> > > +allOf:
> > > +  - $ref: ethernet-phy.yaml#
> > > +
> > > +properties:
> > > +  adi,disable-2400mv-tx-level:
> > > +    description:
> > > +      Prevent ADIN1100 from using the 2.4 V pk-pk transmit level.
> > > +    type: boolean
> >
> > This property should be generic. It is defined by IEEE 802.3cg 2019 and can
> > be implemented on all T1L PHYs.
> >
> > I assume, it should be something like:
> > ethernet-phy-10base-t1l-2.4vpp-enable
> > ethernet-phy-10base-t1l-2.4vpp-disable
> 
> 'ethernet-phy-' is a bit redundant and I'd make it a tristate (not
> present, 0, 1). So just '10base-t1l-2.4vpp'?
> 
> > To overwrite bootstrapped of fuzed values if supported. The IEEE 802.3cg
> > specification uses following wordings for this functionality:
> > "10BASE-T1L increased transmit level request ..."

sounds ok for me.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
