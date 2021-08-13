Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B073EBBF9
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhHMSX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:23:29 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:35505 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhHMSX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 14:23:28 -0400
Received: by mail-ot1-f41.google.com with SMTP id r19-20020a0568301353b029050aa53c3801so13069688otq.2;
        Fri, 13 Aug 2021 11:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tpbnD/GvsLKZ81IxmHwIGA1dTzsxr0AhEtp1onHyNnw=;
        b=CsbUsRWkFx/madDgjOXIO8ErTdlKsirgy21rY1OBp6ogSA1JCM0WpFdh03mNplU3+o
         Wg+u01QlKmGq0XLAe9TSrLzUlqUfMszSp4p23OFsvw5YVBuufwxgkVu43ZFbnIp2zgnd
         KhNC5mgjpS7OsMQwft8MTQyr56WiupKdSohfWfEkP77g3cAHemeTVvKB6FloD5uIsZPR
         FQiO2GcwFDVHMdb5yh6qKjuuQDoWvGZZV3CJIjb/YRlpSntghAQJsgiuaI2+Sy2PlX6u
         EoJvP1hyzUE9OWKpWO91ZtetG8a8H+OPCCp5nVs4pYLKAA9v1B+BgtldSpRS5v+XFOYj
         U59g==
X-Gm-Message-State: AOAM5304r1bIbQ3JKeLmY8fUEOY1Xx4ckxevxw0JQKyawGN1KtWW3HAm
        Nr/IRvYyJHyEMOzJS6wPeA==
X-Google-Smtp-Source: ABdhPJwBIl+MNB6h2HTYTrEN5YMc98K25OaHILkcATZKTfAT7H2+jo3+d7Pf4mOgjUu+xMOy2WLylg==
X-Received: by 2002:a9d:4590:: with SMTP id x16mr3154518ote.94.1628878981431;
        Fri, 13 Aug 2021 11:23:01 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id bf41sm500815oib.41.2021.08.13.11.23.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 11:23:00 -0700 (PDT)
Received: (nullmailer pid 3804702 invoked by uid 1000);
        Fri, 13 Aug 2021 18:22:59 -0000
Date:   Fri, 13 Aug 2021 13:22:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
 wakeup-irq" property
Message-ID: <YRa4g8cjGrQ979pQ@robh.at.kernel.org>
References: <20210805074615.29096-1-qiangqing.zhang@nxp.com>
 <20210805074615.29096-2-qiangqing.zhang@nxp.com>
 <2e1a14bf-2fa8-ed39-d133-807c4e14859c@gmail.com>
 <DB8PR04MB67950F6863A8FEE6745CBC68E6F69@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <498f3cee-8f37-2ab1-93c4-5472572ecc37@gmail.com>
 <DB8PR04MB6795DC35D0387637052E64A1E6F79@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YRKOGYwx1uVdsKoF@lunn.ch>
 <VI1PR04MB6800EE08F70CC3F0DD53C991E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR04MB6800EE08F70CC3F0DD53C991E6F89@VI1PR04MB6800.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 07:57:46AM +0000, Joakim Zhang wrote:
> 
> Hi Andrew,
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: 2021年8月10日 22:33
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: Florian Fainelli <f.fainelli@gmail.com>; davem@davemloft.net;
> > kuba@kernel.org; robh+dt@kernel.org; shawnguo@kernel.org;
> > s.hauer@pengutronix.de; festevam@gmail.com; kernel@pengutronix.de;
> > dl-linux-imx <linux-imx@nxp.com>; netdev@vger.kernel.org;
> > devicetree@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org
> > Subject: Re: [PATCH net-next 1/3] dt-bindings: net: fsl, fec: add "fsl,
> > wakeup-irq" property
> > 
> > > > > 1) FEC controller has up to 4 interrupt lines and all of these are
> > > > > routed to GIC
> > > > interrupt controller.
> > > > > 2) FEC has a wakeup interrupt signal and always are mixed with
> > > > > other
> > > > interrupt signals, and then output to one interrupt line.
> > > > > 3) For legacy SoCs, wakeup interrupt are mixed to int0 line, but
> > > > > for i.MX8M
> > > > serials, are mixed to int2 line.
> > 
> > So you need to know which of the interrupts listed is the wake up interrupt.

We already have a way to do this by using 'wakeup' for the 
interrupt-names entry. But I guess that ship has sailed here and that 
wouldn't work well if not just a wakeup source (though you could repeat 
an interrupt line that's the wakeup source).

> > 
> > I can see a few ways to do this:
> > 
> > The FEC driver already has quirks. Add a quirk to fec_imx8mq_info and
> > fec_imx8qm_info to indicate these should use int2.

Bingo!

Note that if the device is wakeup capable, it should have a 
'wakeup-source' property in this case.

> > 
> > or
> > 
> > Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> > 
> >   b) two cells
> >   ------------
> >   The #interrupt-cells property is set to 2 and the first cell defines the
> >   index of the interrupt within the controller, while the second cell is used
> >   to specify any of the following flags:
> >     - bits[3:0] trigger type and level flags
> >         1 = low-to-high edge triggered
> >         2 = high-to-low edge triggered
> >         4 = active high level-sensitive
> >         8 = active low level-sensitive
> > 
> > You could add
> > 
> >        18 = wakeup source

I'd be okay with this (though it should be a power of 2 number).

> > 
> > and extend to core to either do all the work for you, or tell you this interrupt is
> > flagged as being a wakeup source. This solution has the advantage of it should
> > be usable in other drivers.

Another option is couldn't you just enable all the interrupts as wakeup 
sources? Presumably, only one of them would trigger a wakeup.

> 
> Thanks a lot for your comments first!
> 
> I just look into the irq code, if we extend bit[5] to carry wakeup info ( due to bit[4] is used for IRQ_TYPE_PROBE), 
> then configure it in the TYPE field of 'interrupts' property, so that interrupt controller would know which interrupt
> is wakeup capable. 
> I think there is no much work core would do, may just set this interrupt wakup capable. Another functionality is
> driver side get this info to identify which mixed interrupt has wakeup capability, we can export symbol from kernel/irq/irqdomain.c.
> 
> The intention is to let driver know which interrupt is wakeup capable, I would choose to provider this in specific driver,
> instead of interrupt controller, it seems to me that others may all choose this solution for wakeup mixed interrupt.
> 
> So I would prefer solution 1, it's easier and under-control. I can have a try if you strongly recommend solution 2.
> 
> Best Regards,
> Joakim Zhang
> > 	  Andrew
