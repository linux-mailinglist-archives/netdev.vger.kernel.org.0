Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1506B4C2FC1
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236185AbiBXPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbiBXPdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:33:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AD21C60DC;
        Thu, 24 Feb 2022 07:33:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DC3760FF2;
        Thu, 24 Feb 2022 15:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE97C340E9;
        Thu, 24 Feb 2022 15:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645716799;
        bh=DKZPxHqQvX/aqIXROPldvpL7eycK9WsHrUm3NPhovas=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNLUBY+REBZhj2qPwuQY4aMo6UuJgtShd5LcKSJXbJ68rdX5CURC/YL62XXHDgxp9
         RYkKubdetxoxXTcMSS7PvaD+Us3FqMqm9PUrGmq32cWzhE89OegFF+or4sUk2oD5TR
         2TiNy72KcDexgdItn008rhK+4036GjR5Ddvqs7KlnWFNtFgc1KBIh+TTqvvrBCyy41
         /6pdqIvcLjQy75IokHLmJgO/Ej72xkfVpQTkk4T4ksHRwrcp8/KsrL6a72lpEzaTP3
         cJoL7qXvaKiSk8RKy7wtHLYY/LJFAc7V69W7wp9ld/WoCn1VN2H3mRQCSdyQjz6BfI
         M1Qa8z96ZQKoQ==
Date:   Thu, 24 Feb 2022 15:33:12 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
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
Message-ID: <YhelOFYKBsfQ8SRW@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UFz+oQAxc4hNGIf3"
Content-Disposition: inline
In-Reply-To: <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
X-Cookie: I smell a wumpus.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UFz+oQAxc4hNGIf3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 24, 2022 at 03:58:04PM +0100, Hans de Goede wrote:

> As Mark already mentioned the regulator subsystem has shown to
> be a bit problematic here, but you don't seem to need that?

I believe clocks are also potentially problematic for similar reasons
(ACPI wants to handle those as part of the device level power management
and/or should have native abstractions for them, and I think we also
have board file provisions that work well for them and are less error
prone than translating into an abstract data structure).

--UFz+oQAxc4hNGIf3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIXpTcACgkQJNaLcl1U
h9C7rgf+KUcGclTVHJInHu1Lj3WFJRxMKM3KumT2C5IZueBQRnqjO6CJ/+nBQsKe
E25G8+ptCsa5iDNHDLl79Dr3oyV+pP0hVHYi4pWYIbnpyCf0gzj70ism86+RuD+g
NvC9ArDKBDyfMji4MXdQi7+HoWpudYGO6pfJSX4nngW8u4djH8nh0WvzyV/HX+Vl
WfW4J06a38ywZrPpoalaSj0cy4+uhTIkN7h7ZzlGGm0JgpKDxsnA5ZruABMNCqGU
gu63uQN68U7XJ4LE+2mgbu7P8iMBLoLhqClCuez1Ulk5KEL5YlNOsI9Zkhmb7WG3
6M3AJxCgE/PZnU/s9GSABYzlfmzLww==
=L3wN
-----END PGP SIGNATURE-----

--UFz+oQAxc4hNGIf3--
