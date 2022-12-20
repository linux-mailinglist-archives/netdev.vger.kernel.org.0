Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99E6525AE
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 18:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiLTRkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 12:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiLTRkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 12:40:02 -0500
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8711EFF1;
        Tue, 20 Dec 2022 09:40:01 -0800 (PST)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-144b21f5e5fso16178680fac.12;
        Tue, 20 Dec 2022 09:40:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+uqKNupLom5HOX393/X5dcMBDb877yjyv1k5TVvfHA=;
        b=dYy9G5znw3qUvh2+VZkZceDeq9Lw8DSJHuPCnucxj3I2yFDJGt3+U4uuckwosxmSci
         871zqwT91uuGI6q4UVfUGnloPMvMAessZtb4HxRUGtijSN1lfnOMl3uSqt6f9yBqan0J
         bStGHJZa4jcHF9CHKQwFbvb9aIVyUblAezMfipzFV1bXMorx7lV8kYzKDY9rSCrwFes0
         0vvr4xWIujVKyMzS/tgD2inoTrAXFmgluLSn9FleU3HkyVTRZZww0Ba9dahJks71n1dX
         FgRJ7DxlIt1TnhwRhPh8RK1VnauNMxm27IwTK4QFSIwtZmPCbaUFhlqJGQr6r32L3Pvv
         rcVw==
X-Gm-Message-State: ANoB5pkryApv9g3LiySo4iYTHevuXf2iSg7z/jXxD4YkqGGUGMFf+PNE
        0KJHXz7bOZt8QAFXUDSSkw==
X-Google-Smtp-Source: AA0mqf76SVmlQ2s3MNPaz5jKJiFUnELkYDbfYdBJK/nJs4YnkQox5rSMMXsrtk/xEbpO8oFir2KjVQ==
X-Received: by 2002:a05:6870:2dc8:b0:13b:9ee:aa19 with SMTP id op8-20020a0568702dc800b0013b09eeaa19mr20163092oab.55.1671558000766;
        Tue, 20 Dec 2022 09:40:00 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id er34-20020a056870c8a200b0014866eb34cesm6216065oab.48.2022.12.20.09.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 09:39:59 -0800 (PST)
Received: (nullmailer pid 796697 invoked by uid 1000);
        Tue, 20 Dec 2022 17:39:58 -0000
Date:   Tue, 20 Dec 2022 11:39:58 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <20221220173958.GA784285-robh@kernel.org>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
 <20221214235438.30271-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235438.30271-12-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:54:38AM +0100, Christian Marangi wrote:
> Add LEDs definition example for qca8k using the offload trigger as the
> default trigger and add all the supported offload triggers by the
> switch.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 978162df51f7..4090cf65c41c 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -65,6 +65,8 @@ properties:
>                   internal mdio access is used.
>                   With the legacy mapping the reg corresponding to the internal
>                   mdio is the switch reg with an offset of -1.
> +                 Each phy have at least 3 LEDs connected and can be declared
> +                 using the standard LEDs structure.
>  
>  patternProperties:
>    "^(ethernet-)?ports$":
> @@ -202,6 +204,7 @@ examples:
>      };
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/leds/common.h>
>  
>      mdio {
>          #address-cells = <1>;
> @@ -284,6 +287,27 @@ examples:
>  
>                  internal_phy_port1: ethernet-phy@0 {
>                      reg = <0>;
> +
> +                    leds {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        led@0 {
> +                            reg = <0>;
> +                            color = <LED_COLOR_ID_WHITE>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            linux,default-trigger = "netdev";

'function' should replace this. Don't encourage more users. 

Also, 'netdev' is not documented which leaves me wondering why there's 
no warning? Either this patch didn't apply or there's a problem in the 
schema that's not checking this node.

> +                        };
> +
> +                        led@1 {
> +                            reg = <1>;
> +                            color = <LED_COLOR_ID_AMBER>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;

Typo? These are supposed to be unique. Can't you use 'reg' in your case?


> +                            linux,default-trigger = "netdev";
> +                        };
> +                    };
>                  };
>  
>                  internal_phy_port2: ethernet-phy@1 {
> -- 
> 2.37.2
> 
> 
