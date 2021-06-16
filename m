Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874913A97A2
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhFPKjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 06:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbhFPKjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 06:39:13 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76922C06175F
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 03:37:07 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltSuj-0000mm-Io; Wed, 16 Jun 2021 12:36:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E9D1B63D201;
        Wed, 16 Jun 2021 10:36:49 +0000 (UTC)
Date:   Wed, 16 Jun 2021 12:36:49 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] can: at91_can: use DEVICE_ATTR_RW() helper macro
Message-ID: <20210616103649.jruqlbvmlfdcnean@pengutronix.de>
References: <20210603100233.11877-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xwqrfzab6iau3iqs"
Content-Disposition: inline
In-Reply-To: <20210603100233.11877-1-thunder.leizhen@huawei.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xwqrfzab6iau3iqs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.06.2021 18:02:33, Zhen Lei wrote:
> Use DEVICE_ATTR_RW() helper macro instead of plain DEVICE_ATTR(), which
> makes the code a bit shorter and easier to read.

Applied all 3 (at91, esd_usb2 and janz-ican3) to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xwqrfzab6iau3iqs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDJ1D4ACgkQqclaivrt
76mSVwf+IsQQ73cBL6el5+JaZ1HMA1Yjuudm/D5qR0Ww0wYosFVXIdtMfzP48zjr
qNfFcD1X6GgrBTs9OsDUdLx0iFCcE+cFhkwJzMAwK+7VV5kOO64o1P+HQFfXpCmY
NOKfB5kxffLL6U58qns8WJePqpUKUzuyOtsp3slssC8hGReOoB8ANQ3ZqUigiRAX
7TSU1XHdNaLLVJHVAEikHbNoAq6txGKg+8S+AIG8g/WGx5pROWFqHxQRYxoNtU4S
PjnxATtO+FksYqySmPS79TLmVCdBOWOsUPg4KloeD+SaKinGVr413iaz7ZhtElCJ
fne21EyEFCm52Ef8g8VtOy05F1NwlA==
=lasF
-----END PGP SIGNATURE-----

--xwqrfzab6iau3iqs--
