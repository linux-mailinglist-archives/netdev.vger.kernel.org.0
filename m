Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10D730E77
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 14:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfEaM5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 08:57:55 -0400
Received: from sauhun.de ([88.99.104.3]:41376 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbfEaM5y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 08:57:54 -0400
Received: from localhost (unknown [91.64.182.124])
        by pokefinder.org (Postfix) with ESMTPSA id 4E89C2C2761;
        Fri, 31 May 2019 14:57:52 +0200 (CEST)
Date:   Fri, 31 May 2019 14:57:52 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     David Miller <davem@davemloft.net>
Cc:     ruslan@babayev.com, mika.westerberg@linux.intel.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190531125751.GB951@kunai>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190530.112759.2023290429676344968.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20190530.112759.2023290429676344968.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi David,

> Series applied.

Could you make a small immutable branch for me to pull into my I2C tree?
I have some changes for i2c.h pending and want to minimize merge
conflicts.


--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlzxJM8ACgkQFA3kzBSg
Kbb1wA//fn1qdw/P/G4yYAQFHakA9HK+3BNgDFHQN/ZdkCgDS26rlttDdYLIadRl
IphKCvNM3KLp38dlIOPUbtXGMHbNGNLTARUe13eQGSnI2EPhAjMot9CRWlRzAzFO
NzFG7OgtL1t8zv/ttDiJl4RD4+N4TR9s3s2mqNdDRIyWXj3ltSU6wy4AgYEbiAWP
39Hp+Tk+xCfvo4ZSOEGQWijMpMjc6LNFtCvd5M7Dv8kBeSAA6bNdVlvLZcw/+fc4
MyWfbf3ROERN4m8hlYEBskJDNQPapnQeOGwsX0L1qD+uUaisz2UHW6YK7RE49/oO
cee9ITU7Nq+ru1QfSLRvJa0THZ3YRT1Zha3XU5yPVELLf237yJ0htfrDj49L8UKU
p9pQmBpRCM9ZtrHfcYNykimrgA+xHStwLL0qCFbiyKjLbN1M8ru7+331BalYIYZ2
U5ZcjDW5niA5IEDOtDkcDfup77yYlQTiuS1j8KHPzBnFOz0nPezSeJkIuIK5aPoH
nqUKtfIk6sSJ7xrQW5HPEq7pRnjHvjToz1wpL0n5d6W5JnppcPwdIiK1PJaYBZd9
6V+EXMlPuqwaxLTFxT/eyXhWtGolXN6HQwaITaLSCTIfGq9UOAebK6d1AvdLLq77
LTk8JZusICbWyGl+6j8fprxQNBfGUonOQNgy8QpzZI3QqRnbgCA=
=89Ll
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
