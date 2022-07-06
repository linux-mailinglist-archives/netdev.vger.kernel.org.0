Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E391569093
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 19:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbiGFRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 13:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbiGFRWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 13:22:47 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF0B2A724
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 10:22:46 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1657128164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+kZ9exZQ0XB530uYV3U/seLEV8Km4T11LMvCBDan7GA=;
        b=Lvm+sjXgEIRRm28h23L50yG11bF2QkieGGDclalRX2UEi2FosdAeKVNGRf5+iOvuFV2zoK
        n9yQlSWKEAbqIiTmojOeUA3NpyUDuoK6scpFu/nnAiAOPhPbCmiO+hzoi+xkrkhcvLOHev
        5AwBK7RQSwGCzJ/HfdcTVHokf/H387kd5qg6aUyREQPk5SFkccOqvh/y6UqOOQbCPg916d
        WD9OCiayGBnak+XoxB4XOSDGDI1eCqsZwE2949KtLKHnq3yw1rF8W6rZzcVbYTFGLmmlMb
        8kQXqFJRGW+MbN5QpKieNV38th2CsLdOKkLQjjBGL1Ez5JZbLH+cpsk3G9D8jA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1657128164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+kZ9exZQ0XB530uYV3U/seLEV8Km4T11LMvCBDan7GA=;
        b=HDtlQ/T8dmQJvJLxMiCaaQA0NESh5ZITwLEvZXWeUnWXYbGeJfqpj4dwYXctmSf+CbhWcw
        ngwBkgY86BEVD+Cg==
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
In-Reply-To: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
Date:   Wed, 06 Jul 2022 19:22:41 +0200
Message-ID: <877d4q9mvy.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Russell,

On Tue Jul 05 2022, Russell King wrote:
> A new revision of the series which incorporates changes that Marek
> suggested. Specifically, the changes are:
>
> 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
>    default interface rather than re-using port_max_speed_mode()
>
> 2. Patch 4 - if no default interface is provided, use the supported
>    interface mask to search for the first interface that gives the
>    fastest speed.
>
> 3. Patch 5 - now also removes the port_max_speed_mode() method

Tested with hellcreek driver and no problems observed.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmLFxOETHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzglisD/9Nj6vRxJ5jiige/G3eUJYpGYfPMd6X
bjqn9VZTm3Cvxmm6Tt4TJM0zZseBFNRnQyOhG+Z2hVG2Y9gtPxrUoI+VeffHCq+4
eRLG09nLOllfuST798RTA1CnDpl8FDc1okrcdO+Mmg6etBOltokx3DHbjpn0AgaP
+iuSMQ/dcajxkqXn28uaYwivNU7pK8RnJfi8KgW8gaOAbP0k8Sh5Kxaa2u6w/05a
jonfbZwaoLeqF5x5vBuKHS1xe/O81c6ThAOs/RB67ORNOeDClA49aLQ4/m7omYP0
3wG98FfcHXsAu+BLIzdiwSi9vSnh3u1+4fhxQWi/8F24N6dOmjb6R6KpnuTx7XR+
febMS5MxQ01V/K0JijNTBFVfXdnWE9xI2YSaDkaJ8d6lvTfaJe8BZGwlNqvUiUqK
OIDudA+Qifqjimmb+aEZLo5YpIyCiFqKdeYXN2R7QTMPvXMQ8N+4fCfTTbs4RDDS
bommmpaQr6pzqQTIwShwbez+DNAsAhoyeviXEZ79dI3F6M8nZLTUIM0TtRstVWl3
RQGrxW7kGhMvEVPRA9kmvispxbVC7BHHrr6szsEAofSvlJx+ILkb2c8qw+JDUPm2
MbRgCWG5oebfi12LY66UsG1tUj7DfkX7np1j5CjcbJPj7DjycF/j/mfpy/4eVxcr
PJAoL6Ngk/c+Fg==
=W6Vb
-----END PGP SIGNATURE-----
--=-=-=--
