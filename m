Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA326A4240
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjB0NGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:06:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjB0NGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:06:51 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F911F909;
        Mon, 27 Feb 2023 05:06:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 552B1CE0FD9;
        Mon, 27 Feb 2023 13:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C8FC433D2;
        Mon, 27 Feb 2023 13:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677503179;
        bh=+TZvd92l9qjnJ46cOT5L9UcQe7CKFe0gXGAYlHM+pn4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MBZPUuouC2wHJXTMDns2HmltZ/Am3KtGB6qtPlCrb3/MBdH12QLCyQ124jkJwejTj
         /9jv3pfgL9kql6Rp3/Mq2/oP7T0TD+IVY2I/dEo4N2srigsxf9hH5lZRHbih9dWDwj
         bKmH5HuGP7y3RcKuUDughHTcAD0HLkjvOCAa0YLQU63I5krx7OlxqjLjJRKRa5iMW1
         1WqULk3QoqzkYDvk171oAv6DocJ1wuNnQRljHqnVaZ3QnM0+BZNRt9FqYD6ukaYhF9
         4YfWL+ENcpjdEgqhggrilecv9D1A/jzeAWs5nQjTAv+W3u/OFvR0OfJHKMWv/o+m+N
         5kgeZLeLoTRXw==
Date:   Mon, 27 Feb 2023 13:06:10 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        Jose Abreu <joabreu@synopsys.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v8 5/9] net: phy: add
 genphy_c45_ethtool_get/set_eee() support
Message-ID: <Y/yqwifeQBC3sSaD@sirena.org.uk>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-6-o.rempel@pengutronix.de>
 <Y/ufuLJdMcxc6f47@sirena.org.uk>
 <20230227055241.GC8437@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="18YmcFoX2FMeA9qB"
Content-Disposition: inline
In-Reply-To: <20230227055241.GC8437@pengutronix.de>
X-Cookie: On the eighth day, God created FORTRAN.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--18YmcFoX2FMeA9qB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 27, 2023 at 06:52:41AM +0100, Oleksij Rempel wrote:
> On Sun, Feb 26, 2023 at 06:06:48PM +0000, Mark Brown wrote:

> > Currently mainline is failing to bring up networking on the Libre
> > Computer AML-S905X-CC, with a bisect pointing at this commit,
> > 022c3f87f88 upstream (although I'm not 100% sure I trust the bisect it
> > seems to be in roughly the right place).  I've not dug into what's going
> > on more than running the bisect yet.

> Can you please test following fixes:
> https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
> https://lore.kernel.org/all/20230225071644.2754893-1-o.rempel@pengutronix.de/

They seem to work, thanks!  I had found and tried the second patch but
it doesn't apply without the first series.  Will those patches be going
to Linus for -rc1?  It's pretty disruptive to a bunch of the test
infrastructure to not be able to NFS boot.

--18YmcFoX2FMeA9qB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmP8qsIACgkQJNaLcl1U
h9Bl6Qf+Kb7ZKOT7CiUaam7FNIgjrgALxbl+vEoK4Jd449ZZ8D4wKW/ZCeFYsMtX
jDz4FdBm3yWIycYw0aDgBv+Rx5022ewQlSidOoHLtqJFyn4C8anRLgge2fCwGXRt
87RUPWhKsqyl7wpZaQirbjkkS5e2eJnXYg7qRUIkNYwjO4IGBxdx4Y05qCGI90vD
d5orhnfGEb5O5rf9JpGlz6X6FuoTaNF+QE8PJWaYve86GxFeZ45r2LA2mwO5KXK2
lR9TEJAspu738yEXGCxU4J6pZn/PAH6MdaAL3nz5SonmmQ4xcPZxveXbYEI2amK+
qUGMfJEdqtVeKb0reNsl0z2pPn1Lwg==
=p/hg
-----END PGP SIGNATURE-----

--18YmcFoX2FMeA9qB--
