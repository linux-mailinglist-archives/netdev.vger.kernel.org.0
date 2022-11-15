Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B40CF6295F8
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiKOKet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiKOKes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:34:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BBA319;
        Tue, 15 Nov 2022 02:34:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B9A2B818B4;
        Tue, 15 Nov 2022 10:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34451C433C1;
        Tue, 15 Nov 2022 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668508485;
        bh=QhsyM1sejJzY9LKr0ozqQQa7/mRn2Cu9yjwa5qLHBMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5ztEXL+9jRc6/QvzxJ1KaG07L1vXWj/orsKIdItt1mL/LhKuQR/VnyvTLBiHMzYM
         35QeowLWm4TFTlLWjE+YDpEummPT75yZedMVQZEGiTRmXY/WjzjpeN6qYKttrVL4Pb
         mODUR84o40aH7Xqc4wejQl4e0JOGOxuDX0wQHobpKsac9yRpPVBaEYojeynw+RfNti
         IVF4suQImk5R4ENlEM4vebTFbp2kF0lXAxEzqeCZ9ToYvexK22734Z9oaFWJ48ekIz
         Nrnv/Hxhtpklzvn7XFBf+n/T1YlXVkSSrtD0zqSu0/8588AeGjkDV+POW8gJ4hMxJv
         UlnfIjCFn5FKQ==
Date:   Tue, 15 Nov 2022 10:34:41 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Corentin LABBE <clabbe@baylibre.com>
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
Message-ID: <Y3NrQffcdGIjS64a@sirena.org.uk>
References: <20221115073603.3425396-1-clabbe@baylibre.com>
 <20221115073603.3425396-2-clabbe@baylibre.com>
 <Y3Nj4pA2+WRFvSNd@sirena.org.uk>
 <Y3NnirK0bN71IgCo@Red>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="waLqEqmMHBOLvAom"
Content-Disposition: inline
In-Reply-To: <Y3NnirK0bN71IgCo@Red>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--waLqEqmMHBOLvAom
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2022 at 11:18:50AM +0100, Corentin LABBE wrote:
> Le Tue, Nov 15, 2022 at 10:03:14AM +0000, Mark Brown a =E9crit :

> > What's the use case - why would a device not know which supplies
> > it requires?  This just looks like an invitation to badly written
> > consumers TBH.

> The device know which supply it have, but I found only this way to made a=
ll maintainers happy.
> See https://lore.kernel.org/netdev/0518eef1-75a6-fbfe-96d8-bb1fc4e5178a@l=
inaro.org/t/#m7a2e012f4c7c7058478811929774ab2af9bfcbf6

Well, it's not making this maintainer happy :/  If we know what
PHY is there why not just look up the set of supplies based on
the compatible of the PHY?

--waLqEqmMHBOLvAom
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNza0AACgkQJNaLcl1U
h9C+bAf/e6ca+HkJXJ/Zw5AzMnYMfDEUD3jeR53Av8KjusBGlxK+1yqCPcPux2uD
/p9cJSk6dKFaqEVIV6hLguzDwiOkgVtwg4ocN50BdSl+OBmrILSvPVz/k+n6aQk4
2326JGlVTtvE11gKagZH3deg1gMpLlLzp6wabO4eWEEVbLI2X423TJqo20t/m8V8
MpPXfGRyabHfL83KKYgsIdYyOKll/1f0gt9npCixw257p/ZQ/ODICMKJpfPedYZE
mAKCJWxf11BJJodCYkJxnm435o6Wx4+FUuefHHkkqCOD8w1mkaIUuSZI9LOUHDYk
eECLU5ztsC7UDkvs6N+XsF4Fq+/t9w==
=rRlF
-----END PGP SIGNATURE-----

--waLqEqmMHBOLvAom--
