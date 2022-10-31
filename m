Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C86139DA
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbiJaPRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiJaPRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:17:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE9911456
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 08:17:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1opWXY-00078z-KN; Mon, 31 Oct 2022 16:17:28 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:3c2a:13d:f861:4564])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D6B1010F39A;
        Mon, 31 Oct 2022 15:17:24 +0000 (UTC)
Date:   Mon, 31 Oct 2022 16:17:19 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: RE: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Message-ID: <20221031151719.6p3jyou4rxoblz3q@pengutronix.de>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
 <20221028102458.6qcuojc5xk46jbuo@pengutronix.de>
 <OS0PR01MB5922A029B93F82F47AE1DD7C86329@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922BBCF1BDFD3176C5DAAF386379@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="i5zf2r45iochguhu"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922BBCF1BDFD3176C5DAAF386379@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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


--i5zf2r45iochguhu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.10.2022 14:57:43, Biju Das wrote:
[...]

> > > This way we'll avoid a merge conflict.
>=20
> Is it OK, if I send all other patches ie, patch#1 to patch#5 in [1] and l=
ater
> once net/main merged to net-next/main, will send patch#6?
>=20
> Please let me know.

I picked patches 1...5 for can-next/main.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--i5zf2r45iochguhu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNf5vwACgkQrX5LkNig
010NgAf+PVoRDYEoikD26GnGOeEZn240nW7P24ols+p3jfOaqpb4AlFAPafKRHho
ZzKWxR9paqtd+YKONsh5bhgI12d005S2vFs0Rq6I/TyxivBUG5VDPwC1Wm/WMg0N
kkLwV+ac3CsW/rf8fpaAy4vg7fS9Kz0oAXkaOr5iiihW0iEF4W9KxmwoQZUfU5S0
446aMy4EGg5OtQ9S2IzZP3gQ138NivbIYBK4UoCKhHDT6NSzlH3oNNzNWln3862H
oHh0fNqO1PW2Ismwy3LyONlQnH/xVARY392uvD2rPtEOhtuD0ecVjguFajJXK59K
snjKBap38hsh4ofDHfN0dZlScLvKDg==
=EXJg
-----END PGP SIGNATURE-----

--i5zf2r45iochguhu--
