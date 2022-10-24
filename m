Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8722660B361
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiJXRF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 13:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbiJXRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 13:04:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09EBBA267
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 08:40:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1omxuW-0000Tz-Bu; Mon, 24 Oct 2022 15:54:36 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1bbf:91f6:fcf3:6f78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D94CB108980;
        Mon, 24 Oct 2022 13:54:30 +0000 (UTC)
Date:   Mon, 24 Oct 2022 15:54:22 +0200
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
Message-ID: <20221024135422.egkcbxvudtj7z3ie@pengutronix.de>
References: <20221024110033.727542-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xnap6ow5gg7x5npq"
Content-Disposition: inline
In-Reply-To: <20221024110033.727542-1-dzm91@hust.edu.cn>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xnap6ow5gg7x5npq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.10.2022 19:00:30, Dongliang Mu wrote:
> From API pairing, modify unregister_netdev to unregister_candev since
> the registeration function is register_candev. Actually, they are the
            ^ typo
> same.
>=20
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Fixed while applying.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xnap6ow5gg7x5npq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNWmQsACgkQrX5LkNig
0121mAf7BiRgfNOG9M3efutpUwqUshfIiVD/k+sS1Ppxu6bs8vQVw3hOny4M6sf0
8oWz6I45twfV9eBZMuueFzt51OQnczM2Ygmauk2F6je16tFWBLa4xbRlYam+uwSO
8w70ZMpOFVpGz2EjN06JMvsS2CxNv+KQnOP5AaoFFaAvX+e6aKFIUUT0dA4fC82j
98ygrX05X/FXIrhPgY/vKIhLCpi0z1qYcqzFzG61ViIMjROFvFDy8D0JHQF4MLLq
4I0HxwjDTpFfzIaQQsbt8sy8lu4aD6ehw6eOnyiwNdb46I9NrsgZ8/cBHvGjOb8m
vOd94T9UO9jvlVbRyDW6N4+2opsTCA==
=MNLr
-----END PGP SIGNATURE-----

--xnap6ow5gg7x5npq--
