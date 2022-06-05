Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C5C53DD8C
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348375AbiFESJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 14:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346682AbiFESJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 14:09:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD172B279
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 11:08:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxugJ-0001D5-DA; Sun, 05 Jun 2022 20:08:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8EA3B8C914;
        Sun,  5 Jun 2022 18:08:54 +0000 (UTC)
Date:   Sun, 5 Jun 2022 20:08:54 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220605180854.wry2wczguswaahg5@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
 <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
 <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
 <20220604151859.hyywffrni4vo6gdl@pengutronix.de>
 <CAMZ6RqK45r-cqXvorUzRV-LA_C+mk6hNSA1b+0kLs7C-oTcDCA@mail.gmail.com>
 <20220605103909.5on3ep7lzorc35th@pengutronix.de>
 <CAMZ6RqLfJ8v+=HcSU8yprXeR8q8aSOsg4i379D9rZgE9ZmC=fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e7jgsbsz7vpuyfms"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLfJ8v+=HcSU8yprXeR8q8aSOsg4i379D9rZgE9ZmC=fg@mail.gmail.com>
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


--e7jgsbsz7vpuyfms
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2022 22:57:03, Vincent MAILHOL wrote:
> > /me just realized that merged are independent of pull requests. I can
> > create a local branch and merge it, as Davem and Jakub do it. I've added
> > your v5 to can-next/master as a merge and I'll include this in my next
> > PR to net-next if Davem and Jakub are OK with merges in my branch.
>=20
> So my dreams of getting my kernel.org account swag just evaporated
> (just kidding :))

No!

> I think I will prepare a GPG key just to be ready in the opportunity
> to get it signed pop-up one day.
>=20
> Happy to see that this is reaching an end. Honestly speaking, the
> menuconfig cleanup was not my most exciting contribution (euphemism)
> but was still a necessity.

Thanks for the persistence!

> Glad that this is nearly over after more
> than 80 messages in the full thread (including all five versions). If
> I recall correctly, this is the longest thread we had in the last two
> years. And thanks again to Max, Oliver and you for animating the
> debate!

So the longest-thread-badge goes definitely to you!

Thanks again,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e7jgsbsz7vpuyfms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKc8TMACgkQrX5LkNig
012qDAgAkxoqM1lCOeQSO/i/ImgmtKGiGJk9G3mWjZ6rjazclepXFOlNCI/sahDs
Q6P0xVjutQXkAz3DD0Oajwvawyp0U9dHkZV4yI/JNKNJi5jJ/E4DqwjMb1SyaefB
9u5E2e2id6+hADctI5fs4fZ/iK2bnXeytSev0DzRoOFYSFRrroAsaTpu/Us8SaSm
RgK9YOpzOReo+u3uKLMgFQ2F/edk7VT8n9QgjyClG9NGiN/WagzFPewpOuM0TiCk
EPqoztTNGxVC3jRezbGNOdpj60O+nXFJW2xkuQPCNgWVNk22YFO0OPhYgtVpHzeI
ed2pr+qXm4bigRhO7JW2gOUaSaILFA==
=GA7q
-----END PGP SIGNATURE-----

--e7jgsbsz7vpuyfms--
