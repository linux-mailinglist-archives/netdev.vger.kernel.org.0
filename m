Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD52699F79
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 22:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBPVyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 16:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjBPVyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 16:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D119772;
        Thu, 16 Feb 2023 13:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F07CBB829C0;
        Thu, 16 Feb 2023 21:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEA3C4339E;
        Thu, 16 Feb 2023 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676584390;
        bh=/89NA4NAoXcXzdPfjHUemplkBWp+8gbW+gPen4ZFpgo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xx7q4GXXB4Ze6YTbHhjjCXHrGwNp71BIJV5GuJj4gBwBiwzTg6nkKStAHxNTmYAcy
         qbDmYTSljpicwjrAbhw5o/ypDDD0tgcN26EfyZPgeM1yI1U7lOOg7oHb35651sjpBe
         PZ3IeInK+WNQUl00mwuiCFvStJUKoaCwq6saPl6xj8Aa3Se3DH/+s8LiyHyAFtqu+H
         dsRq+jSUQU7Ns+eRE5UkrZotfNyo1vvj0nuOX633djBUYop/B4g5vkZjFroJsa5C8D
         ptZXCA31Et8eKsHz+ywE8GbM+0R51PxwoNZwLz68UUZrQNR0n+X07KI3BbaeeNo1gW
         mupdA/vmOkC8w==
Date:   Thu, 16 Feb 2023 21:53:02 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Emil Renner Berthing <emil.renner.berthing@canonical.com>,
        daire.mcnamara@microchip.com
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
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: Re: [PATCH 02/12] dt-bindings: riscv: sifive-ccache: Add
 'uncached-offset' property
Message-ID: <Y+6lvizTUhF9t+xk@spud>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-3-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+OUnDp7k4pWMwsmV"
Content-Disposition: inline
In-Reply-To: <20230211031821.976408-3-cristian.ciocaltea@collabora.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+OUnDp7k4pWMwsmV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey all,

On Sat, Feb 11, 2023 at 05:18:11AM +0200, Cristian Ciocaltea wrote:
> Add the 'uncached-offset' property to be used for specifying the
> uncached memory offset required for handling non-coherent DMA
> transactions.
>=20
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>  Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml =
b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> index 2b864b2f12c9..60cd87a2810a 100644
> --- a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> +++ b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
> @@ -82,6 +82,11 @@ properties:
> =20
>    next-level-cache: true
> =20
> +  uncached-offset:
> +    $ref: /schemas/types.yaml#/definitions/uint64
> +    description: |
> +      Uncached memory offset for handling non-coherent DMA transactions.

Firstly, this pretty tied to the StarFive stuff, where there is only one
"bank" of memory that neatly maps to one bank of non-cached memory.
On PolarFire SoC, where we would also like to make use of non-coherent
DMA for some transfers using the FPGA fabric, things are a bit more
complex.
Instead of a region & a non-cached alias, we have 2 regions and 2
non-cached regions.
These regions lie at 0x8000_0000 & 0x10_0000_0000 and the non-cached
regions are at 0xc000_0000 & 0x14_0000_0000. As you can tell, one fixed
offset isn't going to work there!

The other bit of a problem is that there is no fixed concept of aliases,
as seems to be the case on the jh7100. Instead, where the regions
"point" to in physical DDR is something that is configurable at runtime.
Practically speaking, it is set by firmware very early on in boot & is
fixed from there out, but will vary between boards and FPGA fabric
configuration. Effectively that means that from the PoV of a Devicetree
it is constant, but a good bit of flexibility is going to be needed.

What we have been doing on PolarFire SoC (although mostly internally at
this point) is, rather than creating a property like uncached-offset, we
instead are using the dma-ranges properties to induce the same affect.

In an example configuration with memory at:
	reg =3D <0x0 0x80000000 0x0 0x4000000>;
	reg =3D <0x0 0x8a000000 0x0 0x8000000>;
	reg =3D <0x0 0xc4000000 0x0 0x6000000>;
	reg =3D <0x10 0x22000000 0x0 0x5e000000>;
	reg =3D <0x14 0x12000000 0x0 0x10000000>;

a reserved memory section then covering the non-cached region at
0x14_0000_0000:
	dma_non_cached_high: non-cached-high-buffer {
		compatible =3D "shared-dma-pool";
		size =3D <0x0 0x10000000>;
		no-map;
		linux,dma-default;
		alloc-ranges =3D <0x14 0x12000000 0x0 0x10000000>;
	};

and dma-ranges:
	dma-ranges =3D <0x14 0x0 0x0 0x80000000 0x0 0x4000000>,
		     <0x14 0x4000000 0x0 0xc4000000 0x0 0x6000000>,
		     <0x14 0xa000000 0x0 0x8a000000 0x0 0x8000000>,

In this configuration, 0x8000_0000, 0x10_0000_0000, 0xc000_0000 &
0x14_0000_0000 are all aliases of the same address.
With this setup, we're able to do non-coherent DMA to the FPGA fabric,
to the PCI for example.
The DTS does grow a bit of complexity, with reserved memory regions and
dma-ranges - but at least they're standard properties!

Emil, if you want to take a look at that it is here:
https://github.com/linux4microchip/linux linux-5.15-mchp
I think I said to you before that it was based on one of Atish's early
approaches, the one from the 5.15 development cycle IIRC since we're
using that LTS.
Obviously it'll need changes to be upstreamable so we're not wedded to
this approach. For instance, it's being controlled by a compile time
option at the moment, so that clearly needs to become runtime for
upstream (and realistically needs to be one in our vendor tree too...)

I'll try to hack that approach into the visionfive v1 soonTM and see how
it goes, but it'll not be this side of March before I have time to do
that.

Cheers,
Conor.


--+OUnDp7k4pWMwsmV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+6lvgAKCRB4tDGHoIJi
0ulqAQCULkPATgqWtudHs9arilghmWnIl+5HOdnui0TiEobVIwD9EJWZRVVAGTBQ
VrKlrkCPLqc12a+YcCC0aBjkaR6SDwI=
=ZTRK
-----END PGP SIGNATURE-----

--+OUnDp7k4pWMwsmV--
