Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678C6672C7F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 00:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjARXV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 18:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjARXV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 18:21:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED31D15563;
        Wed, 18 Jan 2023 15:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 548C261AA9;
        Wed, 18 Jan 2023 23:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85F1C433D2;
        Wed, 18 Jan 2023 23:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674084116;
        bh=i9S00yMf8qyKo0oOTiPvurWtSMXbNJFJ77YkIhe5t5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2upfGLoOgCF/BO7wNwbw0zmOs/IH5KaUcAgR+WtytEGd3TIOcjEaMg494JQ0vQg5
         +xd6jbXucRrs2bbFavMHNvSfIQUSNxl7tsQPa0Mik175+pNhiO2if7w3doJCmO08+m
         3zxlRgCanZ5MOLYRlQWb+semP4UzRWhPBacSSrtwiJcq4r44ym70MmGI95Hv1TyqQ8
         iC6rA/UMCi76PbYqwV5Ed0laNIzujEkvZP23U4OoCdrF2fdNTETEtFMy6Pw3Kmv4hA
         IumOC6XmGFP33tHbJNLDQ3Eg4rn48ni1Rvj79PlZ1G+s37IgMm+21rit1JIA93VQPB
         kofi6m4FLuCng==
Date:   Wed, 18 Jan 2023 23:21:51 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v4 0/7] Add Ethernet driver for StarFive JH7110 SoC
Message-ID: <Y8h/D7I7/2KhgM00@spud>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CP+gNPEkC7FNanYh"
Content-Disposition: inline
In-Reply-To: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CP+gNPEkC7FNanYh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Yanhong!

On Wed, Jan 18, 2023 at 02:16:54PM +0800, Yanhong Wang wrote:
> This series adds ethernet support for the StarFive JH7110 RISC-V SoC. The=
 series
> includes MAC driver. The MAC version is dwmac-5.20 (from Synopsys DesignW=
are).
> For more information and support, you can visit RVspace wiki[1].
> =09
> This patchset should be applied after the patchset [2], [3], [4].
> [1] https://wiki.rvspace.org/
> [2] https://lore.kernel.org/all/20221118010627.70576-1-hal.feng@starfivet=
ech.com/
> [3] https://lore.kernel.org/all/20221118011108.70715-1-hal.feng@starfivet=
ech.com/
> [4] https://lore.kernel.org/all/20221118011714.70877-1-hal.feng@starfivet=
ech.com/

I've got those series applied, albeit locally, since they're not ready,
but I cannot get the Ethernet to work properly on my board.
I boot all of my dev boards w/ tftp, and the visionfive2 is no exception.
The fact that I am getting to the kernel in the first place means the
ethernet is working in the factory supplied U-Boot [1].

However, in Linux this ethernet port does not appear to work at all.
The other ethernet port is functional in Linux, but not in the factory
supplied U-Boot.

Is this a known issue? If it's not, I'll post the logs somewhere for
you. In case it is relevant, my board is a v1.2a.

Thanks,
Conor.

1 - U-Boot 2021.10 (Oct 31 2022 - 12:11:37 +0800), Build: jenkins-VF2_515_B=
ranch_SDK_Release-10

--CP+gNPEkC7FNanYh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY8h/DwAKCRB4tDGHoIJi
0kw8AP9GfecCx2UsoFt4mQLdt1S4n6zge+JkYT0BSfNEGwD7rQEAqPYvoYDK4Awd
bkmwzm7jj5RXNYNbs51sEKR/of7XXQ8=
=g7DT
-----END PGP SIGNATURE-----

--CP+gNPEkC7FNanYh--
