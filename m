Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A744C34EE
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiBXSoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiBXSog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:44:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6B920D51B;
        Thu, 24 Feb 2022 10:44:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65500CE2121;
        Thu, 24 Feb 2022 18:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791C0C340E9;
        Thu, 24 Feb 2022 18:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645728242;
        bh=zA08bRriFMPaf162sIg9Um6tUBFcfmX4OyxJrViAe1o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TTTVpuZULnazk1kH8AFcyDz0jEj4UGSIdMkERpRxHSV9AGq6i0q5GoUaunaCR0Jh2
         tHzBLdKnIkE57vnFbTaswsO4ER7Msf7r85uPVPROoU9z5S6bJ5VHVkfCgJwc9Udpi2
         zJhhGR4N8IF888ai8dj8t8IUohLvHzmkjvBrKNX+08idstMdLbVbwdpfuAOcgpLWI8
         wSKnp3kJU6WrARdpFdmyywO3N3ZY9s3D37Ui1sBumOvIAAIgXQNs6KJgYKSWr4QW2X
         +RU3lwKtqBmu0RZYvq+wh/2Rkr6fRLfZA7u+uDIf0gph1EUtPEhfc4rK4lWUESGgAd
         ivND+B8ySHImg==
Date:   Thu, 24 Feb 2022 18:43:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <YhfR6sqtHO8G9P0v@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <YhelOFYKBsfQ8SRW@sirena.org.uk>
 <YhfLG6wlFvYY3YU8@paasikivi.fi.intel.com>
 <YhfQ+MCYxrdDqN9J@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8tk8SElfMW55/7jZ"
Content-Disposition: inline
In-Reply-To: <YhfQ+MCYxrdDqN9J@piout.net>
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


--8tk8SElfMW55/7jZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 24, 2022 at 07:39:52PM +0100, Alexandre Belloni wrote:

> In this use case, we don't need anything that is actually described in
> ACPI as all the clocks we need to control are on the device itself so I
> don't think this is relevant here.

You should be able to support this case, the concern is if it's done in
a way that would allow things to be parsed out of the firmware by other
systems.

--8tk8SElfMW55/7jZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIX0eoACgkQJNaLcl1U
h9ArGwgAgEF+m4bUPVcGxa9dFUFZbofdeOQPwrvIldaZLHe7Hem1OiOFsBKPPboq
1iv6GWEkSm8lC7rW5V76gPI7aihMS/JjKZeqpEdQQMpmj50sPEM3Hz+d5oKrB8ej
Frvae9SSK3kX13jsYITiE3hPrLHLee5i0vJR85lcDPP8l7bHXByKR44Bo8Dr9/yE
F/jpJVH/3RBUhzJLp80PH12L3B/oA9BMUXUr73lLHs6DyyyzGRuyhj+K44SKRZCV
ydliExojW26rCdUlEYn3We4VzuH2lgshW9t3fMFsSZkjQD1h5NP00p70BfKbKQDG
h8OFt5DdBcfAJztcVWIuRwhHyxtyBA==
=wgGS
-----END PGP SIGNATURE-----

--8tk8SElfMW55/7jZ--
