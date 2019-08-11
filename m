Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9F89272
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbfHKQIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:08:18 -0400
Received: from mail.nic.cz ([217.31.204.67]:50700 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfHKQIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:08:17 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id E4734140B17;
        Sun, 11 Aug 2019 18:08:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565539696; bh=ROGZS0WEgXXpqMSTzhVir73G0XwTaeLH1ABEdZBEk0I=;
        h=Date:From:To;
        b=b08v0LY3FElel2xKPcSAfo/doE4WKH/RC8aYQfe4cwPoCCNhNBzwbBZVBqIdHokdZ
         jvZKeY65Qj8coCsa5+eQFWOvJ+BwMNSTcEtwsnpsiVYen0wuF9DppMQhUaKZIGllSU
         TURD9C6XJoQSs8P9UaFHPzC2iKM7hCRUP21uLPL8=
Date:   Sun, 11 Aug 2019 18:08:15 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] net: fixed_phy: set is_gigabit_capable
 member when needed
Message-ID: <20190811180815.024870da@nic.cz>
In-Reply-To: <20190811154001.GC14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
        <20190811150812.6780-2-marek.behun@nic.cz>
        <20190811154001.GC14290@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Aug 2019 17:40:01 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Sun, Aug 11, 2019 at 05:08:12PM +0200, Marek Beh=C3=BAn wrote:
> > The fixed_phy driver does not set the phydev->is_gigabit_capable member
> > when the fixed_phy is gigabit capable. =20
>=20
> Neither does any other PHY driver. It should be possible to tell if a
> PHY supports 1G by looking at register values. If this does not work
> for fixed_link, it means we are missing something in the emulation.
> That is what we should be fixing.
>=20
> Also, this change has nothing to do the lp_advertise, what you
> previously said the problem was. At the moment, i don't get the
> feeling you have really dug all the way down and really understand the
> root causes.
>=20
>      Andrew

Andrew,
is_gigabit_capable is otherwise set only in the phy_probe function.
This function is not called at all for the DSA cpu port fixed_link phy.
Why is that? But I guess it is not important anymore, if CPU and DSA
were converted to phylink in net-next. I shall test it and let you know.
In any case, sorry for the spam.
Marek
