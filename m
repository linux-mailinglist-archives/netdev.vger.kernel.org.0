Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F18370342
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 23:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhD3VyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 17:54:17 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:46875 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbhD3VyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 17:54:16 -0400
Received: by mail-ot1-f53.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso63837175otb.13;
        Fri, 30 Apr 2021 14:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jllp/+vp6E8x8z18/+vfOIziwd4SDgO/V85o6jom1sI=;
        b=qK0wDcXL+ozLTenDyvi6ZvIeywrP5e+cbnG1N4d1UTIdQ04HvSS3qVciWAPmq6Am75
         dcZiPc9vyx9nejc8KcnIw67PgX09aC9gXYX17X8zQz1XyvGMRkTMN+rRBinYaKpz5qvg
         xPM5DRFW8yoFCgXTZQ1RUhnM30UjjeBas59MC/7pzugAr+RH5K2nzXF7nItMRiD1A22G
         Em4/T2ssnAAvaOnxYvUVizgC9vUqqdpLSuJBYRMXo9FBTlH02PMacPpgcxeIR2lEF6sY
         ipP6u+JMfHddnSTr/PGh1T60q9OGJnk+6528RvgKvOQ4oxqDvOY5+p6Ox8xQDC8B2hhI
         Ehdg==
X-Gm-Message-State: AOAM533gJdWXTBUytZc4XnAwoyBgVPqs0aCmk+XyEfZCcSRT8ZRlKy4l
        LaVSh7dM2LqNieJt8cWNlQ==
X-Google-Smtp-Source: ABdhPJxpXpJm92cnwWYpMkS6YvJ66+iz1HDOHiqhSWqjgFKvOmFbYYcAn1QlpANBkTDIooCLfHjv2w==
X-Received: by 2002:a05:6830:90b:: with SMTP id v11mr5011259ott.110.1619819606591;
        Fri, 30 Apr 2021 14:53:26 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id n17sm1054496oie.11.2021.04.30.14.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 14:53:26 -0700 (PDT)
Received: (nullmailer pid 3967618 invoked by uid 1000);
        Fri, 30 Apr 2021 21:53:25 -0000
Date:   Fri, 30 Apr 2021 16:53:25 -0500
From:   Rob Herring <robh@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <20210430215325.GA3957879@robh.at.kernel.org>
References: <20210430182941.915101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430182941.915101-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 06:29:41PM +0000, Corentin Labbe wrote:
> Converts net/mdio-gpio.txt to yaml
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Changes since v1:
> - fixes yamllint warning about indent
> - added maxItems 3
> 
> Changes since v2:
> - fixed example (gpios need 2 entries)
> 
>  .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
>  .../devicetree/bindings/net/mdio-gpio.yaml    | 57 +++++++++++++++++++
>  2 files changed, 57 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
> deleted file mode 100644
> index 4d91a36c5cf5..000000000000
> --- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -MDIO on GPIOs
> -
> -Currently defined compatibles:
> -- virtual,gpio-mdio
> -- microchip,mdio-smi0
> -
> -MDC and MDIO lines connected to GPIO controllers are listed in the
> -gpios property as described in section VIII.1 in the following order:
> -
> -MDC, MDIO.
> -
> -Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
> -node.
> -
> -Example:
> -
> -aliases {
> -	mdio-gpio0 = &mdio0;
> -};
> -
> -mdio0: mdio {
> -	compatible = "virtual,mdio-gpio";
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -	gpios = <&qe_pio_a 11
> -		 &qe_pio_c 6>;
> -};
> diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> new file mode 100644
> index 000000000000..183cf248d597
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> @@ -0,0 +1,57 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mdio-gpio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MDIO on GPIOs
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    enum:
> +      - virtual,mdio-gpio
> +      - microchip,mdio-smi0
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  gpios:
> +    minItems: 2
> +    maxItems: 3
> +    description: |
> +      MDC and MDIO lines connected to GPIO controllers are listed in
> +      the gpios property as described in section VIII.1 in the
> +      following order: MDC, MDIO.

section VIII.1 of what? Might be in DT spec, but if so the section is 
different for sure.

What's the order with 3 lines? In any case, define the order with 
schema:

minItems:
items:
  - description: MDC signal
  - description: MDIO or ?? signal
  - description: ?? signal

> +
> +#Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
> +#node.
> +unevaluatedProperties: false

additionalProperties:
  type: object

To say anything else has to be a child node.

> +
> +examples:
> +  - |
> +    aliases {
> +        mdio-gpio0 = &mdio0;
> +    };
> +
> +    mdio0: mdio {
> +      compatible = "virtual,mdio-gpio";
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      gpios = <&qe_pio_a 11>,
> +              <&qe_pio_c 6>;
> +      ethphy0: ethernet-phy@0 {
> +        reg = <0>;
> +      };
> +    };
> +...
> -- 
> 2.26.3
> 
