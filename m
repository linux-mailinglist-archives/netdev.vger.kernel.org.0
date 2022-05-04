Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FBC51AEB7
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377855AbiEDUNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiEDUN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:13:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36964D251;
        Wed,  4 May 2022 13:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C4A3B82834;
        Wed,  4 May 2022 20:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83578C385A5;
        Wed,  4 May 2022 20:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651694987;
        bh=iStJpBX3VysI3BJkMa+4eOTaEzUvXsP2MKiLXZmdm98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a6do+IeWTo7YZXY9hCFP+MnNkgjGWY50ZpS0AWhM6oAsu9I+c4wxET54Hq+Q0TeXP
         uHVy8+rL81TQDqXIjaD1in0PJQ2582iQsXCsfwxQMb33/OjiaBRBZToxiBJOClLi6Z
         JzPiN0tndFSVfFlybc3GFh0KM9Sm+Pauy87H2f3NRlls0LWJOsEkwSwCal183C5noh
         8CzCWVRhrb6d8NXC8BNZMUmxW+Nav2cknc8FCTIJM3nE6lgksnMPaW6u7H77gIZxEu
         BGsuDwlLiw0byBpE9B+54XIHrP+2rhihmHfZwFIFlee4uocSs1kGTP3a2JTgjVxNK2
         JRJELIn3oVNlw==
Date:   Wed, 4 May 2022 22:09:43 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v1 1/4] powerpc/52xx: Remove dead code, i.e.
 mpc52xx_get_xtal_freq()
Message-ID: <YnLdh96Z6S6IcaL2@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Anatolij Gustschin <agust@denx.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Mark Brown <broonie@kernel.org>
References: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="++MSw5fknTzpn73A"
Content-Disposition: inline
In-Reply-To: <20220504134449.64473-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--++MSw5fknTzpn73A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Wow, MPC5200, that was a long time ago for me...

> It seems mpc52xx_get_xtal_freq() is not used anywhere. Remove dead code.

Looks like it.

Reviewed-by: Wolfram Sang <wsa@kernel.org>


--++MSw5fknTzpn73A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmJy3XEACgkQFA3kzBSg
KbbTjRAApraHeAflyhzKaB4HdS0SS02AfYrsPj4tQGg+OdY7fGIgt0ZNCwI8CTsE
A+PYJ4XvUcIsL5q2RFeWnsiXSeGRLiui2WLVBILJoiVfILFsR01R6QTy6OOlwIzO
Nx5QSUgwHQB7ODDVbjOvp8pQ8FSFvqa+TM3lOJ6zWnG4d1sSSUoQnb8iXWnQFBM1
L6wpf1VRjbKYkLyO8/omDQDGJQd2BAn9rG1jF3pEmVEmMGY57wzaRmpyU49KnPRP
VuKtBXNrUbZXyvk4h7IEOhvI6tSD15uOrqJ/eeSfYcDLk3amS2TTvqwHaiuZCe1E
9PJB8ch296Sr+/LCdw3nMsLZY0v5NmrthY6K7AMZCN3eFkebsSnxkbcK1BXnuKKQ
YHKw8BafHhoQUrYxcWanNuOp2qjVodSurENsIE4s5wjpVP9EKp562+nWsrWtHns0
poXhMlPDYldvRG/IciRnG5p/XiMeKdX2ud4OdXgTVHulLxa8AMQEap0nVwwXFjTL
IcP3m7MEo8L5OhGsHAaw9G/VLVutLoBnyWk3oLXdSqpRPBov9r+oyZnVV5q7z8Gz
gjejj4ciQRm08iHn9eqJ1hvHHk2erpc1aP6takxN+owEbVSAqJpypk4B3EcAhdGp
P3VVm1YqMbiPpzP2LhWYS8ajAwFUEuyRrJSsPTzjA34uSVu4jHI=
=2zt3
-----END PGP SIGNATURE-----

--++MSw5fknTzpn73A--
