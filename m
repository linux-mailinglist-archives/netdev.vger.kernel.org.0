Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3B52CD90
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiESHvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiESHvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E84131DC6;
        Thu, 19 May 2022 00:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CFEF616F6;
        Thu, 19 May 2022 07:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369D2C34100;
        Thu, 19 May 2022 07:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652946692;
        bh=FfHT4dH2rOQjGAgKaeBVEfcrb90XoHDYJNfYFwMsxqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wdv6bZZW5o0QW+rLup4siFbRoAjk45vnoN2mBGF4tNrdcd66OnuMRG65UQonX8drr
         8lGlydQqEA1F4HaXRjzM2tLRFkz1VPSZNN7REHWsnI4pFXI6LsbLxiHzqMrXTD4Uck
         LWfKHIP977c130bKAkPbczwSlC0tqqYAwJf61e6dWPNJupadE/Z0aG6+CZ8mAeIPF2
         FBPYyqQIr43HrGQhWuginBW4P5SG1y7+Xxh1cS93ikwaxiRVMzhYM4yRy6YZ8YeXnN
         FHmDu0tjisuECWEyEVCML7hB8WY3PbV/B/JOyv115n0FBHEB72P08WuToCiISPBZKJ
         +rjLTLvUacrpw==
Date:   Thu, 19 May 2022 09:51:28 +0200
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
Message-ID: <YoX3AMlBFfDcl69o@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
 <20220517184122.522ed708@kernel.org>
 <YoTA+5gLC4zhoQ0F@lore-desk>
 <20220518084431.66aa1737@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8OQvFQTAYPTT9lFf"
Content-Disposition: inline
In-Reply-To: <20220518084431.66aa1737@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--8OQvFQTAYPTT9lFf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, 18 May 2022 11:48:43 +0200 Lorenzo Bianconi wrote:
> > > On Mon, 16 May 2022 18:06:38 +0200 Lorenzo Bianconi wrote: =20
> > > >  /* PDMA RX Base Pointer Register */
> > > > -#define MTK_PRX_BASE_PTR0	0x900
> > > > +#define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x10=
0)
> > > >  #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10)) =
=20
> > >=20
> > > Implicit macro arguments are really unpleasant for people doing
> > > tree-wide changes or otherwise unfamiliar with the driver.
> > >=20
> > > Nothing we can do to avoid this? =20
> >=20
> > I used this approach in order to have just few changes in the codebase.=
 I guess the best
> > option would be to explicitly add eth parameter to the register macros,=
 what do you think?
>=20
> I don't think there's a best known practice, you'll have to exercise
> your judgment. Taking a look at a random example of MTK_PDMA_INT_STATUS.
> Looks like that one is already assigned to eth->tx_int_status_reg.
> Maybe that can be generalized? Personally I'd forgo the macros
> completely and just use eth->soc->register_name in the code.

I personally think the code is easier to read if we use macros in this case.
Let's consider MTK_LRO_CTRL_DW1_CFG(), it depends on the particular soc bas=
ed
on the register map and even on the ring index. I guess the best trade-off =
we
can get is to explicitly pass eth to the macros as parameter when needed.

Regards,
Lorenzo

--8OQvFQTAYPTT9lFf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoX3AAAKCRA6cBh0uS2t
rMJTAP9dIIJyzXlJOTfk8iKUs4K1OR4VWsGZQxS/9U+Knpof5QD/ared7Qln5hSb
jxz/VwPojHBJxLWHwNrp4ROvp7awIwA=
=/+XK
-----END PGP SIGNATURE-----

--8OQvFQTAYPTT9lFf--
