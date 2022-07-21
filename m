Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECBB57D34C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiGUSaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiGUS34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:29:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038608C8D9;
        Thu, 21 Jul 2022 11:29:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7704D61FD8;
        Thu, 21 Jul 2022 18:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4F9C341CE;
        Thu, 21 Jul 2022 18:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658428193;
        bh=Pl+gLqKQxLJK9F7QwAj5jF5+jUyNj4bbTIpEoPFUbOU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=d/FlpGKKy3eShP4OygXsSMW28+0naP5V+ZPoYCur5cXCFuKAGHwmr33yGIxl/sXpu
         gnVU7GxKpRG6rebW/TTugIJ1/4207yZJ59bCFXBFySDa1hRyHbSBiKocX3X9xtGFBJ
         Zk1g6x0zMLALQ6YaPAafQ3dDMiEenBV7S+j/x840TlFtUx28HgQm1rSMC5HA/IKk9P
         LJV1Kl9PTponXPV5vckYOuVAcpXx+61KbNNU9O3igtBhbC1NeyfK2t2G0mG7ekddGh
         SaOKG+em9VSPhfv85DcbZSC7i8u0i5eWYYJn3zbzEMXAYeqVXLbQfovMyIz/TeoU9T
         iVFs6ZQMCXVEQ==
Received: by mail-vs1-f51.google.com with SMTP id j1so2344246vsr.4;
        Thu, 21 Jul 2022 11:29:53 -0700 (PDT)
X-Gm-Message-State: AJIora/r3Q1OoNs79XXwft0DlGNcCbfh66/t/Ow+efiTOMV2qeEQWVgx
        XiHXPm2LS9HjQmYmPoq8Jl4iuMubGSSO9xrKSA==
X-Google-Smtp-Source: AGRyM1vEvtKbdX8fyIgtgjSksM0g4dPbh/ZQKD7bHOOzlJUyWkTVS0NhGIVkqx8TiLx/fB0F/mXqOevv+MGWOCT1OLE=
X-Received: by 2002:a67:c088:0:b0:358:bb1:fdf7 with SMTP id
 x8-20020a67c088000000b003580bb1fdf7mr4938634vsi.85.1658428192502; Thu, 21 Jul
 2022 11:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-2-sean.anderson@seco.com> <20220720221704.GA4049520-robh@kernel.org>
 <d4d6d881-ca3e-b77f-cee0-70e2518bef69@seco.com>
