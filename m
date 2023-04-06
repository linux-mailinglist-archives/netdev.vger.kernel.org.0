Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6C76D9932
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbjDFOLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239046AbjDFOKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:10:53 -0400
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81A1B441;
        Thu,  6 Apr 2023 07:10:20 -0700 (PDT)
Received: by mail-oi1-f176.google.com with SMTP id w13so17754062oik.2;
        Thu, 06 Apr 2023 07:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680790219;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nc5XJTaOIWq/+ghJJzs83WOcsawa6agTiIS3abEUxHk=;
        b=x8sssvE1fguDgTaa359uP6+nb6PL5dA/9tR89We4arWwIxw4PL//zqnK767J+5ckiE
         VAawNAP1jqBzz1gJJfINoqfz6WD+1phYvGVhdqyAWozBV2hGuXDKExZlLJkb7MQYsb4L
         iH4ENx0wBn/iOMcJEhzmfRWhjaGAMruy/xP8swITUMBjrmtGlOzJYuxsFhz+6/CEL11R
         TelINgsXL/wo/2gPN/XkIzC0mhvYoHau8jZfAlM+3sC5pUS424imm9o249J8qCHDJ493
         +OY70UGOOgbegW48b4gpl2L3Cr9Ony8Cpo0vO3MgsY+1tm61DGuwWYfZHyYrNv0FXEQg
         fznQ==
X-Gm-Message-State: AAQBX9dKY0xZp4nnkUUfw49KWRTyNWGn0yoYi5fzQp6a9jgK3VzfevtD
        UXNTvFYXTiN4Ofybr03MPA==
X-Google-Smtp-Source: AKy350bprKKRW6e63wfLCr4O11TNLUQS8A8vFXvQ7rnM+SgcwkuVgGwzG9QgCq5uzZdD14u6qXu/Sw==
X-Received: by 2002:a54:4585:0:b0:387:926e:35d3 with SMTP id z5-20020a544585000000b00387926e35d3mr3309739oib.20.1680790219545;
        Thu, 06 Apr 2023 07:10:19 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y9-20020a4a9809000000b005251f71250dsm566500ooi.37.2023.04.06.07.10.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 07:10:19 -0700 (PDT)
Received: (nullmailer pid 2976308 invoked by uid 1000);
        Thu, 06 Apr 2023 14:10:18 -0000
Date:   Thu, 6 Apr 2023 09:10:18 -0500
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
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 12/16] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
Message-ID: <20230406141018.GA2956156-robh@kernel.org>
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-13-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327141031.11904-13-ansuelsmth@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:10:27PM +0200, Christian Marangi wrote:
> Add LEDs definition example for qca8k Switch Family to describe how they
> should be defined for a correct usage.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 389892592aac..ad354864187a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -18,6 +18,8 @@ description:
>    PHY it is connected to. In this config, an internal mdio-bus is registered and
>    the MDIO master is used for communication. Mixed external and internal
>    mdio-bus configurations are not supported by the hardware.
> +  Each phy has at most 3 LEDs connected and can be declared
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

Isn't function-enumerator supposed to be unique within a given 
'function'?

> +                            default-state = "keep";
> +                        };
> +                    };
>                  };
>  
>                  port@2 {
> -- 
> 2.39.2
> 
