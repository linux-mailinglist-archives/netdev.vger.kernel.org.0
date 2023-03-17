Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83FB6BF3B1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 22:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjCQVQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 17:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCQVQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 17:16:27 -0400
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD1469CFB;
        Fri, 17 Mar 2023 14:16:26 -0700 (PDT)
Received: by mail-il1-f175.google.com with SMTP id i19so3409878ila.10;
        Fri, 17 Mar 2023 14:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679087785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8EReBm37JWyJO8L1kIPOgKUl1U5FCQclLtDZ/qXfAs=;
        b=T9OD8EDmmspN5qP6O0f9aqn23exd9IXa16FNFPu9CWKpEB6ZJdDN2SZYeKENQQG5Ef
         fWY9t1SLe/M/Z9CZAAnsfuUSOSp7Oqquo7QN8gsMKC1U1BPWnun6YWISwZMWrRAyAoPW
         mTW3MBSi6+9pZFblEhNr39Q672Uq9tn9FiIx1+XK1kbXENjlVrDX7WV1UcC0TilOPZF8
         qqOrikKJnz8uyFGtl9f74h5ZcphO5DVL6kc6u4PcK6Yd4Q9/J+a5x98oqimeXLEeX23p
         ubUZ6cloyeRehh8OJ9jKEWSTMsR4XvQkX8VSejJH11HjBrZp9cOzv9cA85blkSoMBB8N
         N8gw==
X-Gm-Message-State: AO0yUKWiwyBiUE9fqyYObhX5SfGwCBqeLxjAVE9YReg2bSWzqA07UcoL
        bqLPWKVPzdczxfVfYTLtksl5rKLPBA==
X-Google-Smtp-Source: AK7set+44jDdZQnQ5gK5eSj07BZtp0lA+8sBDtriRGbUAZiENzi39wMOmMGgf61Ip66/ii32uJBABg==
X-Received: by 2002:a92:cc08:0:b0:317:99b9:3d1c with SMTP id s8-20020a92cc08000000b0031799b93d1cmr12777ilp.26.1679087785257;
        Fri, 17 Mar 2023 14:16:25 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id c7-20020a929407000000b003232362a4c2sm879970ili.8.2023.03.17.14.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 14:16:23 -0700 (PDT)
Received: (nullmailer pid 2819364 invoked by uid 1000);
        Fri, 17 Mar 2023 21:16:21 -0000
Date:   Fri, 17 Mar 2023 16:16:21 -0500
From:   Rob Herring <robh@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] p54spi: convert to devicetree
Message-ID: <20230317211621.GA2814846-robh@kernel.org>
References: <20230314163201.955689-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314163201.955689-1-arnd@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:30:56PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The Prism54 SPI driver hardcodes GPIO numbers and expects users to
> pass them as module parameters, apparently a relic from its life as a
> staging driver. This works because there is only one user, the Nokia
> N8x0 tablet.
> 
> Convert this to the gpio descriptor interface and move the gpio
> line information into devicetree to improve this and simplify the
> code at the same time.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> As I don't have an N8x0, this is completely untested.
> 
> I listed the driver authors (Johannes and Christian) as the maintainers
> of the binding document, but I don't know if they actually have this
> hardware. It might be better to list someone who is actually using it.
> 
> Among the various chip identifications, I wasn't sure which one to
> use for the compatible string and the name of the binding document.
> I picked st,stlc4560 as that was cited as the version in the N800
> on multiple websites.
> ---
>  .../bindings/net/wireless/st,stlc45xx.yaml    | 64 +++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  arch/arm/boot/dts/omap2.dtsi                  |  4 ++
>  arch/arm/boot/dts/omap2420-n8x0-common.dtsi   | 12 ++++
>  arch/arm/mach-omap2/board-n8x0.c              | 18 -----
>  drivers/net/wireless/intersil/p54/p54spi.c    | 69 +++++++------------
>  drivers/net/wireless/intersil/p54/p54spi.h    |  3 +
>  7 files changed, 109 insertions(+), 62 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/st,stlc45xx.yaml

Binding looks fine, but I assume you'll split this into at least 3 
patches?

Rob
