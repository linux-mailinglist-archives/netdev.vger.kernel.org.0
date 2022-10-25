Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD4260C4CD
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbiJYHN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 03:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbiJYHN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 03:13:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 684E9FB71F
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 00:13:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onE89-0005Sa-OP; Tue, 25 Oct 2022 09:13:45 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 34395109265;
        Tue, 25 Oct 2022 07:13:44 +0000 (UTC)
Date:   Tue, 25 Oct 2022 09:13:42 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: usb: ucan: modify unregister_netdev to
 unregister_candev
Message-ID: <20221025071342.uoysd4rkg2vkhxe4@pengutronix.de>
References: <20221024110033.727542-1-dzm91@hust.edu.cn>
 <20221024135422.egkcbxvudtj7z3ie@pengutronix.de>
 <43C42E60-73A1-4F8A-A587-588B0E76F654@hust.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="il4e3nevj4ytp4go"
Content-Disposition: inline
In-Reply-To: <43C42E60-73A1-4F8A-A587-588B0E76F654@hust.edu.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--il4e3nevj4ytp4go
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2022 10:27:12, Dongliang Mu wrote:
> > Fixed while applying.
>=20
> You mean it is already done in your own tree? If yes, that=E2=80=99s fine.

ACK

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--il4e3nevj4ytp4go
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNXjKMACgkQrX5LkNig
0109SAgAtxqKKn2Fe10Y521WkMErfO1ZI26jqt6uXu3bs2zyaUb6udhyLJwY2n0/
vHxx+l6psF0cz0Z+vJ3JKXPBmmWQ3FRro8t2gwnR7xcXlTg5SRzN1Lsu7fE6Nyr7
M9uIgNX3HC2u7r1InYkJl3FabCr9dHz/Z3LtFSSWqTDhptRNtWaZTCS3m10cBLQw
5lDoJfJC/+WZEctxNOBzbNqS4oZbPFmCxpLWwGSt+nzcMbkVze8KwlfvXKhkO/fa
QfcJ7avbJ0/f8TCq97Z9cISfcYlY659cvGR+kFClJJPVidliqZJZ9hbyEe5b1mxu
5P2NK01GQ/+PO8FxinQXevl3Gk2BKg==
=DpXj
-----END PGP SIGNATURE-----

--il4e3nevj4ytp4go--
