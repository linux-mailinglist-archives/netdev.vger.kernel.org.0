Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208623ADBA6
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 22:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFSUXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 16:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFSUXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 16:23:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9324EC061574
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 13:21:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luhT0-0005PM-Pt; Sat, 19 Jun 2021 22:21:22 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:8352:71b5:153f:5f88])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id DD39363F796;
        Sat, 19 Jun 2021 20:21:19 +0000 (UTC)
Date:   Sat, 19 Jun 2021 22:21:19 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH net-next 0/8] net: at91_can: clean up some code style
 issues
Message-ID: <20210619202119.4xkssewsebtg76rn@pengutronix.de>
References: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bwh3gyhihsre2tqm"
Content-Disposition: inline
In-Reply-To: <1624096589-13452-1-git-send-email-huangguangbin2@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bwh3gyhihsre2tqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19.06.2021 17:56:21, Guangbin Huang wrote:
> This patchset clean up some code style issues.
>=20
> Peng Li (8):
>   net: at91_can: remove redundant blank lines
>   net: at91_can: add blank line after declarations
>   net: at91_can: fix the code style issue about macro
>   net: at91_can: use BIT macro
>   net: at91_can: fix the alignment issue
>   net: at91_can: add braces {} to all arms of the statement
>   net: at91_can: remove redundant space
>   net: at91_can: fix the comments style issue
>=20
>  drivers/net/can/at91_can.c | 131 +++++++++++++++++++++------------------=
------
>  1 file changed, 60 insertions(+), 71 deletions(-)

Applied whole series to linux-can-net/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bwh3gyhihsre2tqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDOUbwACgkQqclaivrt
76mu+Qf/dhaGIXcctaGvvJT3V7K6THcZgPMDatr4LWFwKVBTz/yO6pDRmYy8Cd4Z
HmLRJzcSOTZHK4CHv7IDLJ4GHwYQi1yPszSEfV0Dbaqfwe7SNaNAvtaUNPXM9YQA
NA0k0bBOQFtOxAl4mYegtIkR3c3im9zli2hnc3RDDtfuRLmd4u4zxJDdIPITE0Ok
Is9qJZ0vaB3Eoyc1A74dwsRqq/83v+ioRoEHPTAYDUf3qYw0/qBgsZ9Ui+cxvR1+
3s8aAaJWZ0h251B7qb8Wx6IBn3QM/q1O1Ai+t/PGbKvC4NfAaEvuFnMRmFUszLhJ
RRpfXU5iVTvt1sx6D2tDVUb09MK6sg==
=QhqL
-----END PGP SIGNATURE-----

--bwh3gyhihsre2tqm--
