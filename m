Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E7443FB51
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhJ2L12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhJ2L10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 07:27:26 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEB7C061570;
        Fri, 29 Oct 2021 04:24:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d3so15653163wrh.8;
        Fri, 29 Oct 2021 04:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DPGT6EUAlraqd/w6sEA+D7Ix1Gyx1G5HP1PHalM05U4=;
        b=J3y4C4t2fcaY4GN/FXjXriBeRhkFD2rsz6XCXLaSElDUTekqaguUf8Wu7PjjNynDj5
         16gjveiw7sXk7TlAygummz/IeJBUF3pn9VYq2mOrpXWGRaBF8v+F98EGPVoM4OkoK2Iu
         6Frkry3JpfPFMjDwLWjaJJ4hlu9Dzx6n9+6YmD/Jl1wgcDx/j3HriCaZIfWatWsx9ysl
         MzvtORsRb4F1f1L4fK3jbIcVnF3CtIjsvdbO83xzDZH78+w6HoEdRkq6ZMNL8d8ZXTmv
         rdmbOlVsbO7y7QijhotMDnW0lavAk+3RouSyrMm1EOPYnw0da/uOFmj7oSOCjCn6DwrY
         5LTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPGT6EUAlraqd/w6sEA+D7Ix1Gyx1G5HP1PHalM05U4=;
        b=NmfJUDuLvpuvDN4JpHgpURi5B/enSEgjYryTBD+k6q7MglX2fUtqvKffVtyWHaSca7
         K1oM/8GD76NLsaEbCnSHyRR2Lcg5ZpDFw6iUIWpPvk2Esf9xb1VDSwu8pYV4WjB51zjz
         B/K8bmRzYXK54KkDlsvkoM4wX3eUqPyghXX0KFcpOue+a7rxbKS3ES2vVNwtHjmPiTiX
         pHrvsprEg/FwH+x8oLoRGYAiWP1EdFCROlODXPg9LphZdFORtjEsv0lnftiZu8RMcPlZ
         HLPeQ9wj/ttdN2bmLYMYAsiWLw+xliie3fUx/uFzZAxb6Hja9EZWB9oauHxPOHfOW2OV
         t0dw==
X-Gm-Message-State: AOAM533bErpcFzS4arkjKaqMuWizGjGKLCiy/OJ3lC1UjogyMqvOH3jW
        ZgP5SchqrqF+iYKR8vflXEm3OpSgwpE=
X-Google-Smtp-Source: ABdhPJwldtJeX0nZAbo5YdMAz7rfWLLt0/NVdwm6ZBnkNLV0fkbhD5tfpRwj9pD7I57kb/u8gjtlhg==
X-Received: by 2002:adf:a143:: with SMTP id r3mr13406217wrr.8.1635506696733;
        Fri, 29 Oct 2021 04:24:56 -0700 (PDT)
Received: from skbuf ([188.25.175.102])
        by smtp.gmail.com with ESMTPSA id x6sm6229660wro.63.2021.10.29.04.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 04:24:56 -0700 (PDT)
Date:   Fri, 29 Oct 2021 14:24:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 net-next 01/10] dt-bindings: net: dsa: dt bindings for
 microchip lan937x
Message-ID: <20211029112454.a765gtse5vyk4feq@skbuf>
References: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
 <20211029052256.144739-2-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029052256.144739-2-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 10:52:47AM +0530, Prasanna Vengateshan wrote:
> Documentation in .yaml format and updates to the MAINTAINERS
> Also 'make dt_binding_check' is passed.
> 
> Introduced rx-internal-delay-ps & tx-internal-delay-ps for RGMII
> internal delay along with min/max values. This is to address the
> Vladimir proposal from the previous revision and mdio details
> are added as suggested by Rob.

This sort of meta-information does not really belong in a commit
message, there is...

> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---

...this area for it. People of the future won't have any idea what is
the previous revision or who Vladimir is.

