Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE8FC6C3CA1
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 22:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCUV2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 17:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCUV2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 17:28:02 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE86D3C3E;
        Tue, 21 Mar 2023 14:28:00 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id bm2so3327346oib.4;
        Tue, 21 Mar 2023 14:28:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679434080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuIPF2p5MBOAhgvZYwGUOCveU0K59ld+o3H/BrUHIXc=;
        b=jPn5XrnZWSZ3qzPbDmA5Evutc6kGyystnWLH4wUthWtN3tea0ssvOdPe24K1eTP50K
         TTjJuf6vaX0MHqGsG1edGzX4qLijYcEZLmmz2J0Jz4a9lXwwOsYUo9SWYcLwtzOXBxMW
         cNmB9s2V/kiVYSK9qObNB0g9Y+xH9NwviEcJjbAHugzDcN88rNLA5eMIIfL1CjI3OW9U
         nbel0+ijmSJRqhXw+eYyJST/yBcaffqhdI+4PoNyQvMV2PxOi+p/yh/Rbo0yN7q5Eeny
         UpqHV1117ENv+Lmo5Wzd25i4/VKAjctKq+zOzpZA/cePOicEdV+A/pfbrLOLEiCCkTpU
         mD0g==
X-Gm-Message-State: AO0yUKVzeMnQ2zu73FOcrfKmRxf6buDiRn9wMEVqPxLWiqA0HfbGIcmf
        cyZF0O18YKPaHIXpWhcwNA==
X-Google-Smtp-Source: AK7set/faoMGqVJ+QTJCoH7na00DNWHkcm9XMi+/7B7CQTvY9i7F6tP/AT297tYCXkj3ApwrgJrMzg==
X-Received: by 2002:a05:6808:8c6:b0:384:356a:a26f with SMTP id k6-20020a05680808c600b00384356aa26fmr256794oij.51.1679434078727;
        Tue, 21 Mar 2023 14:27:58 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id v184-20020acadec1000000b003871471f894sm1753856oig.27.2023.03.21.14.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 14:27:57 -0700 (PDT)
Received: (nullmailer pid 1643739 invoked by uid 1000);
        Tue, 21 Mar 2023 21:27:56 -0000
Date:   Tue, 21 Mar 2023 16:27:56 -0500
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 11/15] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <20230321212756.GA1635435-robh@kernel.org>
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230319191814.22067-12-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.8 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 08:18:10PM +0100, Christian Marangi wrote:
> Add LEDs definition example for qca8k Switch Family to describe how they
> should be defined for a correct usage.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 389892592aac..2e9c14af0223 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -18,6 +18,8 @@ description:
>    PHY it is connected to. In this config, an internal mdio-bus is registered and
>    the MDIO master is used for communication. Mixed external and internal
>    mdio-bus configurations are not supported by the hardware.
> +  Each phy has at least 3 LEDs connected and can be declared
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
> @@ -226,6 +229,27 @@ examples:
>                      label = "lan1";
>                      phy-mode = "internal";
>                      phy-handle = <&internal_phy_port1>;
> +
> +                    leds {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        led@0 {
> +                            reg = <0>;

Once 'unevaluatedProperties' is properly implemented in the schema, this 
will be a warning. You didn't define 'reg' in the schema.

> +                            color = <LED_COLOR_ID_WHITE>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            default-state = "keep";
> +                        };
> +
> +                        led@1 {
> +                            reg = <1>;
> +                            color = <LED_COLOR_ID_AMBER>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            default-state = "keep";
> +                        };
> +                    };
>                  };
>  
>                  port@2 {
> -- 
> 2.39.2
> 
