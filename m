Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB2B27AED0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 15:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgI1NMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 09:12:52 -0400
Received: from mail.thorsis.com ([92.198.35.195]:33513 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgI1NMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 09:12:52 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 09:12:52 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id 555DC3D0A;
        Mon, 28 Sep 2020 15:04:17 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I8mEQwsw7i0Y; Mon, 28 Sep 2020 15:04:17 +0200 (CEST)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id 34B9C3C7F; Mon, 28 Sep 2020 15:04:16 +0200 (CEST)
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NO_RECEIVED,
        NO_RELAYS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.2
From:   Alexander Dahl <ada@thorsis.com>
To:     linux-leds@vger.kernel.org
Cc:     Marek Behun <marek.behun@nic.cz>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Alexander Dahl <post@lespocky.de>
Subject: Re: Request for Comment: LED device naming for netdev LEDs
Date:   Mon, 28 Sep 2020 15:04:10 +0200
Message-ID: <2817077.TXCUc2rGbz@ada>
In-Reply-To: <20200927025258.38585d5e@nic.cz>
References: <20200927004025.33c6cfce@nic.cz> <20200927025258.38585d5e@nic.cz>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hei Marek,

Am Sonntag, 27. September 2020, 02:52:58 CEST schrieb Marek Behun:
> On Sun, 27 Sep 2020 00:40:25 +0200
>=20
> Marek Behun <marek.behun@nic.cz> wrote:
> > What I am wondering is how should we select a name for the device part
> > of the LED for network devices, when network namespaces are enabled.
> >=20
> > a) We could just use the interface name (eth0:yellow:activity). The
> >=20
> >    problem is what should happen when the interface is renamed, or
> >    moved to another network namespace.
> >    Pavel doesn't want to complicate the LED subsystem with LED device
> >    renaming, nor, I think, with namespace mechanism. I, for my part, am
> >    not opposed to LED renaming, but do not know what should happen when
> >    the interface is moved to another namespace.
> >=20
> > b) We could use the device name, as in struct device *. But these names
> >=20
> >    are often too long and may contain characters that we do not want in
> >    LED name (':', or '/', for example).
> >=20
> > c) We could create a new naming mechanism, something like
> >=20
> >    device_pretty_name(dev), which some classes may implement somehow.
> >=20
> > What are your ideas about this problem?
> >=20
> > Marek
>=20
> BTW option b) and c) can be usable if we create a new utility, ledtool,
> to report infromation about LEDs and configure LEDs.
>=20
> In that case it does not matter if the LED is named
>   ethernet-adapter0:red:activity
> or
>   ethernet-phy0:red:activity
> because this new ledtool utility could just look deeper into sysfs to
> find out that the LED corresponds to eth0, whatever it name is.

I like the idea to have such a tool.  What do you have in mind?  Sounds for=
 me=20
like it would be somehow similar to libgpiod with gpio* for GPIO devices or=
=20
like libevdev for input devices or like mtd-utils =E2=80=A6

Especially a userspace library could be helpful to avoid reinventing the wh=
eel=20
on userspace developer side?

Does anyone else know prior work for linux leds sysfs interface from=20
userspace?

Greets
Alex



