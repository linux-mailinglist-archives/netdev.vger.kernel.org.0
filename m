Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931092DE8BA
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 19:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgLRSFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 13:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgLRSFz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 13:05:55 -0500
Date:   Fri, 18 Dec 2020 18:05:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608314714;
        bh=NdVqBMtoRocNA2YPB3gxwzcZOZ5Lc5aEsvs74M1GU+o=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=BRDVO50wHKlGAD5qiF/1c3cHXBdUjdySFj7cCYHZFP7hg5VMIFrBs9M8ZE7M9lOWb
         w/QSgenWviEs/BRyTgLzmxGV6KpEzW1oVd1BeEmvpez1pwXAuMUIoQjpzfbzVJqMuz
         xckZiJciy8PF29r16te2+p2AnfMD+DQAoH20ViDcoxk91rwY/i/zPD+OrwxeTTrkBD
         unt6XOr8LdH9x/btrK3F1w1jJ2YHpbu4FHdOTzxGkgM8Mp3AHQ/EOTHC7IKfzAEjiq
         YayGtfiPnimOB5IpFWn7NxJWr992NpubmVgcmrGiBiXl1o62QsBtFABsWiFA2SAUua
         x2V1EdvRPmWLw==
From:   Mark Brown <broonie@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201218180500.GA35480@sirena.org.uk>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
X-Cookie: Can I have an IMPULSE ITEM instead?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 17, 2020 at 04:34:29PM -0600, Rob Herring wrote:
> The correct syntax for JSON pointers begins with a '/' after the '#'.
> Without a '/', the string should be interpretted as a subschema
> identifier. The jsonschema module currently doesn't handle subschema
> identifiers and incorrectly allows JSON pointers to begin without a '/'.
> Let's fix this before it becomes a problem when jsonschema module is
> fixed.

Acked-by: Mark Brown <broonie@kernel.org>

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl/c70wACgkQJNaLcl1U
h9C6xgf9GjyMMhxOLX/4FgKAp9F6/WeX1DyiCkHx+c5d/DWDd3e6moV9ahFZFTfE
LrJs1vcq4nCVKZUpsrP1igIKVm9HGo72kHsmh5MGJCiXfu0PLDBcOVW7Usr8rp4S
i4USBt22cnVncSx48sFNIbqOYBmwVLKZpX7Xv4UK7lCQWQ/xS7X9K7Ywolmg/Hvw
rgEcSLE0YfA7INdLl3CrXHouY90pR/yzx30b8GH4OvxVy8bHobQvtLUfg0ITSHdU
AM/dgOB/iDzxLWtpq8OAjUgB1GWkdPOTAjcQJVEDTMJra1e0Rln5uad7DWf2ggj8
Y4qUdmvrYgeXtl9ugMXRG1lZg8+3lw==
=4D70
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
