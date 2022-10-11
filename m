Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768F75FBC1B
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 22:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiJKUee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 16:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKUed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 16:34:33 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA3E7754F
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 13:34:31 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o64so17127707oib.12
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 13:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K1hrqeMqcrecJQqIBuIb6NTt7na4rSliwCpyxyTURNo=;
        b=F9vfNa/5kId1sULp3PZu4PxADFGT14i+6QGWtBUyQKpHTSAGfukcnJLFoJXQtCWKY2
         sSDPkDoVelg36OBhKUAudAFS8CHHmoqXL5hKxUQHG2IM1RosouDh/H8fIuYWf2O0GABz
         ddGQ8Dug4usa4M21lAZVQsdUldsPZtu5uucNuZ0AcgMhGwLBJ+erqMUKnS9eNyIusjfL
         udGJq0Ab51nGT1LDe4WM4Np2De/rEiiSKelf6x4PBJ324m5d18jG975MS1b0LQQwORJd
         EdqJfHV10zNI84hWgHRolGqjht9Q2gjKoY7gGhi6B0bVTbITnUZ8z2ohi2BqtABNfvjX
         WoXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K1hrqeMqcrecJQqIBuIb6NTt7na4rSliwCpyxyTURNo=;
        b=75mVVV+9IF1MSI574Zlg2qRcqbpa3usRlEFOPoPrVZV1z/YN7/72fEzYECPHAW4Cwf
         86YQzA/vc1ja25s6n5QMPo1SxGjnGeW8MKiTGc6C8RjKaC6a/SKNBbYsTg7EihBxI2jg
         mVUNKSNq1efqyf3LEEReyNg7vMeEKnAX+6gkslVe6pNyo8Ks531YSkp6O/tQCY/B6sPY
         I1QjOZqpjraDpU+VKN6PoFxpRJ/ye8ZKnEJ9F+FZU6jm7znIm1M/hyGDH7qdGGS+94V6
         Ot/+NVWAs6MzjN25HodilaQbjAdU5OLXz9lvDWQmRcNOKskhm+8HwUEybqIIu/YuOUOT
         CDJQ==
X-Gm-Message-State: ACrzQf0G612uUOPBqHac0kWWxzku1rqrTqqH3luGIkipXkt7cCFQOqgQ
        2CuMI/ahIhrzDJ9htwalfOGq4s2WsH+bINs8KFkBsA==
X-Google-Smtp-Source: AMsMyM5NHjnR6NrvSHIvvuxyX4HjfOUVSrI0LRMDkc/nfT9Jbe71lDLRt+qg9RI3Ink6nJAEZ8oq1znmVG566EBTJmg=
X-Received: by 2002:aca:2806:0:b0:354:82ad:4173 with SMTP id
 6-20020aca2806000000b0035482ad4173mr486268oix.66.1665520470751; Tue, 11 Oct
 2022 13:34:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221011190613.13008-1-mig@semihalf.com> <20221011190613.13008-2-mig@semihalf.com>
 <ad015bc9-a6d2-491d-463a-42a6a0afbf75@linaro.org>
In-Reply-To: <ad015bc9-a6d2-491d-463a-42a6a0afbf75@linaro.org>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 11 Oct 2022 22:34:20 +0200
Message-ID: <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dt-bindings: net: marvell,pp2: convert to json-schema
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     =?UTF-8?Q?Micha=C5=82_Grzelak?= <mig@semihalf.com>,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

Let me chime in.

