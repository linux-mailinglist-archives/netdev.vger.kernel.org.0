Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5C06EF99A
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239108AbjDZRsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239107AbjDZRsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:48:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636E4698
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 10:48:10 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1prjEt-0002VF-LH; Wed, 26 Apr 2023 19:47:35 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 86BFD1B7C6B;
        Wed, 26 Apr 2023 17:47:30 +0000 (UTC)
Date:   Wed, 26 Apr 2023 19:47:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Mendez, Judith" <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 1/4] can: m_can: Add hrtimer to generate software
 interrupt
Message-ID: <20230426-engine-pueblo-9967197ace5a-mkl@pengutronix.de>
References: <20230424195402.516-1-jm@ti.com>
 <20230424195402.516-2-jm@ti.com>
 <20230424-canon-primal-ece722b184d4-mkl@pengutronix.de>
 <0261131b-35b5-4570-0283-651432a9d537@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sy6skchj6wehju3r"
Content-Disposition: inline
In-Reply-To: <0261131b-35b5-4570-0283-651432a9d537@ti.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--sy6skchj6wehju3r
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.04.2023 11:11:12, Mendez, Judith wrote:
[...]
> > print a proper error message using dev_err_probe("IRQ %s not found and
> > polling not activated\n")
> >=20
> Why %s when MCAN requests 1 IRQ which is "int0"? If we want to print "int=
0",
> should it be hardcoded into the print error message?

I think I copied the error message from platform_get_irq_byname() and
extended it. Of course it makes sense to hardcode the IRQ name.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--sy6skchj6wehju3r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRJY64ACgkQvlAcSiqK
BOg2Bgf/XL6ENIVYIeH/OuUT86EybAyKIzENCqwDozaSalVYGwgnuG3umI+/cLfW
Vw1/8IBXKkoC5YN8KPt+Kkjbc1FF8H1SC495I8qW2f2IJ605BArcF5/LZOqSB/s2
ekqNjshR9Y5EJBVa/Lmlskq/H2UuQI7+/Z47aEPyS3OpVNbvLktJkgdVjxQLJHa9
tFW28wcyBEvaM2lUaVnqYZ8lDmWp+poAEOBGxwGpX9OZjDGtzDwwEJysL4MsEkRs
PSt4a0m1MdjJvmsi3dIc7rIrMm5FEBYSNmBA4/btjkfx2HdyGhWTC3mDQHHLCCIx
zDaCyzB/YLEZmndoh0zOPK3uX6XwGQ==
=Z3Pe
-----END PGP SIGNATURE-----

--sy6skchj6wehju3r--
