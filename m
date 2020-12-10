Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA1A42D5221
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 04:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgLJDzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 22:55:20 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42150 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgLJDzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 22:55:20 -0500
Received: by mail-ot1-f65.google.com with SMTP id 11so3648242oty.9;
        Wed, 09 Dec 2020 19:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wL0ajPlgdAT6O4z+bN0Qz8NaqhzcUBA3uihC+tT0e8o=;
        b=PBVlo0Iyqo1EY7OsGhpk5Ovvv78GLmP6P9+hl+BKRTunHG1Frf2fowD9dPIwCbUseG
         ngJbfSwZmQ49kSzvvgDGcSzyOPY0pzEMpNc7Dgyqqlk+DNTScHrlyIgVoo9CKcYgPD2L
         Ucw45A84TnbsRAgRL933+kgD0Xy20gQZvKt1STrdGVNTkJD5PBPdHIq3bqw5aLAQHVkg
         ZByIMOunBCUTvplwg0AuIdWGM4+wfZke8mGdIqF5JqZAjNZbhC5MpoAiUIrsl6Cx43Co
         OTTXXHulyOU4IEc8v4IygYKlPXKD57ubrqHSZRaaDElHer71I3wKYS3PS6SQjJsm/WBE
         RIDw==
X-Gm-Message-State: AOAM531DCSgUDXX5OYgjwdM03f9mlyYA7LhCc6KaQAbsX3etV99Dorsf
        7aHiEvcOpOsx/w/6XKQJLQ==
X-Google-Smtp-Source: ABdhPJzxVeckBGv2tyO4i8ZF5YrQSsAyQSr5Y0SeVbQ6wo/ZMSKxasdfzKc4phKVtDcAUZGowJs8rQ==
X-Received: by 2002:a9d:67da:: with SMTP id c26mr4513062otn.321.1607572479277;
        Wed, 09 Dec 2020 19:54:39 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id i1sm753108ool.43.2020.12.09.19.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 19:54:38 -0800 (PST)
Received: (nullmailer pid 1631175 invoked by uid 1000);
        Thu, 10 Dec 2020 03:54:37 -0000
Date:   Wed, 9 Dec 2020 21:54:37 -0600
From:   Rob Herring <robh@kernel.org>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] dt-bindings: net: dsa: add bindings for
 xrs700x switches
Message-ID: <20201210035437.GA1627447@robh.at.kernel.org>
References: <20201207220355.8707-1-george.mccollister@gmail.com>
 <20201207220355.8707-4-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207220355.8707-4-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 04:03:55PM -0600, George McCollister wrote:
> Add documentation and an example for Arrow SpeedChips XRS7000 Series
> single chip Ethernet switches.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 74 ++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> new file mode 100644
> index 000000000000..05ed36ce02ec
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> @@ -0,0 +1,74 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/arrow,xrs700x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +maintainers:
> +  - George McCollister <george.mccollister@gmail.com>
> +
> +description:
> +  The Arrow SpeedChips XRS7000 Series of single chip gigabit Ethernet switches
> +  are designed for critical networking applications. They have up to three
> +  RGMII ports and one RMII port and are managed via i2c or mdio.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - enum:
> +          - arrow,xrs7003e
> +          - arrow,xrs7003f
> +          - arrow,xrs7004e
> +          - arrow,xrs7004f
> +
> +  reg:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    i2c {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        switch@8 {
> +            compatible = "arrow,xrs7004e";
> +            reg = <0x8>;
> +
> +            status = "okay";

Don't show status in examples.

> +            ports {

ethernet-ports is preferred.

> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +                port@1 {

And ethernet-port

> +                    reg = <1>;
> +                    label = "lan0";
> +                    phy-handle = <&swphy0>;
> +                    phy-mode = "rgmii-id";
> +                };
> +                port@2 {
> +                    reg = <2>;
> +                    label = "lan1";
> +                    phy-handle = <&swphy1>;
> +                    phy-mode = "rgmii-id";
> +                };
> +                port@3 {
> +                    reg = <3>;
> +                    label = "cpu";
> +                    ethernet = <&fec1>;
> +                    fixed-link {
> +                        speed = <1000>;
> +                        full-duplex;
> +                    };
> +                };
> +            };
> +        };
> +    };
> -- 
> 2.11.0
> 
