Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25553CFF88
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 18:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233651AbhGTPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 11:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231201AbhGTPvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 11:51:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7613561029;
        Tue, 20 Jul 2021 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626798751;
        bh=ypdOVSXde9mSqNuEOYJo1JsPFR9n/cYlE3gaMft6WwQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YAt9DZvmhhkENoU2GW2xwfIA4L29UqoEO1U+6Q0GkVfmQmehZfOhbWj3TgPdJNL+u
         M8u2DpOUx0kDEqsFsdAP9nY+WVNSj0reMexIzquzm8CDU4Nk0FmLHXPmKmpnv710/f
         wvEZi9Q0au0T5VjVU4DdCDUGv7h213+fxzhwtNfLvhk2JFawezq7LBvAgtgD4Lnail
         2RhttnmI17ps+pRzbP21hqRDLJDXsmbyaYEAV2rq9GVp1LBf5Cuc6vpJUhVx2BJxAt
         TfhM+pHK3fbvNBxXSXBK3uQW2n/GtocgJcImGZU+Qe4Dyz6CfuJ7ExyzzYp1tTn3jv
         B3ZgbvnK+yvhA==
Received: by mail-ed1-f49.google.com with SMTP id ee25so29173786edb.5;
        Tue, 20 Jul 2021 09:32:31 -0700 (PDT)
X-Gm-Message-State: AOAM530XP84Sd34kzWUDI3AQ+QhNo820toRtNd8zciH589AwDZ1No6lc
        xloImDmJRWO6+PQg6PhAEakH2Ur72UDXibtS1g==
X-Google-Smtp-Source: ABdhPJzkh3fmHHxZ43PsduTEYBj6eKlrwTJQC9me/kiO9JLvFkAJRrNaivP/bcGcf6ZhRZ9e5v9w/XkQn2xSn7p0K+w=
X-Received: by 2002:aa7:df12:: with SMTP id c18mr41966112edy.62.1626798750012;
 Tue, 20 Jul 2021 09:32:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
 <20210716102911.23694-2-qiangqing.zhang@nxp.com> <20210719224507.GA2740161@robh.at.kernel.org>
 <DB8PR04MB67950DD860AEB00CEDA9020FE6E29@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB67950DD860AEB00CEDA9020FE6E29@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 20 Jul 2021 10:32:18 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKzONKSooUFDKZOiAGg7fP3=wxALz=kxs9jGb9BF2XBjw@mail.gmail.com>
Message-ID: <CAL_JsqKzONKSooUFDKZOiAGg7fP3=wxALz=kxs9jGb9BF2XBjw@mail.gmail.com>
Subject: Re: [PATCH V1 1/3] dt-bindings: net: fec: convert fsl,*fec bindings
 to yaml
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "bruno.thomsen@gmail.com" <bruno.thomsen@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 3:58 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrot=
e:
>
>
> Hi Rob,
>
> > -----Original Message-----
> > From: Rob Herring <robh@kernel.org>
> > Sent: 2021=E5=B9=B47=E6=9C=8820=E6=97=A5 6:45
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; shawnguo@kernel.org;
> > s.hauer@pengutronix.de; kernel@pengutronix.de; festevam@gmail.com;
> > bruno.thomsen@gmail.com; dl-linux-imx <linux-imx@nxp.com>;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org;
> > linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> > Subject: Re: [PATCH V1 1/3] dt-bindings: net: fec: convert fsl,*fec bin=
dings to
> > yaml
> >
> > On Fri, Jul 16, 2021 at 06:29:09PM +0800, Joakim Zhang wrote:
> > > In order to automate the verification of DT nodes convert fsl-fec.txt
> > > to fsl,fec.yaml, and pass binding check with below command.
> > >
> > > $ make ARCH=3Darm CROSS_COMPILE=3Darm-linux-gnueabihf- dt_binding_che=
ck
> > DT_SCHEMA_FILES=3DDocumentation/devicetree/bindings/net/fsl,fec.yaml
> > >   DTEX    Documentation/devicetree/bindings/net/fsl,fec.example.dts
> > >   DTC
> > Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml
> > >   CHECK
> > Documentation/devicetree/bindings/net/fsl,fec.example.dt.yaml
> > >
> > > Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> > > ---
> > >  .../devicetree/bindings/net/fsl,fec.yaml      | 213 ++++++++++++++++=
++
> > >  .../devicetree/bindings/net/fsl-fec.txt       |  95 --------
> > >  2 files changed, 213 insertions(+), 95 deletions(-)  create mode
> > > 100644 Documentation/devicetree/bindings/net/fsl,fec.yaml
> > >  delete mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt
> >
> > Since the networking maintainers can't wait for actual binding reviews,=
 you get
