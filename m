Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE635FA967
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 02:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJKAi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 20:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJKAi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 20:38:26 -0400
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C7182747
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 17:38:23 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id i25-20020a4a8d99000000b0047fa712fc6dso7868248ook.2
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 17:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CAG1OQzBDKZih+9JChCc9zr67psu/gssWF1Btg5zONk=;
        b=idJlfjxY7IFFy99rv+yG23stcCoHJT1jjKgm6bgeMQ/xKZY2zAIVr8XXAYR3ZHseNV
         g8kD2/0OfdQ4bXxvxGnfSUly7+r/N4aMViJF1HlYWfw2QKLb7kAZHepM5szrixev40Zx
         lE9xcHFGv4ExvLzPq13oL+oTfZKRIbkrMepw1j+Fw527JbfH/U9LYfkjhv6iMuRxBewz
         WxryNyjsrEalBrs9P/nZEnyKUO4o8p/5ClH+LezZF0J81Sut3XIK/0gshgCQD9PA7IN5
         9Tc91gaIFlEy+zhAtG+YHdE65Ps5MumNBC6ULGdWuTCAa9TY3TM5zU7GSVMRLs5Cq5Vm
         9gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CAG1OQzBDKZih+9JChCc9zr67psu/gssWF1Btg5zONk=;
        b=ZzMrPt46hAweKDmpleOrThJUJxLVtrcKprL3bav7Luch2T4ts/UICagRXA/xllBain
         Yg9qp3O696i5C7eIJaoEdZjN2AuCE7kDUgiBbsIrGRrbEvofREEnq43xKzFBKjqWZJ3s
         /o3/v3FJAez1a3Z7pwBVBRffmoP5dnPYKUxkcJkbWHQ9lcuf4CIkBCRMYyOlcA7AMpz+
         CDw7iIBLxwk21L00DgItPxH4FiyOiUAWdX1qiZuCOc6bZ/GR4U2eUjQT7TbiPqpQxQcj
         216MSG/ECH6tpjGbJ3Hy2PsMIRaTb1MkcJVO7JiGXCbVeS0Ap+r1x9VzdmY5vBbV0MRo
         lX6A==
X-Gm-Message-State: ACrzQf0T4SzTctfKaiZFiqvQZ+wKFw/RoVj4bsBo6C1E5CbYlgG7uUtm
        jzsT7rE/vDKlpvR+H7ICz3BVlOgpKx5T22zO1ciP5w==
X-Google-Smtp-Source: AMsMyM6xEfKRXqW9busquuXOvS+rovbN/yWFEazHj3OsJiyRKlCmY4R3huN1cO8x+k6rikbDZ8hnUwz+scIsq0WE5ac=
X-Received: by 2002:a9d:7a8a:0:b0:656:284c:d5bd with SMTP id
 l10-20020a9d7a8a000000b00656284cd5bdmr9205692otn.52.1665448702387; Mon, 10
 Oct 2022 17:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220926232136.38567-1-mig@semihalf.com>
In-Reply-To: <20220926232136.38567-1-mig@semihalf.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 11 Oct 2022 02:38:13 +0200
Message-ID: <CAPv3WKdeq-FbPJ5dJ1--bP9oX5u3u_D3DSi2qwkNyU3DWQGRbw@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: marvell,pp2: convert to json-schema
To:     =?UTF-8?Q?Micha=C5=82_Grzelak?= <mig@semihalf.com>
Cc:     devicetree@vger.kernel.org, linux@armlinux.org.uk,
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

Hi Micha=C5=82,

Additional comments inline.

