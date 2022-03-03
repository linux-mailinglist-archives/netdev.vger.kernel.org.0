Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03C04CBDBE
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 13:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbiCCM04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 07:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbiCCM0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 07:26:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870CC17926F;
        Thu,  3 Mar 2022 04:26:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CEDFB82510;
        Thu,  3 Mar 2022 12:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F72C004E1;
        Thu,  3 Mar 2022 12:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646310367;
        bh=B3BHZUoFkAxakpfWVy7Ovv7STmV7xnVb3Bv9zPL7UD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pCuj49GGDkQkoGwM+RIDo+JdR8DK8baCoyAru3+ZPTttEE/xtWzb/8uCXEzIbNsZ2
         KtJhieu3p8poLHalvoNhuc+EEy9K3wZPhrGT4I17XmHId3V3qZ+jQDJFQctT2FbqCH
         ElR/xoO7t/AuT+OSk61bq8XYu04GEOiTqCMRMchekp3Zt+XfqhTkjG3cyI0Q6+C+fl
         QV08LZN26O9fltuRDrbpurCWsQtObij4/cQgDoaNAwm+/th09WTEXq1FjNS1twoJjT
         PnKyDyfLeTR063/BUdhA1f6+46VJ2wFj7JCSIGj4EonLz8vw0YVVtiHnZFAjU36dvq
         LtD8tN9jx7S8Q==
Date:   Thu, 3 Mar 2022 12:26:00 +0000
From:   Mark Brown <broonie@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YiCz2Dk/0Mf2XgDR@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <20220224174205.43814f3f@fixe.home>
 <Yhe/qhFNNiGVHSW1@sirena.org.uk>
 <20220303094840.3b75c4c9@fixe.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ot7L5NG/LQsDdHwB"
Content-Disposition: inline
In-Reply-To: <20220303094840.3b75c4c9@fixe.home>
X-Cookie: Password:
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ot7L5NG/LQsDdHwB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 03, 2022 at 09:48:40AM +0100, Cl=E9ment L=E9ger wrote:

> Instead of making it specific for swnode, could we make it instead non
> working for acpi nodes ? Thus, the parsing would work only for swnode
> and device_node, not allowing to use the fwnode support with acpi for
> such subsystems (not talking about regulators here).

*Potentially*.  I'd need to see the code, it doesn't fill me with great
joy and there are disadvantages in terms of input validation but that
does address the main issue and perhaps the implementation would be
nicer than I'm immediately imagining.

> If switching to board file based mechanism, this means that all drivers
> that are used by the PCIe card will have to be modified to support this
> mechanism.

You should be able to mix the use of board file regulator descriptions
with other descriptions for other bits of the hardware.

--ot7L5NG/LQsDdHwB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIgs9cACgkQJNaLcl1U
h9CCDQf+NV5Fk1jewvCyw3G34WWQh95R6QE48mTxBv/1+F9d9hwDTq4abojmWB2A
hhd5HoCBN1k71bQJUJz60ERbP7RGMOKnPBBKRMHNDiPIeTpP9gRZvw5c4E+YZD0l
MPEtVE6bcPrKstw5eGmn3YC0Sh9V7NkpLZN3xz0NBToEjT92curG0Mq1x3y93OxH
44F1DxZnMbZYU6pvcaZhloCCt9qApNua1kukHYcYPquii7yIC87xEYC/sqZLn6Tn
LZFkhQo8QpkEWzGPiMdJJgQuABK36vk6LGVHKj1jPOztuZX7NPT0oQiYsWVXYR/M
XgmoV02ViiGGoaAieUpYB1F2ex6UEg==
=y3p8
-----END PGP SIGNATURE-----

--ot7L5NG/LQsDdHwB--