wt., 11 pa=C5=BA 2022 o 21:50 Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> napisa=C5=82(a):
>
> On 11/10/2022 15:06, Micha=C5=82 Grzelak wrote:
> > Convert the marvell,pp2 bindings from text to proper schema.
> >
> > Move 'marvell,system-controller' and 'dma-coherent' properties from
> > port up to the controller node, to match what is actually done in DT.
>
> You need to also mention other changes done during conversion -
> requiring subnodes to be named "(ethernet-)?ports", deprecating port-id.
>
> >
> > Signed-off-by: Micha=C5=82 Grzelak <mig@semihalf.com>
> > ---
> >  .../devicetree/bindings/net/marvell,pp2.yaml  | 286 ++++++++++++++++++
> >  .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
> >  MAINTAINERS                                   |   2 +-
> >  3 files changed, 287 insertions(+), 142 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.y=
aml
> >  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.t=
xt
> >
> > diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/D=
ocumentation/devicetree/bindings/net/marvell,pp2.yaml
> > new file mode 100644
> > index 000000000000..24c6aeb46814
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> > @@ -0,0 +1,286 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/marvell,pp2.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Marvell CN913X / Marvell Armada 375, 7K, 8K Ethernet Controller
> > +
> > +maintainers:
> > +  - Marcin Wojtas <mw@semihalf.com>
> > +  - Russell King <linux@armlinux.org>
> > +
> > +description: |
> > +  Marvell Armada 375 Ethernet Controller (PPv2.1)
> > +  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
> > +  Marvell CN913X Ethernet Controller (PPv2.3)
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - marvell,armada-375-pp2
> > +      - marvell,armada-7k-pp22
> > +
> > +  reg:
> > +    minItems: 3
> > +    maxItems: 4
> > +
> > +  "#address-cells":
> > +    const: 1
> > +
> > +  "#size-cells":
> > +    const: 0
> > +
> > +  clocks:
> > +    minItems: 2
> > +    items:
> > +      - description: main controller clock
> > +      - description: GOP clock
> > +      - description: MG clock
> > +      - description: MG Core clock
> > +      - description: AXI clock
> > +
> > +  clock-names:
> > +    minItems: 2
> > +    items:
> > +      - const: pp_clk
> > +      - const: gop_clk
> > +      - const: mg_clk
> > +      - const: mg_core_clk
> > +      - const: axi_clk
> > +
> > +  dma-coherent: true
> > +
> > +  marvell,system-controller:
> > +    $ref: /schemas/types.yaml#/definitions/phandle
> > +    description: a phandle to the system controller.
> > +
> > +patternProperties:
> > +  '^(ethernet-)?port@[0-9]+$':
> > +    type: object
> > +    description: subnode for each ethernet port.
> > +
> > +    properties:
> > +      interrupts:
> > +        minItems: 1
> > +        maxItems: 10
> > +        description: interrupt(s) for the port
> > +
> > +      interrupt-names:
> > +        minItems: 1
> > +        items:
> > +          - const: hif0
> > +          - const: hif1
> > +          - const: hif2
> > +          - const: hif3
> > +          - const: hif4
> > +          - const: hif5
> > +          - const: hif6
> > +          - const: hif7
> > +          - const: hif8
> > +          - const: link
> > +
> > +        description: >
> > +          if more than a single interrupt for is given, must be the
> > +          name associated to the interrupts listed. Valid names are:
> > +          "hifX", with X in [0..8], and "link". The names "tx-cpu0",
> > +          "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are supporte=
d
> > +          for backward compatibility but shouldn't be used for new
> > +          additions.
> > +
> > +      reg:
> > +        description: ID of the port from the MAC point of view.
> > +
> > +      port-id:
> > +        $ref: /schemas/types.yaml#/definitions/uint32
>
>         deprecated: true
>
> > +        description: >
> > +          ID of the port from the MAC point of view.
> > +          Legacy binding for backward compatibility.
> > +
> > +      phy:
> > +        $ref: /schemas/types.yaml#/definitions/phandle
> > +        description: >
> > +          a phandle to a phy node defining the PHY address
> > +          (as the reg property, a single integer).
> > +
> > +      phy-mode:
> > +        $ref: ethernet-controller.yaml#/properties/phy-mode
> > +
> > +      marvell,loopback:
> > +        $ref: /schemas/types.yaml#/definitions/flag
> > +        description: port is loopback mode.
> > +
> > +      gop-port-id:
> > +        $ref: /schemas/types.yaml#/definitions/uint32
> > +        description: >
> > +          only for marvell,armada-7k-pp22, ID of the port from the
> > +          GOP (Group Of Ports) point of view. This ID is used to index=
 the
> > +          per-port registers in the second register area.
> > +
> > +    required:
> > +      - interrupts
> > +      - port-id
> > +      - phy-mode
> > +      - reg
>
> Keep the same order of items here as in list of properties
>
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - clocks
> > +  - clock-names
> > +
> > +allOf:
> > +  - $ref: ethernet-controller.yaml#
>
> Hmm, are you sure this applies to top-level properties, not to
> ethernet-port subnodes? Your ports have phy-mode and phy - just like
> ethernet-controller. If I understand correctly, your Armada Ethernet
> Controller actually consists of multiple ethernet controllers?
>

PP2 is a single controller with common HW blocks, such as queue/buffer
management, parser/classifier, register space, and more. It controls
up to 3 MAC's (ports) that can be connected to phys, sfp cages, etc.
The latter cannot exist on their own and IMO the current hierarchy -
the main controller with subnodes (ports) properly reflects the
hardware.

Anyway, the ethernet-controller.yaml properties fit to the subnodes.
Apart from the name. The below is IMO a good description:.

> If so, this should be moved to proper place inside patternProperties.
> Maybe the subnodes should also be renamed from ports to just "ethernet"
> (as ethernet-controller.yaml expects), but other schemas do not follow
> this convention,

ethernet@
{
    ethernet-port@0
    {
     }
     ethernet-port@1
     {
     }
}

What do you recommend?

Thanks,
Marcin