In-Reply-To: <d4d6d881-ca3e-b77f-cee0-70e2518bef69@seco.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 21 Jul 2022 12:29:40 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJqU4-F52NLWDWK=Qy0ECRrYL9fmJD4CLd=J1KzCBgU7Q@mail.gmail.com>
Message-ID: <CAL_JsqJqU4-F52NLWDWK=Qy0ECRrYL9fmJD4CLd=J1KzCBgU7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 01/47] dt-bindings: phy: Add Lynx 10G phy binding
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        "open list:GENERIC PHY FRAMEWORK" <linux-phy@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 10:06 AM Sean Anderson <sean.anderson@seco.com> wrote:
>
>
>
> On 7/20/22 6:17 PM, Rob Herring wrote:
> > On Fri, Jul 15, 2022 at 05:59:08PM -0400, Sean Anderson wrote:
> >> This adds a binding for the SerDes module found on QorIQ processors. The
> >> phy reference has two cells, one for the first lane and one for the
> >> last. This should allow for good support of multi-lane protocols when
> >> (if) they are added. There is no protocol option, because the driver is
> >> designed to be able to completely reconfigure lanes at runtime.
> >> Generally, the phy consumer can select the appropriate protocol using
> >> set_mode. For the most part there is only one protocol controller
> >> (consumer) per lane/protocol combination. The exception to this is the
> >> B4860 processor, which has some lanes which can be connected to
> >> multiple MACs. For that processor, I anticipate the easiest way to
> >> resolve this will be to add an additional cell with a "protocol
> >> controller instance" property.
> >>
> >> Each serdes has a unique set of supported protocols (and lanes). The
> >> support matrix is configured in the device tree. The format of each
> >> PCCR (protocol configuration register) is modeled. Although the general
> >> format is typically the same across different SoCs, the specific
> >> supported protocols (and the values necessary to select them) are
> >> particular to individual SerDes. A nested structure is used to reduce
> >> duplication of data.
> >>
> >> There are two PLLs, each of which can be used as the master clock for
> >> each lane. Each PLL has its own reference. For the moment they are
> >> required, because it simplifies the driver implementation. Absent
> >> reference clocks can be modeled by a fixed-clock with a rate of 0.
> >>
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> ---
> >>
> >> Changes in v3:
> >> - Manually expand yaml references
> >> - Add mode configuration to device tree
> >>
> >> Changes in v2:
> >> - Rename to fsl,lynx-10g.yaml
> >> - Refer to the device in the documentation, rather than the binding
> >> - Move compatible first
> >> - Document phy cells in the description
> >> - Allow a value of 1 for phy-cells. This allows for compatibility with
> >>   the similar (but according to Ioana Ciornei different enough) lynx-28g
> >>   binding.
> >> - Remove minItems
> >> - Use list for clock-names
> >> - Fix example binding having too many cells in regs
> >> - Add #clock-cells. This will allow using assigned-clocks* to configure
> >>   the PLLs.
> >> - Document the structure of the compatible strings
> >>
> >>  .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 311 ++++++++++++++++++
> >>  1 file changed, 311 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> >>
> >> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> >> new file mode 100644
> >> index 000000000000..a2c37225bb67
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
> >> @@ -0,0 +1,311 @@
> >> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> >> +%YAML 1.2
> >> +---
> >> +$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
> >> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> >> +
> >> +title: NXP Lynx 10G SerDes
> >> +
> >> +maintainers:
> >> +  - Sean Anderson <sean.anderson@seco.com>
> >> +
> >> +description: |
> >> +  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
> >> +  SerDes provides up to eight lanes. Each lane may be configured individually,
> >> +  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
> >> +  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
> >> +  others. The specific protocols supported for each lane depend on the
> >> +  particular SoC.
> >> +
> >> +definitions:
> >
> > $defs:
>
> That didn't work until recently :)
>
> I will change this for next revision.
>
> >> +  fsl,cfg:
> >> +    $ref: /schemas/types.yaml#/definitions/uint32
> >> +    minimum: 1
> >> +    description: |
> >> +      The configuration value to program into the field.
> >
> > What field?
>
> Ah, looks like this lost some context when I moved it. I will expand on this.
>
> >> +
> >> +  fsl,first-lane:
> >> +    $ref: /schemas/types.yaml#/definitions/uint32
> >> +    minimum: 0
> >> +    maximum: 7
> >> +    description: |
> >> +      The first lane in the group configured by fsl,cfg. This lane will have
> >> +      the FIRST_LANE bit set in GCR0. The reset direction will also be set
> >> +      based on whether this property is less than or greater than
> >> +      fsl,last-lane.
> >> +
> >> +  fsl,last-lane:
> >> +    $ref: /schemas/types.yaml#/definitions/uint32
> >> +    minimum: 0
> >> +    maximum: 7
> >> +    description: |
> >> +      The last lane configured by fsl,cfg. If this property is absent,
> >> +      then it will default to the value of fsl,first-lane.
> >> +
> >> +properties:
> >> +  compatible:
> >> +    items:
> >> +      - enum:
> >> +          - fsl,ls1046a-serdes
> >> +          - fsl,ls1088a-serdes
> >> +      - const: fsl,lynx-10g
> >> +
> >> +  "#clock-cells":
> >> +    const: 1
> >> +    description: |
> >> +      The cell contains the index of the PLL, starting from 0. Note that when
> >> +      assigning a rate to a PLL, the PLLs' rates are divided by 1000 to avoid
> >> +      overflow. A rate of 5000000 corresponds to 5GHz.
> >> +
> >> +  "#phy-cells":
> >> +    minimum: 1
> >> +    maximum: 2
> >> +    description: |
> >> +      The cells contain the following arguments:
> >> +      - The first lane in the group. Lanes are numbered based on the register
> >> +        offsets, not the I/O ports. This corresponds to the letter-based ("Lane
> >> +        A") naming scheme, and not the number-based ("Lane 0") naming scheme. On
> >> +        most SoCs, "Lane A" is "Lane 0", but not always.
> >> +      - Last lane. For single-lane protocols, this should be the same as the
> >> +        first lane.
> >
> > Perhaps a single cell with a lane mask would be simpler.
>
> Yes.
>
> >> +      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
> >> +      first cell will specify the only lane in the group.
> >
> > It is generally easier to have a fixed number of cells.
>
> This was remarked on last time. I allowed this for better compatibility with the lynx
> 28g serdes binding. Is that reasonable? I agree it would simplify the driver to just
> have one cell type.
>
> >> +
> >> +  clocks:
> >> +    maxItems: 2
> >> +    description: |
> >> +      Clock for each PLL reference clock input.
> >> +
> >> +  clock-names:
> >> +    minItems: 2
> >> +    maxItems: 2
> >> +    items:
> >> +      enum:
> >> +        - ref0
> >> +        - ref1
> >> +
> >> +  reg:
> >> +    maxItems: 1
> >> +
> >> +patternProperties:
> >> +  '^pccr-':
> >> +    type: object
> >> +
> >> +    description: |
> >> +      One of the protocol configuration registers (PCCRs). These contains
> >> +      several fields, each of which mux a particular protocol onto a particular
> >> +      lane.
> >> +
> >> +    properties:
> >> +      fsl,pccr:
> >> +        $ref: /schemas/types.yaml#/definitions/uint32
> >> +        description: |
> >> +          The index of the PCCR. This is the same as the register name suffix.
> >> +          For example, a node for PCCRB would use a value of '0xb' for an
> >> +          offset of 0x22C (0x200 + 4 * 0xb).
> >> +
> >> +    patternProperties:
> >> +      '^(q?sgmii|xfi|pcie|sata)-':
> >> +        type: object
> >> +
> >> +        description: |
> >> +          A configuration field within a PCCR. Each field configures one
> >> +          protocol controller. The value of the field determines the lanes the
> >> +          controller is connected to, if any.
> >> +
> >> +        properties:
> >> +          fsl,index:
> >
> > indexes are generally a red flag in binding. What is the index, how does
> > it correspond to the h/w and why do you need it.
>
> As described in the description below, the "index" is the protocol controller suffix,
> corresponding to a particular field (or set of fields) in the protocol configuration
> registers.
>
> > If we do end up needing
> > it, 'reg' is generally how we address some component.
>
> I originally used reg, but I got warnings about inheriting #size-cells and
> #address-cells. These bindings are already quite verbose to write out (there
> are around 10-20 configurations per SerDes to describe) and I would like to
> minimize the amount of properties to what is necessary. Additionally, this
> really describes a particular index of a field, and not a register (or an offset
> within a register).

