Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB115AB99B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 22:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiIBUu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 16:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIBUu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 16:50:58 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DB4A723E;
        Fri,  2 Sep 2022 13:50:52 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-12566bc8e52so4435724fac.12;
        Fri, 02 Sep 2022 13:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=EOpW4WejvYrrZZZ/HuJUkBNhBHbazAogZY3qNbeFoIE=;
        b=1wMI1uEW3gqE0RtsGS5DDkVyA5/M0C1nhP8xWlck6Y4Nep1B6JRetlSKMp1N39S/p5
         WzVBqc2A92HTreTwOdnb09cIaKIJb2MBtCJqkkUvFpCdHyx0sdV7rd7fcbX49bZOAuCX
         d8QzJh7tMbm5cYY+dV2A4HAoYOUTeiIkPecQaGq0ejE1MjZIc5GIgsONv56ugnpaNvtu
         xRR3urmAqAKMp3VjbF9zXpZopKTyLXiHrNdwp9j5ZhySwUdmEE8SmDq4FJJ7JwTpjFGE
         qfT2bGKZfyFFKoSrxDHmMos+qwLjjugPutr1B3SKA7XHeh8H1fyKXVuGBretMTAnYArp
         Brbw==
X-Gm-Message-State: ACgBeo3Xjpg2S/hshI8xWb0uQewkTgPs4p3RyoGDYllfDPEkGWY1LbXa
        d0uPt7UupyPl0Xplgfs/JQ==
X-Google-Smtp-Source: AA6agR6pbUe/gxk0J9hqcfJSe/UXp4BZrJcIVle5VJp0L2jHl3JHWDzqJYX6EIL/eM+UckcDY9L+/w==
X-Received: by 2002:a05:6808:1a13:b0:344:d744:5950 with SMTP id bk19-20020a0568081a1300b00344d7445950mr2661425oib.243.1662151851753;
        Fri, 02 Sep 2022 13:50:51 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id h34-20020a9d2f25000000b00638ab4c953asm1429274otb.74.2022.09.02.13.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 13:50:51 -0700 (PDT)
Received: (nullmailer pid 392304 invoked by uid 1000);
        Fri, 02 Sep 2022 20:50:50 -0000
Date:   Fri, 2 Sep 2022 15:50:50 -0500
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
Subject: Re: [PATCH net-next v5 6/7] dt-bindings: net: pse-dt: add bindings
 for regulator based PoDL PSE controller
Message-ID: <20220902205050.GA382567-robh@kernel.org>
References: <20220831133240.3236779-1-o.rempel@pengutronix.de>
 <20220831133240.3236779-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831133240.3236779-7-o.rempel@pengutronix.de>
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

On Wed, Aug 31, 2022 at 03:32:39PM +0200, Oleksij Rempel wrote:
> Add bindings for the regulator based Ethernet PoDL PSE controller and
> generic bindings for all PSE controllers.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> changes v5:
> - rename to podl-pse-regulator.yaml
> - remove compatible description
> - remove "-1" on node name
> - add pse-controller.yaml for common properties
> changes v4:
> - rename to PSE regulator
> - drop currently unused properties
> - use own compatible for PoDL PSE
> changes v2:
> - rename compatible to more generic "ieee802.3-pse"
> - add class and type properties for PoDL and PoE variants
> - add pairs property
> ---
>  .../net/pse-pd/podl-pse-regulator.yaml        | 40 +++++++++++++++++++
>  .../bindings/net/pse-pd/pse-controller.yaml   | 28 +++++++++++++
>  2 files changed, 68 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
>  create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
> new file mode 100644
> index 0000000000000..c6b1c188abf7e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
> @@ -0,0 +1,40 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pse-pd/podl-pse-regulator.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Regulator based Power Sourcing Equipment
> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +description: Regulator based PoDL PSE controller. The device must be referenced
> +  by the PHY node to control power injection to the Ethernet cable.
> +
> +allOf:
> +  - $ref: "pse-controller.yaml#"
> +
> +properties:
> +  compatible:
> +    const: podl-pse-regulator
> +
> +  '#pse-cells':
> +    const: 0
> +
> +  pse-supply:
> +    description: Power supply for the PSE controller
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - pse-supply
> +
> +examples:
> +  - |
> +    ethernet-pse {
> +      compatible = "podl-pse-regulator";
> +      pse-supply = <&reg_t1l1>;
> +      #pse-cells = <0>;
> +    };
> diff --git a/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> new file mode 100644
> index 0000000000000..36e398fea220c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
> @@ -0,0 +1,28 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/pse-pd/pse-controller.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: PSE Generic Bindings

What is PSE?

When would I use this binding? Does this follow some spec? Who is 
the consumer? Please answer all those questions in this doc.

> +
> +maintainers:
> +  - Oleksij Rempel <o.rempel@pengutronix.de>
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet-pse(@[a-f0-9]+)?$"

The format of the unit-address depends on the bus, so it shouldn't be 
defined here. Just '^ethernet-pse(@.*)?$'.

> +
> +  "#pse-cells":
> +    description:
> +      Used to uniquely identify a PSE instance within an IC. Will be
> +      0 on PSE nodes with only a single output and at least 1 on nodes
> +      controlling several outputs.
> +    enum: [0, 1]
> +
> +required:
> +  - "#pse-cells"
> +
> +additionalProperties: true
> +
> +...
> -- 
> 2.30.2
> 
> 
