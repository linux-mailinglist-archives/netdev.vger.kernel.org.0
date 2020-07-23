Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9373C22B7E6
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGWUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:37:14 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46753 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgGWUhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:37:13 -0400
Received: by mail-io1-f67.google.com with SMTP id a12so7648701ion.13;
        Thu, 23 Jul 2020 13:37:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6nkqz8zGOU3urYFWNeUbOdQOY3hcOTYFkmXK97Wy0sc=;
        b=lpng8KEhCeaVgJQ6RwE2sS+ShDzFrRs6EN2l9KRmxpE85bZQY1QKxoS8NdMLB7e/sB
         PruvC4Id2IHkLTlk08J7oUPjt43JjBG9x5UuhFLVzpwq7tprYH18J/D5JPUJJ5fMnEVj
         c38H3YIxuQzDcf9PCmdHqlcpFlbLtva39jYcd5FoowmG2Ners/lTqid9PpgZeOLYHTiJ
         37urMaIM8X/2ww9SgEacQrPMUdtDeUo+POnbTqd6Lcy5cY1CHfHl24nMPy+KcIlFESW2
         vGfuMeOyIVqO5C7Mtkw/eq9xc55kAPOuJ+Q54Ut718pxYkeHUKKAx4AcsymaoRsK0PgR
         PbMg==
X-Gm-Message-State: AOAM533hv5RX5nbfmr5Eo7AWHEIgTxLuLyuhi8rImPfYW4FU/hGAkx9l
        xfn56r5bO+XlXigZlh35Bw==
X-Google-Smtp-Source: ABdhPJyLxzJTOSuCRBbbSVeCMMXUCvUWmlkxvfC5/nxyt+iEdErKiX/49sT7x90v4qMwaYIbqsRHzw==
X-Received: by 2002:a02:cc24:: with SMTP id o4mr6881649jap.105.1595536632720;
        Thu, 23 Jul 2020 13:37:12 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id i6sm1997252ilj.61.2020.07.23.13.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 13:37:12 -0700 (PDT)
Received: (nullmailer pid 819123 invoked by uid 1000);
        Thu, 23 Jul 2020 20:37:10 -0000
Date:   Thu, 23 Jul 2020 14:37:10 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 8/8] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200723203710.GA810197@bogus>
References: <20200723081714.16005-1-kurt@linutronix.de>
 <20200723081714.16005-9-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723081714.16005-9-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 10:17:14AM +0200, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../bindings/net/dsa/hellcreek.yaml           | 126 ++++++++++++++++++
>  1 file changed, 126 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> new file mode 100644
> index 000000000000..1b192ba7f4ca
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> @@ -0,0 +1,126 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/hellcreek.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>
> +  - Kurt Kanzenbach <kurt@linutronix.de>
> +
> +description:
> +  The Hellcreek TSN Switch IP is a 802.1Q Ethernet compliant switch. It supports
> +  the Precision Time Protocol, Hardware Timestamping as well the Time Aware
> +  Shaper.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - const: hirschmann,hellcreek

Don't need 'oneOf' for 1 entry.

> +
> +  reg:
> +    description:
> +      The physical base address and size of TSN and PTP memory base
> +    minItems: 2
> +    maxItems: 2
> +
> +  reg-names:
> +    description:
> +      Names of the physical base addresses

No need for generic descriptions. That's all 'reg-names'...

> +    minItems: 2
> +    maxItems: 2
> +    items:
> +      enum: ["reg", "ptp"]

Why not 'tsn' as above instead of reg? In any case, the correct form is:

items:
  - const: reg
  - const: ptp

> +
> +  leds:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^led@[0-9]+$":
> +          type: object
> +          description: Hellcreek leds

This should reference leds/common.yaml

> +
> +          properties:
> +            reg:
> +              items:
> +                - enum: [0, 1]
> +              description: Led number
> +
> +            label: true
> +
> +            default-state: true
> +
> +          required:
> +            - reg
> +
> +          additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - ports

Use the preferred 'ethernet-ports'.

> +  - leds

Add:

unevaluatedProperties: false

> +
> +examples:
> +  - |
> +        switch0: switch@ff240000 {
> +            compatible = "hirschmann,hellcreek";
> +            status = "okay";

Don't show status in examples.

> +            reg = <0xff240000 0x1000>,
> +                  <0xff250000 0x1000>;
> +            reg-names = "reg", "ptp";
> +            dsa,member = <0 0>;
> +
> +            ports {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                port@0 {
> +                    reg = <0>;
> +                    label = "cpu";
> +                    ethernet = <&gmac0>;
> +                };
> +
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan0";
> +                    phy-handle = <&phy1>;
> +                };
> +
> +                port@3 {
> +                    reg = <3>;
> +                    label = "lan1";
> +                    phy-handle = <&phy2>;
> +                };
> +            };
> +
> +            leds {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                led@0 {
> +                    reg = <0>;
> +                    label = "sync_good";
> +                    default-state = "on";
> +                };
> +
> +                led@1 {
> +                    reg = <1>;
> +                    label = "is_gm";
> +                    default-state = "off";
> +                };
> +            };
> +        };
> -- 
> 2.20.1
> 
