Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6C84B6597
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 09:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiBOINp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 03:13:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbiBOINm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 03:13:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AD147ADC
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 00:13:32 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nJsxk-0003ei-D6; Tue, 15 Feb 2022 09:13:28 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6A8023384F;
        Tue, 15 Feb 2022 08:13:27 +0000 (UTC)
Date:   Tue, 15 Feb 2022 09:13:24 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Schneider <max@schneidersoft.net>
Subject: Re: [RFC PATCH v1] can: gs_usb: change active_channels's type from
 atomic_t to u8
Message-ID: <20220215081324.gkrut2pa3l324rnu@pengutronix.de>
References: <20220214234814.1321599-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z4gra5dh4uqv6g3s"
Content-Disposition: inline
In-Reply-To: <20220214234814.1321599-1-mailhol.vincent@wanadoo.fr>
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


--z4gra5dh4uqv6g3s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15.02.2022 08:48:14, Vincent Mailhol wrote:
> The driver uses an atomic_t variable: gs_usb:active_channels to keep
> track of the number of opened channels in order to only allocate
> memory for the URBs when this count changes from zero to one.
>=20
> However, the driver does not decrement the counter when an error
> occurs in gs_can_open(). This issue is fixed by changing the type from
> atomic_t to u8 and by simplifying the logic accordingly.
>=20
> It is safe to use an u8 here because the network stack big kernel lock
> (a.k.a. rtnl_mutex) is being hold. For details, please refer to [1].
>=20
> [1] https://lore.kernel.org/linux-can/CAMZ6Rq+sHpiw34ijPsmp7vbUpDtJwvVtdV=
7CvRZJsLixjAFfrg@mail.gmail.com/T/#t
>=20
> Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN
> devices")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Looks good to me, added to linux-can/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--z4gra5dh4uqv6g3s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmILYKEACgkQrX5LkNig
013hGwgAlFjf104cx/rCg+L2FHCMMDuztd+6XhCPSU1in2Q2GNXL+HJE4qPPhDPN
VfwENmcf2yH2ecW/kIEducOGt8gl26gC9EzeCIEoiflepU9qfDJ/cqcgqPlP4gcG
kcbm+fAomoIrPCTI/UvLUFLX88Oiza1L3x4VaQqGZxevcmPWXzYNQGKosD0F3Oz1
FodizylGOSIBy+1g2xvAXc51Vhnkwo+5rRfZHJhbRzLFGrS9Fbim+QOOib0/hVLJ
cAbtI6TQ3CDqU2TBa1kN/BUbCrhzb2C0rOL1nPuTrvxyDF8pgxSeAqJsTJ/g+QGS
rOpyugIMCxyvPzjOtbz5oUao6I0NIA==
=tkn1
-----END PGP SIGNATURE-----

--z4gra5dh4uqv6g3s--