>  .../bindings/net/dsa/microchip,lan937x.yaml   | 180 ++++++++++++++++++
>  MAINTAINERS                                   |   1 +
>  2 files changed, 181 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> new file mode 100644
> index 000000000000..0bc16894c8c4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
> @@ -0,0 +1,180 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LAN937x Ethernet Switch Series Tree Bindings
> +
> +maintainers:
> +  - UNGLinuxDriver@microchip.com
> +
> +allOf:
> +  - $ref: dsa.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - microchip,lan9370
> +      - microchip,lan9371
> +      - microchip,lan9372
> +      - microchip,lan9373
> +      - microchip,lan9374
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 50000000
> +
> +  reset-gpios:
> +    description: Optional gpio specifier for a reset line
> +    maxItems: 1
> +
> +  mdio:
> +    $ref: /schemas/net/mdio.yaml#
> +    unevaluatedProperties: false
> +
> +patternProperties:
> +  "^(ethernet-)?ports$":
> +    patternProperties:
> +      "^(ethernet-)?port@[0-7]+$":
> +        allOf:
> +          - if:
> +              properties:
> +                phy-mode:
> +                  contains:
> +                    enum:
> +                      - rgmii
> +                      - rgmii-rxid
> +                      - rgmii-txid
> +                      - rgmii-id
> +            then:
> +              properties:
> +                rx-internal-delay-ps:
> +                  $ref: "#/$defs/internal-delay-ps"
> +                tx-internal-delay-ps:
> +                  $ref: "#/$defs/internal-delay-ps"
> +
> +required:
> +  - compatible
> +  - reg
> +
> +$defs:
> +  internal-delay-ps:
> +    description: Delay is in pico seconds
> +    minimum: 2170
> +    maximum: 4000
> +    default: 0

Why is the default value smaller than the minimum? What kind of minimum is that?
If the hardware does not accept the continuous range of values between
2170 and 4000, just enumerate the valid discrete values. It takes 30
seconds to write a bash script. That's one of the reasons why I added a
$def in nxp,sja1105.rst for this in the first place, to avoid
duplicating that enumeration.

> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    //Ethernet switch connected via spi to the host
> +    ethernet {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      fixed-link {
> +        speed = <1000>;
> +        full-duplex;
> +      };
> +    };
> +
> +    spi {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      lan9374: switch@0 {
> +        compatible = "microchip,lan9374";
> +        reg = <0>;
> +
> +        spi-max-frequency = <44000000>;
> +
> +        ethernet-ports {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +          port@0 {
> +            reg = <0>;
> +            label = "lan1";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy0>;
> +          };
> +          port@1 {
> +            reg = <1>;
> +            label = "lan2";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy1>;
> +          };
> +          port@2 {
> +            reg = <2>;
> +            label = "lan4";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy2>;
> +          };
> +          port@3 {
> +            reg = <3>;
> +            label = "lan6";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy3>;
> +          };
> +          port@4 {
> +            reg = <4>;
> +            phy-mode = "rgmii";
> +            ethernet = <&ethernet>;
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@5 {
> +            reg = <5>;
> +            label = "lan7";
> +            phy-mode = "rgmii";
> +            fixed-link {
> +              speed = <1000>;
> +              full-duplex;
> +            };
> +          };
> +          port@6 {
> +            reg = <6>;
> +            label = "lan5";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy4>;
> +          };
> +          port@7 {
> +            reg = <7>;
> +            label = "lan3";
> +            phy-mode = "internal";
> +            phy-handle = <&t1phy5>;
> +          };
> +        };
> +
> +        mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          t1phy0: ethernet-phy@0{
> +            reg = <0x0>;
> +          };
> +          t1phy1: ethernet-phy@1{
> +            reg = <0x1>;
> +          };
> +          t1phy2: ethernet-phy@2{
> +            reg = <0x2>;
> +          };
> +          t1phy3: ethernet-phy@3{
> +            reg = <0x3>;
> +          };
> +          t1phy4: ethernet-phy@6{
> +            reg = <0x6>;
> +          };
> +          t1phy5: ethernet-phy@7{
> +            reg = <0x7>;
> +          };
> +        };
> +      };
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b85f039fbf9..9dfd8169dcdf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12312,6 +12312,7 @@ M:	UNGLinuxDriver@microchip.com
>  L:	netdev@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
>  F:	drivers/net/dsa/microchip/*
>  F:	include/linux/platform_data/microchip-ksz.h
>  F:	net/dsa/tag_ksz.c
> -- 
> 2.27.0
> 
