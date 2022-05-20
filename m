Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAE1952F21D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiETSL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiETSLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:11:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DD0580D2;
        Fri, 20 May 2022 11:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D7B86178C;
        Fri, 20 May 2022 18:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72113C385A9;
        Fri, 20 May 2022 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070281;
        bh=k/yJclsWlrwAFMAoHXAQBg8IUcASAQM+ZxdCKiEZ3o0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gWzdXZX8E2cheZv2N7f9vQRmDrxDCYMjKMAirb/L+ZiAI9bkMaqPQX8dgplfBW2l+
         urhqN5F3kd0I4MidxnVeVINAjqG74n/jsqvgm8dWzeQLeHV+vaownZI4tK/sVQmoI4
         NYrOBX1gSF0oGs1l8at4wRt8ingJR7/BCodpA8nAXUCvQ6WyLVeJRYjkv9qMqdfi1V
         mrPcUlH1bqw8lgWlgaKa+Yw1xmDty+3YAkaFmHgbYwvU7Mvo7wcPl3HojbAKVRQrO4
         lvbn3IMpKp49shNVCCCuUbUyHNQN0hrOz0D6gePQWsnXjquhjyAwJxDRHx+33m0o07
         zF5GPSVolicxw==
Date:   Fri, 20 May 2022 20:11:16 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 11/15] net: ethernet: mtk_eth_soc: introduce
 device register map
Message-ID: <YofZxFO2nGuPCyZi@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
 <20220517184122.522ed708@kernel.org>
 <YoTA+5gLC4zhoQ0F@lore-desk>
 <20220518084431.66aa1737@kernel.org>
 <YoX3AMlBFfDcl69o@lore-desk>
 <20220519091224.4409b54d@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Hegm7aOIsPhLkENM"
Content-Disposition: inline
In-Reply-To: <20220519091224.4409b54d@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Hegm7aOIsPhLkENM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 19 May 2022 09:51:28 +0200 Lorenzo Bianconi wrote:
> > > I don't think there's a best known practice, you'll have to exercise
> > > your judgment. Taking a look at a random example of MTK_PDMA_INT_STAT=
US.
> > > Looks like that one is already assigned to eth->tx_int_status_reg.
> > > Maybe that can be generalized? Personally I'd forgo the macros
> > > completely and just use eth->soc->register_name in the code. =20
> >=20
> > I personally think the code is easier to read if we use macros in this =
case.
> > Let's consider MTK_LRO_CTRL_DW1_CFG(), it depends on the particular soc=
 based
> > on the register map and even on the ring index. I guess the best trade-=
off we
> > can get is to explicitly pass eth to the macros as parameter when neede=
d.
>=20
> Yeah, do you, I was just sharing what my knee jerk direction would be.
> You know the code better.

reworking the code I introduced a register map removing the macro dependenc=
y.
I will post v3 soon.

Regards,
Lorenzo

--Hegm7aOIsPhLkENM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYofZxAAKCRA6cBh0uS2t
rHdnAPwNnnUCfrfNOQE+XS8G2+JVOD3zD5Mm04pipDf4xGwi2AEAwmpnbYwRQlnZ
ivMIn2SWK8Rx8uxbKDxQAGNFLEFD6A8=
=XugI
-----END PGP SIGNATURE-----

--Hegm7aOIsPhLkENM--
