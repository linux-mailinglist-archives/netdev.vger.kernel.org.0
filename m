Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275D54312F3
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhJRJOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhJRJOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:14:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D70C06176E
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:12:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcOgj-00085b-6z; Mon, 18 Oct 2021 11:12:09 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-c2ef-28ab-e0cd-e8fd.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c2ef:28ab:e0cd:e8fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6464869648E;
        Mon, 18 Oct 2021 09:12:07 +0000 (UTC)
Date:   Mon, 18 Oct 2021 11:12:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: xilinx_can: remove redundent netif_napi_del from
 xcan_remove
Message-ID: <20211018091206.cflpumnfm3mt7aiy@pengutronix.de>
References: <20211017125022.3100329-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="y7pxvzm5vjcfieof"
Content-Disposition: inline
In-Reply-To: <20211017125022.3100329-1-mudongliangabcd@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y7pxvzm5vjcfieof
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.10.2021 20:50:21, Dongliang Mu wrote:
> Since netif_napi_del is already done in the free_candev, so we remove
> this redundent netif_napi_del invocation. In addition, this patch can
       ^^^^^^^^^
redundant, fixed (also in subject)     =20
> match the operations in the xcan_probe and xcan_remove functions.
>=20
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Applied to linux-can-next/testing

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--y7pxvzm5vjcfieof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFtOmQACgkQqclaivrt
76ksUggAm2ZWnU3CCSGRvLcFjJzgxAiS4yxJpOl6RxPGRWXuWM1cbV1Z9mLGHYjy
12Cd6AbHOPY604fxUZtqbTS/7gSoH8YxQvGACfipc6kWxPvAJ/tLrNNOm6iwjUWT
GZAdS9cmOPlWYjwgLwMoXqQ2Ql9F0p8kqafgyuFnfiexs1i7/XzNJRA3X+DXskAH
IEixjxp1yH80/rEvnW0n7c2ZowtVSTS6VP5k3+E8NbfKEVUGUkHlD3ZbqW3+9NdM
46Hq8fpyG2bUynANiVG4fIEqLaiUUXiELYXjq28QIk+64V1QNfQc+onnO6TKY/Sm
516tLD/oKmZ6lMui6zHnmnrhdbkI/w==
=oZ/W
-----END PGP SIGNATURE-----

--y7pxvzm5vjcfieof--
