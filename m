Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA62586E7B
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiHAQXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 12:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiHAQXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 12:23:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC21E1835C;
        Mon,  1 Aug 2022 09:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8220460EE6;
        Mon,  1 Aug 2022 16:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EF9C433C1;
        Mon,  1 Aug 2022 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659370978;
        bh=uJxbC9lFZcULQRmAJwk4jNToadVBCPsNxrzs+F17Yf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCwV9sClJDQqs9U577arTBiLzpUD8DxFqMLeAIXv0Am7gpn8Qlj6rUfChgnCmdg4m
         qvzulf9C6y0rdFF6N0U8yOR8E6G1of2ED6/6Tf2hx204V+FhdbYlFtLCznH33BJeHC
         6EV/61OWM28EcbeWfT6FKAJU6ubvkQNjeQjS8TnHvDJ4ShAPt49bfN4h7V7dByHDBI
         iyxJkbxOEILCaW2/gnxIHleBb1QXvjujPV2G5I906g/AhJpM6tBbTDAwv83CLUNgNE
         mCgwZ3z+OaWCQcgYGNYa7WSr9AxNPqtjlU04GGPj/aYXTwz2VZvHw3l0c5fL4hZajc
         ctiooiWHXmpSQ==
Date:   Mon, 1 Aug 2022 09:22:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings
 required for CPU/DSA ports
Message-ID: <20220801092256.3e05c12e@kernel.org>
In-Reply-To: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
References: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Jul 2022 18:00:06 +0300 Vladimir Oltean wrote:
> It is desirable that new DSA drivers are written to expect that all
> their ports register with phylink, and not rely on the DSA core's
> workarounds to skip this process.
> 
> To that end, DSA is being changed to warn existing drivers when such DT
> blobs are in use:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220729132119.1191227-1-vladimir.oltean@nxp.com/
> 
> Introduce another layer of validation in the DSA DT schema, and assert
> that CPU and DSA ports must have phylink-related properties present.
> 
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I've sent this patch separately because at least right now I don't have
> a reason to resend the other 4 patches linked above, and this has no
> dependency on those.

If I'm reading

https://lore.kernel.org/r/CAL_JsqKZ6cEny_xD8LUMQUR6AQ0q7JKZMmdP-9MUZxzzNxZ3JQ@mail.gmail.com/

correctly - the warnings are expected but there needs to be a change 
to properties, so CR? (FWIW I'd lean towards allowing it still, even
tho net-next got closed. Assuming v2 can get posted and acked today.)
