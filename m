Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A56580C35
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbiGZHMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbiGZHMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:12:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56B4275FA
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:12:32 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658819551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDclq0CgJf4KeboJhcZ6ZgrJ36PCcGyE6EiJbo/HOh0=;
        b=eP+h2zxs34pe92+OfiXnOCykCYZtv0qKCqXZjOdg2spwGTSJTTJHi09zdJ8QPkfUAWqg2U
        orJXfSBm0edXWX5jU1kgHTjEOn8jpExvWGsJ0daPjsCWhCFM59wp1KxPv/QwCTCb8yJJjz
        wMqYF2uEPqEu2vCOm8JsTaouhM7pRTiozLgNoKJE11tLUbQZOXg/B7qPVyfnJWZQrI9LID
        CQeJEGgktozT7tT5BAIEeIFry0wuLRbtMOKn3j64APASfc0ROQUTlCWSbw/Fc3KCRZeVtB
        cpA8R4MFdG/5qoF0SBbknRQRlA2yoS3Kqig6M7kFy6e8q+p7fK2LhtmB1HwYxQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658819551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VDclq0CgJf4KeboJhcZ6ZgrJ36PCcGyE6EiJbo/HOh0=;
        b=7Hm5Kth2YSMwUurpral83idQGgdgG4UzrSp6HUp7L//g+Byir1cURnT4zEyKuKV8PcipcJ
        p84//r/1Zt4gAgDw==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
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
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
In-Reply-To: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
Date:   Tue, 26 Jul 2022 09:12:28 +0200
Message-ID: <87y1wgfiub.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Sat Jul 23 2022, Vladimir Oltean wrote:
> hellcreek
> ~~~~~~~~~
>
>     compatible strings:
>     - hirschmann,hellcreek-de1soc-r1
>
>     No occurrence in mainline device trees, we don't know.
>
>     Verdict: opt out of validation.

The device tree lacks phy-mode and fixed link. Anyway, I'm going to fix
the downstream dts now.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLfk90THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgnZnD/9hMgGbeCya+t0SaIvWlBrN087YLzdE
eoYZy3CKpsLUJgIFFU9PQbhs2szNynD11MhKuKHTeyyCiK9ElKqjvtbdaj8/KbJW
hqcbYp1vzJbC/HBN73Htr4FkT0yPODU9g8WMOu7s1Ro8cUTupwftCTi8qy99D8Fb
x1Q0HkSJ9cyi5NQP6EWEYI2Fm4O2VoKoYCvfYLQD8kdhi/8k6DaR95SbjL851SoD
fTIuJgG6Sez4HTbyoLFdwR+Z9E5yZoTKOgKLOQlsdPFbjQl5JdkR5BJ59Wkq4Arf
mcOSaDs2y6tLebiDHrU1smubVMEo2ezC3EL0nLb0PU46yDF4oYQ+ORfiiAY8oIOr
6FSA23AzTl/zooAP5FxG2+O+lQ+BAnK11kanNX5OoDmKWH6WpF+yp9+RDSel6246
g2BTYAwWpjviRXgB4rTJhO3xVakNVGyLt97KLN8SY1REqNArYFLbFHnzdWjF1gdo
+VQOSd2NzQVuYQHF1pSS+b2kuFmrHfg9Cia2G1CricFLvbwoVY/b8lXKqzMBLede
zcbl6NLR0VMM7abqP9nMi8y2dLaRYymqwymN/qgY9vmsfK5LvHTRe92Vj5MaBQ+C
rd1AevIYLpRIvSWxILayKOYzMKxY7FwtwTCLNB8lC87v4nqfYRWQSqjx+b6rG7QQ
yBr1wWEZBI1goQ==
=7kM2
-----END PGP SIGNATURE-----
--=-=-=--
