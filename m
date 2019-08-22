Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262B5989DB
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729681AbfHVDeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:34:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:39124 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728332AbfHVDeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 23:34:00 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 38D42140C5B;
        Thu, 22 Aug 2019 05:33:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566444838; bh=UzY324amQOApe016dQSk0omdmjamtjTk79BVFa6U/qo=;
        h=Date:From:To;
        b=sC4Rkv6Vo7USwtsQ6H4NGOBok7P21cWgcXShItBAJ4FPpDLjBG/vIzxo5eeYf5ALJ
         Oz6P3nUz8LS18n0a9vLpFdVzQzqM0zoYEiJiH3lw32v1CFZURctTpRR07ojpbDkvCn
         0E+ZwPP0v/PnHM6/Ig4vT/Homzdn9og5alm5VyKg=
Date:   Thu, 22 Aug 2019 05:33:57 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com
Subject: Re: [PATCH net-next 01/10] net: dsa: mv88e6xxx: support 2500base-x
 in SGMII IRQ handler
Message-ID: <20190822053357.6309582f@dellmb.labs.office.nic.cz>
In-Reply-To: <20190821.202542.800433879227385529.davem@davemloft.net>
References: <20190821232724.1544-1-marek.behun@nic.cz>
        <20190821232724.1544-2-marek.behun@nic.cz>
        <20190821.202542.800433879227385529.davem@davemloft.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT,
        URIBL_BLOCKED shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 20:25:42 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Marek Beh=FAn <marek.behun@nic.cz>
> Date: Thu, 22 Aug 2019 01:27:15 +0200
>=20
> > int port, int lane) {
> >  	struct dsa_switch *ds =3D chip->ds;
> > +	u8 cmode =3D chip->ports[port].cmode;
> >  	int duplex =3D DUPLEX_UNKNOWN;
> >  	int speed =3D SPEED_UNKNOWN;
> >  	int link, err;
> > +	phy_interface_t mode;
> >  	u16 status; =20
>=20
> Please retain the reverse christmas tree ordering of local variables
> here.
>=20
> Thank you.

:DDDDDDDDDDDDDDDDDD
Okay, I shall do so in next version.
