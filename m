Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8892068DA1F
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjBGOHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:07:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbjBGOG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:06:59 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90222C9
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 06:06:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPObi-0008HA-7V; Tue, 07 Feb 2023 15:06:02 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:b5cc:20f3:3e4b:3812])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4AC0617277A;
        Tue,  7 Feb 2023 14:06:00 +0000 (UTC)
Date:   Tue, 7 Feb 2023 15:05:52 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Robin van der Gracht <robin@protonic.nl>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: j1939: do not wait 250 ms if the same addr was
 already claimed
Message-ID: <20230207140552.bhsq5a2j5rxmwlao@pengutronix.de>
References: <20221124051611.GA7870@pengutronix.de>
 <20221125170418.34575-1-devid.filoni@egluetechnologies.com>
 <20221126102840.GA21761@pengutronix.de>
 <1ae01ab918876941dc57d01d4c2f1d7376dda87b.camel@egluetechnologies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tjaisgwns5axhr7i"
Content-Disposition: inline
In-Reply-To: <1ae01ab918876941dc57d01d4c2f1d7376dda87b.camel@egluetechnologies.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
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


--tjaisgwns5axhr7i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 07.02.2023 14:50:15, Devid Antonio Filoni wrote:
[...]
> I noticed that this patch has not been integrated in upstream yet. Are
> there problems with it?

Thanks for the heads up, I've send a PR.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tjaisgwns5axhr7i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmPiWr4ACgkQvlAcSiqK
BOhGygf/UdoRT6XNx2iC0H5I6wLEb8zsIOtlwzphvfAavWLy78Ri/GZTCLVHkGA1
9K0HV5AKAqrUjp24bfJ5oiYGBymKqV8R4Dw9NpLebF8NqdZ58WtP1Ejx4oC4c6Rv
JqvUObqQ5+7zEveK3jDgFl5wQTqyf2vf7IhcOcURCGat/dxrcnuSrDT4wwt1gg5F
H5Nn80rZjEPeQniFFVXA2ivAdGqQIhLV1Setps1czVPF/yMvGXMgYamGVkIEgnY6
ecgFdwlmKNdr5rN4Oa+crofLXcN0OSc+SS51EZ6LM8u6jZuwDDXajyc6t2LkC+YG
OwmZ2asb6dhMBxy21krSdjGvmdnHQQ==
=Quy/
-----END PGP SIGNATURE-----

--tjaisgwns5axhr7i--
