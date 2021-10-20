Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8C434D5F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhJTOXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:23:46 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:34782 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhJTOXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 10:23:45 -0400
Received: by mail-ot1-f41.google.com with SMTP id g62-20020a9d2dc4000000b0054752cfbc59so6317946otb.1;
        Wed, 20 Oct 2021 07:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XG3RAyJEhy1T5+7Mzfxe89VCAx3Ob+1lXbbGvhvmLrg=;
        b=K8LOnyN8ODE+Z3Ny8WHYXvAWtmUtIgxFpfPRqpVB/JvEB//9ODqCS7UhS/c1mwcbfD
         5j6FdJYpH7AuwmSvNELMt5AaLdwaDLuls5h1U9ce4nehyMq4LMVWM0nMWZNvAeyUbLSj
         vsTX68d51ifFCWypPEmLiyBudpH67YM355HvbVsHnKSh0hau/kquvUFWxRjgPm+4cFNH
         BaG6I6hFf0zj3UBe+AXXbnVec7Trs+/MZSafk37COIMu8uTFlKJ+gRG+0dDxkEmeHjYh
         Q3NLRBGXBxVg5PiJKJi3Kz0AAjiO7e25cN2LksIbgWREuqHaCIqRdQoxPCsvTaTJuDbt
         4v9w==
X-Gm-Message-State: AOAM530RCkDYYtC/VTOATHHLkOS9HlisJgVjF0mIiL4pRztgi3APTCaR
        udwQY0vESWL5rGLJRgqK5A==
X-Google-Smtp-Source: ABdhPJx4od9dszhBlHZ5LNPRg1jYyAj0rc84Zjz3OBzNi2cUC4Fohy/HjYC8gvuMpM1STyKm4mqKHg==
X-Received: by 2002:a9d:728d:: with SMTP id t13mr163090otj.66.1634739689320;
        Wed, 20 Oct 2021 07:21:29 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x8sm494492otg.31.2021.10.20.07.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 07:21:28 -0700 (PDT)
Received: (nullmailer pid 2301836 invoked by uid 1000);
        Wed, 20 Oct 2021 14:21:27 -0000
Date:   Wed, 20 Oct 2021 09:21:27 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Sebastian Reichel <sre@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-renesas-soc@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        David Lechner <david@lechnology.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/3] dt-bindings: net: wireless: ti,wlcore: Convert to
 json-schema
Message-ID: <YXAl5zLeFP3lxs0S@robh.at.kernel.org>
References: <cover.1634646975.git.geert+renesas@glider.be>
 <23a2fbc46255a988e5d36f6c14abb7130480d200.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a2fbc46255a988e5d36f6c14abb7130480d200.1634646975.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 14:43:12 +0200, Geert Uytterhoeven wrote:
> The Texas Instruments Wilink 6/7/8 (wl12xx/wl18xx) Wireless LAN
> Controllers can be connected via SPI or via SDIO.
> Convert the two Device Tree binding documents to json-schema, and merge
> them into a single document.
> 
> Add missing ti,wl1285 compatible value.
> Add missing interrupt-names property.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>   - The wlcore driver is marked orphan in MAINTAINERS.  Both Tony and
>     Russell made recent bugfixes, and my not-so-random coin picked Tony
>     as a suitable maintainer.  Please scream if not appropriate.
>   - How to express if a property is required when connected to a
>     specific bus type?
> ---
>  .../devicetree/bindings/net/ti-bluetooth.txt  |   2 +-
>  .../bindings/net/wireless/ti,wlcore,spi.txt   |  57 --------
>  .../bindings/net/wireless/ti,wlcore.txt       |  45 ------
>  .../bindings/net/wireless/ti,wlcore.yaml      | 134 ++++++++++++++++++
>  arch/arm/boot/dts/omap3-gta04a5.dts           |   2 +-
>  5 files changed, 136 insertions(+), 104 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
>  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
> 

Applied, thanks!
