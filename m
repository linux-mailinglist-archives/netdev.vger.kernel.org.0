Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865F635A2AC
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDIQIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:08:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhDIQIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:08:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98A3601FC;
        Fri,  9 Apr 2021 16:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617984489;
        bh=PULqMndYVkQ6GkmnOOQSw0zg0mec7exTRm08KyyKi4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=apeJtpAtgHUq3Iz7+rcv9WzLS5HqcM+CLDyueF+iqCIO/U+onpxBuCFF9dpQo1m5J
         XYwqmSBcQYe9sQCNIhTwYsi6LK0rzcbk5oq+fI5/y0RDFOv6auKw4OBdqE3NrsNOJO
         KcE4SEi3gTx2qIxMMWaohFTOpFy4BNC/wZnG2Ct+1CQlooArpVzksr59kyI4H2c0rj
         1g3PM809poFJpdETY4f6xIdDi1jEgaLd9n+mE935huH2qAhhqJsD4iAYYp/Q9S5iJt
         zuf1CAeP41iC3xAtducX6yX44H0NDNFkhNW6rwabeaT7HnM4r9+RJPqKCVB5u6WaQo
         Zq05PwKFI7iDQ==
Date:   Fri, 9 Apr 2021 17:07:50 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Subject: Re: [RFC PATCH 1/2] regmap: add miim bus support
Message-ID: <20210409160750.GD4436@sirena.org.uk>
References: <cover.1617914861.git.sander@svanheule.net>
 <489e8a2d22dc8a5aaa3600289669c3bf0a15ba19.1617914861.git.sander@svanheule.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <489e8a2d22dc8a5aaa3600289669c3bf0a15ba19.1617914861.git.sander@svanheule.net>
X-Cookie: I'm shaving!!  I'M SHAVING!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 08, 2021 at 10:52:34PM +0200, Sander Vanheule wrote:
> Basic support for MIIM bus access. Support only includes clause-22
> register access, with 5-bit addresses, and 16-bit wide registers.

What is "MIIM"?  A quick search isn't showing up useful hits for that.
Why not just call this MDIO like the rest of the kernel is doing, it
seems like using something else is at best going to make it harder to
discover this code?  If MIIM is some subset or something it's not
obvious how we're limited to that.

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBwe9YACgkQJNaLcl1U
h9CGLQf9EBRj6sYahOtMiNq61Anrqx80NYXUbskhcEDD83AyuDH7fClBSFu5a/Rj
RorpF69jhF+/VIj9ZdoG2+BKlGWCmOetkaAzbTsLOdAHh+2mpyQuy5TKBticSbRA
EzPQQwuJUCFtdKLrV++r2LGG91Kdlext30VgVpljY62jw7dOvTUAdt2g9vydgnTy
wQDGmg6tSBLiH3IiJwT4jyx/xMXEwsfAXBgitFDcW3Ft15xVkqWidI4FV8QWQSlX
xmxyMf1tGGygOGJSbFhLfkBNdWlT2u49dHaVSqq48nN6qCoxqfpRue5W0c6KmqGR
77t5cLgRnvKqqPSbrElY73I7WkjASw==
=6qSC
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
