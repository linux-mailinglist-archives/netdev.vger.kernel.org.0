Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7009A5AE005
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbiIFGm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbiIFGm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:42:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD6D6D9DB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 23:42:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oVSHh-00089p-Ul; Tue, 06 Sep 2022 08:42:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:a3ba:d49d:1749:550])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AD53FDB5AA;
        Tue,  6 Sep 2022 06:42:06 +0000 (UTC)
Date:   Tue, 6 Sep 2022 08:42:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     socketcan@hartkopp.net, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] can: raw: random optimizations
Message-ID: <20220906064204.xabrr4gy3lq537bt@pengutronix.de>
References: <cover.1661584485.git.william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="an64ryy5uyd6c3vg"
Content-Disposition: inline
In-Reply-To: <cover.1661584485.git.william.xuanziyang@huawei.com>
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


--an64ryy5uyd6c3vg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.08.2022 15:20:09, Ziyang Xuan wrote:
> Do some small optimizations for can_raw.

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--an64ryy5uyd6c3vg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmMW67oACgkQrX5LkNig
012dYQf/UfERc4TRZPv5gJYjnerc5COZEVGGZIAydI/sjqKidImoG3dYsPvz9+pe
XyJd81sJCK1G+cYMnSiV0E7x1y+aa61l/cou6Sd//v4NK/xbfxm7ZWeAsts4cd8O
YrWx4sl3rUCv5YJkFQqj1u7iSg/rngOT1NjWcRS88X9tReqOtI8ZT4sgABZ9OIF+
DFO63boNAxr6fr/zSmkk8Vx+Bd7SP4sbEIDFsHhsze1RmqPQw+bHuE0GyCwdPvqG
75zCnE15MJCmNg7v0ZRaxAYQcytbAOb2MlgSVpu3kOt8Ejr+4qH64JEsTL9tre1W
DG7E9QXro3B6GASKdTRoth0JiwlPIQ==
=JJ22
-----END PGP SIGNATURE-----

--an64ryy5uyd6c3vg--