> > to send a follow-up patch...
> OK.
>
> > >
> > > diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > > b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > > new file mode 100644
> > > index 000000000000..7fa11f6622b1
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > > @@ -0,0 +1,213 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +%YAML 1.2
> > > +---
> > > +$id:
> > > +https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fd=
evi
> > >
> > +cetree.org%2Fschemas%2Fnet%2Ffsl%2Cfec.yaml%23&amp;data=3D04%7C01
> > %7Cqia
> > >
> > +ngqing.zhang%40nxp.com%7Cf54454be267b426e60d008d94b06dfc7%7C686
> > ea1d3b
> > >
> > +c2b4c6fa92cd99c5c301635%7C0%7C0%7C637623315180063755%7CUnknow
> > n%7CTWFp
> > >
> > +bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> > I6M
> > >
> > +n0%3D%7C1000&amp;sdata=3DMG%2F9aKVQ8quuLiYxtC%2F7zqZTY7mIHur4G
> > D7tsPtfq%
> > > +2Bg%3D&amp;reserved=3D0
> > > +$schema:
> > > +https://eur01.safelinks.protection.outlook.com/?url=3Dhttp%3A%2F%2Fd=
evi
> > >
> > +cetree.org%2Fmeta-schemas%2Fcore.yaml%23&amp;data=3D04%7C01%7Cqia
> > ngqing
> > >
> > +.zhang%40nxp.com%7Cf54454be267b426e60d008d94b06dfc7%7C686ea1d3b
> > c2b4c6
> > >
> > +fa92cd99c5c301635%7C0%7C0%7C637623315180063755%7CUnknown%7CT
> > WFpbGZsb3
> > >
> > +d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0
> > %3D%
> > >
> > +7C1000&amp;sdata=3D7vf8UYQ7c%2BlaJxzAzhzvkPPvbaX3UWVowCtDtPNO9p
> > Q%3D&amp
> > > +;reserved=3D0
> > > +
> > > +title: Freescale Fast Ethernet Controller (FEC)
> > > +
> > > +maintainers:
> > > +  - Joakim Zhang <qiangqing.zhang@nxp.com>
> > > +
> > > +allOf:
> > > +  - $ref: ethernet-controller.yaml#
> > > +
> > > +properties:
> > > +  compatible:
> > > +    oneOf:
> > > +      - enum:
> > > +          - fsl,imx25-fec
> > > +          - fsl,imx27-fec
> > > +          - fsl,imx28-fec
> > > +          - fsl,imx6q-fec
> > > +          - fsl,mvf600-fec
> > > +      - items:
> > > +          - enum:
> > > +              - fsl,imx53-fec
> > > +              - fsl,imx6sl-fec
> > > +          - const: fsl,imx25-fec
> > > +      - items:
> > > +          - enum:
> > > +              - fsl,imx35-fec
> > > +              - fsl,imx51-fec
> > > +          - const: fsl,imx27-fec
> > > +      - items:
> > > +          - enum:
> > > +              - fsl,imx6ul-fec
> > > +              - fsl,imx6sx-fec
> > > +          - const: fsl,imx6q-fec
> > > +      - items:
> > > +          - enum:
> > > +              - fsl,imx7d-fec
> > > +          - const: fsl,imx6sx-fec
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  interrupts:
> > > +    minItems: 1
> > > +    maxItems: 4
> > > +
> > > +  interrupt-names:
> > > +    description:
> > > +      Names of the interrupts listed in interrupts property in the s=
ame
> > order.
> > > +      The defaults if not specified are
> > > +      __Number of interrupts__   __Default__
> > > +            1                       "int0"
> > > +            2                       "int0", "pps"
> > > +            3                       "int0", "int1", "int2"
> > > +            4                       "int0", "int1", "int2", "pps"
> > > +      The order may be changed as long as they correspond to the
> > interrupts
> > > +      property.
> >
> > Why? None of the existing dts files do that and there is no reason to s=
upport
> > random order. You can do this:
> >
> > oneOf:
> >   - minItems: 1
> >     items:
> >       - const: int0
> >       - const: pps
> >   - minItems: 3
> >     items:
> >       - const: int0
> >       - const: int1
> >       - const: int2
> >       - const: pps
>
> How about below?
>     oneOf:
>       - items:
>           - const: int0
>       - items:
>           - const: int0
>           - const: pps
>       - items:
>           - const: int0
>           - const: int1
>           - const: int2
>       - items:
>           - const: int0
>           - const: int1
>           - const: int2
>           - const: pps

