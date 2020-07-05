Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBBE2215041
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgGEWyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 18:54:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:52164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgGEWyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 18:54:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7A9F3AB1A;
        Sun,  5 Jul 2020 22:54:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id F12DC604BB; Mon,  6 Jul 2020 00:54:31 +0200 (CEST)
Date:   Mon, 6 Jul 2020 00:54:31 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH ethtool v5 0/6] ethtool(1) cable test support
Message-ID: <20200705225431.xo24bjj7aaexegvk@lion.mk-sys.cz>
References: <20200705175452.886377-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2irbx7hvtypunh4c"
Content-Disposition: inline
In-Reply-To: <20200705175452.886377-1-andrew@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2irbx7hvtypunh4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 05, 2020 at 07:54:46PM +0200, Andrew Lunn wrote:
> Add the user space side of the ethtool cable test.
>=20
> The TDR output is most useful when fed to some other tool which can
> visualize the data. So add JSON support, by borrowing code from
> iproute2.
>=20
> v2:
> man page fixes.
>=20
> v3:
> More man page fixes.
> Use json_print from iproute2.
>=20
> v4:
> checkpatch cleanup
> ethtool --cable-test dev
> Place breakout into cable_test_context
> Remove Pair: Pair output
>=20
> v5:
> Add missing pair in help text
> Allow --cable-test|--cable-test-tdr with --monitor
> Fix rounding when converting from floating point meters to centimeters

Series applied, thank you.

Michal

--2irbx7hvtypunh4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8CWicACgkQ538sG/LR
dpVbbwgAmSU0Asdm6nmOw5wzXDkvKALJ5IKCBbGDzqPyvHcFnfoGbytWKY8XX5Et
0TFxBrzkh6r0qtzxm2RIqpGiHnxc9HN6199MrExdEUP85Qpd5wn+KGWIMnaNCUV0
Z0riiq3mYVsCnIQS7nVGXYX3Keb1jStpowAEC3zrOYzitQNsIBW29hTGc2gDM0Tl
M78rDPK7ckohlenxlTZqpsWgUPau6vI2dGkLQMbuSVRxSSyZbDZCSc+zFCYa/9V8
bwq3+8tjSv2S7+S91K5sy3LUzv/0R6v44V0OgoKwUmzhzEoCO9fBQUq/jvmLGhBe
k5U5f0ZN5XH7jeEzYJtQMsP80sliIw==
=4aFW
-----END PGP SIGNATURE-----

--2irbx7hvtypunh4c--
