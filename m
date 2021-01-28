Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C49307F8E
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA1UY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:24:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhA1UYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:24:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9197E64DA1;
        Thu, 28 Jan 2021 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611865423;
        bh=lbM6GwZMYRImaPta0V1n79EGw3P6kP+wV2qFO0XXCEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L5sfIFYCx19rJd1BV9wJ6fpsdueLYb5eolWLbvn9hH6LMBIDu7KHFjJlbU5SxG7Eg
         XDquLwgE5EGm5DFryKIEhaQpk2uKId4zhyQzEmGel8QtgJCMWypSGp3cvEONb57Cfn
         0OYGJ9YO7rHtHd8pSeobJOfLsYLCwtdQ11sXKno41UZa6QmypJ/NAlJ6xgEx9WpCcX
         kfGLYsMmDBZA5eZaePIxwXtSrwemRYsFEltlOX9/8n6uKy46trS2Lj5H7H7KjqSfO7
         DsqGQ5/qs+Ly/Ih+Z+49Y5LPb46GN28UmRpCKlVFrxua2xD2IbvCe859NTAmcihXrT
         Sv/6bOU6R7nbA==
Date:   Thu, 28 Jan 2021 20:22:57 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Wolfram Sang <wolfram@the-dreams.de>,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Cleanup standard unit properties
Message-ID: <20210128202257.GG4537@sirena.org.uk>
References: <20210128194515.743252-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Content-Disposition: inline
In-Reply-To: <20210128194515.743252-1-robh@kernel.org>
X-Cookie: Do not pick the flowers.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 28, 2021 at 01:45:15PM -0600, Rob Herring wrote:
> Properties with standard unit suffixes already have a type and don't need
> type definitions. They also default to a single entry, so 'maxItems: 1'
> can be dropped.

Acked-by: Mark Brown <broonie@kernel.org>

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmATHSAACgkQJNaLcl1U
h9AFOQf7Bk9kfd72eswvzk03qYrNzRUn/oYHBukYGABZxeJRqRFJl5+jb4FOglXo
ocmDsdb34YsgINlYHWXljMcykPaAMfuY73a3ak/VfZR83lQ985rj2tyC0DRUTBnX
spUxl6EQIUaFRmlSARZRK0iGC2QknTRzafuaIDv91uXpokCIEFw/KXY+1075TAS3
2NeAWqaaV6NGsWHAhjs3HGarXyGgMzjEPBJLWnDg996A5/3nOaUm2qNeBauScB7C
ywiZRUH9e+WMcDRKMBbOMl+au1Gx1wRzTiVtCViTII7mvweTZxqybXa6ztmKKZMS
xQFRKT7ZM6c6Jsj6z1eM+bLGwj41bA==
=Q38P
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
