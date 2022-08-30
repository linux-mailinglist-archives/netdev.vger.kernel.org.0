Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1165C5A6E2E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiH3ULL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbiH3UK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:10:57 -0400
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9DA543C4;
        Tue, 30 Aug 2022 13:10:56 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-11e9a7135easo16964006fac.6;
        Tue, 30 Aug 2022 13:10:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HN9nt5MKpRjQf+XTDn3zjxFKHaai2Dr1l/AVE9BA+h0=;
        b=k6B82L5JO2i5bPd9UEDC0TYJoNihZix4rc02ilpj2YhfjI4YRfZPHkXEg1Lw93dQfr
         NLSt9SzZa2favB7OpSw/jYk5bH4N3uO4BWtqOcZyz27oZAHOO/ESO9de09bkIiMKoW5Q
         MZCaT3Dbj7aBb/vG5qo7aNWFGdFZn6+kl2BMqc57SJNMZWcZuQqHdcgVwBeONKx0qAHY
         vOkxSRXJ3eXsM4oIMmcwKk9XLFrBm3WxD8cBTbB/0bv+2qJ/5VSZi1VLU+jUpSHNCpMd
         adV0llaHtHShXwJ/LqvnVyeFMV4gOwv9eD5oDv2+1CmStieb+jnH+rclkzaRETuTkQdK
         +pYg==
X-Gm-Message-State: ACgBeo3H3CB0E3Q2vDfxdLIF/w+aQZQuZgRTVwyLoC/v3SnPNaUgpZeK
        q5WGKcNv1IPNmla66NSRdw==
X-Google-Smtp-Source: AA6agR73UpzSjVGGVSnUe9wraiSZ2NR0x+XejVAx+JPYkja6UEbBNNj6vmJbuGRsY+4GdYfN08ZYqw==
X-Received: by 2002:a05:6808:d48:b0:343:1ed2:7d08 with SMTP id w8-20020a0568080d4800b003431ed27d08mr10040929oik.197.1661890255976;
        Tue, 30 Aug 2022 13:10:55 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t27-20020a056808159b00b0034305ddc29dsm6731909oiw.28.2022.08.30.13.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 13:10:55 -0700 (PDT)
Received: (nullmailer pid 1979150 invoked by uid 1000);
        Tue, 30 Aug 2022 20:10:54 -0000
Date:   Tue, 30 Aug 2022 15:10:54 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v4 6/7] dt-bindings: net: pse-dt: add bindings
 for generic PSE controller
Message-ID: <20220830201054.GA1874385-robh@kernel.org>
References: <20220828063021.3963761-1-o.rempel@pengutronix.de>
 <20220828063021.3963761-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220828063021.3963761-7-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 08:30:20AM +0200, Oleksij Rempel wrote:
> Add binding for generic Ethernet PSE controller.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v4:
> - rename to PSE regulator
> - drop currently unused properties
> - use own compatible for PoDL PSE
> changes v2:
> - rename compatible to more generic "ieee802.3-pse"
> - add class and type properties for PoDL and PoE variants
> - add pairs property
> ---
>  .../bindings/net/pse-pd/pse-regulator.yaml    | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-regulator.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/pse-pd/pse-regulator.yaml b/Documentation/devicetree/bindings/net/pse-pd/pse-regulator.yaml
> new file mode 100644
> index 0000000000000..1a906d2135a7a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pse-pd/pse-regulator.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pse-pd/pse-regulator.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Regulator based Power Sourcing Equipment
> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +description: Regulator based PSE controller. The device must be referenced by
> +  the PHY node to control power injection to the Ethernet cable.
> +
> +properties:
> +  compatible:
> +    description: Regulator based PoDL PSE controller for a single twisted-pair
> +      link.
> +    const: podl-pse-regulator
> +
> +  '#pse-cells':
> +    const: 0

Do you have intentions that this would be non-zero? This series is 
defining a new common binding, but only creating a specific schema. 
You need to define in a common schema what the purpose of the cells may 
be and if there's common constraints defining those in the common 
schema. There's several examples where only 0 or 1 is allowed for 
example.

There's a standard pattern of '#foo-cells' for the provider and 'foos' 
for the consumer. Ultimately, anything that doesn't follow that pattern 
needs explicit support in dtschema to decode the consumers. IOW, try to 
follow the pattern. Either '#ieee802.3-pse-cells'/'ieee802.3-pses' or 
'#pse-cells'/'pses'. Neither seems great to me. The former is a bit too 
specific and the latter a bit too short. Shrug.

Rob

