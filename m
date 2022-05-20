Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA87452E725
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346864AbiETITY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237421AbiETITW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:19:22 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CD313C1E2;
        Fri, 20 May 2022 01:19:20 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6B42C60010;
        Fri, 20 May 2022 08:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1653034758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fMAISBStviL8tlNoDX7xITb89xcvlrGbnp+RNcwHWt4=;
        b=HO7Jrqij1gQxfgMu2EYH9++IPbkDw+4U3a2NegIvyRoEvMoq3QJO/HfBWN7gihmtNea2u4
        Wm33e4gVLTDkkTZXe1yr3zz5rLFmjKbtsgs3ktVU7rR4nPX8ALf8u+G/fbE7F8TuLfvRDf
        xWJfCFfpUt1NBK2ATVPiOvmh2PS2dEJtUPIIVjezppFmpsHDWd+xKJibTFnu6Kfn7ehPvx
        KSMJNxPpBZZkMkVCKWzCMPp1CqxLSDaRWk5r3tZbINVuwq1kqXoS8smKlSo8dhlqDa8MGg
        w60KZoy2DZdeZOWdKpKcx2uRTjn5c7t+AUAo9agHqkz7YKu8MapOSzOCSIEQwA==
Date:   Fri, 20 May 2022 10:18:05 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?B?TWlxdcOobA==?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 12/13] ARM: dts: r9a06g032: describe switch
Message-ID: <20220520101805.765db5a4@fixe.home>
In-Reply-To: <20220519182812.lmp2gp6m47jt742y@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
        <20220519153107.696864-13-clement.leger@bootlin.com>
        <20220519182812.lmp2gp6m47jt742y@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Thu, 19 May 2022 21:28:12 +0300,
Vladimir Oltean <olteanv@gmail.com> a =C3=A9crit :

> Does the switch port count depend on anything? If it doesn't, maybe you
> could add the "ethernet-ports" node and all the ports here, with status
> =3D "disabled", so that board files don't need to spell them out each tim=
e?

Port count does not depends on anything, it's always fixed so indeed, it
would be a good idea to provide all the ports as disabled.

> I'm also thinking you could define the fixed-link and phy-mode =3D "inter=
nal"
> property of the CPU port with this occasion. That surely isn't a
> per-board thing.

Totally.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
