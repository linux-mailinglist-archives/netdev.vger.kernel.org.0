Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0B0602434
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiJRGPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJRGPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:15:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD991B9D1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:15:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1okfsa-0004f1-Tx; Tue, 18 Oct 2022 08:15:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DA78F101433;
        Tue, 18 Oct 2022 06:15:05 +0000 (UTC)
Date:   Tue, 18 Oct 2022 08:15:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] can: mcan: Add support for handling DLEC error on CAN
 FD
Message-ID: <20221018061504.c7hrvepn3uxvk2d4@pengutronix.de>
References: <CGME20221018050046epcas5p1ff6339e8394597948f9b26aecb4b51a9@epcas5p1.samsung.com>
 <20221018043333.38858-1-vivek.2311@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qn42ftkobda7rvf2"
Content-Disposition: inline
In-Reply-To: <20221018043333.38858-1-vivek.2311@samsung.com>
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


--qn42ftkobda7rvf2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.10.2022 10:03:33, Vivek Yadav wrote:
> When a frame in CAN FD format has reached the data phase, the next
> CAN event (error or valid frame) will be shown in DLEC.
>=20
> Utilizes the dedicated flag (Data Phase Last Error Code: DLEC flag) to
> determine the type of last error that occurred in the data phase
> of a CAN FD frame and handle the bus errors.
>=20
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

Have you actually compiled this code?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qn42ftkobda7rvf2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNORGUACgkQrX5LkNig
0138NggAmtM0pUByADEQjRpsTAaOHHkgAk9GtabF4BP2yk0pit3u3+rfCtr5mpTb
cF3UNAIsrVszhzOeL9ESoB/fKPFVi3PLkKu7ghr6//IXU/UNorF8aQHHBidPGQMU
mCPx+7zy2jKpst2Lr/2xFlAfk6e47ghKiNSVHeundAs5fDNuNRYSoKdMJxf8SAah
b/nio/0A/Gh2iYeKPfNduJL13Lk9TZ019JzG2LtQ9XqppLYk7RO/O/fhHlQJBFzD
851pyOx+O4fNHQFU0X4kzwKBWnLcjyVbaJwF2PFn4A8yTtNcDc/TM3McQUWWwL4E
Cz04Xoa65l6pj2AFCn4WoXH40TsMOA==
=pzO3
-----END PGP SIGNATURE-----

--qn42ftkobda7rvf2--
