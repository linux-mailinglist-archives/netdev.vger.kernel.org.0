Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B015B8943
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiINNia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 09:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiINNi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 09:38:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CF5282F
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 06:38:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYSas-0007RQ-Qk; Wed, 14 Sep 2022 15:38:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:956:4247:55d:c7ae])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DF4AFE2F18;
        Wed, 14 Sep 2022 13:38:21 +0000 (UTC)
Date:   Wed, 14 Sep 2022 15:38:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        wg@grandegger.com
Subject: Re: [PATCH -next] can: flexcan: Switch to use dev_err_probe() helper
Message-ID: <20220914133813.h7hmrithtavzuxum@pengutronix.de>
References: <20220914134030.3782754-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fe3p4i3bvieo4hmd"
Content-Disposition: inline
In-Reply-To: <20220914134030.3782754-1-yangyingliang@huawei.com>
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


--fe3p4i3bvieo4hmd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.09.2022 21:40:30, Yang Yingliang wrote:
> dev_err() can be replace with dev_err_probe() which will check if error
> code is -EPROBE_DEFER.
>=20
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

added to linux-can-next

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--fe3p4i3bvieo4hmd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMh2UIACgkQrX5LkNig
012wBggAoTxd886BIviOOOJhOve8Jv+O7vZADm5twM5s+NmsWM6OmZ0+iZJFvTks
ZUL8WKYW2773xHCdCVIe0euTchgqF0GwlCAnysBBYSKm3gtXCIPRJRBQ6aodgyRA
Ld4hK0veZgnjBQqSUJHfKCBh8LStwgBB7cAIoMqHUm25J66mWf+XWN/TzL70DAoX
GDzWKIJ5fhpquhnu8CS8/QMIWCT2tNI5ZVZ22q+/I6Z2oblolTMt9C6Z9OtSC5Qn
wWo5l3TOij98dc4EziT1bqN+AB9feI0kBKi/gH5rlgjMjDJpnHVSRBzhy6tl4ltk
bZVi0arNOvQeO7hpcgiEJ7z9LOw1Nw==
=xCxj
-----END PGP SIGNATURE-----

--fe3p4i3bvieo4hmd--
