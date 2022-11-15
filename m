Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE98629713
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 12:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbiKOLR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 06:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238255AbiKOLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 06:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A67563A0;
        Tue, 15 Nov 2022 03:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9B13616A1;
        Tue, 15 Nov 2022 11:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11215C433C1;
        Tue, 15 Nov 2022 11:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668511025;
        bh=WtfglS+fHBP2n3DCncZu5y610bEqJwb4B2bqp0aQtXA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kbZXyEsRQ7AbwmFyU7jSi25sJSMtMZHaEgRllS9A0n5qUULkADCOlqHupxcUhcLTx
         NxZSBOYUCNBXcVvvAu1CiKEhyTMROCVv+Q4OxRHkyKELaEBa6KKWajbP9Ei+eq2bYD
         4gwjbMiLp2Hdrn9Wk1y02JQciwUV4QltulHZSvBBo0cVUrlEsKaxro3XSsFc7wwWZS
         OFnsFHV7oM+7/eKt152cSyC17XYhfMNSocVvK0sAGO2SOLAmiTeXakViAFD18M5QGp
         vUxeLaIjziEZfbyK+i7fn23zz7Mq8sb8HAAWTJywrvIa1ajuLapUl8gTxazKsPGSEs
         ADZSqF3caLEeQ==
Date:   Tue, 15 Nov 2022 11:16:53 +0000
From:   Mark Brown <broonie@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Corentin LABBE <clabbe@baylibre.com>, andrew@lunn.ch,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, pabeni@redhat.com,
        robh+dt@kernel.org, samuel@sholland.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        netdev@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 1/3] regulator: Add of_regulator_bulk_get_all
Message-ID: <Y3N1JYVx9tB9pisR@sirena.org.uk>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-2-clabbe@baylibre.com>
 <Y3Nj4pA2+WRFvSNd@sirena.org.uk>
 <Y3NnirK0bN71IgCo@Red>
 <Y3NrQffcdGIjS64a@sirena.org.uk>
 <Y3NtKgb0LpWs0RkB@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="khsmKj4b0178bR6g"
Content-Disposition: inline
In-Reply-To: <Y3NtKgb0LpWs0RkB@shell.armlinux.org.uk>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--khsmKj4b0178bR6g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 15, 2022 at 10:42:50AM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 15, 2022 at 10:34:41AM +0000, Mark Brown wrote:

> > Well, it's not making this maintainer happy :/  If we know what
> > PHY is there why not just look up the set of supplies based on
> > the compatible of the PHY?

> It looks to me like this series fetches the regulators before the PHY
> is bound to the driver, so what you're proposing would mean that the
> core PHY code would need a table of all compatibles (which is pretty
> hard to do, they encode the vendor/device ID, not some descriptive
> name) and then a list of the regulator names. IMHO that doesn't scale.

Oh, PHYs have interesting enough drivers to dynamically load
here? The last time I was looking at MDIO stuff it was all
running from generic class devices but that was quite a while
ago.

--khsmKj4b0178bR6g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNzdSUACgkQJNaLcl1U
h9Dunwf/UIC8Fi+irHTQ/olw2gqDv6691gO5hJTGM3xepy7LuVjmp0NUgHJR3q8G
NPWdNrz0GP3bdx61XL1FlajcfnM/JU5RoMiFAyQmnceuK7P2hmLboHcW85BFGjtc
FP8wgwBiWyrAfZnEePrZcPwxKFpdyUxtX3pkhTWy5+MYsc8H+fBiEpmpOhPu+FYb
gZwx/FeE0fxZQKnViJddT5naB61EZ7OR5EsGjuZP2+AVG8D5c9seFd81V1ulkQKe
IPwRZGjre5377b3iy3gVbtrJ6ol4nN0YmaEkW2eL0BVcDwCCVSkf7nP5rK8QIiAM
8HFyYYD6WtCEjnUU1tyFcRLYPLKJwA==
=KltA
-----END PGP SIGNATURE-----

--khsmKj4b0178bR6g--
