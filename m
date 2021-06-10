Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5743A2267
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 04:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFJC4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 22:56:37 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:34411 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJC4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 22:56:36 -0400
Received: by mail-oi1-f173.google.com with SMTP id u11so523935oiv.1;
        Wed, 09 Jun 2021 19:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pFQ0HVskYN+r9fzWJAQa0wlVzPlvU5e2ueuLh14hP8M=;
        b=jsTLmsVjm1qdVnX9FW1ukRqOCgJKXFP/VbhwusUHEsH5X7s1iD/14xZeQYpRCEOFj6
         oGbMpJ/ZXsxCmlC1ScXzDYL6h08qkh0f6XYdA6aJbZeeyEyc90f/xho7sO1T6Ne0vgJV
         CSAtTVc3yEkVTMEElRWKB7KDMxlnbfKOWDxXUOyyVuSdiH5sMkX1FrPdbXf/tNVJXT4f
         0SD5l7FCkX6tluPrrZxV6NvnDFWYBenHUG5BKiQwm9QRc1rTLYZlTmksBSImCVAhKMq8
         YuBfzwYTLjb3VGq8HxAkBInKhEmEu2dZb7YkExLZlOlMNZrjLN0MJX2A2fDNrjOHIyUV
         lGyw==
X-Gm-Message-State: AOAM532szTU0JBTvx7lhj/J9vX+ftPq7hpSlx+PUSmNSsg6ya3DZPFzm
        MEgFA2mOTzAk2hs+5TKA1w==
X-Google-Smtp-Source: ABdhPJzEOtUvmJdHWhy3NhrpJq/wqcfDkuFKSxjGhoTzmi0X3cUVs6H8OeD4rNntIdtNhfhTlSV0QA==
X-Received: by 2002:a05:6808:60e:: with SMTP id y14mr8184047oih.105.1623293681070;
        Wed, 09 Jun 2021 19:54:41 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id r83sm320000oih.48.2021.06.09.19.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 19:54:39 -0700 (PDT)
Received: (nullmailer pid 729105 invoked by uid 1000);
        Thu, 10 Jun 2021 02:54:38 -0000
Date:   Wed, 9 Jun 2021 21:54:38 -0500
From:   Rob Herring <robh@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, f.fainelli@gmail.com,
        Jisheng.Zhang@synaptics.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] dt-bindings: net: add dt binding for
 realtek rtl82xx phy
Message-ID: <20210610025438.GA720819@robh.at.kernel.org>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
 <20210608031535.3651-2-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608031535.3651-2-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 11:15:32AM +0800, Joakim Zhang wrote:
> Add binding for realtek rtl82xx phy.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../bindings/net/realtek,rtl82xx.yaml         | 45 +++++++++++++++++++
>  1 file changed, 45 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> new file mode 100644
> index 000000000000..bb94a2388520
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
> @@ -0,0 +1,45 @@
> +# SPDX-License-Identifier: GPL-2.0+
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/realtek,rtl82xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Realtek RTL82xx PHY
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>
> +
> +description:
> +  Bindings for Realtek RTL82xx PHYs
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  realtek,clkout-disable:
> +    type: boolean
> +    description:
> +      Disable CLKOUT clock, CLKOUT clock default is enabled after hardware reset.
> +
> +

Extra blank line.

> +  realtek,aldps-enable:
> +    type: boolean
> +    description:
> +      Enable ALDPS mode, ALDPS mode default is disabled after hardware reset.
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethphy1: ethernet-phy@1 {
> +                reg = <1>;
> +                realtek,clkout-disable;
> +                realtek,aldps-enable;

The schema here will never be applied because there is nothing to match 
on to determine which nodes it is valid. This should have a compatible 
(because ethernet phys are not special).

Rob
