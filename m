Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10B06A4C86
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 21:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjB0UzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 15:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjB0UzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 15:55:24 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B3625BB1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 12:55:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pWkWN-00025C-11; Mon, 27 Feb 2023 21:54:55 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1c98:86b6:77e8:2586])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 7E90A183DF4;
        Mon, 27 Feb 2023 20:54:48 +0000 (UTC)
Date:   Mon, 27 Feb 2023 21:54:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Message-ID: <20230227205446.udsl5tbnzzo4dhi4@pengutronix.de>
References: <20230227133457.431729-1-arnd@kernel.org>
 <1daa9f1f-6a68-273f-0866-72a4496cd0db@hartkopp.net>
 <c5ea695e-8693-4033-9941-c582f1c6f6be@app.fastmail.com>
 <c5f1e652-b7e7-ff79-11e3-8c5c91011b83@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mqdy46osj5uoiol2"
Content-Disposition: inline
In-Reply-To: <c5f1e652-b7e7-ff79-11e3-8c5c91011b83@hartkopp.net>
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


--mqdy46osj5uoiol2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.02.2023 21:32:40, Oliver Hartkopp wrote:
> On 27.02.23 20:53, Arnd Bergmann wrote:
> > On Mon, Feb 27, 2023, at 20:07, Oliver Hartkopp wrote:
>=20
> > > I assume these CAN bus PCMCIA interfaces won't work after your patch
> > > set, right?
> >=20
> > Correct, the patch series in its current form breaks this since
> > your laptop is cardbus compatible. The options I can see are:
> >=20
> > - abandon my series and keep everything unchanged, possibly removing
> >    some of the pcmcia drivers that Dominik identified as candidates
> >=20
> > - decide on a future timeline for when you are comfortable with
> >    discontinuing this setup and require any CAN users with cardbus
> >    laptops to move to USB or cardbus CAN adapters, apply the series
> >    then
> >=20
> > - duplicate the yenta_socket driver to have two variants of that,
> >    require the user to choose between the cardbus and the pcmcia
> >    variant depending on what card is going to be used.
> >=20
> > Can you give more background on who is using the EMS PCMCIA card?
> > I.e. are there reasons to use this device on modern kernels with
> > machines that could also support the USB, expresscard or cardbus
> > variants, or are you likely the only one doing this for the
> > purpose of maintaining the driver?
>=20
> Haha, good point.
>=20
> In fact the EMS PCMCIA, the PEAK PCMCIA (PCAN PC Card) and the supported
> Softing PCMCIA cards are nearly 20 year old designs and they are all
> discontinued for some time now. Today you can easily get a high performan=
ce
> Classical CAN USB adapter with an excellent OSS firmware for ~13 EUR.
>=20
> The only other laptop CAN "Cards" I'm aware of are PCIe "ExpressCard" 34/=
54
> from PEAK System which use the PCI subsystem.
>=20
> Maybe you are right and we should simply drop the support for those old
> PCMCIA drivers which will still be supported for the LTS 6.1 lifetime the=
n.
>=20
> @Marc Kleine-Budde: What do you think about removing these three drivers?

I don't have any of these cards, nor any $CUSTOMER who's using it.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mqdy46osj5uoiol2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmP9GJQACgkQvlAcSiqK
BOim1Af9HhMjxavoReN1OLf67lmnwdcKJx0jkNEBErIZDw9Y8aQ41jDfSxFVuWqf
3lDwrMpqnDa/fsh8BN1nxWOpf8uDeNrFl8J6gWeXDL91MthD+FZaOMGPiHmpkvYa
w7+i2RzYHMLvwcA+reEz/k79GL794WiUXOCF46YRkveH/1YvDdlrg+wbQWWKMmSj
7PCcGwXtLHhJMhqjo4RbKAyALQpcGuT4M/iMRW+bYulFz3metZUGi+xElA54WAvh
TdG4OpRH1vHbUKUcpc6vAaemJM1tC89ZkPio0rbOHzM/8Y5JRMeJm+wXWAiMJqGS
8JiNXemUDlN3ImForuqgYT1+Jbohqw==
=bdCc
-----END PGP SIGNATURE-----

--mqdy46osj5uoiol2--
