Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33BD4E39F0
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 08:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiCVHzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 03:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiCVHzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 03:55:45 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14A74A3D4;
        Tue, 22 Mar 2022 00:54:17 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D2EA4240002;
        Tue, 22 Mar 2022 07:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647935656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hL95WIkdjvtUtma7mkkPOD4nhIAtPPlN3w0wuizzJOs=;
        b=CtYGjJ3RELDYNEkF8xpunTXp7/UOD8Z1R5pYu/yHzgzpNiIWaVp+5QTsjUZ7X1eUepxBiT
        7AdNl5rSbXWguc2UV5n8SRvtlL7SwbaOzuqTjJ6axk5N9M0aHhs8N6XQ9bmAioR4sdpax9
        sDKHg8s13+R4MwRpc6/Fk1lloD+yl00xvaI9bafNniv0TtZUYBHA2zpqFQ+daiuqRd2e/S
        q9SvPNlVW2QremxkvnjZmr99XWsWmaEM4bEajI4ZUXUkKYtsWRH6zJOtIhs0ct23zFa9/F
        xOh2gHpUdmvscPFGHNJpsQ7v3XjUj4dt1dj7JlpL0mM4Lne0bah6cuomJFm6cQ==
Date:   Tue, 22 Mar 2022 08:52:52 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "'Rafael J . Wysocki '" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/6] introduce fwnode in the I2C subsystem
Message-ID: <20220322085252.143a700f@fixe.home>
In-Reply-To: <20220321113634.56d6fe2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220318160059.328208-1-clement.leger@bootlin.com>
        <20220318100201.630c70bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220321115634.5f4b8bd4@fixe.home>
        <20220321113634.56d6fe2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

Le Mon, 21 Mar 2022 11:36:34 -0700,
Jakub Kicinski <kuba@kernel.org> a =C3=A9crit :

> > Hi Jakub,
> >=20
> > Ok, to be clear, you would like a series which contains all the
> > "base" fwnode functions that I'm going to add to be sent separately
> > right ? And then also split i2c/net stuff that was sent in this series =
? =20
>=20
> I'm mostly concerned about conflicts, so if you can get the entire
> series into 5.18 before the merge window is over then consider it=20
> acked. If it doesn't make 5.18 looks like you'd need to send patches=20
> 1 and 2 as a PR so that both the i2c and net trees can pull it.=20
> Once pulled send patch 6 out to net-next. Does that make sense?

Yes totally, I guess I'll go for I2C only and then I'll move on with
next patches individually later. No need to hurry.


--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
