Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A762F693033
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 12:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjBKLLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 06:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBKLLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 06:11:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FA08A5E;
        Sat, 11 Feb 2023 03:11:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 225CEB80122;
        Sat, 11 Feb 2023 11:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A369CC433D2;
        Sat, 11 Feb 2023 11:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676113905;
        bh=bSc3QDkye7G9brveSsTMHHaP4EPwwtXKdg0WmqV1umU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CiCGIO4wHeg6JQxT/y7YBpqTzyXtJIUzaPGd8SF3pY2iHyGGEh/nbleA0AtbQuMEq
         KReZiJB6MGrKU3+tqOh2Xu19WAwTUHm3J9B3Y1MB9ST+ZI+eNrGdRYUbtXHpCzT21p
         ezPENxYiFLSp9XY5SFryvk8vLyW5VgR7IJP/PrTzMeMNe+F3OkrIpqqw6dJOXsA54E
         aCDnTABvUhX45PQ2F5pdim+GVjCBdUCRWjdbtuCZ0ZoIx2o/h/2g2utpJNXgwXmn/x
         /Ru0ZgBBu8rmvTwXqq6DbwgY9USXxd8jMtPJvOqUObEyXSzpCV8Y0pa7xI+RwqWKd1
         AwYvY5oQgxWdw==
Date:   Sat, 11 Feb 2023 11:11:38 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com,
        arnd@arndb.de, prabhakar.csengg@gmail.com
Subject: Re: [PATCH 00/12] Enable networking support for StarFive JH7100 SoC
Message-ID: <Y+d36nz0xdfXmDI1@spud>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j1FzqJZn+VPtvkJp"
Content-Disposition: inline
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--j1FzqJZn+VPtvkJp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Cristian!

+CC Arnd, Prabhakar

On Sat, Feb 11, 2023 at 05:18:09AM +0200, Cristian Ciocaltea wrote:
> This patch series adds ethernet support for the StarFive JH7100 SoC and=
=20
> makes it available for the StarFive VisionFive V1 and BeagleV Starlight=
=20
> boards, although I could only validate on the former SBC.
>=20
> The work is heavily based on the reference implementation [1] and require=
s=20
> the non-coherent DMA support provided by Emil via the Sifive Composable=
=20
> Cache controller.
>=20
> Also note there is an overlap in "[PATCH 08/12] net: stmmac: Add glue lay=
er=20
> for StarFive JH7100 SoC" with the Yanhong Wang's upstreaming attempt [2]:
> "[PATCH v4 5/7] net: stmmac: Add glue layer for StarFive JH7110 SoCs".=20
>=20
> Since I cannot test the JH7110 SoC, I dropped the support for it from Emi=
l's
> variant of the stmmac glue layer. Hence, we might need a bit of coordinat=
ion
> in order to get this properly merged.

To be honest, that one is the least of your worries sequencing wise.
Anything doing non-coherent DMA on RISC-V that doesn't use instructions is
dependant on Prabhakar's series:
https://lore.kernel.org/linux-riscv/20230106185526.260163-1-prabhakar.mahad=
ev-lad.rj@bp.renesas.com/#t
That's kinda stalled out though, waiting on Arnd to make some changes to
the cross-arch DMA code:
https://lore.kernel.org/linux-riscv/ea4cb121-97e9-4365-861a-b3635fd34721@ap=
p.fastmail.com/

I was talking to Emil about the non-coherent support at FOSDEM actually,
and I see no real reason not to bring the JH7100 non-coherent support in
if we are doing it for other SoCs.

So yeah, hopefully we shall get there at some point soonTM...

Sorry,
Conor.

> [1] https://github.com/starfive-tech/linux/commits/visionfive
> [2] https://lore.kernel.org/linux-riscv/20230118061701.30047-6-yanhong.wa=
ng@starfivetech.com/
>=20
> Cristian Ciocaltea (7):
>   dt-bindings: riscv: sifive-ccache: Add compatible for StarFive JH7100
>     SoC
>   dt-bindings: riscv: sifive-ccache: Add 'uncached-offset' property
>   dt-bindings: net: Add StarFive JH7100 SoC
>   riscv: dts: starfive: Add dma-noncoherent for JH7100 SoC
>   riscv: dts: starfive: jh7100: Add ccache DT node
>   riscv: dts: starfive: jh7100: Add sysmain and gmac DT nodes
>   riscv: dts: starfive: jh7100-common: Setup pinmux and enable gmac
>=20
> Emil Renner Berthing (5):
>   soc: sifive: ccache: Add StarFive JH7100 support
>   soc: sifive: ccache: Add non-coherent DMA handling
>   riscv: Implement non-coherent DMA support via SiFive cache flushing
>   dt-bindings: mfd: syscon: Add StarFive JH7100 sysmain compatible
>   net: stmmac: Add glue layer for StarFive JH7100 SoC
>=20
>  .../devicetree/bindings/mfd/syscon.yaml       |   1 +
>  .../devicetree/bindings/net/snps,dwmac.yaml   |  15 +-
>  .../bindings/net/starfive,jh7100-dwmac.yaml   | 106 ++++++++++++
>  .../bindings/riscv/sifive,ccache0.yaml        |  33 +++-
>  MAINTAINERS                                   |   6 +
>  arch/riscv/Kconfig                            |   6 +-
>  .../boot/dts/starfive/jh7100-common.dtsi      |  78 +++++++++
>  arch/riscv/boot/dts/starfive/jh7100.dtsi      |  55 +++++++
>  arch/riscv/mm/dma-noncoherent.c               |  37 ++++-
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |  12 ++
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-starfive.c  | 155 ++++++++++++++++++
>  drivers/soc/sifive/Kconfig                    |   1 +
>  drivers/soc/sifive/sifive_ccache.c            |  71 +++++++-
>  include/soc/sifive/sifive_ccache.h            |  21 +++
>  15 files changed, 587 insertions(+), 11 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7100=
-dwmac.yaml
>  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
>=20
> --=20
> 2.39.1
>=20

--j1FzqJZn+VPtvkJp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+d36gAKCRB4tDGHoIJi
0tBsAQDdrlFgBWg7PiySc6og9Whrn0zcOLK13yTZBJsgJt+dpQEA7lF2MNYZsVWJ
2GMwFbzf/sF46dzxMbyYAIa8XTMemws=
=Slx1
-----END PGP SIGNATURE-----

--j1FzqJZn+VPtvkJp--
