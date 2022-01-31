Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736704A488A
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiAaNqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiAaNqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 08:46:22 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3FC061714;
        Mon, 31 Jan 2022 05:46:21 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id D0F0520010;
        Mon, 31 Jan 2022 13:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643636780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9AZC57V8aDIMgaYrrpTASAli0lviVYKgdahqGrxweQ=;
        b=Z+SH49WL7BKLKn4+jq4JIkPfwW+aciazRgN1ASnEN8hwXJbSzkqNwGBzGJl5j2V0hi35kY
        eE9YzkC63JuOFNI86XwOKJqfAueIXZlqJ7chospAM9bvsQmoRaEK2EWZyc+QcXqJuqyf4f
        ez/IuS7xQK/aspBhYBTtzfseD67DE0ZnMrEXSETEAdkjDPhoQAlH9yHLu10cEwbcTBCA16
        Tsw/dMmlAdbVDIpABSktsu0i0DcER8CQf/OviXRP2zXH+nEUL35gccZs1NogdKO1sYPGdF
        iCGd99IGx5hkaHIhNyr7SkJMGKMACPzVv7naMCDYFdl7c+7+EXa6sTryujb0zg==
Date:   Mon, 31 Jan 2022 14:46:17 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>
Subject: Re: [PATCH wpan-next v2 1/2] net: ieee802154: Move the IEEE
 802.15.4 Kconfig main entries
Message-ID: <20220131144617.3c762cfb@xps13>
In-Reply-To: <CAB_54W45Hht8OVLDhKTKkfORYUJ30oWBz2psxX2m8OB4foK=0Q@mail.gmail.com>
References: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
 <20220128112002.1121320-2-miquel.raynal@bootlin.com>
 <CAB_54W45Hht8OVLDhKTKkfORYUJ30oWBz2psxX2m8OB4foK=0Q@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 30 Jan 2022 16:07:53 -0500:

> Hi,
>=20
> I will do this review again because I messed up with other series.
>=20
> On Fri, Jan 28, 2022 at 6:20 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > From: David Girault <david.girault@qorvo.com>
> >
> > It makes certainly more sense to have all the low-range wireless
> > protocols such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
> > together, so let's move the main IEEE 802.15.4 stack Kconfig entry at a
> > better location.
> >
> > As the softMAC layer has no meaning outside of the IEEE 802.15.4 stack
> > and cannot be used without it, also move the mac802154 menu inside
> > ieee802154/.
> > =20
>=20
> That's why there is a "depends on".
>=20
> > Signed-off-by: David Girault <david.girault@qorvo.com>
> > [miquel.raynal@bootlin.com: Isolate this change from a bigger commit and
> > rewrite the commit message.]
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/Kconfig            | 3 +--
> >  net/ieee802154/Kconfig | 1 +
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/Kconfig b/net/Kconfig
> > index 8a1f9d0287de..a5e31078fd14 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -228,8 +228,6 @@ source "net/x25/Kconfig"
> >  source "net/lapb/Kconfig"
> >  source "net/phonet/Kconfig"
> >  source "net/6lowpan/Kconfig"
> > -source "net/ieee802154/Kconfig" =20
>=20
> I would argue here that IEEE 802.15.4 is no "network option". However
> I was talking once about moving it, but people don't like to move
> things there around.
> In my opinion there is no formal place to "have all the low-range
> wireless such as Bluetooth, IEEE 802.11 (WiFi) and IEEE 802.15.4
> together". If you bring all subsystems together and put them into an
> own menuentry this would look different.
>=20
> If nobody else complains about moving Kconfig entries here around it
> looks okay for me.
>=20
> > -source "net/mac802154/Kconfig"
> >  source "net/sched/Kconfig"
> >  source "net/dcb/Kconfig"
> >  source "net/dns_resolver/Kconfig"
> > @@ -380,6 +378,7 @@ source "net/mac80211/Kconfig"
> >
> >  endif # WIRELESS
> >
> > +source "net/ieee802154/Kconfig"
> >  source "net/rfkill/Kconfig"
> >  source "net/9p/Kconfig"
> >  source "net/caif/Kconfig"
> > diff --git a/net/ieee802154/Kconfig b/net/ieee802154/Kconfig
> > index 31aed75fe62d..7e4b1d49d445 100644
> > --- a/net/ieee802154/Kconfig
> > +++ b/net/ieee802154/Kconfig
> > @@ -36,6 +36,7 @@ config IEEE802154_SOCKET
> >           for 802.15.4 dataframes. Also RAW socket interface to build M=
AC
> >           header from userspace.
> >
> > +source "net/mac802154/Kconfig" =20
>=20
> The next person in a year will probably argue "but wireless do source
> of wireless/mac80211 in net/Kconfig... so this is wrong".
> To avoid this issue maybe we should take out the menuentry here and do
> whatever wireless is doing without questioning it?

Without discussing the cleanliness of the wireless subsystem, I don't
feel bad proposing alternatives :)

I'm fine adapting to your preferred solution either way, so could you
clarify what should I do:
- Drop that commit entirely.
- Move things into their own submenu (we can discuss the naming,
  "Low range wireless Networks" might be a good start).
- Keep it like it is.

Thanks,
Miqu=C3=A8l