wt., 27 wrz 2022 o 01:22 Micha=C5=82 Grzelak <mig@semihalf.com> napisa=C5=
=82(a):
>
> This converts the marvell,pp2 bindings from text to proper schema.
>
> Move 'marvell,system-controller' and 'dma-coherent' properties from
> port up to the controller node, to match what is actually done in DT.
>
> Signed-off-by: Micha=C5=82 Grzelak <mig@semihalf.com>
> ---
>  .../devicetree/bindings/net/marvell,pp2.yaml  | 241 ++++++++++++++++++
>  .../devicetree/bindings/net/marvell-pp2.txt   | 141 ----------
>  MAINTAINERS                                   |   2 +-
>  3 files changed, 242 insertions(+), 142 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yam=
l
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
>
> diff --git a/Documentation/devicetree/bindings/net/marvell,pp2.yaml b/Doc=
umentation/devicetree/bindings/net/marvell,pp2.yaml
> new file mode 100644
> index 000000000000..6faa4c87dfc6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> @@ -0,0 +1,241 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,pp2.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell CN913X / Marvell Armada 375, 7K, 8K Ethernet Controller
> +
> +maintainers:
> +  - Marcin Wojtas <mw@semihalf.com>
> +  - Russell King <linux@armlinux.org>
> +
> +description: |
> +  Marvell Armada 375 Ethernet Controller (PPv2.1)
> +  Marvell Armada 7K/8K Ethernet Controller (PPv2.2)
> +  Marvell CN913X Ethernet Controller (PPv2.3)
> +
> +properties:
> +  compatible:
> +    enum:
> +      - marvell,armada-375-pp2
> +      - marvell,armada-7k-pp22
> +
> +  reg:
> +    minItems: 3
> +    maxItems: 4
> +    description: |
> +      For "marvell,armada-375-pp2", must contain the following register =
sets:
> +        - common controller registers
> +        - LMS registers
> +        - one register area per Ethernet port
> +      For "marvell,armada-7k-pp22" used by 7K/8K and CN913X, must contai=
n the following register sets:
> +        - packet processor registers
> +        - networking interfaces registers
> +        - CM3 address space used for TX Flow Control
> +
> +  clocks:
> +    minItems: 2
> +    items:
> +      - description: main controller clock
> +      - description: GOP clock
> +      - description: MG clock
> +      - description: MG Core clock
> +      - description: AXI clock
> +
> +  clock-names:
> +    minItems: 2
> +    items:
> +      - const: pp_clk
> +      - const: gop_clk
> +      - const: mg_clk
> +      - const: mg_core_clk
> +      - const: axi_clk
> +
> +  dma-coherent: true
> +  '#size-cells': true
> +  '#address-cells': true
> +
> +  marvell,system-controller:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description: a phandle to the system controller.
> +
> +patternProperties:
> +  '^eth[0-9a-f]*(@.*)?$':
> +    type: object
> +    properties:
> +      interrupts:
> +        minItems: 1
> +        maxItems: 10
> +        description: interrupt(s) for the port
> +
> +      interrupt-names:
> +        items:
> +          - const: hif0
> +          - const: hif1
> +          - const: hif2
> +          - const: hif3
> +          - const: hif4
> +          - const: hif5
> +          - const: hif6
> +          - const: hif7
> +          - const: hif8
> +          - const: link
> +
> +        description: >
> +          if more than a single interrupt for is given, must be the
> +          name associated to the interrupts listed. Valid names are:
> +          "hifX", with X in [0..8], and "link". The names "tx-cpu0",
> +          "tx-cpu1", "tx-cpu2", "tx-cpu3" and "rx-shared" are supported
> +          for backward compatibility but shouldn't be used for new
> +          additions.
> +
> +      port-id:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: ID of the port from the MAC point of view.
> +
> +      phy:
> +        $ref: /schemas/types.yaml#/definitions/phandle
> +        description: >
> +          a phandle to a phy node defining the PHY address
> +          (as the reg property, a single integer).
> +
> +      phy-mode:
> +        $ref: "ethernet-controller.yaml#/properties/phy-mode"
> +
> +      marvell,loopback:
> +        $ref: /schemas/types.yaml#/definitions/flag
> +        description: port is loopback mode.
> +
> +      gop-port-id:
> +        $ref: /schemas/types.yaml#/definitions/uint32
> +        description: >
> +          only for marvell,armada-7k-pp22, ID of the port from the
> +          GOP (Group Of Ports) point of view. This ID is used to index t=
he
> +          per-port registers in the second register area.
> +
> +    required:
> +      - interrupts
> +      - port-id
> +      - phy-mode
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +  - if:
> +      properties:
> +        compatible:
> +          const: marvell,armada-7k-pp22
> +    then:
> +      patternProperties:
> +        '^eth[0-9a-f]*(@.*)?$':
> +          required:
> +            - gop-port-id

For this variant, 'marvell,system-controller' should also be marked as requ=
ired.

> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    // For Armada 375 variant
> +    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    ethernet@f0000 {
> +      compatible =3D "marvell,armada-375-pp2";
> +      reg =3D <0xf0000 0xa000>,
> +            <0xc0000 0x3060>,
> +            <0xc4000 0x100>,
> +            <0xc5000 0x100>;
> +      clocks =3D <&gateclk 3>, <&gateclk 19>;
> +      #address-cells =3D <1>;
> +      #size-cells =3D <0>;
> +      clock-names =3D "pp_clk", "gop_clk";
> +
> +      eth0: eth0@c4000 {
> +        reg =3D <0xc4000>;
> +        interrupts =3D <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
> +        port-id =3D <0>;
> +        phy =3D <&phy0>;
> +        phy-mode =3D "gmii";
> +      };
> +
> +      eth1: eth1@c5000 {
> +        reg =3D <0xc5000>;
> +        interrupts =3D <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
> +        port-id =3D <1>;
> +        phy =3D <&phy3>;
> +        phy-mode =3D "gmii";
> +      };
> +    };
> +
> +  - |
> +    // For Armada 7k/8k and Cn913x variants
> +    #include <dt-bindings/interrupt-controller/mvebu-icu.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    cpm_ethernet: ethernet@0 {
> +      compatible =3D "marvell,armada-7k-pp22";
> +      reg =3D <0x0 0x100000>, <0x129000 0xb000>, <0x220000 0x800>;
> +      clocks =3D <&cpm_syscon0 1 3>, <&cpm_syscon0 1 9>,
> +               <&cpm_syscon0 1 5>, <&cpm_syscon0 1 6>, <&cpm_syscon0 1 1=
8>;

s/syscon0/clk/

Also add missing marvell,system-controller.

Best regards,
Marcin
