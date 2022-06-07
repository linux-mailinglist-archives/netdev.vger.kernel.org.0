Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4427753F828
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 10:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbiFGI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 04:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238191AbiFGI2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 04:28:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09456674D5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 01:28:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyUZj-0005qp-9D; Tue, 07 Jun 2022 10:28:31 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C42C68D888;
        Tue,  7 Jun 2022 08:28:27 +0000 (UTC)
Date:   Tue, 7 Jun 2022 10:28:27 +0200
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
Message-ID: <20220607082827.iuonhektfbuqtuqo@pengutronix.de>
References: <20220607065459.2035746-1-conor.dooley@microchip.com>
 <20220607071519.6m6swnl55na3vgwm@pengutronix.de>
 <51e8e297-0171-0c3f-ba86-e61add04830e@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ajso5cyytlmmpn5k"
Content-Disposition: inline
In-Reply-To: <51e8e297-0171-0c3f-ba86-e61add04830e@microchip.com>
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


--ajso5cyytlmmpn5k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 07:52:30, Conor.Dooley@microchip.com wrote:
> On 07/06/2022 08:15, Marc Kleine-Budde wrote:
> > On 07.06.2022 07:54:58, Conor Dooley wrote:
> >> When adding the dts for PolarFire SoC, the can controllers were
> >                                             ^^^
> >> omitted, so here they are...
> >=20
> > Nitpick:
> > Consider writing "CAN" in capital letters to avoid confusion for the not
> > informed reader.
>=20
> Yeah, sure. I'll try to get over my fear of capital letters ;)

:)

> > Is the documentation for the CAN controller openly available? Is there a
> > driver somewhere?
>=20
> There is a driver /but/ for now only a UIO one so I didn't send it.

Brrrrr...

> There's an online doc & if the horrible link doesn't drop you there
> directly, its section 6.12.3:
> https://onlinedocs.microchip.com/pr/GUID-0E320577-28E6-4365-9BB8-9E1416A0=
A6E4-en-US-3/index.html?GUID-A362DC3C-83B7-4441-BECB-B19F9AD48B66
>=20
> And a PDF direct download here, see section 4.12.3 (page 72):
> https://www.microsemi.com/document-portal/doc_download/1245725-polarfire-=
soc-fpga-mss-technical-reference-manual

Thanks. The documentation is quite sparse, is there a more detailed one?
The register map cannot be downloaded directly anymore. For reference:

http://web.archive.org/web/20220403030214/https://www.microsemi.com/documen=
t-portal/doc_download/1244581-polarfire-soc-register-map

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ajso5cyytlmmpn5k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfDCgACgkQrX5LkNig
010ixggAri8+zJpGE06Rm9LwkSy5IXbnAuXl+05ecMHijzwTZoXuxRjLi7FLgUt8
RMmHB1ehanHgnud3Ux9EMH2GIbigcx6EwV5iEcShe8ltxXfHATt7HI/L1x8dtS/Z
e6ic76cZ24PHhR/EAn5+uN9O17sTaoj+nCx13pVdLOe1iHUqZQf3RaVbABSibySZ
wt1j6nOt7Au4o2hJCHXO3uQ72fiNDQQAdKIFRRqvsDvMVukw+nrt1vL8Fw87AKXU
xfswszw4E2QowEV8gQeSduJwoYBlzCiya0hQJjTrlWPpxlLpYIN0VsNX+oliI0BN
bXRB2pUhMmd1nv1wnSnZOzNcCS91/A==
=PF1R
-----END PGP SIGNATURE-----

--ajso5cyytlmmpn5k--
