Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE703D19E7
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 00:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhGUWEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 18:04:32 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33904 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhGUWEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 18:04:31 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E10BA1C0B81; Thu, 22 Jul 2021 00:45:06 +0200 (CEST)
Date:   Thu, 22 Jul 2021 00:45:06 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721224506.GB7278@duo.ucw.cz>
References: <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
 <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
 <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad>
 <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
 <YPiJjEBV1PZQu0S/@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <YPiJjEBV1PZQu0S/@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Also, function is totally unclear. The whole reason we want to use
> Linux LEDs is triggers, and it is the selected trigger which
> determines the function.

Usually, yes. But "function" is what _manufacturer_ wanted LED to
mean, and "trigger" is how user is using it. I have currently disk
activity LED mapped on scrollock.

There are some mini desktops which have skull LED, probably meant to
be user defined LED. In such cases, user will have to select trigger.

> Colour is also an issue. The IGC Ethernet controller has no idea what
> colour the LEDs are in the RG-45 socket. And this is generic to
> Ethernet MAC and PHY chips. The data sheets never mention colour.

Maybe datasheet does not mention color, but the LED _has_ color.

> might know the colour in DT (and maybe ACPI) systems where you have
> specific information about the board. But in for PCIe card, USB
> dongles, etc, colour is unknown.

Not.. really. You don't know from chip specificiations, but you should
know the color as soon as you have USB IDs (because they should tell
you exact hardware). And I believe same is true for PCIe cards. It may
be more tricky if no actual PCIe card exists and it is just a chip
built into generic notebook. (But then, you should have notebook's DMI
id etc...?)

Anyway, you can leave the color field empty if you don't know.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYPijcgAKCRAw5/Bqldv6
8mgUAKCNC5hOmB2+DEy/49NTRrTsOKNbsACeKKOJbfRXm5RbS3LacejsBj3j7Jo=
=b+aE
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