Are you trying to describe all possible configurations in DT? Don't.
The DT should be the config for the specific board, not a menu of
possible configurations.


> >> +            $ref: /schemas/types.yaml#/definitions/uint32
> >> +            description: |
> >> +              The index of the field. This corresponds to the suffix in the
> >
> > What field?
>
> The one from the description above.
>
> >> +              documentation. For example, PEXa would be 0, PEXb 1, etc.
> >> +              Generally, higher fields occupy lower bits.
> >> +
> >> +              If there are any subnodes present, they will be preferred over
> >> +              fsl,cfg et. al.
> >> +
> >> +          fsl,cfg:
> >> +            $ref: "#/definitions/fsl,cfg"
> >> +
> >> +          fsl,first-lane:
> >> +            $ref: "#/definitions/fsl,first-lane"
> >> +
> >> +          fsl,last-lane:
> >> +            $ref: "#/definitions/fsl,last-lane"
> >
> > Why do you have lane assignments here and in the phy cells?
>
> For three reasons. First, because we need to know what protocols are valid on what
> lanes. The idea is to allow the MAC to configure the protocols at runtime. To do
> this, someone has to figure out if the protocol is supported on that lane. The
> best place to put this IMO is the serdes.

Within ethernet protocols, that makes sense.

> Second, some serdes have (mostly) unsupported protocols such as PCIe as well as
> Ethernet protocols. To allow using Ethernet, we need to know which lanes are
> configured (by the firmware/bootloader) for some other protocol. That way, we
> can avoid touching them.

