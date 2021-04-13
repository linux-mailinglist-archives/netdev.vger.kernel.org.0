Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3E335DFE5
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345109AbhDMNP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:15:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344864AbhDMNPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 09:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0FD6613B6;
        Tue, 13 Apr 2021 13:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618319732;
        bh=hntf3n54qqh0uXzZ6D8tUaPqStMPIr+/hNfZoDniY4A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pFpwLvstWECXqVpOgyrkrKmlfsQ28mBYBwtR2o1zDIZNTN3s1OyR8ka9IMQF3ifAE
         apbS1JSkX1Thm0Dz70rv4l+fRx8vcuF9w7H0zOOqpejghSANJvWB7UO37TuxD0SsPE
         tPNQd5x1e3XOL1g/hzXjXdaL4D/pRLipUmK6nOWDyro+mXVGfwYFTYKNilgerKm4ss
         VbyvwloBimOPyZejVrnXMy5SwDPYjcGpLt7in7dRz23norkDFszPBjq6XLp2scE4Ss
         IpeYXQTzhOEVZSa4EnQ+y8p0vmIN3KT0xqanjCYFh1IMn2jykf6CATmG4DFSpIF8+T
         9Z6LYAE7/ltbQ==
Received: by mail-ej1-f48.google.com with SMTP id sd23so17205708ejb.12;
        Tue, 13 Apr 2021 06:15:32 -0700 (PDT)
X-Gm-Message-State: AOAM531BGVUO9slmIAe8bA1f5SyEqknh1J7ju3fJz278EpTLZq+Qp2fC
        Zk6j3NCd6UNh+cxw8K9q57fsClDc2UWan1ALmA==
X-Google-Smtp-Source: ABdhPJzC/tge5Y9i/M8U9jxXXMaHumRpj2qoNI/uM/HWkeG+5F6Zoeof4s70jO3VjFJc52wf9aBwCKB/22YZrMkMMhQ=
X-Received: by 2002:a17:907:367:: with SMTP id rs7mr18299959ejb.468.1618319731269;
 Tue, 13 Apr 2021 06:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210409134056.18740-1-a-govindraju@ti.com> <20210409134056.18740-2-a-govindraju@ti.com>
 <f9b04d93-c249-970e-3721-50eb268a948f@pengutronix.de> <20210412174956.GA4049952@robh.at.kernel.org>
 <20210413074106.gvgtjkofyrdp5yxt@pengutronix.de>
In-Reply-To: <20210413074106.gvgtjkofyrdp5yxt@pengutronix.de>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 13 Apr 2021 08:15:18 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+yEQGuZYWhsQ-we36_Xi5X94YJ23oFe-T6h4U4X6iUhg@mail.gmail.com>
Message-ID: <CAL_Jsq+yEQGuZYWhsQ-we36_Xi5X94YJ23oFe-T6h4U4X6iUhg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: phy: Add binding for TI TCAN104x CAN transceivers
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Aswath Govindraju <a-govindraju@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-phy@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 2:41 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 12.04.2021 12:49:56, Rob Herring wrote:
> > On Mon, Apr 12, 2021 at 12:19:30PM +0200, Marc Kleine-Budde wrote:
> > > On 4/9/21 3:40 PM, Aswath Govindraju wrote:
> > > > Add binding documentation for TI TCAN104x CAN transceivers.
> > > >
> > > > Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> > > > ---
> > > >  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
> > > >  1 file changed, 56 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > > > new file mode 100644
> > > > index 000000000000..4abfc30a97d0
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> > > > @@ -0,0 +1,56 @@
> > > > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > > > +%YAML 1.2
> > > > +---
> > > > +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
> > > > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > > > +
> > > > +title: TCAN104x CAN TRANSCEIVER PHY
> > > > +
> > > > +maintainers:
> > > > +  - Aswath Govindraju <a-govindraju@ti.com>
> > > > +
> > > > +properties:
> > > > +  $nodename:
> > > > +    pattern: "^tcan104x-phy"
> > > > +
> > > > +  compatible:
> > > > +    enum:
> > > > +      - ti,tcan1042
> > > > +      - ti,tcan1043
> > >
> > > Can you create a generic standby only and a generic standby and enable transceiver?
> >
> > As a fallback compatible fine, but no generic binding please. A generic
> > binding can't describe any timing requirements between the 2 GPIO as
> > well as supplies when someone wants to add those (and they will).
>
> Right - that makes sense.
>
> > > > +
> > > > +  '#phy-cells':
> > > > +    const: 0
> > > > +
> > > > +  standby-gpios:
> > > > +    description:
> > > > +      gpio node to toggle standby signal on transceiver
> > > > +    maxItems: 1
> > > > +
> > > > +  enable-gpios:
> > > > +    description:
> > > > +      gpio node to toggle enable signal on transceiver
> > > > +    maxItems: 1
> > > > +
> > > > +  max-bitrate:
> > > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > > +    description:
> > > > +      max bit rate supported in bps
> >
> > We already have 'max-speed' for serial devices, use that.
>
> There is already the neither Ethernet PHY (PHYLINK/PHYLIB) nor generic
> PHY (GENERIC_PHY) can-transceiver binding
> Documentation/devicetree/bindings/net/can/can-transceiver.yaml which
> specifies max-bitrate. I don't have strong feelings whether to use
> max-bitrate or max-speed.

Okay, max-bitrate is fine.

>
> Speaking about Ethernet PHYs, what are to pros and cons to use the
> generic PHY compared to the Ethernet PHY infrastructure?

For higher speed ethernet, both are used. There's the serdes phy and
the ethernet phy with serdes phy using the generic phy binding. For
CAN, it probably comes down to what's a better fit.

Rob
