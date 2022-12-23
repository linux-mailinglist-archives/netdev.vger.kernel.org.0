Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E35654A94
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 02:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiLWBzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 20:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiLWBzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 20:55:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B3218BD;
        Thu, 22 Dec 2022 17:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3F0B9CE1C2B;
        Fri, 23 Dec 2022 01:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E47C433D2;
        Fri, 23 Dec 2022 01:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671760512;
        bh=7+FMQzhkdUuBY613R/cYs3AH1Nhez93yWDo3mNZV11k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UEUyNKx2i1LZAVFYds1BlBgyPm/Ik7cpS8U7LfeCdyg6rN34F2MxFbpWcB99oJhWY
         z3PCM+xeXJc8le1cBwEWvQgHqE+zizdVCc4EUggVJTBdAm0up55elIPXsA9sD3udvn
         egfjkJqY68Ty9hr//Cwd/0R2imFrjdY7DYeYlQVxFgF9Q0OUNI4ahLOXrdlwppZIB6
         IGhXVuGjgxPiqZ+dXPaQBHuwYPZJmwzRe0TKQx92R0ZBjDHgjG9XG1UG2kB1/5SaK9
         lLwTXBmiVtso4HCVs5oQGkXY15JlAV0Smt/mRzag40XxsQXH3LS8gDdBUvVpwnDEtY
         scu31Ntzcd6dQ==
Date:   Thu, 22 Dec 2022 17:55:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?UTF-8?B?xaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 04/10] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221222175510.7ca0b563@kernel.org>
In-Reply-To: <Y6S5Ple5SURq0QSU@colin-ia-desktop>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
        <20221210033033.662553-5-colin.foster@in-advantage.com>
        <1df417b5-a924-33d4-a302-eb526f7124b4@arinc9.com>
        <Y5TJw+zcEDf2ItZ5@euler>
        <c1e40b58-4459-2929-64f3-3e20f36f6947@arinc9.com>
        <20221212165147.GA1092706-robh@kernel.org>
        <Y5d5F9IODF4xhcps@COLIN-DESKTOP1.localdomain>
        <Y6S5Ple5SURq0QSU@colin-ia-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Dec 2022 12:08:30 -0800 Colin Foster wrote:
> Heads up on my plan for this. I plan to re-submit this on Monday after
> the merge window with the change where I move the $ref: dsa-port.yaml#
> to outside the allOf: section, and remove the object type as the above
> code suggests. Hopefully that's the right step to take.

FWIW in case you mean Mon, Dec 26th and net-next -- we extended 
the period of net-next being closed until Jan:
https://lore.kernel.org/all/20221215092531.133ce653@kernel.org/