The ones needed for ethernet are the ones with a connection to the
ethernet MACs with the 'phys' properties. Why don't you just ignore
the !ethernet ones?

> Third, as part of the probe sequence, we need to ensure that no protocol controllers
> are currently selected. Otherwise, we will get strange problems later when we try
> to connect multiple protocol controllers to the same lane.

Sounds like a kernel problem...

>
> >> +
> >> +          fsl,proto:
> >> +            $ref: /schemas/types.yaml#/definitions/string
> >> +            enum:
> >> +              - sgmii
> >> +              - sgmii25
> >> +              - qsgmii
> >> +              - xfi
> >> +              - pcie
> >> +              - sata
> >
> > We have standard phy modes already for at least most of these types.
> > Generally the mode is set in the phy cells.
>
> Yes, but this is the "protocol" which may correspond to multiple phy modes.
> For example, sgmii25 allows SGMII, 1000BASE-X, 1000BASE-KR, and 2500BASE-X
> phy modes.

As phy mode is more specific than protocol (or mode implies protocol),
why do we need protocol in DT?

[...]

> >> +        xfi-1 {
> >> +          fsl,index = <1>;
> >> +          fsl,cfg = <0x1>;
> >> +          fsl,first-lane = <0>;
> >> +          fsl,proto = "xfi";
> >> +        };
> >> +      };
> >> +    };
> >
> > Other than lane assignments and modes, I don't really understand what
> > you are trying to do.
>
> This is touched on a bit above, but the idea here is to allow for dynamic
> reconfiguration of the serdes mode in order to support multiple ethernet
> phy modes at runtime. To do this, we need to know about all the available
> protocol controllers, and the lanes they support. In particular, the
> available controllers and the lanes they map to (and the values to
> program to select them) differ even between different serdes on the same
> SoC.
>
> > It all looks too complex and I don't see any other
> > phy bindings needing something this complex.
>
> This was explicitly asked for last time. I also would not like to do this,
> but you and Krzysztof Kozlowski were very opposed to having per-device
> compatible strings. If you have a suggestion for a different approach, I
> am all ears. I find it very frustrating that the primary feedback I get from
> the device tree folks is "you can't do this" without a corresponding "do it
> this way."

How much time do you expect that we spend on your binding which is
only 1 out of the 100-200 patches we get a week? We're not experts in
all kinds of h/w and the experts for specific h/w don't always care
about DT bindings. We often get presented with solutions without
sufficient explanations of the problem. If I don't understand the
problem, how can I propose a solution? We can only point out what
doesn't fit within normal DT patterns. PHYs with multiple modes
supported is not a unique problem, so why are existing ways to deal
with that not sufficient and why do you need a *very* specific
binding?

With the phy binding, you know what each lane is connected to. You can
put whatever information you want in the phy cells to configure the
phy for that client. The phy cells are defined by the provider and
opaque to the consumer. Yes, we like to standardize cells when
possible, but that's only a convenience. I'm not saying phy cells is
the answer for everything and define 10 cells worth of data either.

Rob
