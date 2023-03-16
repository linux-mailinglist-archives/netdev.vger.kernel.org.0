Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB17C6BD48C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjCPP7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCPP7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:59:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83263ABB24
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:59:10 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pcpzT-0001Wg-0O; Thu, 16 Mar 2023 16:58:07 +0100
Received: from pengutronix.de (unknown [IPv6:2a00:20:3043:e035:5ae3:9609:678c:e1fb])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EEF27194E2F;
        Thu, 16 Mar 2023 15:57:59 +0000 (UTC)
Date:   Thu, 16 Mar 2023 16:57:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, dccp@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-can@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-x25@vger.kernel.org,
        mptcp@lists.linux.dev, rds-devel@oss.oracle.com,
        tipc-discussion@lists.sourceforge.net,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 28/28] sock: Remove ->sendpage*() in favour of
 sendmsg(MSG_SPLICE_PAGES)
Message-ID: <20230316155758.5ylpybqjma7x4lbs@pengutronix.de>
References: <20230316152618.711970-1-dhowells@redhat.com>
 <20230316152618.711970-29-dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="km5oeoth2y26yqyc"
Content-Disposition: inline
In-Reply-To: <20230316152618.711970-29-dhowells@redhat.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--km5oeoth2y26yqyc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.03.2023 15:26:18, David Howells wrote:
> [!] Note: This is a work in progress.  At the moment, some things won't
>     build if this patch is applied.  nvme, kcm, smc, tls.
>=20
> Remove ->sendpage() and ->sendpage_locked().  sendmsg() with
> MSG_SPLICE_PAGES should be used instead.  This allows multiple pages and
> multipage folios to be passed through.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>

> cc: linux-can@vger.kernel.org

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de> # for net/can

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--km5oeoth2y26yqyc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQTPIMACgkQvlAcSiqK
BOj6JAgAtfBV5yq+uNvtDfdNTDCgUnr0pkrsEqo0Ygt0A84TUlJF1K9QFkFTlvFo
NEtegJFeDvbE8EmvRgOnpoTRcMQwDClaw5c7O7TquCr3SEAcXECesFYUVLWR7hsf
Mk3DzSWUNIqMeSUOAEPBPfWNGGQWdjut5IQHdhuIs2/irjgsb5GZJ27rYyV9F/+l
daE1Ac6RGnKq9zV/UszZ7AbfKA7bI9TVioWBVmIFCQZeWJprHq5rD0LTH6+QjdyQ
5AdUTjTbZ/YRTjr4KQQkISfoq8oMC/zVENiagYZ89SGTbciIaCeqBpvdgUVKTob6
2Uoo/o+yUY90Dy8JPw9/gLSsthDGaw==
=IhKV
-----END PGP SIGNATURE-----

--km5oeoth2y26yqyc--
