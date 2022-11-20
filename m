Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83856313D5
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 12:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiKTL6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 06:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKTL6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 06:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152F8BC06;
        Sun, 20 Nov 2022 03:58:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C13ACB80AB3;
        Sun, 20 Nov 2022 11:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB8BC433C1;
        Sun, 20 Nov 2022 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668945529;
        bh=wu6UtbK+Wpmizr3fSbUysxgCSn426hOUGl096imE0os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FiV5AUWL4SwB7uH9NkXGSB/me6YN4W4qO8TGO6hdy1xr/cLhxzP4B1d4q1sQFmsLd
         5Jxy3t/GwBr6ptwE8iIZjzlk4xkMQSbpKnoYcBp+k5m4cdoIP0GH/d7uXtkCq+uMtT
         dHcMl7eXpq2wLhdlUrH9GrjAmjddKuLbrYRdhtybz8EwkIqwvM3AgLcF5mkO2Ng9rN
         HFDzlpc3SJu4yPXoy1U0kY9EaARSFcs7jSD3Dy2XYmYalr226bmyKdYvicAb2gXMqF
         pvmdU42RIuQamhVMKmeq/vNchOMJSJOy9swCKHci7i3gTaXi3vX/KrvsIAkpHCJtJ+
         yNifHpNYmz2lQ==
Date:   Sun, 20 Nov 2022 11:58:26 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several
 modules
Message-ID: <Y3oWYhw9VZOANneu@sirena.org.uk>
References: <20221119225650.1044591-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P/X5vuacK0/qt+zb"
Content-Disposition: inline
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--P/X5vuacK0/qt+zb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 19, 2022 at 11:03:57PM +0000, Alexander Lobakin wrote:

Your mails appear to be encrypted which isn't helping with
review...

--P/X5vuacK0/qt+zb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmN6FmEACgkQJNaLcl1U
h9DxmQf+IpjM5cFY1oSzbvda89z7KyJRed4jurLLoAvNTr0Y6Tn86c3rwFjUYIQb
z4rGziSVjTmPX4UgJK4zfWi03e8gJd8bUWr0mGg8qU0/1jl7RgqJz0fR+/E4iQLp
z5CjBr5+WsyBMp1pJx/hu2rXt0xKZdT0ze6mNEEwFyumYLv51HC2DZ3ZB1zGEAe+
EyeB/9nUz9xZXSCbFKZpgpdnDAH2+aextKNPD1d8mbAFXj+u+khwQNn/TZdf3agv
o6tfgXuux2OUifA/78biY60QZ2oGGkcprOPBN0G/w2+ZeDbBjbkggqGV4yFVdZW3
1/LYqdNc6yCzf5jclSwsLoeEM4yLZA==
=Rb/i
-----END PGP SIGNATURE-----

--P/X5vuacK0/qt+zb--
