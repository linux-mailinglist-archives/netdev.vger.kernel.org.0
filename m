Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656DC6EDEFB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 11:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbjDYJSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 05:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjDYJSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 05:18:10 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE58F2103
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 02:18:05 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1prEnf-0007gm-LC; Tue, 25 Apr 2023 11:17:27 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2DB771B6C6E;
        Tue, 25 Apr 2023 09:17:21 +0000 (UTC)
Date:   Tue, 25 Apr 2023 11:17:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [PATCH] can: virtio-can: cleanups
Message-ID: <20230425-oxidizing-blandness-ca9cc2cf114e-mkl@pengutronix.de>
References: <20230424-modular-rebate-e54ac16374c8-mkl@pengutronix.de>
 <20230424170901-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wrzhwsd3655udnop"
Content-Disposition: inline
In-Reply-To: <20230424170901-mutt-send-email-mst@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wrzhwsd3655udnop
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24.04.2023 17:09:23, Michael S. Tsirkin wrote:
> On Mon, Apr 24, 2023 at 09:47:58PM +0200, Marc Kleine-Budde wrote:
> > Address the topics raised in
> >=20
> > https://lore.kernel.org/20230424-footwear-daily-9339bd0ec428-mkl@pengut=
ronix.de
> >=20
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> given base patch is rfc this should be too?

This is an incremental patch that fixes the topics I raised in the
review of "[RFC PATCH v2] can: virtio: Initial virtio CAN driver.", see
linked discussion thread.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--wrzhwsd3655udnop
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmRHmp0ACgkQvlAcSiqK
BOhdHwf/elII+CN8WhgoClA6Y9+l7RyecrlVcqKWmgZNO5hTG6BmvkzP//T6m9Lq
3XEmvI6TFszxDp+0yHDIaRS1fqBDCKaSpjRZEozRyE1df4BH7XBFIkcVyI5M3oEZ
BJ6O94BtlJ+/vlg5pn9mebyFo6TYwaHLQuVwVcB9Gxc3S6JGqgYcE0N6uW2hdr9t
0tk/zZTu+jwul+wlzo1vhd/xkmpiGshP2Z5TCJA8XkAokqz4LcLxOfGtSKS6Xey8
4+qgTgCDpkkX+yhAZrycTfQii7JcMxbOtnBjGONXMkG3vMQo2ueIDaonqlGLvC+/
WWX2HB7sfw7YZMKZ5h7ov7ottPC2ew==
=7r0O
-----END PGP SIGNATURE-----

--wrzhwsd3655udnop--
