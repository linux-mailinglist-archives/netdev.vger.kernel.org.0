Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC7526177
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380090AbiEML4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344951AbiEML4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:56:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF10423E296
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:56:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npTuK-0000S0-BE; Fri, 13 May 2022 13:56:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2910E7D988;
        Fri, 13 May 2022 11:56:29 +0000 (UTC)
Date:   Fri, 13 May 2022 13:56:28 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <vincent.mailhol@gmail.com>
Cc:     Srinivas Neeli <srinivas.neeli@xilinx.com>, wg@grandegger.com,
        davem@davemloft.net, edumazet@google.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [PATCH] can: xilinx_can: Add Transmitter delay compensation
 (TDC) feature support
Message-ID: <20220513115628.tiplo5wtucri6hy2@pengutronix.de>
References: <20220512135901.1377087-1-srinivas.neeli@xilinx.com>
 <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vddfwce3cegun5mc"
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq+z69CTY6Ec0n9d0-ri6pcyHtKH917M1eTD6hgkmyvGDQ@mail.gmail.com>
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


--vddfwce3cegun5mc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 13.05.2022 10:24:06, Vincent Mailhol wrote:
> >  #define XCAN_BTR_SJW_SHIFT             7  /* Synchronous jump width */
> >  #define XCAN_BTR_TS2_SHIFT             4  /* Time segment 2 */
> >  #define XCAN_BTR_SJW_SHIFT_CANFD       16 /* Synchronous jump width */
> > @@ -259,7 +261,7 @@ static const struct can_bittiming_const xcan_bittim=
ing_const_canfd2 =3D {
> >         .tseg2_min =3D 1,
> >         .tseg2_max =3D 128,
> >         .sjw_max =3D 128,
> > -       .brp_min =3D 2,
> > +       .brp_min =3D 1,
>=20
> Was there any reason to have brp_min =3D 2 in the first place?
> I think this change  should be a different patch. If the brp_min =3D 2
> is just a typo, you might also want to backport it to stable branches.

+1

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vddfwce3cegun5mc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJ+R2kACgkQrX5LkNig
011GeQf+LzltNxNz6ZYdvq6yIaIO39Yezh+I+SEnF4qsY5YaMHolOc5EEIAK93Si
wXDfQ4v/uXWIIXTKXXzkIHShHnrtj5JBVOONGLqRr15dp+zoFWQ9cym0toL45h+J
CYeTu+aHAoouoqxIfW5yZ9TRSrrtX6EKasrVZn8Qo3xWw+A2aom5Tx2HSPI82uNj
uzUt2IDUG6Vbghe/WyCoA3ggaJ7D5qR3KMVrW87RjU5XiCPFUZVMx8K7RibTwn3a
vn8HDwC2ICcnpy9HUpY9E/tKp+GGR9FazpNVVuRB7WMMNpjqgrjy91FtlW/viZh6
ubzjc2Hy9P+9V3R5mSyd6H3ZTBDyPA==
=Szv2
-----END PGP SIGNATURE-----

--vddfwce3cegun5mc--
