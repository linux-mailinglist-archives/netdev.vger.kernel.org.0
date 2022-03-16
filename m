Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201E4DB9C1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358095AbiCPUwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiCPUwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:52:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AFF5A5BA
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:51:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUabo-0004XT-9i; Wed, 16 Mar 2022 21:51:04 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-0549-f74e-91ef-4d7d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:549:f74e:91ef:4d7d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B26144CBF7;
        Wed, 16 Mar 2022 20:51:03 +0000 (UTC)
Date:   Wed, 16 Mar 2022 21:51:03 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [net-next] can: isotp: sanitize CAN ID checks in isotp_bind()
Message-ID: <20220316205103.7bqn25fmmjomfwnf@pengutronix.de>
References: <20220315203748.1892-1-socketcan@hartkopp.net>
 <20220315185134.687fe506@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3922032f-c829-b609-e408-6dec83a0041a@hartkopp.net>
 <20220316074802.b3xazftb7axziue3@pengutronix.de>
 <7445f2f1-4d89-116e-0cf7-fc7338c2901f@hartkopp.net>
 <20220316080111.s2hlj6krlzcroxh6@pengutronix.de>
 <ec2adb66-2199-2f9d-15ce-6641562c54f2@hartkopp.net>
 <3892b065-59e0-3490-50ba-baa56f118859@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vxbfafwcak22w4gi"
Content-Disposition: inline
In-Reply-To: <3892b065-59e0-3490-50ba-baa56f118859@hartkopp.net>
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


--vxbfafwcak22w4gi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2022 17:49:35, Oliver Hartkopp wrote:
> Hi Marc,
>=20
> I sent a patch set with three patches on the CAN ML.
>=20
> Maybe it is just better when you pick them up for a regular process and s=
end
> a pull request to Jakub and Dave.

Done:
https://lore.kernel.org/all/20220316204710.716341-1-mkl@pengutronix.de/

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vxbfafwcak22w4gi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIyTbQACgkQrX5LkNig
011XeQf/Sv53S4yuP2SjVWpJ7Vakgd34QiqE5bDFnCXBuG/pI5854unYNTXZ2puS
s75vSXtfl8hDviEB4zOQ20jvxtje6jdCwxZ2XD7LNkJUgyd5rbUTIFOcvxbGSu7a
5Zinx+v8Hvotjc72ng3NU+MX5qyBcgy8tiNFuKSBG3h+XHbT8GS641xbyd4SHsUK
H2CHbDY1Bc8mXmDm6gx34hI4eNgQVtWQaikYi8HauzJHroWbpnDRR7OPjtdLmbi2
TPRJdRWmGd2usgTlMD/1hfXv53CbddxLnZhUHJnws19yOzBIsIG1VV7gPhNUvFuA
62SIMSIvj5T15lWa53NVG+xj0ndn8A==
=ji+0
-----END PGP SIGNATURE-----

--vxbfafwcak22w4gi--
