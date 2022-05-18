Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3B252B4F3
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbiERI37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiERI35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665E813D76;
        Wed, 18 May 2022 01:29:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18E6EB81EEC;
        Wed, 18 May 2022 08:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487EBC385AA;
        Wed, 18 May 2022 08:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652862592;
        bh=0abp1pszzsRBx5y5nc3egC4D4HkrMKsciN1YVkpNL6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzQG4rxQryyz4XT24Lc3jCcLIMgpq3o5cM4Kw8JjxTBlkVJpFu7k+W8D71NpvrgFJ
         OQ/jjI3WaTLFvRI26qQ3nw1elquXdpbzm2vrzoSuo/59jHnWoD50iYgo1yQ+A3ZVNc
         ykQwWV4ptWmohUAA62Inkgc4rFpkgqTJomn+dQhqDc9YkxgKrAsSVN7lILAQvn/AwH
         MDByP5EQlmIr67oIZU/eVRG7k0rpwe0QqvTj1QNE/+QizdlCPUEFti+DuMBBnPryfB
         LLrxHxcnb+mJC+LX+EEhLaih3EsAzeaIsmV9HkPQIKIIcrbK9NYIX5tAQ5qLxNO2g5
         gxVLUGa7S5QOQ==
Date:   Wed, 18 May 2022 10:29:48 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 04/15] net: ethernet: mtk_eth_soc: add
 txd_size to mtk_soc_data
Message-ID: <YoSufPWnGPdtVYZ+@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
 <22bd1bd88c09205b9bf83ea4c3ab030d5dc6e670.1652716741.git.lorenzo@kernel.org>
 <20220517183311.3d4c76fe@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kza9CdNu8v+g1M7c"
Content-Disposition: inline
In-Reply-To: <20220517183311.3d4c76fe@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kza9CdNu8v+g1M7c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 16 May 2022 18:06:31 +0200 Lorenzo Bianconi wrote:
> >  	eth->scratch_ring =3D dma_alloc_coherent(eth->dma_dev,
> > -					       cnt * sizeof(struct mtk_tx_dma),
> > +					       cnt * soc->txrx.txd_size,
> >  					       &eth->phy_scratch_ring,
> >  					       GFP_ATOMIC);
> >  	if (unlikely(!eth->scratch_ring))
> >  		return -ENOMEM;
> > =20
> > -	eth->scratch_head =3D kcalloc(cnt, MTK_QDMA_PAGE_SIZE,
> > -				    GFP_KERNEL);
> > +	eth->scratch_head =3D kcalloc(cnt, MTK_QDMA_PAGE_SIZE, GFP_KERNEL);
>=20
> Unrelated, but GFP_ATOMIC right next to GFP_KERNEL caught my attention.

ack, mtk_init_fq_dma() is run by mtk_open() so it is ok to use GFP_KERNEL. I
will fix it in v3.

Regards,
Lorenzo

--kza9CdNu8v+g1M7c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoSufAAKCRA6cBh0uS2t
rFYlAQC2wAg1jYAWiba7EodXO/uiiufplKyBb3ecXPYBR62etAD+ND4ZonW4brDP
P3P5htwp0JlPey9fJNA1452zhxCQOgs=
=0Wh0
-----END PGP SIGNATURE-----

--kza9CdNu8v+g1M7c--
