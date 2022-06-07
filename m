Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F1153FAF9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbiFGKPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbiFGKPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:15:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817BBC8BC2
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:15:41 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nyWFI-0007ir-LV; Tue, 07 Jun 2022 12:15:32 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 234908DAF7;
        Tue,  7 Jun 2022 10:15:31 +0000 (UTC)
Date:   Tue, 7 Jun 2022 12:15:30 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 03/13] can: slcan: use the alloc_can_skb() helper
Message-ID: <20220607101530.54gezhyq6goxwckz@pengutronix.de>
References: <20220607094752.1029295-1-dario.binacchi@amarulasolutions.com>
 <20220607094752.1029295-4-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="r3lgh2urouzfbnrf"
Content-Disposition: inline
In-Reply-To: <20220607094752.1029295-4-dario.binacchi@amarulasolutions.com>
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


--r3lgh2urouzfbnrf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.06.2022 11:47:42, Dario Binacchi wrote:
> It is used successfully by most (if not all) CAN device drivers. It
> allows to remove replicated code.

While you're at it, you can change the function to put the data into the
allocated skb directly instead of first filling the "cf" on the stack
and then doing a memcpy();

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--r3lgh2urouzfbnrf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKfJUAACgkQrX5LkNig
011FFQf/e7SAr4zvYs50K56wjpR7g5D+cUH7S1ta0y07du1xPlxbJM5aYvJyoSE9
TfkFuoj77+DEbtnJz3BcmqseB2GE76YvkcyLLCdyWyY41wgCCFSzKcU4vCZ7SdlT
Koia7yO4YlqJm1keua9OKVhtGVeP5xOgRmhuzLJkHKhO+Mg10MX0y8pXHIrinuCN
+xIroJWNVd/I3Xwd5O+svnQgW60+8rfqb9/Lvx9zT89dD/fvXnr9Kjtd4nkljYjT
/r//8CzmgWszLomt+7Yb+khwOpIsvEp2c2eyv/pKYuuX6vyzQ6F9fhRE5F4+i42g
kJsP+Z+1S+mws9gb5Wm8Z1ttmvV28w==
=lReK
-----END PGP SIGNATURE-----

--r3lgh2urouzfbnrf--
