Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9825D3E40AF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 09:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhHIHJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 03:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233161AbhHIHJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 03:09:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C9BC061796
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 00:09:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mCzPB-0007u0-22; Mon, 09 Aug 2021 09:09:01 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:565a:9e00:3ca4:4826])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DA85866308D;
        Mon,  9 Aug 2021 07:08:55 +0000 (UTC)
Date:   Mon, 9 Aug 2021 09:08:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/4] can: c_can: cache frames to operate as a true FIFO
Message-ID: <20210809070854.wwqealdhd2sai5mo@pengutronix.de>
References: <20210807130800.5246-1-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ay6iz3pyqwovhyef"
Content-Disposition: inline
In-Reply-To: <20210807130800.5246-1-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ay6iz3pyqwovhyef
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.08.2021 15:07:56, Dario Binacchi wrote:
>=20
> Performance tests of the c_can driver led to the patch that gives the
> series its name. I also added two patches not really related to the topic
> of the series.
>=20
> Run test succesfully on a custom board having two CAN ports.
> I connected the CAN1 port to the CAN2 port with a cable. Then I
> opened two terminals. On one I issued a dump command and on the
> other the transmit command used in the tests described in
> https://marc.info/?l=3Dlinux-can&m=3D139746476821294&w=3D2.

Thanks! Applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ay6iz3pyqwovhyef
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEQ1IMACgkQqclaivrt
76mypggAlneAs4NSSW3S+G3/q1nOv7cdt5e//scBTcElGf6JbAL8kcJFZ5PcQFbR
R3c/CAPgIk/NpU+6xBHBJfijxWOVYQhx2txEtcWPpClTRjwKM04/SYDU3ilVx3t9
3xe3/943AhxOeZ+nOfWWAceyxuprlcJAigMLKcalqwTwQlQOr1BIz9PEALXJ2Wo0
mCHhJpSVhQupUczLlOR3zTVTY6+WjSrfNLI630EZWX9pYb2J4gXhlqwZzpiqYr8h
OoHnM14rOfbz5ND56+xS7dCGKNgsf8vwff8AskDcMbHQul7j+1bD4m/2l+EgTUGx
uxGYNxMYF/Op+c6cCuBD721Q1Sw4Yg==
=6OpO
-----END PGP SIGNATURE-----

--ay6iz3pyqwovhyef--
