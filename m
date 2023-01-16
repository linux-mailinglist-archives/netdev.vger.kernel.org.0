Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB46C66C303
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjAPO64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjAPO6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:58:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9271222DFA;
        Mon, 16 Jan 2023 06:47:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50FC8B80FE3;
        Mon, 16 Jan 2023 14:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F535C433F2;
        Mon, 16 Jan 2023 14:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673880470;
        bh=twPexIfKoAN+WjWTy5RLoIvwPbPlryHvq/rfgYpovQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cSickh/w9waXiECjCIggVB6S45ipxMb5uGWzI3rQBzQqdpJ8lvIrTNLGprWPYq4mH
         yFkMAgmuIUlgHiT/KQL6oeBJPYEg+wbmt4zEaZhULGzXUivYQ8HlqV5zzFWI+FLp3h
         IIldZTWIFu8fanlWHEEl3brnBJq10dqyshaEooXoUHo6rP90GdX8KApGKGzLg4qbhz
         AFzDmgw6QrHWCG3DDfXOHJr2e60X/8ZD6GSeaCuChY46tGdj+rOXFrlATRTxJ7oyKU
         OHCvl1SiRK8ebk4Ft3jefV/+UH8E4XLkEX2A5FYp+hRVwOPQ6VjxWiCB/G/NLzzvV/
         oNunCjRURipaQ==
Date:   Mon, 16 Jan 2023 14:47:46 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write} for
 new C45 API.
Message-ID: <Y8VjkgcWHjR9TzNw@sirena.org.uk>
References: <20230116111509.4086236-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PXispJuV/LhwcbWV"
Content-Disposition: inline
In-Reply-To: <20230116111509.4086236-1-michael@walle.cc>
X-Cookie: Serving suggestion.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PXispJuV/LhwcbWV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 12:15:09PM +0100, Michael Walle wrote:
> From: Andrew Lunn <andrew@lunn.ch>
>=20
> The MDIO subsystem is getting rid of MII_ADDR_C45 and thus also
> encoding associated encoding of the C45 device address and register
> address into one value. regmap-mdio also uses this encoding for the
> C45 bus.

The following changes since commit 1b929c02afd37871d5afb9d498426f83432e71c2:

  Linux 6.2-rc1 (2022-12-25 13:41:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/r=
egmap-mdio-c45-rework

for you to fetch changes up to 7b3c4c370c09313e22b555e79167e73d233611d1:

  regmap: Rework regmap_mdio_c45_{read|write} for new C45 API. (2023-01-16 =
13:16:09 +0000)

----------------------------------------------------------------
regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.

This reworks the regmap MDIO handling of C45 addresses in
preparation for some forthcoming updates to the networking code.

----------------------------------------------------------------
Andrew Lunn (1):
      regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.

 drivers/base/regmap/regmap-mdio.c | 41 ++++++++++++++++++++++-------------=
----
 include/linux/regmap.h            |  8 ++++++++
 2 files changed, 31 insertions(+), 18 deletions(-)

--PXispJuV/LhwcbWV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmPFY5EACgkQJNaLcl1U
h9CmnQf/a4CnKk3hyuNTmn52dFmhdAgCiC6NcswkaijIYDh/uwgFqWVMl93KW+rv
35ea6TrsMQBRw7a6A/LRqiTxoOZjmi2sSAt6Ep956Q7GawgwPBCaXZ9fxuE8azlE
zbB2B/+oK/djlS+fayHiX5o5Cr9+FtFVKu0VhEVMvMuBSO0TIcxl6TC8jjG2708+
RVzi7sJUaIe2eghiBXl8lVOy3/u7b6zxKhAVQw2/+IID7g3GIw32grpKUlsbVIM6
PwOXlNng5uLcMqk4btPeNe1y1twfvWXNxIKdZhfYQDq491+05j1ncxgdJ2niBzjW
7pm9JIzaYhqoh8zYRePVC74T+UUTcA==
=BGIb
-----END PGP SIGNATURE-----

--PXispJuV/LhwcbWV--
