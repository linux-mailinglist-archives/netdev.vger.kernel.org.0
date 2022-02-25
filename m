Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5054C4B4B
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238399AbiBYQso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242717AbiBYQsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:48:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DE11BBF42
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:48:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nNdl2-0002vs-Fv; Fri, 25 Feb 2022 17:47:52 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-c8b7-5627-f914-a39f.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c8b7:5627:f914:a39f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 777263D845;
        Fri, 25 Feb 2022 16:47:50 +0000 (UTC)
Date:   Fri, 25 Feb 2022 17:47:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Subject: Re: [PATCH] can: rcar_canfd: Register the CAN device when fully ready
Message-ID: <20220225164750.stt7xrlteqskt3n5@pengutronix.de>
References: <20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="62tn3zuzt65dpeai"
Content-Disposition: inline
In-Reply-To: <20220221225935.12300-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
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


--62tn3zuzt65dpeai
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.02.2022 22:59:35, Lad Prabhakar wrote:
> Register the CAN device only when all the necessary initialization
> is completed. This patch makes sure all the data structures and locks are
> initialized before registering the CAN device.

Applied to can/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--62tn3zuzt65dpeai
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIZCDMACgkQrX5LkNig
013w0gf9GHv8h+twoAJc+oj+ZtApGB6lXKUKpDTYt4HXx5gytxU287sJ1uTxRLgy
4OyhPc4csoPX1ENy4De+1yeeUAmWeh6gR0/l+aZaki7NmT8U+ZdAKjnCbs4Y+REg
mgXQmnDaGLIUOkW0b0IatgZsxAd+iEGXUNhin+aMfr6f5tP1WV6xYOn06XXCPf7u
HMd72JJged+tSv4k/BrVKbiGvKHYe85HqJXuWtpuy/A7y3rRS68Zg0h0DhHyAIM/
zENW76mnvEnI65hwWNOI+wXF15FK86cdLUj0nk71Uz0ckNULgOFitLjbOPRryqhp
EWsyXs7/kJSBBrsgANUL+C5NYr3d0w==
=wlL+
-----END PGP SIGNATURE-----

--62tn3zuzt65dpeai--
