Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDA948441F
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbiADPD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:03:57 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:38593 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiADPD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:03:56 -0500
Received: by mail-ot1-f46.google.com with SMTP id v22-20020a9d4e96000000b005799790cf0bso47540224otk.5;
        Tue, 04 Jan 2022 07:03:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=152c0gKjn3E33kOx2gb1j/9J4KVx7ChUyzcnpwaFY8g=;
        b=Q0bg9DeO4H5RWgNwl1ZvM+WdWqpx3KLtPvwhQ3hoGAcD79SUzLqO6CGGr0hSsCivIq
         HHbhXfHkXX+Dfhf92Qq5RlSbdpO2XqpbGeXcO5aXJWeNkQwnmZqpuA3oX6CTeq790+ZM
         08XgTF2HGkQ5X+FHwsDERZQvUYaYRjEOKeNsXtGOy/6cxFKI+8wCuEaM92OX6C9DU5Ij
         vQu8GGHCbTU6fjd2q5xF3U2BUVhw1m7gCMCVdfS5WRzKkW5cA4/3WbEMXqYeVCG0MYYU
         Shcth/FuDd9jFGjWNd8uG+nK3K+8PQ3paaXRxSt/iDAfg+4qmhm9iFU41Sym8JuCYzuk
         aekQ==
X-Gm-Message-State: AOAM531iDs7TY5PTEnP0xUkX2+cD45OJwMQK7NAYcA5A7onboe1Ozjzl
        Glpe3YJOXZbQvwga9IfiTw==
X-Google-Smtp-Source: ABdhPJxdcEz899N4s9UGrNr72PJ1GZBttIopE5knK3uzd5fzcvNeYcIE9wjDFZ/opk6pASbc7fBNvw==
X-Received: by 2002:a05:6830:24ac:: with SMTP id v12mr36249885ots.177.1641308635916;
        Tue, 04 Jan 2022 07:03:55 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id h1sm7720007oog.26.2022.01.04.07.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 07:03:55 -0800 (PST)
Received: (nullmailer pid 830577 invoked by uid 1000);
        Tue, 04 Jan 2022 15:03:54 -0000
Date:   Tue, 4 Jan 2022 09:03:54 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 2/8] dt-bindings: nvmem: add transformation bindings
Message-ID: <YdRh2lp5Ca08gHtR@robh.at.kernel.org>
References: <20211228142549.1275412-1-michael@walle.cc>
 <20211228142549.1275412-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211228142549.1275412-3-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 28, 2021 at 03:25:43PM +0100, Michael Walle wrote:
> Just add a simple list of the supported devices which need a nvmem
> transformations.
> 
> Also, since the compatible string is prepended to the actual nvmem
> compatible string, we need to match using "contains" instead of an exact
> match.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../devicetree/bindings/mtd/mtd.yaml          |  7 +--
>  .../bindings/nvmem/nvmem-transformations.yaml | 46 +++++++++++++++++++
>  2 files changed, 50 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
> 
> diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml b/Documentation/devicetree/bindings/mtd/mtd.yaml
> index 376b679cfc70..0291e439b6a6 100644
> --- a/Documentation/devicetree/bindings/mtd/mtd.yaml
> +++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
> @@ -33,9 +33,10 @@ patternProperties:
>  
>      properties:
>        compatible:
> -        enum:
> -          - user-otp
> -          - factory-otp
> +        contains:
> +          enum:
> +            - user-otp
> +            - factory-otp

If the addition is only compatible strings, then I would just add them 
here. Otherwise this needs to be structured a bit differently. More on 
that below.

>  
>      required:
>        - compatible
> diff --git a/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
> new file mode 100644
> index 000000000000..8c8d85fd6d27
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
> @@ -0,0 +1,46 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/nvmem/nvmem-transformations.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NVMEM transformations Device Tree Bindings
> +
> +maintainers:
> +  - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> +
> +description: |
> +  This is a list NVMEM devices which need transformations.
> +
> +properties:
> +  compatible:
> +    oneOf:
> +      - items:
> +        - enum:
> +          - kontron,sl28-vpd
> +        - const: user-otp
> +      - const: user-otp

This will be applied to any node containing 'user-otp'. You need a 
custom 'select' to avoid that.

> +
> +required:
> +  - compatible
> +
> +additionalProperties: true

True is only allowed for common schema intended to be included (i.e. a 
$ref) by other schemas. IOW, ones that are incomplete on their own. So 
you need to reference mtd.yaml and make this 'unevaluatedProperties: false'.

> +
> +examples:
> +  - |
> +    otp-1 {
> +            compatible = "kontron,sl28-vpd", "user-otp";
> +            #address-cells = <1>;
> +            #size-cells = <1>;
> +
> +            serial@2 {
> +                    reg = <2 15>;
> +            };
> +
> +            base_mac_address: base-mac-address@17 {
> +                    #nvmem-cell-cells = <1>;
> +                    reg = <17 6>;
> +            };
> +    };
> +
> +...
> -- 
> 2.30.2
> 
> 
