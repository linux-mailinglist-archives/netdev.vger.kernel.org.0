Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1458C47D
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbiHHH5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242015AbiHHH5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:57:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A866413CFD
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:57:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oKxdM-0008Uj-QL; Mon, 08 Aug 2022 09:57:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4338EC45AD;
        Mon,  8 Aug 2022 07:57:07 +0000 (UTC)
Date:   Mon, 8 Aug 2022 09:57:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Kenneth Lee <klee33@uw.edu>
Cc:     wg@grandegger.com, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for
 allocating only one element
Message-ID: <20220808075706.jeriooy5k2dxd5zc@pengutronix.de>
References: <20220807051656.1991446-1-klee33@uw.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d4cuir6qgpvn5yd7"
Content-Disposition: inline
In-Reply-To: <20220807051656.1991446-1-klee33@uw.edu>
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


--d4cuir6qgpvn5yd7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06.08.2022 22:16:56, Kenneth Lee wrote:
> Use kzalloc(...) rather than kcalloc(1, ...) since because the number of
> elements we are specifying in this case is 1, kzalloc would accomplish the
> same thing and we can simplify. Also refactor how we calculate the sizeof=
()
> as checkstyle for kzalloc() prefers using the variable we are assigning
> to versus the type of that variable for calculating the size to allocate.
>=20
> Signed-off-by: Kenneth Lee <klee33@uw.edu>

Added to can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--d4cuir6qgpvn5yd7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLwwdAACgkQrX5LkNig
011KEAf9GxmG87wtSGyR7GCh3+q0+3uNCOFIu5/aap/gZViTz79dh7s0QTqJAjdz
znRi73PESMFq/9sYUHiPat4u4ucJZhXh0MHa3zr7gBXEtVwlSvJ6p3mZn8W1NZQB
s4becUovf416pbmlRe0mEanBwhIVr5seiWcV4GntgY+HFftnQ8XfmhF9psy/bzT2
mUlWQ5DyIgFFL1Dl8k95y4/e8J3xAdLlC+rQgh8tlkRJe7jOvpKednuPosK4200t
GJTerBrZoTT/QwDixhOycWgiYJz66IUDPRZwyMFoTyJX1Tqf0i2i9AuSpSUi79tv
YOHkhrFR+vKQEK/CWb4jrRqtIvYvKA==
=9YlQ
-----END PGP SIGNATURE-----

--d4cuir6qgpvn5yd7--
