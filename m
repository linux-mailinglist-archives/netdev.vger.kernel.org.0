Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB90851E018
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442617AbiEFUZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442564AbiEFUZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:25:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0994064725;
        Fri,  6 May 2022 13:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97C2162213;
        Fri,  6 May 2022 20:21:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B945C385A9;
        Fri,  6 May 2022 20:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651868511;
        bh=cLKLhRbbocol9rJIAJIP4JoIO/mWUJ8WKXroVZt+kQk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kje+/43WAxiwcb2Qs2nxC7Bo1eaZoYyUrU3tYkZIFYt+oGj9BMUX1rH6eMjtR1Ry2
         Ujsvc/k4GpYTqKGjnf6pKT8whfbJLLNn3l9nq31cZnF01Uuyryv8V2eC65WzrEfF9d
         +TdESfWPWp4arAqXE8YEP4VQ12T7LtEw3cLToR9wqpofr1DTCAjRHkfluOcY2FS3lg
         k85hoPlcIaGX957zVhthJdUGGuIlPbmLRSI2QrutAE/DiHj0W/8AnwZr63RRi3zO/w
         Z+8/tOvmaAOwF/N3o7lqEWBp9uKw1wDL5JCDTcXrMRBGFce8/CVkb1dDltN9Kw5RSl
         57ty5sYUXIB2A==
Date:   Fri, 6 May 2022 22:21:45 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org
Subject: Re: [PATCH net-next 11/14] net: ethernet: mtk_eth_soc: add SRAM soc
 capability
Message-ID: <YnWDWU5wqgfcWND1@lore-desk>
References: <cover.1651839494.git.lorenzo@kernel.org>
 <97298a5aeaa7498893a46103de929d0a7df26e8a.1651839494.git.lorenzo@kernel.org>
 <20220506104109.63388e33@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rLjMcV4QepMwlsrM"
Content-Disposition: inline
In-Reply-To: <20220506104109.63388e33@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rLjMcV4QepMwlsrM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On May 06, Jakub Kicinski wrote:
> On Fri,  6 May 2022 14:30:28 +0200 Lorenzo Bianconi wrote:
> > Introduce SRAM capability for devices that relies on SRAM memory
> > for DMA descriptors.
> > This is a preliminary patch to add mt7986 ethernet support.
>=20
> sparse says boo. I think you dropped an __iomem somewhere.

ack, I will fix it in v2.

>=20
> Please heed the 24h rule.

ack :)

Regards,
Lorenzo

--rLjMcV4QepMwlsrM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYnWDWQAKCRA6cBh0uS2t
rD/pAQD0oGK1X3Ef9v8e3M4KKsaCWTwRUYRgX0rto1i3rbWRAAD/T97NIrVlJ2SF
KYk5kgfnn9NS4QDPqcXK8oG3nI37iQE=
=no2d
-----END PGP SIGNATURE-----

--rLjMcV4QepMwlsrM--
