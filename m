Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E811D1A0E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387393AbgEMQA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728692AbgEMQA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 12:00:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A11AC061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 09:00:29 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jYto3-0005yx-Kv; Wed, 13 May 2020 18:00:27 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jYto2-0002qd-Pi; Wed, 13 May 2020 18:00:26 +0200
Date:   Wed, 13 May 2020 18:00:26 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v1] net: phy: at803x: add cable test support
Message-ID: <20200513160026.fdls7kpxb6luuwed@pengutronix.de>
References: <20200513120648.14415-1-o.rempel@pengutronix.de>
 <0c80397b-58b8-0807-0b98-695db8068e25@gmail.com>
 <20200513154544.gwcccvbicpvrj6vm@pengutronix.de>
 <20200513154953.GI499265@lunn.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6a7oqghoxjesv4z7"
Content-Disposition: inline
In-Reply-To: <20200513154953.GI499265@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:54:56 up 180 days,  7:13, 182 users,  load average: 0.04, 0.08,
 0.05
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6a7oqghoxjesv4z7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 13, 2020 at 05:49:53PM +0200, Andrew Lunn wrote:
> > Uff.. i missed this. Then I'll need only to add some changes on top of
> > his patch.
>=20
> I've been chatting with mwalle on IRC today. There should be a repost
> of the patches soon.

Cool!
@Michael, please CC me.

you can include support for AR9331 and AR8032 in your patch (if you
like)
http://www.jhongtech.com/DOWN/ATHEROS--AR8032.pdf

They have same register, but only 2 pairs.

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--6a7oqghoxjesv4z7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl68GZYACgkQ4omh9DUa
UbMdlA/+O0iIZLBwArtGcqcdiVYupsTy1uBMg/9ZFt/f1XGNIgLXvf7Jy9ySSNeT
ZNUOPpjJ+LnH5GpjhE6xVjq3hZ0IxI973b7Q5gWds10isDkljl9p+E6QPjJvhCnV
btINYfg8BClFgDTvB0lBanAFs2Geny3AL4AR2EHND8mjtT2hRE3caXxd7kOxkbI2
gXd322ndSZP+1HYedeGZLkI/RJTi37tDkM9dENGy706zjWzi+4FsFR0PVJdb0Bx6
XLQ21B8C+/YYb1gj6cD1mi76GIaH0XaSoF5OO2oiW4ijOZZKgqX6/ZMTRl4iakgd
cqYlgJ52Z//iCRyTQhyWyeEem9Chb33dBZicIjmaSZHqwIc0q6FkNdrYWjLFZg1b
crFaeyfxopCnoZD7of5Gryx+PjHa9RFJKSiU8GVhdaW2VDB69XhuicxfQgMMefAo
8xowyZgPbXrcxE9d1aZWbpmIzrK8EYMhuREk3S4JAKJEdz+3emLVExw8Wty5WhXS
/AejFyTKqbOw/42iBXLCzeYEdHg1SaIoxdyhAosoB7LtiivGqI0MkbTP0+2UiSHO
ohQAe0idYWEbByt057QwC2bK5gElRDZJUOL4Q8ncty2B5Wtb9SQESszC1Kaf0bGs
2dYILv1mmM2ShJ0eiE4C0eAsn575hvlq4sIipq+84OJbfV3TFb8=
=uxFm
-----END PGP SIGNATURE-----

--6a7oqghoxjesv4z7--
