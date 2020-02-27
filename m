Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236A71724F8
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 18:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgB0RXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 12:23:43 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35344 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730208AbgB0RXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 12:23:43 -0500
Received: by mail-ot1-f68.google.com with SMTP id r16so3693773otd.2;
        Thu, 27 Feb 2020 09:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3SQrHH3RldHlDSPXSXXFbHJRaEJs4Lzh1Ap0ZS/UfRI=;
        b=aRjxPVhp94sh8Wceqco7uWbuHpFWvMGd+OKcY/bJXk1Ap3Sto1SduoJQSBIKx1yd71
         sn9asVH+JylFCDolbKJxOcK4hM0uNpNNxUxCyD4+6jx2h83LquL1Z6SmvERaWD7I6s66
         F1i2cKQtnzWoMQwJeSKHMPF+olfE+h+AfNZ5jOnlyUh0AlPdggRrND1UXqb2ZrOEPGAr
         g+LAcAEAOCSjo6lRe9Z1vEjv04aWRtJSjTRhTXIadv1LmhTTe3h8jS2OBVY/V0RJB+kS
         x3kO5DsyoyZCxqiELCiyRbI4qgfm3v3JJU8xtIlYGpEKnjSxmwo6Fb08gQxTKixmTyUm
         NT6w==
X-Gm-Message-State: APjAAAUGCICABXruWAfXxcrO9vn7Ul/Cb95uT30KrIeUc3lE2/Fx0nKG
        2OST3umDIi8pVit8gFQ9gA==
X-Google-Smtp-Source: APXvYqzW64cJcps6+Kk6SHemjadYsuL6hjnqtoSPNHPfFBrAfn+8QW46IsbbWEnrIhKEW1l666/RPw==
X-Received: by 2002:a9d:6212:: with SMTP id g18mr659180otj.187.1582824222587;
        Thu, 27 Feb 2020 09:23:42 -0800 (PST)
Received: from rob-hp-laptop (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y13sm2122714otk.40.2020.02.27.09.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 09:23:41 -0800 (PST)
Received: (nullmailer pid 24337 invoked by uid 1000);
        Thu, 27 Feb 2020 17:23:40 -0000
Date:   Thu, 27 Feb 2020 11:23:40 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 2/2] dt-bindings: net: Add ipq806x mdio bindings
Message-ID: <20200227172340.GA19136@bogus>
References: <andrew@lunn.ch>
 <20200227011050.11106-1-ansuelsmth@gmail.com>
 <20200227011050.11106-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227011050.11106-2-ansuelsmth@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 02:10:46AM +0100, Ansuel Smith wrote:
> Add documentations for ipq806x mdio driver.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
> Changes in v8:
> - Fix error in dtb check
> - Remove not needed reset definition from example
> - Add include header for ipq806x clocks
> - Fix wrong License type
> 
> Changes in v7:
> - Fix dt_binding_check problem
> 
>  .../bindings/net/qcom,ipq8064-mdio.yaml       | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> new file mode 100644
> index 000000000000..4334a415f23c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0-only

Dual license new bindings please:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm ipq806x MDIO bus controller
> +
> +maintainers:
> +  - Ansuel Smith <ansuelsmth@gmail.com>
> +
> +description:
> +  The ipq806x soc have a MDIO dedicated controller that is
> +  used to comunicate with the gmac phy conntected.

2 typos

> +  Child nodes of this MDIO bus controller node are standard
> +  Ethernet PHY device nodes as described in
> +  Documentation/devicetree/bindings/net/phy.txt

You might want to read what that file says now.

> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    items:
> +        - const: qcom,ipq8064-mdio
> +        - const: syscon

Why is this a 'syscon'? Does it have more than 1 function?

> +
> +  reg:
> +    description: address and length of the register set for the device

Drop this and you need to state how many (maxItems).

> +
> +  clocks:
> +    description: A reference to the clock supplying the MDIO bus controller

Same here.

> +
> +  clock-names:
> +    const: master
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-ipq806x.h>
> +
> +    mdio0: mdio@37000000 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        compatible = "qcom,ipq8064-mdio", "syscon";
> +        reg = <0x37000000 0x200000>;
> +
> +        clocks = <&gcc GMAC_CORE1_CLK>;
> +
> +        switch@10 {
> +            compatible = "qca,qca8337";
> +            /* ... */
> +        };
> +    };
> -- 
> 2.25.0
> 
