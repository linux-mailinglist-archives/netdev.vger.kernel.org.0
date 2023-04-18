Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229126E60AE
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDRMI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjDRMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:08:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2060B762
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 05:06:57 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pok6b-0004Ph-Q3; Tue, 18 Apr 2023 14:06:41 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B607A1B218A;
        Tue, 18 Apr 2023 12:06:39 +0000 (UTC)
Date:   Tue, 18 Apr 2023 14:06:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Harald Mommer <hmo@opensynergy.com>
Cc:     Mikhail Golubev <Mikhail.Golubev@opensynergy.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Harald Mommer <harald.mommer@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        stratos-dev@op-lists.linaro.org,
        Matti Moell <Matti.Moell@opensynergy.com>
Subject: Re: [virtio-dev] Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
Message-ID: <20230418-pull-negligee-f253a3c8e7db-mkl@pengutronix.de>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
 <40e3d678-b840-e780-c1da-367000724f69@opensynergy.com>
 <c2c0ba34-2985-21ea-0809-b96a3aa5e401@siemens.com>
 <36bb910c-4874-409b-ac71-d141cd1d8ecb@app.fastmail.com>
 <c20ee6cf-2aae-25ef-e97f-0e7fc3f9c5b6@opensynergy.com>
 <20230414-scariness-disrupt-5ec9cc82b20c-mkl@pengutronix.de>
 <9786872e-1063-e1ff-dc0d-6be5952a1826@opensynergy.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qbejfhwai7v6uczb"
Content-Disposition: inline
In-Reply-To: <9786872e-1063-e1ff-dc0d-6be5952a1826@opensynergy.com>
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


--qbejfhwai7v6uczb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.04.2023 11:50:56, Harald Mommer wrote:
> there is now an implementation of the device for qemu internally under
> review.

Great news!

> The paperwork with the company lawyer to publish source code has also been
> done.

This was probably more work than the actual coding :)

> At the same time we changed the driver and the specification draft also,
> especially the bus off indication is now done by a config space bit inste=
ad
> of having a dedicated indication queue. Minor updates to some other
> structures. This means what we have will match an updated driver and
> specification version not yet sent out. Also to be done so that people can
> play around.

Looking forward to see the code.

> So an open source qemu device is in the work and we are close to publish
> this in our public github repository but until now nothing has been pushed
> yet to github.

Next week is our yearly hacking week. Some working qemu and Linux
drivers would be excellent.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--qbejfhwai7v6uczb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQ+h8wACgkQvlAcSiqK
BOiFFgf/XM5nIh2LYk0Iu4Ns08EGdD12H+7cz4mwTAm26MgLjkcJGG5bEMD4AZ6e
OnrKmz+c7hsBk0h+BwF18phQqH3prdje2vnKaczvjD4iNnpId57mCu2hNWP05NhP
x46zraLhQwcy3qS5qpki9gWAV4oMzSAFBhZpV2qp4wwy0HMc2MQhefzJgCa1HxVg
emwNT/3vuf38IslMUlSqZGsnKhCvOajZVTcyo1hpo5DSVf3J0aYWXNRJj/bGaHS3
3KNXmRQjvCCRi5u8VJyYIEp3FGMK6cGtWiNMX+TkIRH6uO/PK9yjLcz/N+1RJbzH
uTR79ceo/ekik35HjzYGnUCxgmtmpw==
=LT/a
-----END PGP SIGNATURE-----

--qbejfhwai7v6uczb--
