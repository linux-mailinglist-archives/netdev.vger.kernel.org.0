Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC078646B98
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLHJMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiLHJL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:11:26 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C2C6F0EB
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:10:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p3CvK-0006Is-OM; Thu, 08 Dec 2022 10:10:34 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:92e:b9fb:f0e7:2adf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F365A1394AF;
        Thu,  8 Dec 2022 09:10:30 +0000 (UTC)
Date:   Thu, 8 Dec 2022 10:10:22 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org,
        Martin Elshuber <martin.elshuber@theobroma-systems.com>,
        Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Maximilian Schneider <mws@schneidersoft.net>,
        Peter Fink <pfink@christ-es.de>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Christoph =?utf-8?Q?M=C3=B6hring?= <cmoehring@christ-es.de>,
        John Whittington <git@jbrengineering.co.uk>,
        Vasanth Sadhasivan <vasanth.sadhasivan@samsara.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] can: usb: remove pointers to struct usb_interface in
 device's priv structures
Message-ID: <20221208091022.pbbalufnoprs3vxh@pengutronix.de>
References: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eyprsdigjtssnwep"
Content-Disposition: inline
In-Reply-To: <20221208081142.16936-1-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eyprsdigjtssnwep
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 08.12.2022 17:11:40, Vincent Mailhol wrote:
> The gs_can and ucan drivers keep a pointer to struct usb_interface in
> their private structure. This is not needed. For gs_can the only use
> is to retrieve struct usb_device, which is already available in
> gs_usb::udev. For ucan, the field is set but never used.
>=20
> Remove the struct usb_interface fields and clean up.

Applied to linux-can-next.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--eyprsdigjtssnwep
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmORqfwACgkQrX5LkNig
011peQf/fVbczowuYalMOjhee9GbgSsXvZQfoRDZLb/RW7/zAt6CbQDicGNIjaD5
VRq2k9hJtDBxbg/I/yvw/9wLIiXSPMt2fAIKrI69wHjAJryqr2C8bNC9CIY8oNqg
MvP0/uZSqNHKC1ocGa6F+FNs8ijISMduUManPycVi0tYzbgBwzPMGA107wnuCNDW
rNX+xyXS6IeXeb/2A1RJCsRoneRDU57zZEQ+htL79cyrVQxGig3sQcdDiq8kHlS/
uccPALroId48Mua/NV3O8GVHcal38iZdQLQki/Di93UvUQ1KHZisSoNEAq2y9O7U
LNW0bCTPiKbFWYo3eDWYwjHswFo5uw==
=f1vo
-----END PGP SIGNATURE-----

--eyprsdigjtssnwep--
