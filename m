Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EEF1DB7B0
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgETPHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgETPHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:07:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFDAC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 08:07:22 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jbQJQ-0004UT-Dl; Wed, 20 May 2020 17:07:16 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jbQJL-0002d2-Sm; Wed, 20 May 2020 17:07:11 +0200
Date:   Wed, 20 May 2020 17:07:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200520150711.rj4b22g3zhzej2aw@pengutronix.de>
References: <20200520062915.29493-1-o.rempel@pengutronix.de>
 <20200520062915.29493-2-o.rempel@pengutronix.de>
 <20200520144544.GB8771@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vqf6y3tx55aruwga"
Content-Disposition: inline
In-Reply-To: <20200520144544.GB8771@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:01:42 up 187 days,  6:20, 194 users,  load average: 0.24, 0.24,
 0.26
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vqf6y3tx55aruwga
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2020 at 04:45:44PM +0200, Michal Kubecek wrote:
> On Wed, May 20, 2020 at 08:29:14AM +0200, Oleksij Rempel wrote:
> > Signal Quality Index is a mandatory value required by "OPEN Alliance
> > SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> > integrity diagnostic and investigating other noise sources and
> > implement by at least two vendors: NXP[2] and TI[3].
> >=20
> > [1] http://www.opensig.org/download/document/218/Advanced_PHY_features_=
for_automotive_Ethernet_V1.0.pdf
> > [2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
> > [3] https://www.ti.com/product/DP83TC811R-Q1
> >=20
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
>=20
> This looks good to me, there is just one thing I'm not sure about:
>=20
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 59344db43fcb1..950ba479754bd 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -706,6 +706,8 @@ struct phy_driver {
> >  			    struct ethtool_tunable *tuna,
> >  			    const void *data);
> >  	int (*set_loopback)(struct phy_device *dev, bool enable);
> > +	int (*get_sqi)(struct phy_device *dev);
> > +	int (*get_sqi_max)(struct phy_device *dev);
> >  };
> >  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
> >  				      struct phy_driver, mdiodrv)
>=20
> I'm not sure if it's a good idea to define two separate callbacks. It
> means adding two pointers instead of one (for every instance of the
> structure, not only those implementing them), doing two calls, running
> the same checks twice, locking twice, checking the result twice.
>=20
> Also, passing a structure pointer would mean less code changed if we
> decide to add more related state values later.
>=20
> What do you think?
>=20
> If you don't agree, I have no objections so
>=20
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

I have no strong opinion on it. Should I rework it?


--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--vqf6y3tx55aruwga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7FR5gACgkQ4omh9DUa
UbOBnA//S7OEdydITBJi9jg46b/y0goQ+Shliwext7lG0yBj8kcRh7CY10RpRozV
avE/EvMXN8D0q2rOwyE8Jlw4zYZPuzuci2lXF1GhfRD28DZZDh9CAqCItK5IaImV
o5h14ztFDNFbWbEplYzfYUY+lUJVQVbkbp0P+C1sLiGM0Fvr4QlH9X8hK+paJzh5
xnhcDMIDumLX7dvkWnMRGNr5GEJmjCn9tK3YoBU1vt2eCb0GIV5O3GfG5ej/hi8n
ix/wR1Ax1+exMePyCm2iiEkBTDV+FlpphMkbj94KqlzPkZQg78+O/vd1jHZJ3Iao
M8SMs6nwcpkB+oGygquO/bhnzTUUv0vYwsuopiVCc6zXxO1jUXWvjmvXW1O9tnF8
15NPv6nGI5H7hYPLM9/nbMwb4VydtFU07ltndvXhU5WrZrDcgNjx+OcexUO726wb
iLuh5PMzYYY/uyAzcI4ov7IkUTUufwKGYj3B1isKu6XYOvRAA1x91x1xUerhQM/V
oelKB7Wct8dzS3up64CXsmhkWH0AA7ZKpoLRgbcAMeRwdR5UTqHHTqGPc6hCupt5
mHSvrSSKrHcdEPmrr5mV6cbAvvF1opP3eMi0VUO0bPw7Ko5pp08Jky+yY3i4moVZ
cYcnlB3Zbi4pW1tMqleezfXz9ja46IgT6W8p+b6Dkm5oqbujj20=
=eIn7
-----END PGP SIGNATURE-----

--vqf6y3tx55aruwga--
