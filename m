Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1074869B620
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 00:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjBQXDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 18:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBQXDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 18:03:49 -0500
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6614F42BE5;
        Fri, 17 Feb 2023 15:03:48 -0800 (PST)
Received: by mail-oi1-f176.google.com with SMTP id i4so2567205oiy.4;
        Fri, 17 Feb 2023 15:03:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aLSLgiQSCVvjkCIXz0HVyuRV1cGMyEHUbSRIVO4Q6fk=;
        b=zckX/gUD8Zwmih0E2FsM6rp+I8sBqw0TFV5vjAJCLaesA8ElwtomhKCMZQ4Kc2R7cV
         7HxWtseWkOja2e/1XULar3ewfD37oXC6dBttntaIo3Q/OPKdTxgBT8+KaLEttXpcXdVx
         edVkwH7P8pLjhDNWVBsJq0/s3BHBc8k8muYsaVFvwXPb3wJfPDBLFSRZf1OznDTt7V31
         gWF/Ryl2jtPvJcEmqZZwuBeepRURqgsISJwOQTX+3HDF3lvwM2WjCBFpCOhLO3ISCfG8
         qVEPCRyPg6v9ZxdXhzEajOHXB80JjsMREpHPjOkSe+7nK9+53P0KUts+drlrEQGbwH4k
         vZig==
X-Gm-Message-State: AO0yUKVS0wLiGXD5hJdsQDKN3SUH50Rei7Ko1tvo+ABZsnpe+q47rkna
        m4KIarY009tOhfsFIW2gIX0XZguP1A==
X-Google-Smtp-Source: AK7set/0/4JrsjWas4uVRGEoFcvaUWkmE547q5kQSBLJyFr90e8HYEdwMd78yhQfUNqXTDvnFXzuXg==
X-Received: by 2002:a05:6808:7cd:b0:360:e1dc:8b18 with SMTP id f13-20020a05680807cd00b00360e1dc8b18mr1094554oij.20.1676675027590;
        Fri, 17 Feb 2023 15:03:47 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m1-20020a05680806c100b0037d7c3cfac7sm2320897oih.15.2023.02.17.15.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 15:03:47 -0800 (PST)
Received: (nullmailer pid 2227917 invoked by uid 1000);
        Fri, 17 Feb 2023 23:03:46 -0000
Date:   Fri, 17 Feb 2023 17:03:46 -0600
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
Subject: Re: [PATCH v8 11/13] dt-bindings: leds: Document netdev trigger
Message-ID: <20230217230346.GA2217008-robh@kernel.org>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-12-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216013230.22978-12-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 02:32:28AM +0100, Christian Marangi wrote:
> Document the netdev trigger that makes the LED blink or turn on based on
> switch/phy events or an attached network interface.

NAK. What is netdev?

Don't add new linux,default-trigger entries either. We have better ways 
to define trigger sources, namely 'trigger-sources'.

> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/leds/common.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/leds/common.yaml b/Documentation/devicetree/bindings/leds/common.yaml
> index d34bb58c0037..6e016415a4d8 100644
> --- a/Documentation/devicetree/bindings/leds/common.yaml
> +++ b/Documentation/devicetree/bindings/leds/common.yaml
> @@ -98,6 +98,8 @@ properties:
>              # LED alters the brightness for the specified duration with one software
>              # timer (requires "led-pattern" property)
>            - pattern
> +            # LED blink and turns on based on netdev events
> +          - netdev
>        - pattern: "^cpu[0-9]*$"
>        - pattern: "^hci[0-9]+-power$"
>          # LED is triggered by Bluetooth activity
> -- 
> 2.38.1
> 
