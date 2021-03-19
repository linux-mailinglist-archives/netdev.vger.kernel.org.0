Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB86C3419C5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhCSKSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhCSKSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:18:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D54C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 03:18:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lNCCi-00024f-GX; Fri, 19 Mar 2021 11:18:04 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:7ffa:65dd:d990:c71d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 787D45FA7C7;
        Fri, 19 Mar 2021 10:18:03 +0000 (UTC)
Date:   Fri, 19 Mar 2021 11:18:02 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] can: isotp: tx-path: zero initialize outgoing CAN
 frames
Message-ID: <20210319101802.qqp7ejj3rel7ejox@pengutronix.de>
References: <20210319100619.10858-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p4lv7vv5c4eqbwae"
Content-Disposition: inline
In-Reply-To: <20210319100619.10858-1-socketcan@hartkopp.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p4lv7vv5c4eqbwae
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.03.2021 11:06:19, Oliver Hartkopp wrote:
> Commit d4eb538e1f48 ("can: isotp: TX-path: ensure that CAN frame flags are
> initialized") ensured the TX flags to be properly set for outgoing CAN
> frames.
>=20
> In fact the root cause of the issue results from a missing initialization
> of outgoing CAN frames created by isotp. This is no problem on the CAN bus
> as the CAN driver only picks the correctly defined content from the struct
> can(fd)_frame. But when the outgoing frames are monitored (e.g. with
> candump) we potentially leak some bytes in the unused content of
> struct can(fd)_frame.
>=20
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied to linux-can/testing

thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--p4lv7vv5c4eqbwae
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBUelgACgkQqclaivrt
76kmLQf+IAXsmtFPKXsfDEjtdNqAyjdFikX+6MzPuuqw91Dm+MBZmM+qRQM2GMJT
IsRSYunlac+ODmdW+BXDzPmMcElFcAIjp8mb3ItvJTYoAFBh4sWFDyJv/JtFEsbX
dcjUeZe6h87SS7iFSztYoLPyFPGl+Fp77J22IIxu/JfRMLhIbmrSWH+g6aXAqi6f
4jT/YwA34UluODm3+BkEmUzmM7UMPam2ti1NPoI9WbhvxvMu/uIMY3LtFaJycvvl
gA9vOpwmfNT61FUP+3ak7652VudMKNgfh0UDwNw7DoeLtKLClgA1JlkE/2deF05k
GxAHaGS8h4TI3wJTKo4JN7hiRuvLoA==
=fKV1
-----END PGP SIGNATURE-----

--p4lv7vv5c4eqbwae--
