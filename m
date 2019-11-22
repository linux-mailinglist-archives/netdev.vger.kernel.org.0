Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E8B107800
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVT1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:27:21 -0500
Received: from foss.arm.com ([217.140.110.172]:51640 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbfKVT1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 14:27:21 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E9B7328;
        Fri, 22 Nov 2019 11:27:20 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CB0A3F6C4;
        Fri, 22 Nov 2019 11:27:19 -0800 (PST)
Date:   Fri, 22 Nov 2019 19:27:18 +0000
From:   Mark Brown <broonie@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     guillaume.tucker@collabora.com, hulkci@huawei.com,
        tomeu.vizoso@collabora.com, khilman@baylibre.com,
        mgalka@collabora.com, enric.balletbo@collabora.com,
        yuehaibing@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: net-next/master bisection: boot on beaglebone-black
Message-ID: <20191122192718.GH6849@sirena.org.uk>
References: <5dd7d181.1c69fb81.64fbc.cd8a@mx.google.com>
 <20191122.093657.95680289541075120.davem@davemloft.net>
 <bfe5e987-e0b5-6c89-f193-6666be203532@collabora.com>
 <20191122.101147.1112820693050959325.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
Content-Disposition: inline
In-Reply-To: <20191122.101147.1112820693050959325.davem@davemloft.net>
X-Cookie: sillema sillema nika su
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2019 at 10:11:47AM -0800, David Miller wrote:

> If you're not combining the net and the net-next tree, as Stephen
> Rothwell's tree is doing, then you're going to run into this problem
> every single day and spam us with these messages.

> What is being done right now doesn't work.  You can't just wait for
> net integration into net-next, that doesn't cut it.

Is there a writeup somewhere of how your trees are expected to work?
That might help testing people figure things out, what you're doing is a
bit unusual and people working on testing infrastructure are likely not
going to be as engaged with the process for specific trees as developers
are.  I didn't spot anything in Docmentation/ and the wiki link in
MAINTAINERS seems broken but I might've been looking in the wrong places.

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3YNpUACgkQJNaLcl1U
h9AS9wf/Uq4dnT2s2ZT0skeaaHINCsGT8qOFWNH1BYsDcrhqWXCuKS0G7yR1POi0
JdMYoOFHKY/mh0uBTCI2erNQem8/jSgs3YA0AB9b50BWe41vGcJOXj9ZFngzRQ17
PS3PGs0Ri7M0/KubZaDO9G2+am3PEKEiyK8YWezhwVhB3D1WE0Elz0e/hybUCDRo
YC+YSLt9D5+XPwBCnLcOO9OD/6Psv1ZVbfXwlD8p2wKAwjwzj5ainxAEhCumYin4
/TmR2lT0/KWZhiMVs2+xSLMdylXFzPlXTmgEphmom5+t3uWNz9rZaA2BbRinNpyw
xNlKZabMIvJCVjiA4hbN/3TVH8VYFw==
=g+r3
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
