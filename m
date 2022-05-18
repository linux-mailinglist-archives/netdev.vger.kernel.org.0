Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1A52B6BF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 12:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233911AbiERJsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbiERJsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:48:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB035A09B;
        Wed, 18 May 2022 02:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD72617B5;
        Wed, 18 May 2022 09:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DABC385AA;
        Wed, 18 May 2022 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652867327;
        bh=lv4HBe8Wz66POFUcjOZzWjCJJ3a3Qv9oZQxybybs8dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIMawBjVDfDDMMhlmDCJY/yrMAjt2SSIwXqnjmd3tS4PdMgks21T0Sb6ttzXYbv61
         ULL2ftPjteTxt9snhY1aNU+9QrGFzq9f2avl9qq7E0jjkdybiSx2aco92RtJvox8kl
         UHRcpGdK98VxAq7GWNdyW4+lb8OWliGnccgw0CUsu2uJ4xDcnlZOFMSc/1uJ7Q0G3f
         RcUYVRTIIURdnL16sRNHJSM6dvGwnHL0sciJDyez5yNyAv/zoibfWOrDepzySmtscb
         qL5m6AAxgncPSWOGmnWCuWpbSe/S+03MJS+L5g1DZIJuujbyRcTZOvrzDE16wyfDQ4
         giEeVFhaZBmmQ==
Date:   Wed, 18 May 2022 11:48:43 +0200
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
Message-ID: <YoTA+5gLC4zhoQ0F@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
 <20220517184122.522ed708@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yGUCWlv2qAlCwbOl"
Content-Disposition: inline
In-Reply-To: <20220517184122.522ed708@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yGUCWlv2qAlCwbOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 16 May 2022 18:06:38 +0200 Lorenzo Bianconi wrote:
> >  /* PDMA RX Base Pointer Register */
> > -#define MTK_PRX_BASE_PTR0	0x900
> > +#define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x100)
> >  #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))
>=20
> Implicit macro arguments are really unpleasant for people doing
> tree-wide changes or otherwise unfamiliar with the driver.
>=20
> Nothing we can do to avoid this?

I used this approach in order to have just few changes in the codebase. I g=
uess the best
option would be to explicitly add eth parameter to the register macros, wha=
t do you think?

Regards,
Lorenzo

--yGUCWlv2qAlCwbOl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoTA+gAKCRA6cBh0uS2t
rKu7AQCqZ6gTV/nH6swFYufh/JvGdCvn+Ju4SVI9ORYBZxNvLgEA0u4maXWDKZI0
eaenqEJ2bXJPNuae7fRx9qniJRt97gQ=
=/+Hi
-----END PGP SIGNATURE-----

--yGUCWlv2qAlCwbOl--
