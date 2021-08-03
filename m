Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4613DF674
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhHCUg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:36:29 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:34658 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHCUg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:36:28 -0400
Received: by mail-il1-f176.google.com with SMTP id a14so20712819ila.1;
        Tue, 03 Aug 2021 13:36:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wqy35kTjsNzZy2xWbHN8s1URPPVgyYNRzMN78986A28=;
        b=ri4LK7MfM3IMd3oLJpHmRrnfrXY8Hkxbr/6O1tVnU0UGmBfMsezqExlkQKyweQvxFn
         81+9dxn2aKLHMVmh6htORLsiahebVN1q6oSI6I7QrZsIqR7sRSzYL/DcqgKQ1xKTAhD0
         EPrElqgehsJAxpx7LlQsje4Q7rgHQZMAo+0pyYodvYwyRcqk+cg5gGF5ZiXcbXn15+yn
         xyMzis6gW3NgSKOTZRAkil7pmLaSbzg9F0jZlCO7JDfDYe/rQOZ1GC0s2DgbWsVBxGNO
         1Xrf1V2xX4yjFKNuBgykyRAPYliYG1//OMDIVF1jpVyDLAnK7jn23k7hbxmL8Mwt6h1I
         Rcaw==
X-Gm-Message-State: AOAM531Ti4pTbtoiAx+6fBJN9QTRYIUqZkmz0/zuT238eQLxmBx+erpe
        in+tVbOgN64F0SGQjZoWxw==
X-Google-Smtp-Source: ABdhPJyroaDdxSu52ggq0iSC2GCg/pS7rfc8sAksJsGo3VBQcbvPLpPpQBMk9T7J3GIWBm7wZyWPEw==
X-Received: by 2002:a92:9412:: with SMTP id c18mr1922089ili.38.1628022976687;
        Tue, 03 Aug 2021 13:36:16 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id l4sm2620ilh.41.2021.08.03.13.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 13:36:15 -0700 (PDT)
Received: (nullmailer pid 3688203 invoked by uid 1000);
        Tue, 03 Aug 2021 20:36:13 -0000
Date:   Tue, 3 Aug 2021 14:36:13 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: can: c_can: convert to json-schema
Message-ID: <YQmovZmgwNozFuvV@robh.at.kernel.org>
References: <20210801075322.30269-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210801075322.30269-1-dariobin@libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 01, 2021 at 09:53:22AM +0200, Dario Binacchi wrote:
> Convert the Bosch C_CAN/D_CAN controller device tree binding
> documentation to json-schema.
> 
> Document missing properties.
> Remove "ti,hwmods" as it is no longer used in TI dts.
> Make "clocks" required as it is used in all dts.
> Correct nodename in the example.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> 
> ---
> 
> Changes in v4:
>  - Fix 'syscon-raminit' property to pass checks.
>  - Drop 'status' property from CAN node of examples.
>  - Replace CAN node of examples (compatible = "bosch,d_can")  with a
>    recent version taken from socfpga.dtsi dts.
>  - Update the 'interrupts' property due to the examples updating.
>  - Add 'resets' property due to the examples updating.
> 
> Changes in v3:
>  - Add type (phandle-array) and size (maxItems: 2) to syscon-raminit
>    property.
> 
> Changes in v2:
>  - Drop Documentation references.
> 
>  .../bindings/net/can/bosch,c_can.yaml         | 94 +++++++++++++++++++
>  .../devicetree/bindings/net/can/c_can.txt     | 65 -------------
>  2 files changed, 94 insertions(+), 65 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> new file mode 100644
> index 000000000000..9f1028fe58d5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
> @@ -0,0 +1,94 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/bosch,c_can.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Bosch C_CAN/D_CAN controller Device Tree Bindings
> +
> +description: Bosch C_CAN/D_CAN controller for CAN bus
> +
> +maintainers:
> +  - Dario Binacchi <dariobin@libero.it>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - bosch,c_can
> +          - bosch,d_can
> +          - ti,dra7-d_can
> +          - ti,am3352-d_can
> +      - items:
> +          - enum:
> +              - ti,am4372-d_can
> +          - const: ti,am3352-d_can
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    minItems: 1
> +    maxItems: 4

Well, now you have to define what each interrupt is.

> +
> +  power-domains:
> +    description: |
> +      Should contain a phandle to a PM domain provider node and an args
> +      specifier containing the DCAN device id value. It's mandatory for
> +      Keystone 2 66AK2G SoCs only.
> +    maxItems: 1
> +
> +  clocks:
> +    description: |
> +      CAN functional clock phandle.
> +    maxItems: 1
> +
> +  clock-names:
> +    maxItems: 1
> +
> +  syscon-raminit:
> +    description: |
> +      Handle to system control region that contains the RAMINIT register,
> +      register offset to the RAMINIT register and the CAN instance number (0
> +      offset).
> +    $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      items:
> +        - description: The phandle to the system control region.
> +        - description: The register offset.
> +        - description: The CAN instance number.
> +
> +  resets:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/reset/altr,rst-mgr.h>
> +
> +    can@ffc00000 {
> +       compatible = "bosch,d_can";
> +       reg = <0xffc00000 0x1000>;
> +       interrupts = <0 131 4>, <0 132 4>, <0 133 4>, <0 134 4>;
> +       clocks = <&can0_clk>;
> +       resets = <&rst CAN0_RESET>;
> +    };
> +  - |
> +    can@0 {
> +        compatible = "ti,am3352-d_can";
> +        reg = <0x0 0x2000>;
> +        clocks = <&dcan1_fck>;
> +        clock-names = "fck";
> +        syscon-raminit = <&scm_conf 0x644 1>;
> +        interrupts = <55>;
> +    };
