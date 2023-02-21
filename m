Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15D669D81C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 02:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232854AbjBUBoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 20:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232546AbjBUBoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 20:44:16 -0500
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1095AA5DC;
        Mon, 20 Feb 2023 17:44:16 -0800 (PST)
Received: by mail-oo1-f43.google.com with SMTP id e2-20020a4ac3c2000000b005246390f576so275742ooq.9;
        Mon, 20 Feb 2023 17:44:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=obXQNPEeBPokDvGJu4er6vxOLfUSEzMaaVG25umedX0=;
        b=PPE+2V89nP8Dvvod84xxhY5hT4FDkrM8rlR2n4jYdRKvoDdyxMOjhbe7QlXdS0hiX3
         Hpj/AipREABdnQjwYcYU/IaX5L6BFKah7AQJ/eMDk1UC4+nIWpCzyHIn4IZL878MewK9
         IiIS0Rf7WX7tUARGNFHaZj7ClhqzU/83vL6uXYhVfUPyux5o23EVOGcZEr2Ff46g4fh0
         VISV0wImpP4pQjOwYYV7snZR2Jh1mUSi0dBWyrQiWmXbMdwRQ0WOjpn92dcoOOrhLwv6
         g2lpDnoaxPkuPSjnbQKo/pcgdp51yuFNwPOZYAmiO3CNZu9ry6IDSv8j6Q+YOYHckDEg
         DuFg==
X-Gm-Message-State: AO0yUKVZhBFhyu7z0HLRfHgrIXRwNZSgG1lDJSUCOiVUW/EWs19v1+92
        rimfwrAElxhiufTFCpuooA==
X-Google-Smtp-Source: AK7set/2XaME5/HW0TjTBaTGKItdoJ57dYvFYFhKWzlH6m8BpboVf4yiMyY/tdD/QvCCZcHLrozBSw==
X-Received: by 2002:a4a:b4c9:0:b0:524:f47f:ec1 with SMTP id g9-20020a4ab4c9000000b00524f47f0ec1mr565747ooo.8.1676943855265;
        Mon, 20 Feb 2023 17:44:15 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id n14-20020a4a848e000000b00520339029f7sm757998oog.32.2023.02.20.17.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 17:44:14 -0800 (PST)
Received: (nullmailer pid 784765 invoked by uid 1000);
        Tue, 21 Feb 2023 01:44:13 -0000
Date:   Mon, 20 Feb 2023 19:44:13 -0600
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
Message-ID: <20230221014413.GA780723-robh@kernel.org>
References: <20230216013230.22978-1-ansuelsmth@gmail.com>
 <20230216013230.22978-12-ansuelsmth@gmail.com>
 <20230217230346.GA2217008-robh@kernel.org>
 <63f0084a.df0a0220.6220b.fb5a@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f0084a.df0a0220.6220b.fb5a@mx.google.com>
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

On Fri, Feb 17, 2023 at 06:58:39AM +0100, Christian Marangi wrote:
> On Fri, Feb 17, 2023 at 05:03:46PM -0600, Rob Herring wrote:
> > On Thu, Feb 16, 2023 at 02:32:28AM +0100, Christian Marangi wrote:
> > > Document the netdev trigger that makes the LED blink or turn on based on
> > > switch/phy events or an attached network interface.
> > 
> > NAK. What is netdev?
> 
> But netdev is a trigger, nothing new. Actually it was never documented.

Okay, please state that in the commit message.

> Is the linux,default-trigger getting deprecated? 

Not quite, but it shouldn't be used for anything tied to a device IMO. 

Rob
