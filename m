Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3052549AF7
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiFMSC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244561AbiFMSBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:01:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C2A3F886
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:45:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o0kNZ-00081i-52; Mon, 13 Jun 2022 15:45:17 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A615593DBC;
        Mon, 13 Jun 2022 13:45:12 +0000 (UTC)
Date:   Mon, 13 Jun 2022 15:45:12 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Conor.Dooley@microchip.com
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        Daire.McNamara@microchip.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next 0/2] Document PolarFire SoC can controller
Message-ID: <20220613134512.t74de4dytxbdbg7k@pengutronix.de>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
 <20220607071519.6m6swnl55na3vgwm@pengutronix.de>
 <51e8e297-0171-0c3f-ba86-e61add04830e@microchip.com>
 <20220607082827.iuonhektfbuqtuqo@pengutronix.de>
 <0f75a804-a0ca-e470-4a57-a5a3ad9dad11@microchip.com>
 <4c5b43bd-a255-cbc1-c7a3-9a79e34d2e91@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ofcrvuhmfdcokgre"
Content-Disposition: inline
In-Reply-To: <4c5b43bd-a255-cbc1-c7a3-9a79e34d2e91@microchip.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ofcrvuhmfdcokgre
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.06.2022 12:52:00, Conor.Dooley@microchip.com wrote:
> >> The register map cannot be downloaded directly anymore. For reference:
> >>
> >> http://web.archive.org/web/20220403030214/https://www.microsemi.com/do=
cument-portal/doc_download/1244581-polarfire-soc-register-map
> >=20
> > Oh that sucks. I know we have had some website issues over the weekend
> > which might be the problem there. I'll try to bring it up and find out.
> >=20
>=20
> Hey Marc,
> Doc is still not available but should be getting fixed.

Thanks.

> What do I need to do for this binding? Are you happy to accept it without
> a driver if I add links to the documentation and a working link to the
> register map?

I'm taking both patches and change the CAN into capital letters while
applying, I'll also add a link to the datasheets.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ofcrvuhmfdcokgre
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKnP2UACgkQrX5LkNig
013f+QgAo0TG9o5JrCA9bcXqT6d4u7VdUwbKtD4+5GEV02lyfojpxd78EtjRNf5U
DeLVrv4ULFwgdO30NjPch+4P6Vc7Ghs8gP4AQRKMzqduRXB76erdzrjeKFT3f+mR
4kH81wkCZESZQ2DJD+p2nYFFZrCuwg3Ez2fZvIbJ06qn4C4g3LbkPkXzD7wUVqx9
bTjHcb9y/E/DNCTaBWpneqN87CNsr2v6PunUNNzb+bJExxQOqXUVtfwnB4FXdoEs
6UJV3deh47FuvPaCvF4mVOV4eaJ4vIlOAzL09TSt2RHE0m2yZ/HNfwZDYu98LKWa
vYqLFhjC3Ebqg2lmFtHMTP1KS0GbYg==
=YYeu
-----END PGP SIGNATURE-----

--ofcrvuhmfdcokgre--
