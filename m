Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E76DC819
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjDJOyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDJOyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491484ED2;
        Mon, 10 Apr 2023 07:54:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08556103F;
        Mon, 10 Apr 2023 14:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D9C433EF;
        Mon, 10 Apr 2023 14:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681138454;
        bh=9+uOJWRfOOVtlTBySmg32nz3qSkxlHDeOSpYS+o/RlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ssAqJLGeCv4udxLGiYHv6O38FhSmjbqX2wp9b/hgpG2OED4HO/QFSXcN7Z2dUrNq+
         eI+Ff5vJYt05iDKQToytkFVNzf0IqjYHDz0IXgMTJffGfKbU6mvRuKXcO2RzblWn+k
         aKcoF4an4eHpQEVNUsdU4fCQo3ubojUDJ5rHL9GBGelkJRW2IJX/pK4u0CWKlfbr8T
         UIhaxAsOtFMxz7+sip5msZdAf9PMqkKj5SPxuokS1kwM1dOBPILyofwLFpO/LUAjGn
         oy4oM4CdTOLZ5v5PQV4X+MlN1WDFIp3Dn/aEy4kNRgDcFUX3cWZL/Yd132KaCrWMgr
         Pc8EIbkmSVvgA==
Date:   Mon, 10 Apr 2023 16:54:10 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in
 dedicated dts nodes
Message-ID: <ZDQjEkTstngxib/0@lore-desk>
References: <cover.1680268101.git.lorenzo@kernel.org>
 <20230406152511.GA3117403-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Mbdi1ZojGS1vdtOH"
Content-Disposition: inline
In-Reply-To: <20230406152511.GA3117403-robh@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Mbdi1ZojGS1vdtOH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Mar 31, 2023 at 03:12:36PM +0200, Lorenzo Bianconi wrote:
> > Since cpuboot, ilm and dlm memory region are not part of MT7986 SoC RAM,
>=20
> That's not really a requirement. Is that the only "problem" here?

I would say this series allows to be closer to a standard binding and at the
same time helps with uboot compatibility.

>=20
> Certainly going from a standard binding to a custom phandle reference is=
=20
> not an improvement.
>=20
> > move them in dedicated mt7986a syscon dts nodes.
>=20
> What makes them a syscon? Are they memory or h/w registers? Can't be=20
> both...

>=20
> Perhaps mmio-sram?

ilm and dlm do not have h/w registers afaik, they are chip memory used
to store firmware information, syscon is just the closest binding I found.
I did not find mmio-sram, my fault.

Regards,
Lorenzo

>=20
> > At the same time we keep backward-compatibility with older dts version =
where
> > cpuboot, ilm and dlm were defined as reserved-memory child nodes.
>=20
> Doesn't really seem big enough issue to justify carrying this.
>=20
> Rob

--Mbdi1ZojGS1vdtOH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZDQjEgAKCRA6cBh0uS2t
rNnEAP98v7/BKa/Fd5y1OymB9T4LAXXAgNEIA7/LExkl8VzmzQD+L0fjplWxRgsc
nyGfpakLxtEGDs0uoT1Qtz4Fd7IzAAI=
=ri5+
-----END PGP SIGNATURE-----

--Mbdi1ZojGS1vdtOH--
