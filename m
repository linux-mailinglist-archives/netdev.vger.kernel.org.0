Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6599462FA01
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241704AbiKRQOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiKRQOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:14:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CE8E0D4;
        Fri, 18 Nov 2022 08:14:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A176E62605;
        Fri, 18 Nov 2022 16:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69566C433C1;
        Fri, 18 Nov 2022 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668788080;
        bh=kpKu/c9BWXRel1V/AWJLvQR+q/X8pLWSB+6SkGCg9f0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eUYwVCxrLpTFAFmyfiVKEVLalU/mClbJ2liZ/IzpK/QF45IPJnQEWgfkjwfWST9/y
         cXQUijC+2qhBZjnVql346XaLv6vulxsl4BL0hTrJcK5l6b3x0lFIxAa6xG2eV9EwIK
         tjhxSmHm2z0SYEpi5F93w9E0MAYqlM9FWvgoBp7Qo4UH2imxR+7fgvdYtfYyjmLCk8
         uVmoeb9B6/O2yxwHGrMO+mt92bSh9C3do3+2sxsYAL6xGodLPV5Aw/WtWOjh1uukpa
         STD8JCi4FjG/dqnEWB7Kc+zAtuVWXfPx6T5xnUfzaHp86x5AswlLstVE7LjX/iR+Ed
         ayII11ONy8JEg==
Date:   Fri, 18 Nov 2022 16:14:37 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     andrew@lunn.ch, calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 1/3] regulator: Add of_regulator_bulk_get_all
Message-ID: <Y3evbTL4P72xwYWS@sirena.org.uk>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-2-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="DJFv/5IyQrUvDztj"
Content-Disposition: inline
In-Reply-To: <20221115073603.3425396-2-clabbe@baylibre.com>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--DJFv/5IyQrUvDztj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 15, 2022 at 07:36:01AM +0000, Corentin Labbe wrote:
> It work exactly like regulator_bulk_get() but instead of working on a
> provided list of names, it seek all consumers properties matching
> xxx-supply.

The following changes since commit 9abf2313adc1ca1b6180c508c25f22f9395cc780:

  Linux 6.1-rc1 (2022-10-16 15:36:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/of_regulator_bulk_get_all

for you to fetch changes up to 27b9ecc7a9ba1d0014779bfe5a6dbf630899c6e7:

  regulator: Add of_regulator_bulk_get_all (2022-11-18 15:13:34 +0000)

----------------------------------------------------------------
regulator: Add of_regulator_bulk_get_all()

This adds a new of_regulator_bulk_get_all() which grab all supplies
properties in a DT node, for use in implementing generic handling
for things like MDIO PHYs where the physical standardisation of
the bus does not extend to power supplies.

----------------------------------------------------------------
Corentin Labbe (1):
      regulator: Add of_regulator_bulk_get_all

 drivers/regulator/of_regulator.c   | 92 ++++++++++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |  8 ++++
 2 files changed, 100 insertions(+)

--DJFv/5IyQrUvDztj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN3r2wACgkQJNaLcl1U
h9CEOQf/U2ff5jdqmcVQLYGSojvvtxIkUDdM8+kofOodWraaYzvkggTTav+lly2R
bzFgqC0N49PIzS0I+jHP7KUD5tdKi8Mg6bdjEIEOjB7rx6QHuHHeeg6KA93iTH5m
rFIL2nbGA/x0awGN6VJUmz+ov1Ve6rixWwx6DOpteeiegTKPWsYi6S/IFIeZTVdn
1KnO+9XmdKzpwNXzInBFExi4H+y++MjfwYhv/m/GmGZllyBDh9P/qp5kFTkUS0nY
mgzg/okKLtcCNtgDBH0rZG3YNJjPRiR+6GTGD7phfwhQbl9WM7m+mZ8rAeb4ms/e
RdvpZsg88t548AY76WBGDUXngBwgLQ==
=M0l3
-----END PGP SIGNATURE-----

--DJFv/5IyQrUvDztj--
