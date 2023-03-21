Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3936C3376
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbjCUNy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjCUNy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:54:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF44D42D;
        Tue, 21 Mar 2023 06:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37521B816A4;
        Tue, 21 Mar 2023 13:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7E9C433EF;
        Tue, 21 Mar 2023 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679406865;
        bh=sLwXEUpXzwGTKCNG2RTmaVz2tpCNp4oAQ+9c+0qNAPI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P6ZTvsXN6sEGNLHViZE8UiBJlkzlMu0GZOFo5s/ofNtlJk884f+PBy8qJDh2Y+i9O
         VmNOVST7oeHB4NtEfkW8wTFGEMwkVo5aK5h06kUp941HHO1kJwUlqiqw73S+HcsYOG
         ssdW7aqVKaPU6HpUEUqiarl/dxbhAK64Yr4M3au8+C0bfu19pPc2xLACyPE2SQ1rxO
         8tOdQKSnxMtoHklZAWgac87QQSVlCvWvLRGFteXYVW1qRNwWIbhpEuMNBWNpjSb7o7
         yQNU6+2sDgio/0K9BQByDIH7TdQuTuS+uMXFFpeBjq+D/hiXfy6YZ53rPnjxrYfXaT
         lttv7P+xrcH3Q==
Date:   Tue, 21 Mar 2023 14:54:22 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     daniel@makrotopia.org, netdev@vger.kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        sean.wang@mediatek.com, devicetree@vger.kernel.org,
        edumazet@google.com, davem@davemloft.net,
        krzysztof.kozlowski+dt@linaro.org, lorenzo.bianconi@redhat.com,
        Mark-MC.Lee@mediatek.com, john@phrozen.org, nbd@nbd.name,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH net-next 06/10] dt-bindings: soc: mediatek: move ilm in a
 dedicated dts node
Message-ID: <ZBm3DvjvvHC+3EAH@lore-desk>
References: <cover.1679330630.git.lorenzo@kernel.org>
 <c9b65ef3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org>
 <167940235606.530981.2024563505368619498.robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JpkRWRtszDHfbi1x"
Content-Disposition: inline
In-Reply-To: <167940235606.530981.2024563505368619498.robh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--JpkRWRtszDHfbi1x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
> On Mon, 20 Mar 2023 17:58:00 +0100, Lorenzo Bianconi wrote:
> > Since the cpuboot memory region is not part of the RAM SoC, move ilm in
> > a deidicated syscon node.
> > This patch helps to keep backward-compatibility with older version of
> > uboot codebase where we have a limit of 8 reserved-memory dts child
> > nodes.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 14 +++---
> >  .../soc/mediatek/mediatek,mt7986-wo-ilm.yaml  | 45 +++++++++++++++++++
> >  2 files changed, 53 insertions(+), 6 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/medi=
atek,mt7986-wo-ilm.yaml
> >=20
>=20
> My bot found errors running 'make DT_CHECKER_FLAGS=3D-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>=20
> yamllint warnings/errors:
>=20
> dtschema/dtc warnings/errors:
> Error: Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed=
=2Eexample.dts:63.59-60 syntax error
> FATAL ERROR: Unable to parse input tree
> make[1]: *** [scripts/Makefile.lib:419: Documentation/devicetree/bindings=
/arm/mediatek/mediatek,mt7622-wed.example.dtb] Error 1
> make[1]: *** Waiting for unfinished jobs....
> make: *** [Makefile:1512: dt_binding_check] Error 2

Hi Rob,

I think it is just a typo in a patch in the middle of the series that I fix=
ed
in the latest one (before posting I compiled the dts schema with the full s=
eries
applied and not incrementally). I will fix it in v2. Thanks.

Regards,
Lorenzo

>=20
> doc reference errors (make refcheckdocs):
>=20
> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/c9b65e=
f3aeb28a50cec45d1f98aec72d8016c828.1679330630.git.lorenzo@kernel.org
>=20
> The base for the series is generally the latest rc1. A different dependen=
cy
> should be noted in *this* patch.
>=20
> If you already ran 'make dt_binding_check' and didn't see the above
> error(s), then make sure 'yamllint' is installed and dt-schema is up to
> date:
>=20
> pip3 install dtschema --upgrade
>=20
> Please check and re-submit after running the above command yourself. Note
> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
> your schema. However, it must be unset to test all examples with your sch=
ema.
>=20

--JpkRWRtszDHfbi1x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZBm3DgAKCRA6cBh0uS2t
rIT4AQDJ0/RUcQ7x5fJKWJaVZ1iajTTGklMAnLOvSiTd8H9wdwD/YtZTqKWECe5o
5y6JQDle8/SY+VNgY1swVG/Mppt+Jwc=
=kpaY
-----END PGP SIGNATURE-----

--JpkRWRtszDHfbi1x--
