Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84974514C81
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377162AbiD2ORO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377181AbiD2ORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:17:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4DD8A7D4
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 07:13:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nkRN3-0001gg-GR; Fri, 29 Apr 2022 16:13:21 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-725c-f539-4e8e-4648.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:725c:f539:4e8e:4648])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D56B571000;
        Fri, 29 Apr 2022 14:13:18 +0000 (UTC)
Date:   Fri, 29 Apr 2022 16:13:18 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:AX.25 NETWORK LAYER" <linux-hams@vger.kernel.org>
Subject: Re: [RFC v2 21/39] net: add HAS_IOPORT dependencies
Message-ID: <20220429141318.qonhkqar2nwyub7d@pengutronix.de>
References: <20220429135108.2781579-1-schnelle@linux.ibm.com>
 <20220429135108.2781579-36-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lqcj2mbryc4mt5il"
Content-Disposition: inline
In-Reply-To: <20220429135108.2781579-36-schnelle@linux.ibm.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--lqcj2mbryc4mt5il
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.04.2022 15:50:33, Niklas Schnelle wrote:
> In a future patch HAS_IOPORT=3Dn will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them. It also turns out that with HAS_IOPORT handled
> explicitly HAMRADIO does not need the !S390 dependency and successfully
> builds the bpqether driver.
>=20
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/net/can/cc770/Kconfig      | 1 +
>  drivers/net/can/sja1000/Kconfig    | 1 +

For drivers/net/can:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lqcj2mbryc4mt5il
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJr8nsACgkQrX5LkNig
010rRQf+I21I3qExctz2dzFcblEyXWU6OZwWbigahGhoVi7VXxh/udlftKM5SSh+
Cbv6NDOt9GxEP3/0Y4muCTq4Xg9jQenFXBGXRT89GaRIDiiAT11MOJ/e6YCiAtBq
yHx8f04ddLmYcRFLdgZS5GvWd8/5Ji6XKBdPf3hE5KgYjEhrGNEGWFQgne10eP2c
WqxPPa+kql2KQ2lDKUY6QcNpdhcug0PxAGJL9gnatBMVQGlwotjP/kpeKK7/7LVX
11FA2bCHvNSpqljEGADPjl73qQsnsY9TgauxzytBOgrmDginWo2AmeJ0Pu8KbP5k
bcb5RRiJNIkv36dBdpipE0wixsnf5A==
=iK8a
-----END PGP SIGNATURE-----

--lqcj2mbryc4mt5il--
