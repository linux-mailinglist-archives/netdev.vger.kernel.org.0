Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE5A64AE45
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 04:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiLMDex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 22:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiLMDew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 22:34:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E54AE8B;
        Mon, 12 Dec 2022 19:34:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB12A612CB;
        Tue, 13 Dec 2022 03:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D242CC433EF;
        Tue, 13 Dec 2022 03:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670902490;
        bh=U81sidzaQaJy/rxfn5PHUydwwpgK0dI201eoQyqbyCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mdw5ed2DjmHNGbFitiAgdH7uuiRirU07ByfHaJUafc2EhurrydQC8e+66t0L5Y+9x
         g+6Fi4aFNL3y+hYpLMo92y0p/CJPpxl9g4pLt/0calOFSGrWH/ysNdkLmYuuGOOXo7
         xB+cNcB7BYPJGJENlYxkW/dRecKJ2R2Tb03ZCiZ/HoiIJyIw3a/6HYkwDqHIAdzFw7
         +8HErc9Poiyty2YGk1v71k2vZapexynaDfa1uYCqN5/E/LN5E7F6WxMmYQoGLLrOW9
         oQjB3oq4YOlT7NcqE7CVYdrOWQUQ0GX/lXP8FnEHu7q0viASuHeeOlnYRQzNXcg0Th
         W08Uo/ufavtQw==
Date:   Mon, 12 Dec 2022 19:34:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
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
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v5 net-next 00/10] dt-binding preparation for ocelot
 switches
Message-ID: <20221212193447.0a69325e@kernel.org>
In-Reply-To: <Y5d67SPMc/YCr0Rq@COLIN-DESKTOP1.localdomain>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
        <20221212102958.0948b360@kernel.org>
        <Y5d67SPMc/YCr0Rq@COLIN-DESKTOP1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Dec 2022 11:03:09 -0800 Colin Foster wrote:
> > A lot of carried over review tags here, so please let me know if
> > there's anything that needs to be reviewed here, otherwise I'd like=20
> > to merge the series for 6.2 by the end of the day. =20
>=20
> I just responded to patch 4, which has a small (?) outstanding issue /
> discussion. I asked Rob and Ar=C4=B1n=C3=A7's opinions as to whether it s=
hould
> hold up this series. Everything else is good to go, as far as I
> understand.

No reply :( Since this is "just" DT bindings (as in shouldn't
functionally break anything) - if Rob gives us a green light
we can still pull it into the mid-merge window follow up.
But I'll drop it from pw for now so it doesn't distract us.
