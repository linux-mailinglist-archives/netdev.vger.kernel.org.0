Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E851FD88E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 00:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgFQWQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 18:16:59 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:33870 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbgFQWQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 18:16:59 -0400
Received: by mail-il1-f194.google.com with SMTP id x18so3916181ilp.1;
        Wed, 17 Jun 2020 15:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/dcY53hMYQl/W+BZuZm5AIbg/CG1JMRTeXapBxnAQnQ=;
        b=cCD97buxR44ylCSMBDeJRaiGlYT7TPaUN6hqN5+C/w2NXW4ALb8n6hDmqw8UXg7AEV
         bvugJmJhcevikmtf/A/h7QlekyEELynR9CI7r3aU8ZHmE6fbZP3uprHmhzRQMOGeLDw5
         olEh3WH3TffXcVEyRfujtkzvZJi5BL0BFBqVkxH5uLEqfKSZQBfvQjcAHt+sTmv6efLb
         EGWU81wphAGUTN4Pw8CBeYfQE2IbuJjHhsCn8U6leidgbOt/KUs7IUY07fROUuC741kz
         DUQ+5kYD4VjKNna69fwX5fweIHiO2ndKF5rT7KZhBuD1Zvp2R31RLXZh3XvOImk93SIG
         fo6w==
X-Gm-Message-State: AOAM530gm0LOvzxXcavQstZci8sU0gfr0dw+3J3XH1iK3JIQKaA5w/tz
        9aUI1FUyjzmeYUDBXlABtg==
X-Google-Smtp-Source: ABdhPJy/RDAuO2ERCKKVsMEchWk9PFvHKMyA40PezXAcNnCIINfQN0maDzTb8FiPAk/8JZR1aEbqIg==
X-Received: by 2002:a92:db01:: with SMTP id b1mr1140964iln.233.1592432218330;
        Wed, 17 Jun 2020 15:16:58 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id c62sm523052ill.62.2020.06.17.15.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 15:16:57 -0700 (PDT)
Received: (nullmailer pid 2931941 invoked by uid 1000);
        Wed, 17 Jun 2020 22:16:56 -0000
Date:   Wed, 17 Jun 2020 16:16:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     wg@grandegger.com, mkl@pengutronix.de, kernel@martin.sperl.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RESEND PATCH 1/6] dt-bindings: can: Document devicetree
 bindings for MCP25XXFD
Message-ID: <20200617221656.GA2927781@bogus>
References: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
 <20200610074711.10969-2-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610074711.10969-2-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 01:17:06PM +0530, Manivannan Sadhasivam wrote:
> From: Martin Sperl <kernel@martin.sperl.org>
> 
> Add devicetree YAML bindings for Microchip MCP25XXFD CAN controller.
> 
> Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
> [mani: converted to YAML binding]
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  .../bindings/net/can/microchip,mcp25xxfd.yaml | 82 +++++++++++++++++++
>  1 file changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml b/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
> new file mode 100644
> index 000000000000..7b87ec328515
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
> @@ -0,0 +1,82 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/microchip,mcp25xxfd.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip MCP25XXFD stand-alone CAN controller binding
> +
> +maintainers:
> +  -  Martin Sperl <kernel@martin.sperl.org>
> +  -  Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> +
> +properties:
> +  compatible:
> +    const: microchip,mcp2517fd
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  gpio-controller: true
> +
> +  "#gpio-cells":
> +    const: 2
> +
> +  vdd-supply:
> +    description: Regulator that powers the CAN controller
> +
> +  xceiver-supply:
> +    description: Regulator that powers the CAN transceiver
> +
> +  microchip,clock-out-div:
> +    description: Clock output pin divider
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/uint32

You can drop the 'allOf' now.

> +    enum: [0, 1, 2, 4, 10]
> +    default: 10
> +
> +  microchip,clock-div2:
> +    description: Divide the internal clock by 2
> +    type: boolean
> +
> +  microchip,gpio-open-drain:
> +    description: Enable open-drain for all pins
> +    type: boolean
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - interrupts
> +  - gpio-controller

And '#gpio-cells'?

> +  - vdd-supply
> +  - xceiver-supply
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    spi {
> +           #address-cells = <1>;
> +           #size-cells = <0>;
> +
> +           can0: can@1 {
> +                   compatible = "microchip,mcp2517fd";
> +                   reg = <1>;
> +                   clocks = <&clk24m>;
> +                   interrupt-parent = <&gpio4>;
> +                   interrupts = <13 0x8>;
> +                   vdd-supply = <&reg5v0>;
> +                   xceiver-supply = <&reg5v0>;
> +                   gpio-controller;
> +                   #gpio-cells = <2>;
> +           };
> +    };
> +
> +...
> -- 
> 2.17.1
> 
