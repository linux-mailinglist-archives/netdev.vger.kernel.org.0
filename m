Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C296E2A9B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 21:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDNTUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjDNTUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 15:20:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6840468A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 12:20:48 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pnOyG-0000Gd-PD; Fri, 14 Apr 2023 21:20:32 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D19891AF431;
        Fri, 14 Apr 2023 19:20:27 +0000 (UTC)
Date:   Fri, 14 Apr 2023 21:20:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Harald Mommer <hmo@opensynergy.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        stratos-dev@op-lists.linaro.org,
        Matti Moell <Matti.Moell@opensynergy.com>
Subject: Re: [virtio-dev] Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
Message-ID: <20230414-scariness-disrupt-5ec9cc82b20c-mkl@pengutronix.de>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
 <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
 <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
 <36bb910c-4874-409b-ac71-d141cd1d8ecb@app.fastmail.com>
 <c20ee6cf-2aae-25ef-e97f-0e7fc3f9c5b6@opensynergy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xnmhcrr72x5qdecz"
Content-Disposition: inline
In-Reply-To: <c20ee6cf-2aae-25ef-e97f-0e7fc3f9c5b6@opensynergy.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--xnmhcrr72x5qdecz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.02.2023 16:02:04, Harald Mommer wrote:
> we had here at OpenSynergy an internal discussion about an open source
> virtio-can device implementation.
>=20
> The outcome of this is now that an open source virtio-can device is to be
> developed.
>=20
> It has not yet been decided whether the open source device implementation
> will be done using qemu or kvmtool (or something else?). Negative or
> positive feedback for or against one of those is likely to influence the
> decision what will be used as basis for the development. Using kvmtool may
> be easier to do for me (to be investigated in detail) but on the other ha=
nd
> we have some people around in the team who have the knowledge to support
> with qemu.

It there some code available yet? We as Pengutronix will be on our
yearly techweek soon and I want to look into the VirtIO CAN stuff.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--xnmhcrr72x5qdecz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ5p3EACgkQvlAcSiqK
BOjfHwf+O/dOtHi/KVZ0/GZIlgqpUhXJ3osE2M7NmHrLC0JYVkbg62cVTjVl2G/k
ACcNQR8dbjUiFwlRF/jh1hie27J1NHkBmILuSLcjXU/a1zIq1JfNyNWo7ECS0VOG
7zg3Oryjh7oGqPmafPjSFPeqJ8xmp65NRm4y5CoAoceL/rn/+Qyuw+Qgyuk/3+q2
7xSWXNV2ZnPwIziZkjGgE87XD+osDnyan6P4XVhguFcQmSrVdzVDKaQAvBlPoujE
GZ3aopCKYpnNIdcdGxYrZWnLRFTGKpnXbMemf+JP2OQX9yIxiFL7KwFMylSuk0H+
JSM2kVdA5fptgdB8wOdwlgyrhMA7sQ==
=91Bh
-----END PGP SIGNATURE-----

--xnmhcrr72x5qdecz--
