Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC64589364
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 22:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237550AbiHCUkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 16:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiHCUkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 16:40:41 -0400
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B7E26C2;
        Wed,  3 Aug 2022 13:40:40 -0700 (PDT)
Received: by mail-io1-f52.google.com with SMTP id s7so1348324ioa.0;
        Wed, 03 Aug 2022 13:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=e7d61MtbAqIhTPAJtqOPhqsXJEq15naLy9VOm7xbRLc=;
        b=14ZwRW9Jh4JVBfxkLtKX6sbZyQb8rz3w0jzyu11o1Bk+f/yMJvhSPqKR2j6CBEBL3T
         2JjVXnFKH9TQ9VJmnf01LlsbNaeLX1MR9nex3BDj1VkRXOuwfjO13HFDwKumRtf38ITK
         PiX6nnahzB/viIivtBJzZMha28t2/MCk2QWulpBAVD+quXY9PKLawWeETluhoK6I/v9g
         1ub9aAc2mNRPNaWHUu83/2pf7/O661DvEYmsKEOl1lDgVWVSpsYRXjKnHYvUDLxDDg+b
         PLBdHZVg5sqDWlUmKqmtqJXtpYf317s+JcYPBiC4eqBepQ4CF6Jw276WuV7+bIr11X6m
         xBxQ==
X-Gm-Message-State: ACgBeo1BzARt/XJ2b54qn4VtV5nGFLNmQcsFENW97YAjHrmxTKCYSS6o
        ujzPijoH9mQ23sTpn/0xLw==
X-Google-Smtp-Source: AA6agR6T0gg1QanRocjsUtRCxVAzvpPriklD63k5r+J0Z6AmYlxq2sr43p8fQ1ZGc1kfdV80bDwTlw==
X-Received: by 2002:a02:b098:0:b0:342:9c0a:6254 with SMTP id v24-20020a02b098000000b003429c0a6254mr653937jah.81.1659559239204;
        Wed, 03 Aug 2022 13:40:39 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id bc11-20020a0566383ccb00b00335b403c3b4sm8077066jab.48.2022.08.03.13.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 13:40:38 -0700 (PDT)
Received: (nullmailer pid 2585450 invoked by uid 1000);
        Wed, 03 Aug 2022 20:40:36 -0000
Date:   Wed, 3 Aug 2022 14:40:36 -0600
From:   Rob Herring <robh@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [net-next v3 3/3] dt-bindings: net: adin1110: Add docs
Message-ID: <20220803204036.GA2583313-robh@kernel.org>
References: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
 <20220802155947.83060-4-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802155947.83060-4-andrei.tachici@stud.acs.upb.ro>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 06:59:47PM +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 82 +++++++++++++++++++
>  1 file changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin1110.yaml b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> new file mode 100644
> index 000000000000..b929b677f16a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/adi,adin1110.yaml
> @@ -0,0 +1,82 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/adi,adin1110.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ADI ADIN1110 MAC-PHY
> +
> +maintainers:
> +  - Alexandru Tachici <alexandru.tachici@analog.com>
> +
> +description: |
> +  The ADIN1110 is a low power single port 10BASE-T1L MAC-
> +  PHY designed for industrial Ethernet applications. It integrates
> +  an Ethernet PHY core with a MAC and all the associated analog
> +  circuitry, input and output clock buffering.
> +
> +  The ADIN2111 is a low power, low complexity, two-Ethernet ports
> +  switch with integrated 10BASE-T1L PHYs and one serial peripheral
> +  interface (SPI) port. The device is designed for industrial Ethernet
> +  applications using low power constrained nodes and is compliant
> +  with the IEEE 802.3cg-2019 Ethernet standard for long reach
> +  10 Mbps single pair Ethernet (SPE).
> +
> +  The device has a 4-wire SPI interface for communication
> +  between the MAC and host processor.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +  - $ref: /schemas/spi/spi-peripheral-props.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - adi,adin1110
> +      - adi,adin2111
> +

> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0

These apply to child nodes, but you don't have any child nodes.

> +
> +  reg:
> +    maxItems: 1
> +
> +  adi,spi-crc:
> +    description: |
> +      Enable CRC8 checks on SPI read/writes.
> +    type: boolean
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    spi {
> +        ethernet@0 {
> +            compatible = "adi,adin2111";
> +            reg = <0>;
> +            spi-max-frequency = <24500000>;
> +
> +            adi,spi-crc;
> +
> +            #address-cells = <1>;
> +            #size-cells = <0>;
> +
> +            interrupt-parent = <&gpio>;
> +            interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
> +
> +            local-mac-address = [ 00 11 22 33 44 55 ];
> +        };
> +    };
> -- 
> 2.25.1
> 
> 
