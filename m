Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4084AEC7C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241510AbiBIIcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:32:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241560AbiBIIcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:32:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC25DC050CD2
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 00:32:15 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nHiON-0007nf-Pu; Wed, 09 Feb 2022 09:31:59 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D988B2EF8B;
        Wed,  9 Feb 2022 08:31:58 +0000 (UTC)
Date:   Wed, 9 Feb 2022 09:31:55 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <sneeli@xilinx.com>
Cc:     "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Appana Durga Kedareswara Rao <appanad@xilinx.com>,
        Srinivas Goud <sgoud@xilinx.com>, git <git@xilinx.com>
Subject: Re: [PATCH] can: xilinx_can: Add check for NAPI Poll function
Message-ID: <20220209083155.xma5m7tayy2atyoo@pengutronix.de>
References: <20220208162053.39896-1-srinivas.neeli@xilinx.com>
 <20220209074930.azbn26glrxukg4sr@pengutronix.de>
 <DM6PR02MB53861A46A48B4689F668BEE9AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ghoqq6pqwpgc7xyw"
Content-Disposition: inline
In-Reply-To: <DM6PR02MB53861A46A48B4689F668BEE9AF2E9@DM6PR02MB5386.namprd02.prod.outlook.com>
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


--ghoqq6pqwpgc7xyw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.02.2022 08:29:55, Srinivas Neeli wrote:
> > On 08.02.2022 21:50:53, Srinivas Neeli wrote:
> > > Add check for NAPI poll function to avoid enabling interrupts with out
> > > completing the NAPI call.
> >=20
> > Thanks for the patch. Does this fix a bug? If so, please add a Fixes:
> > tag that lists the patch that introduced that bug.
>=20
> It is not a bug. I am adding additional safety check( Validating the
> return value of "napi_complete_done" call).

Thanks for your feedback. Should this go into can or can-next?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ghoqq6pqwpgc7xyw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIDe/gACgkQrX5LkNig
011/twf9GGBR2QEXqjnEmw/xzHM60lmxr6bpT4M7YV7fCn4qqpSmKiNJvO8CbePC
Zyv7vyArUWuFtHsCOn4tEQeUr++ssJ82IPKWYBoO/AnNuU/XBid0J7n5cQP/B/ke
AQiGc9kPruEo5hI/yHXQEcWuehl40v9Xu7rEf7Mik/LaWc34ELzbTavxKEgVzyeY
BYKWU0J/yzgBPRzMAU49gS1Eb9+QYfT2KxjlVEcplbnhrAg6qHxGPGDKZNpxO6q+
JQIZXzTUnDAjkDGC0D7/rP4Z0l5yxhs2wedwMyEEZ9HPIUnJRbMIT0xe9WFdAxpw
3UUl4Jk056IshF5rZ6mRfqSSTm+jxg==
=1RHL
-----END PGP SIGNATURE-----

--ghoqq6pqwpgc7xyw--
