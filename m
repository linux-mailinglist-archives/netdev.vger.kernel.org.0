Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1851C30E71
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfEaM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:56:32 -0400
Received: from sauhun.de ([88.99.104.3]:41340 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfEaM4b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:56:31 -0400
Received: from localhost (ip5b40b67c.dynamic.kabel-deutschland.de [91.64.182.124])
        by pokefinder.org (Postfix) with ESMTPSA id AAF692C2761;
        Fri, 31 May 2019 14:56:28 +0200 (CEST)
Date:   Fri, 31 May 2019 14:56:28 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ruslan Babayev <ruslan@babayev.com>, linux@armlinux.org.uk,
        f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190531125628.GA951@kunai>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190529094818.GF2781@lahna.fi.intel.com>
 <20190529155132.GZ18059@lunn.ch>
 <20190531062740.GQ2781@lahna.fi.intel.com>
 <20190531064842.GA1058@kunai>
 <20190531120513.GB18608@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20190531120513.GB18608@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> Maybe he can create a smaller immutable branch for you.

Yeah, that's what I was basically asking for, but probably should reply
to his mail.


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlzxJHcACgkQFA3kzBSg
KbZ/Zg/+N3b5FeN2MagU71YxoN8a9FgQsNW7Sy0U8X1de5MHBp+3lifh3mkDGf7j
BnxWA8GzyHMhabtHy4N8GVhnb7f0jFTgTI3bvhsklvOkicG1k7O6IK4nUx7ddUqd
/bb/PEFj0EEIACra2itO45dxh+mHhiPQPproTzJCoHJ9V68evyft9fxqMczLZlgL
2BOOo0gPG4n4WEhpyXGp3ecaEqpTBZwjuZVSRdGajXkGFGVWsxFEqtLnGMoe7IOo
YS4Wuz6fGch0F46TvYVf5sI2R8QuejUpJ5Op34kseinniCQ1JRoTOlLj6pueWVFp
DWnw3U7bgPApwwkYIfdVWXMS8CYBHvrxqtavJNBxTcYrWfL/AAsCH0Lg4HkUKDjv
ycnC66plq2BMk3KlmMftmCwaVbAlIUvKLQoLsLiEChTS2W7ctppq6A9oOonhuPzH
3aWqS2oQwHm1FRus1uC1K2j/eWMOojiZUsFIL428BeJPZjPu0n2IK3qp0K28pktK
hxyUiFt3YrC82mCO7VFX0dUvFHAJ2H5rniWlt5XbDv1kRQW/TpaTQfz9kPWfn0Ud
50+duo5d5Qxxa5XnZuKwCNBf2qd8Qut+xVZjSv0jx/9bR6fqUb2Ko4MkeE7MShEO
003MzY6cj/PRBBE1PBLh/EI8JFIT23s4EQYxkxxJkUs04atRPZc=
=BnCX
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
