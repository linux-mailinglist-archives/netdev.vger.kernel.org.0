Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8734802CC
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 18:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhL0R3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 12:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhL0R3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 12:29:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEB7C06173E
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 09:29:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n1tna-0006qz-7p; Mon, 27 Dec 2021 18:28:38 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-8412-c786-637d-2154.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:8412:c786:637d:2154])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 39EF76CC499;
        Mon, 27 Dec 2021 17:28:21 +0000 (UTC)
Date:   Mon, 27 Dec 2021 18:28:20 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        John Garry <john.garry@huawei.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-csky@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [RFC 17/32] net: Kconfig: add HAS_IOPORT dependencies
Message-ID: <20211227172820.hbxdrrkyezdzrlr6@pengutronix.de>
References: <20211227164317.4146918-1-schnelle@linux.ibm.com>
 <20211227164317.4146918-18-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="245rarqcf5vldb7b"
Content-Disposition: inline
In-Reply-To: <20211227164317.4146918-18-schnelle@linux.ibm.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--245rarqcf5vldb7b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.12.2021 17:43:02, Niklas Schnelle wrote:
> In a future patch HAS_IOPORT=3Dn will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them.
>=20
> Co-developed-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Arnd Bergmann <arnd@kernel.org>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
>  drivers/net/can/cc770/Kconfig    | 1 +
>  drivers/net/can/sja1000/Kconfig  | 1 +

For the CAN drivers:

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--245rarqcf5vldb7b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmHJ97AACgkQqclaivrt
76kJwQf/YZuHeaxAaIqpnKk5ebNRkZaiADk2wY6053aiOFrchhX+W6rdKv6mgiIg
f/nVGw6D52LCXz7TTZXQn/TUWv+CUMoiLLHANURD4f5qkVSjryI/mAFmnKnm0ip7
abEryjHc+LdLl+zuBJEuD8nkvhV6MOa5WoYxpyBpMHWmK6zlXBV70Qcv+RNmuaQK
1KHD1nNELUM2F5TIFM/Z4F4uEO2BWNnXCYka5fwi96xzKx3m4ExMDh04FyQgtVW3
19YmDZuME6WOFaJMjK0VBXd+pj7Jt1lqVJ7Uf/pgKhvNAnv+mY6wsKKyHBz/oxDi
HZ32rax5tItZ6xQs547v/SVqFrAQsg==
=pAuN
-----END PGP SIGNATURE-----

--245rarqcf5vldb7b--
