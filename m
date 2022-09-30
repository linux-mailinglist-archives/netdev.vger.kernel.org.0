Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CFE5F05BC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 09:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiI3HbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 03:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiI3Ha5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 03:30:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1B7A4B2E
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 00:30:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oeATe-0007uB-6q; Fri, 30 Sep 2022 09:30:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 70649F1291;
        Fri, 30 Sep 2022 07:30:25 +0000 (UTC)
Date:   Fri, 30 Sep 2022 09:30:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] can: j1939: j1939_session_tx_eoma(): fix debug
 info
Message-ID: <20220930073019.fpwsfjvugoj7hssu@pengutronix.de>
References: <1664520728-4644-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nes3bz3xhjgihey7"
Content-Disposition: inline
In-Reply-To: <1664520728-4644-1-git-send-email-zhangchangzhong@huawei.com>
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


--nes3bz3xhjgihey7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.09.2022 14:52:08, Zhang Changzhong wrote:
> Use "%s" instead of "%p" to print function name in debug info.
>=20
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--nes3bz3xhjgihey7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmM2mwgACgkQrX5LkNig
011pLwf/T2b7YdVBog+zhUwRbg+VMZHHGuahPTs6RLtc0yhyyDHwN4t6OMWNRT1L
dHckXNIIMenp38hvMepSGqIQZ72tOJQW3bRkKCQp0v2NCExim9QD7cmtWrKZEL81
+JDbVyo/plMlv2DRA0wDK76polvPwM6d6G7z5tOxKzNVoGBhlAicnRLH3KFF88sj
i/5biwDJcAJTYaxc6yzw5AYQRM1PJFTofksG0P2KHHRMRFigrvBN6LkDJGV9lNvb
3Ex7h4ebWj91x/hKoSOBhQ25PqYfurDq2lUjCA8Imlnc604nFM62eqS5VceiYl4o
VJiM23q2q67atZ8IFQMDeV5wyVRH7w==
=kKZI
-----END PGP SIGNATURE-----

--nes3bz3xhjgihey7--
