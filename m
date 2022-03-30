Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D5A4EBC2F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbiC3H4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243123AbiC3H42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:56:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D052018C
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 00:54:43 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZT9t-0006Qu-Jg; Wed, 30 Mar 2022 09:54:25 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-5314-bece-822a-622d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:5314:bece:822a:622d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BC4C956C76;
        Wed, 30 Mar 2022 07:54:22 +0000 (UTC)
Date:   Wed, 30 Mar 2022 09:54:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ondrej Ille <ondrej.ille@gmail.com>
Cc:     Pavel Pisa <pisa@cmp.felk.cvut.cz>, linux-can@vger.kernel.org,
        devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v8 0/7] CTU CAN FD open-source IP core SocketCAN driver,
 PCI, platform integration and documentation
Message-ID: <20220330075422.4kxnayrdcxz7o5lo@pengutronix.de>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
 <202203220918.33033.pisa@cmp.felk.cvut.cz>
 <20220322092212.f5eaxm5k45j5khra@pengutronix.de>
 <202203221419.23089.pisa@cmp.felk.cvut.cz>
 <CAA7ZjpZbppBy_C+NyN4LWQF2-a-ktfjYeNELTzwsz4B-fBiTpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cn4afc3s4rdrhxit"
Content-Disposition: inline
In-Reply-To: <CAA7ZjpZbppBy_C+NyN4LWQF2-a-ktfjYeNELTzwsz4B-fBiTpw@mail.gmail.com>
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


--cn4afc3s4rdrhxit
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 30.03.2022 09:46:08, Ondrej Ille wrote:
> sorry for the late reply, my work duties are keeping me very busy.

Known problem :)

> Let me just quickly comment on topics discussed in the emails above.
>=20
> *1. Separation of PROP and TSEG1*
>=20
> IMHO there is no real benefit. The reason why CTU CAN FD has this
> split is legacy. First implementation back in 2015 had this split
> since I wanted to follow the standard. In HW, the first thing done in
> bit timing logic (prescaler module), these two numbers are added, and
> all further resynchronization/hard-synchronization is done with TSEG1
> value...

Thanks for the insight. It's not easy to get in touch with the
developers of the proprietary IP cores :)

Never the less, there's another IP core which has different sizes for
the prop and tseg1 register. So an update of the bit timing constant
would help both.

> *2. Number of TXT Buffers and RX Buffer size:*
>=20
> Pavel already replied with TXTB_INFO. The same role has the RX_MEM_INFO
> register, when it comes to RX side.

Thanks for the clarification.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--cn4afc3s4rdrhxit
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJEDKsACgkQrX5LkNig
011BUgf+NqPIJ6CCygkw/buy31ULqwkYdG2fEk72GHxm3xFCjGQ7hVGBD5VKA03s
t4Phc2iZYEmQhKIOtHRVV73LGLW7lTQoJoMfbrMZNSxZy0JVS+4W5a82U3f5+2BL
QW0OHSJ70ChwrMpprbA0Ziko/ij7eSYhliD5gJ5JN4xXNzx4QjGuxKe6s8n4FhUg
NA0uZueotu5rWScNkquy9GsE1Va1Nnrc0/a298V3ycjiSKTrWDJ9UXmBNHKyGohr
bJNUutzmGSdI9eLQHj/LbvGjPjnPV71maQKG2eGNgr4YNq2dA+cKGxnfoTFFmJOv
DjDdy0Mke7BS8jWrTnSpZWOnXXCirw==
=g9uh
-----END PGP SIGNATURE-----

--cn4afc3s4rdrhxit--
