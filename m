Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F8A446EEF
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 17:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbhKFQ3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 12:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbhKFQ3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 12:29:48 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0124C061570
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 09:27:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjOWr-0005tR-Lh; Sat, 06 Nov 2021 17:26:53 +0100
Received: from pengutronix.de (dialin-80-228-153-084.ewe-ip-backbone.de [80.228.153.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D8A7F6A5DC6;
        Sat,  6 Nov 2021 16:26:48 +0000 (UTC)
Date:   Sat, 6 Nov 2021 17:26:47 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] can: j1939: fix some standard conformance
 problems
Message-ID: <20211106162647.qgejhws3osmxfjuq@pengutronix.de>
References: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q4cbyovnoxxgd3sj"
Content-Disposition: inline
In-Reply-To: <1635431907-15617-1-git-send-email-zhangchangzhong@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q4cbyovnoxxgd3sj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2021 22:38:24, Zhang Changzhong wrote:
> This patchset fixes 3 standard conformance problems in the j1939 stack.

Applied to linux-can/testing added stable on Cc.

thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--q4cbyovnoxxgd3sj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmGGrMQACgkQqclaivrt
76kGVAgAqDNbF9848DnAPt5t+jSSaEB38fCyUZdbe/XPnNnB8vdIlUDQsJc9NrQD
AEnqKIZr6eZ8ZzL5xV2zpa81hMVOakpvO0v3fhpDNnw4QkJ3EL89jURPyc1/HCfF
RSBHTS7PLMuXokjfiWtqmSYw1F3LqwF1oMScV7j6D5i202s/R8H7oHwQoJ5Akugz
cqVSphTe3XpgSs3Bt4rKPt8jhOmq61GoIILPXxKOq4aLb4iANQxdDTJT8rwfvLFO
5650A0nXMvKFx4NN5GOuakQDxbzRkI3elekoEkgPoiyBJSwydTqQ6rJQpmNHPqAf
GrdvOJe/kzwi+s2HNc5bMBf63CVZcw==
=38/T
-----END PGP SIGNATURE-----

--q4cbyovnoxxgd3sj--