What I wrote for you is the same thing, just more concise.

> >
> >
> > > Currently, only i.mx7 uses "int1" and "int2". They correspond to
> >
> > Sounds like another constraint under an if/then schema.
> >
> > > +      tx/rx queues 1 and 2. "int0" will be used for queue 0 and ENET=
_MII
> > interrupts.
> > > +      For imx6sx, "int0" handles all 3 queues and ENET_MII. "pps" is=
 for
> > the pulse
> > > +      per second interrupt associated with 1588 precision time
> > protocol(PTP).
> > > +
> > > +  clocks:
> > > +    minItems: 2
> > > +    maxItems: 5
> > > +    description:
> > > +      The "ipg", for MAC ipg_clk_s, ipg_clk_mac_s that are for regis=
ter
> > accessing.
> > > +      The "ahb", for MAC ipg_clk, ipg_clk_mac that are bus clock.
> > > +      The "ptp"(option), for IEEE1588 timer clock that requires the =
clock.
> > > +      The "enet_clk_ref"(option), for MAC transmit/receiver referenc=
e
> > clock like
> > > +      RGMII TXC clock or RMII reference clock. It depends on board
> > design,
> > > +      the clock is required if RGMII TXC and RMII reference clock so=
urce
> > from
> > > +      SOC internal PLL.
> > > +      The "enet_out"(option), output clock for external device, like=
 supply
> > clock
> > > +      for PHY. The clock is required if PHY clock source from SOC.
> > > +
> > > +  clock-names:
> > > +    minItems: 2
> > > +    maxItems: 5
> > > +    contains:
> > > +      enum:
> > > +      - ipg
> > > +      - ahb
> > > +      - ptp
> > > +      - enet_clk_ref
> > > +      - enet_out
> >
> > This means clock-names contains one of these strings and then anything =
else is
> > valid.
> >
> > s/contains/items/
> OK.
>
> >
> > > +
> > > +  phy-mode: true
> > > +
> > > +  phy-handle: true
> > > +
> > > +  fixed-link: true
> > > +
> > > +  local-mac-address: true
> > > +
> > > +  mac-address: true
> > > +
> > > +  phy-supply:
> > > +    description:
> > > +      Regulator that powers the Ethernet PHY.
> > > +
> > > +  fsl,num-tx-queues:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description:
> > > +      The property is valid for enet-avb IP, which supports hw multi
> > queues.
> > > +      Should specify the tx queue number, otherwise set tx queue num=
ber
> > to 1.
> >
> > constraints? 2^32 queues are valid?
> Yes, the value should be limited to 1, 2, 3. Will add:
> default: 1
> minimum: 1
> maximum: 3

