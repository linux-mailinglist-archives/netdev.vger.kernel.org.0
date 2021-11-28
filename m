Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5522460B01
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 00:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359449AbhK1XRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:17:20 -0500
Received: from mail-ot1-f54.google.com ([209.85.210.54]:45008 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbhK1XPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 18:15:19 -0500
Received: by mail-ot1-f54.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso22910749otj.11;
        Sun, 28 Nov 2021 15:12:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JLhPhE/vqeyhzLIFVNAra68Ko84ibz16Pik9DMMX/dw=;
        b=bdWWSWIJsDZLuaU2J1kSGM/iD7Ik6e81jU38OOHq1GIr+OZEV6qBqhJLURFlpuUHED
         jDP/+1CqlLzhvFQEjcLrCbosD5/5TnHIwPTfZUbL0G99IheTZOCEyxhtnKjqYkuZehmg
         YwXSuyM4/JhTN7UYjlz+tFqTtzX9eCIvz94sGsDb3fgjrtobnIjo/KupfQaK+DRaM/mB
         BvWiGY30W36Dysty8T3OeBteyn/H8V2QqS4CSae+GhURRPWthDWpS1VPeJbAAbJzizgr
         AoE/wHsmg56TCJSWLP08on7GWcfSf3Ni8DkfRlTNJNpCdOmG3QHUp4y1hxNl/NsUAVz6
         MfDA==
X-Gm-Message-State: AOAM5332NYKK9mVhgSKK/5O8zwzzhMnVKpH2UyEWE8UY7H7Ha2o9pZzg
        sa/pfkPpnMsveunCXLvjUQ==
X-Google-Smtp-Source: ABdhPJxnoaCUiUDnWSQD8mFyahvMWj6jz9E+kBryiWl4VWlE+blEDR0rRJf4SpaDjOSW8IgqQXVboA==
X-Received: by 2002:a9d:6b87:: with SMTP id b7mr42246123otq.204.1638141122497;
        Sun, 28 Nov 2021 15:12:02 -0800 (PST)
Received: from robh.at.kernel.org ([2607:fb90:5fe7:4487:4f99:dbc0:75d1:3e27])
        by smtp.gmail.com with ESMTPSA id t18sm2346542ott.2.2021.11.28.15.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 15:12:01 -0800 (PST)
Received: (nullmailer pid 2790419 invoked by uid 1000);
        Sun, 28 Nov 2021 23:11:57 -0000
Date:   Sun, 28 Nov 2021 17:11:57 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH v5 8/8] dt-bindings: net: dsa: qca8k: add LEDs definition
 example
Message-ID: <YaQMvSEEFu2AW1Pk@robh.at.kernel.org>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
 <20211112153557.26941-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112153557.26941-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 04:35:57PM +0100, Ansuel Smith wrote:
> Add LEDs definition example for qca8k using the offload trigger as the
> default trigger and add all the supported offload triggers by the
> switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> index 48de0ace265d..106d95adc1e8 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
> @@ -64,6 +64,8 @@ properties:
>                   internal mdio access is used.
>                   With the legacy mapping the reg corresponding to the internal
>                   mdio is the switch reg with an offset of -1.
> +                 Each phy have at least 3 LEDs connected and can be declared
> +                 using the standard LEDs structure.

at most 3? As the example only has 2...

>  
>      properties:
>        '#address-cells':
> @@ -340,6 +342,24 @@ examples:
>  
>                  internal_phy_port1: ethernet-phy@0 {
>                      reg = <0>;
> +
> +                    leds {
> +                        led@0 {
> +                            reg = <0>;
> +                            color = <LED_COLOR_ID_WHITE>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;
> +                            linux,default-trigger = "offload-phy-activity";

function is intended to replace 'linux,default-trigger'.

> +                        };
> +
> +                        led@1 {
> +                            reg = <1>;
> +                            color = <LED_COLOR_ID_AMBER>;
> +                            function = LED_FUNCTION_LAN;
> +                            function-enumerator = <1>;

Should be a different value than led@0?

> +                            linux,default-trigger = "offload-phy-activity";
> +                        };
> +                    };
>                  };
>  
>                  internal_phy_port2: ethernet-phy@1 {
> -- 
> 2.32.0
> 
> 
