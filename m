Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6AC4C34D7
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiBXSkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:40:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbiBXSkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:40:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9494269AA8;
        Thu, 24 Feb 2022 10:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 016E7B828B1;
        Thu, 24 Feb 2022 18:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7CEC340E9;
        Thu, 24 Feb 2022 18:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645728006;
        bh=Ec0Bf+3ImVeowfauIG+LQ4shCDdLO2GrZ8m++9XFHDg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRWkDaPV+RyLUCI4eWa0M3yno60Pp4e0k6vw3vgKSyAF/y7VZ1HE0nnUKFSBnBFSm
         QZAtJfh29hI6CMJlW0sq+GhTUItDSW/7RJMOOLxbOlxdS5oDbkmxnY6EXRVky5sFrW
         YP+Nz/nt1cKLxgedwc0rOnqfyNYLYTNjKYDdky969u9lX9kCjsrWxnN6VjvmVdZlnw
         m5rQ0szPgP/CRSqxWYd9v9dzhD/nAeo/s4PLKwvHi35ovXykrYdkhQVtl30qDe/J2J
         p+g76hQFSdSFezw/tPMC9zigGmiwWl7DkSpc1zTtQ+hK9/h5efDx02/ZehhLiTLG8i
         UMrkKKPsWeYWg==
Date:   Thu, 24 Feb 2022 18:39:56 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
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
Message-ID: <YhfQ/AwhIail39iW@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <YhelOFYKBsfQ8SRW@sirena.org.uk>
 <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Y/gIMW3QkKDjjhBL"
Content-Disposition: inline
In-Reply-To: <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
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


--Y/gIMW3QkKDjjhBL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 24, 2022 at 08:14:51PM +0200, Sakari Ailus wrote:
> On Thu, Feb 24, 2022 at 03:33:12PM +0000, Mark Brown wrote:

> > I believe clocks are also potentially problematic for similar reasons
> > (ACPI wants to handle those as part of the device level power management
> > and/or should have native abstractions for them, and I think we also
> > have board file provisions that work well for them and are less error
> > prone than translating into an abstract data structure).

> Per ACPI spec, what corresponds to clocks and regulators in DT is handled
> through power resources. This is generally how things work in ACPI based
> systems but there are cases out there where regulators and/or clocks are
> exposed to software directly. This concerns e.g. camera sensors and lens
> voice coils on some systems while rest of the devices in the system are
> powered on and off the usual ACPI way.

But note crucially that when these things are controlled by the OS they
are enumerated via some custom mechanism that is *not* _DSD properties -
the issue is with the firmware interface, not with using the relevant
kernel APIs in the client or provider devices.

--Y/gIMW3QkKDjjhBL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIX0PsACgkQJNaLcl1U
h9DneQf5AYLBYxh/PMLXZGAePajDGZ4zjdPPUjBbwV2dS3flyapODZg02fvb/brD
mTqe70jpHZVpVwNwPOVdRyW6Imu7pPPylGMVE1+p5UUT2BGj4TbnPb9OSPMChCq8
rZTouQwPiRXw0K6sG841rB1I5HCIZC4FJxxFurlu9f7wTZKAvJ4hXiTXNnPhLWhh
MkIhvgjTVzgMwrMIyVhnAyeETO7bPv1wUax7Ec6dxph5CrWW3YQNCsVv4esFvxjM
mOFWDTMU0Je3KYxNduAKMkk7ryvfg03ugOHYwx+YO9YHjyAGrZOiwS0dONTOQsnL
R6/PjcUPqXBfgApIosl7D8wAFx3G9w==
=1JLJ
-----END PGP SIGNATURE-----

--Y/gIMW3QkKDjjhBL--
