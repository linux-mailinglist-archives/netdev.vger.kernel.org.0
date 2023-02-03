Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716B7689814
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 12:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbjBCLsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 06:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCLsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 06:48:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1ED1B335;
        Fri,  3 Feb 2023 03:48:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6570F61EFA;
        Fri,  3 Feb 2023 11:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89106C433EF;
        Fri,  3 Feb 2023 11:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675424885;
        bh=sXBX1FG6ndVGefT904bnksV8B+g4LxIK97sutzKIqNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQ5/MYRvKvLBYmD0dA3PJdZ7Epr40/BTH7nbSlK7+wFZPoEBj5EmO4JWqecjeRxR+
         B/iSweeCvTGY3fjdke/bBXjQtVykCLPdFqqGU9ktxc0N70sghU8BNDNuaNjzfDMWhS
         9xRmj7NUziC4xCvRKjHJVNZOLGyot+RdeudHWY7IRVy13TkKgaDOYBJU9t6ynd5wQy
         8feOq45sLlq6jWd1OVq10ZXObB6hZ7Ishp7lMHgECKl5O5z5sPGynRTQhdAmFwGN6/
         ydAbA0R/fQhWdcJFsjLIHKeABeGhliAhtNPY7Cop+P0ZgWlFp3i2xIHg8Lh04A7wPg
         waLBdhfqtax9g==
Date:   Fri, 3 Feb 2023 11:47:57 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Tudor Ambarus <tudor.ambarus@linaro.org>, trivial@kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-mips@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-wireless@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-rtc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-usb@vger.kernel.org
Subject: Re: [PATCH] tree-wide: trivial: s/ a SPI/ an SPI/
Message-ID: <Y9z0bQ8TeFROA0Fj@sirena.org.uk>
References: <20230203101624.474611-1-tudor.ambarus@linaro.org>
 <CAMuHMdVeDbTGLBAk5QWGQGf=o6g25t341FjGTmNsHw0_sDOceg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SpLBoke9z0+WTDIl"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVeDbTGLBAk5QWGQGf=o6g25t341FjGTmNsHw0_sDOceg@mail.gmail.com>
X-Cookie: Pay toll ahead.
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SpLBoke9z0+WTDIl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 03, 2023 at 11:28:03AM +0100, Geert Uytterhoeven wrote:
> On Fri, Feb 3, 2023 at 11:17 AM Tudor Ambarus <tudor.ambarus@linaro.org> wrote:

> > The deciding factor for when a/an should be used is the sound
> > that begins the word which follows these indefinite articles,
> > rather than the letter which does. Use "an SPI" (SPI begins
> > with the consonant letter S, but the S is pronounced with its
> > letter name, "es.").

> While I agree with your pronunciation, I believe the SPI maintainer
> (which you forgot to CC) pronounces it in James Bond-style, i.e. rhymes
> with "spy" ;-)

Yes, I do.  To the best of my knowledge most people just say "spy"
rather than pronouncing the letters or anything.

In any case as I said in reply to one of the individual patches English
isn't regular enough to go with hard and fast rules on anything, and the
letter rule is much more commonly used where something is needed.  Using
an here looks wrong to me, and the fact that a is so widely used does
suggest that usage has escaped whatever rule there is.

--SpLBoke9z0+WTDIl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPc9GwACgkQJNaLcl1U
h9BWWgf7B2SbxlDCRQ/tXsgEj6IpmRoheV/Rc6V7cDJ3WW0RDwuKuwr+iYGYH4wI
JMhxrKQp0ohQOtyboaLZK7RSARZQtK65wRZ2Cnrc3ilSy9T0cwDCOwBQ8I14Rclq
/g2LhsTjAgrRpbQDo70vY9TV1fgGhwKHTNkGBfUAlfdPRz38Q/xX53UXHBy6cVqC
ZWmrmxiRWO0ERd1qkYXsmPVVrtor6skFKeuri+z1H/l/Rl+vj0R4zLIiek1nzhnm
W92b3oRnp6fRbyoiNsBO24Hrvd4POfaUHRf006dJ3jQnJpFKQwP8sFCMJD3BLpIU
flkBLxV/d8OAm+zvn+ZpbTQr/78vKQ==
=4YMj
-----END PGP SIGNATURE-----

--SpLBoke9z0+WTDIl--