Personally, I'd do 'enum: [ 1, 2, 3 ]' instead.

>
> >
> > > +
> > > +  fsl,num-rx-queues:
> > > +    $ref: /schemas/types.yaml#/definitions/uint32
> > > +    description:
> > > +      The property is valid for enet-avb IP, which supports hw multi
> > queues.
> > > +      Should specify the rx queue number, otherwise set rx queue num=
ber
> > to 1.
> >
> > constraints?
> Will add.
>
> >
> > > +
> > > +  fsl,magic-packet:
> > > +    $ref: /schemas/types.yaml#/definitions/flag
> > > +    description:
> > > +      If present, indicates that the hardware supports waking up via=
 magic
> > packet.
> > > +
> > > +  fsl,err006687-workaround-present:
> > > +    $ref: /schemas/types.yaml#/definitions/flag
> > > +    description:
> > > +      If present indicates that the system has the hardware workarou=
nd
> > for
> > > +      ERR006687 applied and does not need a software workaround.
> > > +
> > > +  fsl,stop-mode:
> > > +    $ref: /schemas/types.yaml#/definitions/phandle-array
> > > +    description:
> > > +      Register bits of stop mode control, the format is <&gpr req_gp=
r
> > req_bit>.
> >
> > So, maxItems: 3
> Why? I think maxItems: 1
>
> >
> > > +      gpr is the phandle to general purpose register node.
> > > +      req_gpr is the gpr register offset for ENET stop request.
> > > +      req_bit is the gpr bit offset for ENET stop request.
> > > +
> > > +  mdio:
> > > +    type: object
> > > +    description:
> > > +      Specifies the mdio bus in the FEC, used as a container for phy=
 nodes.
> > > +
> > > +  # Deprecated optional properties:
> > > +  # To avoid these, create a phy node according to ethernet-phy.yaml
> > > + in the same  # directory, and point the FEC's "phy-handle" property
> > > + to it. Then use  # the phy's reset binding, again described by
> > ethernet-phy.yaml.
> > > +
> > > +  phy-reset-gpios:
> > > +    deprecated: true
> > > +    description:
> > > +      Should specify the gpio for phy reset.
> > > +
> > > +  phy-reset-duration:
> > > +    deprecated: true
> > > +    description:
> > > +      Reset duration in milliseconds.  Should present only if proper=
ty
> > > +      "phy-reset-gpios" is available.  Missing the property will hav=
e the
> > > +      duration be 1 millisecond.  Numbers greater than 1000 are inva=
lid
> > > +      and 1 millisecond will be used instead.
> > > +
> > > +  phy-reset-active-high:
> > > +    deprecated: true
> > > +    description:
> > > +      If present then the reset sequence using the GPIO specified in=
 the
> > > +      "phy-reset-gpios" property is reversed (H=3Dreset state, L=3Do=
peration
> > state).
> > > +
> > > +  phy-reset-post-delay:
> > > +    deprecated: true
> > > +    description:
> > > +      Post reset delay in milliseconds. If present then a delay of
> > phy-reset-post-delay
> > > +      milliseconds will be observed after the phy-reset-gpios has be=
en
> > toggled.
> > > +      Can be omitted thus no delay is observed. Delay is in range of=
 1ms to
> > 1000ms.
> > > +      Other delays are invalid.
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - interrupts
> > > +
> > > +# FIXME: We had better set additionalProperties to false to avoid
> > > +invalid or at # least undocumented properties. However, PHY may have
> > > +a deprecated option to # place PHY OF properties in the MAC node,
> > > +such as Micrel PHY, and we can find # these boards which is based on
> > i.MX6QDL.
> > > +additionalProperties: true
> >
> > Why can't the dts files be updated? Can you point me to an example .dts=
?
>
> Below dtsi under fec device node:
> arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
> arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
> arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi

You either need to document all those deprecated properties or update
the dts files. I'd prefer the latter.

Rob
