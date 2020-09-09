Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEF1263610
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgIISdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:33:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:36156 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIISdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 14:33:14 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id A2B3114097F;
        Wed,  9 Sep 2020 20:33:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599676390; bh=13BAo7PhioyRt1A6+QH9jEwBH+3lNyqzcNSmS4Ipjkk=;
        h=Date:From:To;
        b=Z3yhHebVnpBJieJYSVAf4Dyt//HPrNz/KL1TlYgZT1ce3KVofOh7kc+pbcannyrZ/
         L0f3NWfO2bHwD6NLwl70o/G+VOfHTrk/riMAkJZSscdOMhJfZLtdV7MTyMoJvirWHw
         c7IdO9a2SvamiNJ1wLeJZhVVFtN/p27sLDseagiw=
Date:   Wed, 9 Sep 2020 20:33:10 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document
 binding for HW controlled LEDs
Message-ID: <20200909203310.15ca4e42@dellmb.labs.office.nic.cz>
In-Reply-To: <20200909182730.GK3290129@lunn.ch>
References: <20200909162552.11032-1-marek.behun@nic.cz>
        <20200909162552.11032-2-marek.behun@nic.cz>
        <20200909182730.GK3290129@lunn.ch>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Sep 2020 20:27:30 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Wed, Sep 09, 2020 at 06:25:46PM +0200, Marek Beh=FAn wrote:
> > Document binding for LEDs connected to and controlled by various
> > chips (such as ethernet PHY chips).
> >=20
> > Signed-off-by: Marek Beh=FAn <marek.behun@nic.cz>
> > Cc: Rob Herring <robh+dt@kernel.org>
> > Cc: devicetree@vger.kernel.org
> > ---
> >  .../leds/linux,hw-controlled-leds.yaml        | 99
> > +++++++++++++++++++ 1 file changed, 99 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> >=20
> > diff --git
> > a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > new file mode 100644 index 0000000000000..eaf6e5d80c5f5 ---
> > /dev/null +++
> > b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
> > @@ -0,0 +1,99 @@ +# SPDX-License-Identifier: GPL-2.0-only OR
> > BSD-2-Clause +%YAML 1.2
> > +---
> > +$id:
> > http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml# +
> > +title: LEDs that can be controlled by hardware (eg. by an ethernet
> > PHY chip) +
> > +maintainers:
> > +  - Marek Beh=FAn <marek.behun@nic.cz>
> > +
> > +description:
> > +  Many an ethernet PHY (and other chips) supports various HW
> > control modes
> > +  for LEDs connected directly to them. With this binding such LEDs
> > can be
> > +  described.
> > +
> > +properties:
> > +  compatible:
> > +    const: linux,hw-controlled-leds
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +patternProperties:
> > +  "^led@[0-9a-f]+$":
> > +    type: object
> > +    allOf:
> > +      - $ref: common.yaml#
> > +    description:
> > +      This node represents a LED device connected to a chip that
> > can control
> > +      the LED in various HW controlled modes.
> > +
> > +    properties:
> > +      reg:
> > +        maxItems: 1
> > +        description:
> > +          This property identifies the LED to the chip the LED is
> > connected to
> > +          (eg. an ethernet PHY chip can have multiple LEDs
> > connected to it). +
> > +      enable-active-high:
> > +        description:
> > +          Polarity of LED is active high. If missing, assumed
> > default is active
> > +          low.
> > +        type: boolean
> > +
> > +      led-tristate:
> > +        description:
> > +          LED pin is tristate type. If missing, assumed false.
> > +        type: boolean
> > +
> > +      linux,default-hw-mode:
> > +        description:
> > +          This parameter, if present, specifies the default HW
> > triggering mode
> > +          of the LED when LED trigger is set to `dev-hw-mode`.
> > +          Available values are specific per device the LED is
> > connected to and
> > +          per LED itself.
> > +        $ref: /schemas/types.yaml#definitions/string
> > +
> > +    required:
> > +      - reg =20
>=20
> My Yaml foo is not very good. Do you need to list colour, function and
> linux,default-trigger, or do they automagically get included from the
> generic LED binding?
>=20
> 	Andrew

I don't know :) I copied this from other drivers, I once tried setting
up environment for doing checking of device trees with YAML schemas,
and it was a little painful :)
