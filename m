Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3EE308F5
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 08:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfEaGsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 02:48:45 -0400
Received: from sauhun.de ([88.99.104.3]:39252 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfEaGsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 02:48:45 -0400
Received: from localhost (unknown [91.64.182.124])
        by pokefinder.org (Postfix) with ESMTPSA id 3B15F2C2761;
        Fri, 31 May 2019 08:48:43 +0200 (CEST)
Date:   Fri, 31 May 2019 08:48:42 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Ruslan Babayev <ruslan@babayev.com>,
        linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [net-next,v4 0/2] Enable SFP on ACPI based systems
Message-ID: <20190531064842.GA1058@kunai>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190529094818.GF2781@lahna.fi.intel.com>
 <20190529155132.GZ18059@lunn.ch>
 <20190531062740.GQ2781@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20190531062740.GQ2781@lahna.fi.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Are you happy for the i2c patch to be merged via net-next?
>=20
> Yes, that's fine my me.
>=20
> Wolfram do you have any objections?

That's fine with me, I'd like an immutable branch, though. There are
likely other changes to i2c.h coming and that would avoid merge
conflicts.


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlzwzkYACgkQFA3kzBSg
KbYLThAAj7STTMVCIs8F5pQc2CL/VG7m9jE8g45Y2UsC2GalXogsowIOtAJydg9l
Ix5+g9neYnFPj6Kvct20SxzQPtjxZXhn+hStBHTx6AN30pXXywAA1QisHNp4LLSk
6eSsE57svbMqOTtF7HGZeEheocvcDDr8NbTLWFuUOuHJnumSWWSOFtHFGIynZEa6
agL05yQJ2mWQ33ydA6mq8JqB/kYaajsuAPmM4YxaxReshoRxOXOCduvkWk7q8QqI
SlcJZCmccTypcIUxsp1gETxbBScYdcVtd/ZKR5sdxApbWW6OFJMq6DYfg2Cp1ZOw
dSoQBesfighJL0cI0/M291OLRZeJFi4rzJW5ZT0zGadCFiSsGDoJVag5EWVsfl9L
8dkW7eEusUeUk7rwMFNqEa/0ZZanN+DwgDEgEbQI2Si06neTiSflRBtwvWNjDF7i
Wey4mpYZkl4Gem46VPzOk0PbVnnvy3jwXtuMMB61C8jX+sDfI/ESHNWBiADvDkgH
TPdBhRheUUeJZnxDQc8rbqyeZU6URG+AO6gaDNBozJr/GNKRpGHz1iciPUl60rE+
2tfFqWnEgEkWuEwUqFw9e+ZdayGV1bEiIt3r77g4UdzldwS/JzfubncU5XmZX04R
7MrWtxJYl3zXkvlRh+K1xgdN+Ys8L/WJxPq3OdybHR3lBsaBEc4=
=la6d
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
