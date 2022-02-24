Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66ED4C33B7
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiBXR0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiBXR0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:26:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8376A278C92;
        Thu, 24 Feb 2022 09:26:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4F4E61BD6;
        Thu, 24 Feb 2022 17:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB706C340E9;
        Thu, 24 Feb 2022 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645723570;
        bh=wVV7zEE7Be5mHaysjzLTRuSJpGFyALfKlNpGdgCOzgU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H0iXRVEe+RB7/jDaHg1TRBTFCzdWZ9jX4oCBT6hKMteYlX/sdTL8EZn2SUckJjEYi
         DHM2i26aUXzOiIsofo12RXtKrZaphHGaAt5cIbtarjRaUjTsZYTvNycBhTNTxQEpmS
         qEK4KPI9pLEw8Y2pwoID73y97kbS6aShl6V66a7OYCdyeTJ94Q1yuL5Eeoek3oQ8H9
         n0UYaqTtMF4rpUpF2MlqhhGS7Z2QllPbdnSoJQa5PHn1mx1ccbgTaoUxzIMbrFYF+R
         FiPLwKza6aLrpz+Lhq753Esb/kIgC6wWALWTIYl7K5W8ycPnOnm7S/mPjFtjuP8Kv2
         3uk04yePq40LA==
Date:   Thu, 24 Feb 2022 17:26:02 +0000
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
Message-ID: <Yhe/qhFNNiGVHSW1@sirena.org.uk>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220224154040.2633a4e4@fixe.home>
 <2d3278ef-0126-7b93-319b-543b17bccdc2@redhat.com>
 <20220224174205.43814f3f@fixe.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yfmG7fklHcmXRGqd"
Content-Disposition: inline
In-Reply-To: <20220224174205.43814f3f@fixe.home>
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


--yfmG7fklHcmXRGqd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2022 at 05:42:05PM +0100, Cl=E9ment L=E9ger wrote:
> Hans de Goede <hdegoede@redhat.com> a =E9crit :

> > As Mark already mentioned the regulator subsystem has shown to
> > be a bit problematic here, but you don't seem to need that?

> Indeed, I don't need this subsystem. However, I'm still not clear why
> this subsystem in particular is problematic. Just so that I can
> recognize the other subsystems with the same pattern, could you explain
> me why it is problematic ?=20

ACPI has a strong concept of how power supply (and general critical
resources) for devices should be described by firmware which is very
different to that which DT as it is used in Linux has, confusing that
model would make it much harder for generic OSs to work with generic
ACPI systems, and makes it much easier to create unfortunate interactions
between bits of software expecting ACPI models and bits of software
expecting DT models for dealing with a device.  Potentially we could
even run into issues with new versions of Linux if there's timing or
other changes.  If Linux starts parsing the core DT bindings for
regulators on ACPI systems then that makes it more likely that system
integrators who are primarily interested in Linux will produce firmwares
that run into these issues, perhaps unintentionally through a "this just
happens to work" process.

As a result of this we very much do not want to have the regulator code
parsing DT bindings using the fwnode APIs since that makes it much
easier for us to end up with a situation where we are interpreting _DSD
versions of regulator bindings and ending up with people making systems
that rely on that.  Instead the regulator API is intentional about which
platform description interfaces it is using.  We could potentially have
something that is specific to swnode and won't work with general fwnode
but it's hard to see any advantages for this over the board file based
mechanism we have already, swnode offers less error detection (typoing
field names is harder to spot) and the data marshalling takes more code.

fwnode is great for things like properties for leaf devices since those
are basically a free for all on ACPI systems, it allows us to quickly
and simply apply the work done defining bindings for DT to ACPI systems
in a way that's compatible with how APCI wants to work.  It's also good
for cross device bindings that are considered out of scope for ACPI,
though a bit of caution is needed determining when that's the case.

--yfmG7fklHcmXRGqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmIXv6kACgkQJNaLcl1U
h9C1Agf+Kme6hR86cN0B7vpqfch9wuRn7xKc0xr5luehmMY5hz+uq+d496xj40YU
4q3VzYTeb0eeXeRZCnnvP/W1fwZ8+rMFgOc9LcCBJzPzx14u8y1HWciC0n/Hp/Dx
K6u796agx8LCfGGd1ednsIJOAI9vvJSugHPj08P3EQJj1W5unL02Ql7M3FrM2a2y
r4zsRWhgInLqquSLH72KGlVTYFzDTgQ/VUU8yYsoVD8PCt2lAn8/fvd42UrCUCRU
iLlQxFo7/h3W0VgCUc7ptkqqfg3k4dYwZDngrMSQ5YL83a0YbmFFqEeSDCFXnrYi
bAy6tbgvRlKDm7VNDCMVVK9k/8bhAg==
=KvM8
-----END PGP SIGNATURE-----

--yfmG7fklHcmXRGqd--
