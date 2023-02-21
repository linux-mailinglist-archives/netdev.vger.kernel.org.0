Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C169D826
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjBUBsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjBUBsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:48:30 -0500
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4099EDA;
        Mon, 20 Feb 2023 17:48:29 -0800 (PST)
Received: by mail-ot1-f51.google.com with SMTP id bh19-20020a056830381300b00690bf2011b2so532580otb.6;
        Mon, 20 Feb 2023 17:48:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ccmohlnNuK61Zq2Pm+AusM0j8iaM96OwWbVNxMu3hkQ=;
        b=yTDAcaW99eOWSlDGU/HK3rR57Ywc8D5FxsfXpIO5zP38/j0JFDrYyX9LsOYyxat1k9
         CGZF9iaNcm4fl1i8dSyNXMhtcNz9UzFOsLms2D7CBHtvT7Y7OZd12mdp/Zv9e+DtYeY7
         V6MwhIOEpwPTrmrnRp9/PHGf/Lp4602S3OngUQcXwyZ8YAC5QxkILLJLxLE3Iw1+AE64
         fJ/67xaICvB2BqrHVJAreq25JEVaPNsjYNphW8e5wnLQ1EXkf2Kx6SVuUS8t5Kc7hxk+
         3qtn6mBecjRyhlHE7Rompb4rfEH9qrhjHGQzDXjRTK5nr52LDAHNY3b2r0+gFNP6iK3X
         Ic3Q==
X-Gm-Message-State: AO0yUKX5URc66REuplorlBbsS3irp9E5D415xRfJ3y88nyPcoHTDr6sP
        8HRAS3TbWaeLVGz07yCAng==
X-Google-Smtp-Source: AK7set9YtYnryjeiLQnpZZHbAsYom5BpzmXxxi7u+CjIiNWfvZSix0P7dzN0AkCl9ByBwf/Vbv+A/w==
X-Received: by 2002:a05:6830:2a11:b0:693:bdd8:62a9 with SMTP id y17-20020a0568302a1100b00693bdd862a9mr764204otu.7.1676944108672;
        Mon, 20 Feb 2023 17:48:28 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id l11-20020a9d7a8b000000b0068bd5af9b82sm5597945otn.43.2023.02.20.17.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:48:28 -0800 (PST)
Received: (nullmailer pid 790312 invoked by uid 1000);
        Tue, 21 Feb 2023 01:48:27 -0000
Date:   Mon, 20 Feb 2023 19:48:27 -0600
From:   Rob Herring <robh@kernel.org>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH v8 13/13] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <20230221014827.GA784986-robh@kernel.org>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-14-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216013230.22978-14-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:32:30AM +0100, Christian Marangi wrote:
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
> index 389892592aac..ba3821364039 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -18,6 +18,8 @@ description:
>    PHY it is connected to. In this config, an internal mdio-bus is registered and
>    the MDIO master is used for communication. Mixed external and internal
>    mdio-bus configurations are not supported by the hardware.
> +  Each phy have at least 3 LEDs connected and can be declared
> +  using the standard LEDs structure.
>  
>  properties:
>    compatible:
> @@ -117,6 +119,7 @@ unevaluatedProperties: false
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/leds/common.h>
>  
>      mdio {
>          #address-cells = <1>;
> @@ -276,6 +279,27 @@ examples:
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

Wouldn't the default for an ethernet phy controlled LED always be 
"netdev"? If a PHY has LED nodes, then just always set it to "netdev" 
unless something else is selected.

Rob
