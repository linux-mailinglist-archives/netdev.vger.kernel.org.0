Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2AB430941
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 15:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343661AbhJQNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242195AbhJQNKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 09:10:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8921BC061768
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 06:08:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc5tc-0000CJ-Cn; Sun, 17 Oct 2021 15:08:12 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7b24-848c-3829-1203.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7b24:848c:3829:1203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 52FD4695D2C;
        Sun, 17 Oct 2021 13:08:09 +0000 (UTC)
Date:   Sun, 17 Oct 2021 15:08:08 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH v2] can: rcar_can: Fix suspend/resume
Message-ID: <20211017130808.fxyzq6yqh44lirlf@pengutronix.de>
References: <20210924075556.223685-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="aq4mbtvzmu7apxyo"
Content-Disposition: inline
In-Reply-To: <20210924075556.223685-1-yoshihiro.shimoda.uh@renesas.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--aq4mbtvzmu7apxyo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.09.2021 16:55:56, Yoshihiro Shimoda wrote:
> If the driver was not opened, rcar_can_suspend() should not call
> clk_disable() because the clock was not enabled.
>=20
> Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Ayumi Nakamichi <ayumi.nakamichi.kf@renesas.com>
> Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
> Tested-by: Biju Das <biju.das.jz@bp.renesas.com>

Applied to linux-can/testing, added stable on Cc.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--aq4mbtvzmu7apxyo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsIDUACgkQqclaivrt
76lbmwf9HpboAd6PqC5qPwslXUSCzVSpHfjs+6wWUmHFFetBdjB2Al3O1va0pADI
xeCbcQmEkRSW6rXj6KTH2ryzsttm4b/NvCCjVvOB2RbP/uE5mi6L27Jq+U/5Woxk
2KD5Zd/gqlnXC3Ig4zX0TI5zUD6PkuSm3SfVyIpYBpbG3JmsirEgwLz31amc0Jep
ejzNnvB+r4UHaP80uIqewXSxOT2kfzy/c8hV3WRAOsRXegj+Xp0hUNDJRfzqjnYI
dG07U2NwRGpxkdVk0sph63lznasRJBpsnWoBIM0/ODkykEbrhkrQV4ZKEatbinIe
xJVadI3aoXXxcG08enq6//lSSjOP1g==
=xTRR
-----END PGP SIGNATURE-----

--aq4mbtvzmu7apxyo--
