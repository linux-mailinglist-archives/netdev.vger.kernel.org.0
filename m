Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C9B5026A3
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351374AbiDOI2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiDOI2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:28:51 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E004AFB35;
        Fri, 15 Apr 2022 01:26:23 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 787FB1BF211;
        Fri, 15 Apr 2022 08:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1650011181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kKojKZULnPE/wWjIpye1ilTyE1X2MJhejc5l4csXybI=;
        b=eyakLyHQLwnmDg3QFRsBeVWxdYLaiRMfBgkqSYNyJ8w18zYfQe/rzoYSew7hsuaxFbbh3t
        D3ANnDwMXwuBDdry+VBoxXei0xbk2gIqOIEUt4fnRmdCMYTAc1IK9wF4ZTKGxE1SZCA3ci
        lNoTkfyU912659amNnzGFgRAx1Tdr3oDrAE5DIG06FsVTELhC2uzNdEyN8DxYgoFabwGz9
        fIRDG5T+ngpImU8lhDgvP0UuA42Fe/+6IiKB84vp9GsZvnuDVopyQaS3I4FYaYHVnbW9YO
        BvjQh/R8VvNSDzKTwvGfYMzJXp0u/W8HKsLllI2HxiqBVhLE+Gxbvhzh8ui9Ag==
Date:   Fri, 15 Apr 2022 10:24:53 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/12] ARM: dts: r9a06g032: describe MII
 converter
Message-ID: <20220415102453.1b5b3f77@fixe.home>
In-Reply-To: <YlismVi8y3Vf6PZ0@lunn.ch>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
        <20220414122250.158113-10-clement.leger@bootlin.com>
        <YlismVi8y3Vf6PZ0@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, 15 Apr 2022 01:22:01 +0200,
Andrew Lunn <andrew@lunn.ch> a =C3=A9crit :

> On Thu, Apr 14, 2022 at 02:22:47PM +0200, Cl=C3=A9ment L=C3=A9ger wrote:
> > Add the MII converter node which describes the MII converter that is
> > present on the RZ/N1 SoC. =20
>=20
> Do you have a board which actually uses this? I just noticed that
> renesas,miic-cfg-mode is missing, it is a required property, but maybe
> the board .dts file provides it?
>=20
>     Andrew

Hi Andrew, yes, I have a board that defines and use that. The
renesas,miic-cfg-mode actually configures the muxes that are present on
the SoC. They allows to mux the various ethernet components (Sercos
Controller, HSR Controller, Ethercat, GMAC1, RTOS-GMAC).
All these muxes are actually controller by a single register
CONVCTRL_MODE. You can actually see the muxes that are present in the
manual [1] at Section 8 and the CONVCTRL_MODE possible values are listed
on page 180.

This seems to be something that is board dependent because the muxing
controls the MII converter outputs which depends on the board layout.

I'm open to any modification for this setup which does not really fit
any abstraction that I may have seen.

[1]
https://www.renesas.com/us/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-gr=
oup-users-manual-system-introduction-multiplexing-electrical-and

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
