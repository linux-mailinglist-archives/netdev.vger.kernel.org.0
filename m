Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671182523A0
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 00:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHYW25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 18:28:57 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44220 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgHYW24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 18:28:56 -0400
Received: by mail-io1-f65.google.com with SMTP id v6so126496iow.11;
        Tue, 25 Aug 2020 15:28:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsR2olYHtf/kZ6/wDuAR7attt85kdbDpUtHLjjhNSTc=;
        b=GHdBMM0Z8Yv2WGzWp7kv/TtEOHZOeVzEUZGzOBeXtwueTJwAiAIVcryz8k825j+8GF
         SszIiSQ4ZhoRhB6kS0kgDPFT0uGGEOwmpGWIt+b5wPo2zq8kh2oMGk1ZtTV5LeiGIAle
         WXAU8/H1hNu3lfjJHyoGVFVEjJNJGhr2nL3ct+RmeEnIMz+XrjT6mMRYyarXwceJYwuw
         kefaobK8yy/ITsXXrnaTOgSie62e5vci3XXxRwsp9EmnFcehRdOQSRVeUQgmX83n8p1M
         ZQ5HHz3wqEN7q9+rTSp7g0z3ACy4tfx+uNKn8xy0oyjqfMT+vGZx8lDDkRrPU+R26CO5
         OZlA==
X-Gm-Message-State: AOAM530GL/+KX4FG8hk6zTRm5EVgpst0fy0so5F9GBGEZkBcaEiDli/w
        YBJ/482xg2Zds9pP2r1JVA==
X-Google-Smtp-Source: ABdhPJy/rYJKROLufn+RuXd3ysfH07hyv+0Vrjp3yzrCLb0ibjZab6czT5HoNUIRaCjjQqPoTu2x4Q==
X-Received: by 2002:a05:6602:25c9:: with SMTP id d9mr10665967iop.150.1598394533925;
        Tue, 25 Aug 2020 15:28:53 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id 18sm91196iog.31.2020.08.25.15.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 15:28:53 -0700 (PDT)
Received: (nullmailer pid 1460645 invoked by uid 1000);
        Tue, 25 Aug 2020 22:28:50 -0000
Date:   Tue, 25 Aug 2020 16:28:50 -0600
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
Subject: Re: [PATCH v3 8/8] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200825222850.GA1455114@bogus>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-9-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820081118.10105-9-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:11:18AM +0200, Kurt Kanzenbach wrote:
> Add basic documentation and example.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../bindings/net/dsa/hellcreek.yaml           | 125 ++++++++++++++++++
>  1 file changed, 125 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> new file mode 100644
> index 000000000000..412f2e573540
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/hellcreek.yaml
> @@ -0,0 +1,125 @@
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
> +    items:
> +      - const: hirschmann,hellcreek
> +
> +  reg:
> +    description:
> +      The physical base address and size of TSN and PTP memory base
> +    minItems: 2
> +    maxItems: 2
> +
> +  reg-names:
> +    items:
> +      - const: tsn
> +      - const: ptp
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

As there are only 2 LED nodes:

"led@[01]$"

> +          type: object
> +          description: Hellcreek leds
> +          $ref: ../../leds/common.yaml#
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

For the 'leds' node:

       additionalProperties: false

With those fixes,

Reviewed-by: Rob Herring <robh@kernel.org>

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - ethernet-ports
> +  - leds
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +        switch0: switch@ff240000 {
> +            compatible = "hirschmann,hellcreek";
> +            reg = <0xff240000 0x1000>,
> +                  <0xff250000 0x1000>;
> +            reg-names = "tsn", "ptp";
> +            dsa,member = <0 0>;
> +
> +            ethernet-ports {
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
