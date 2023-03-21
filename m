Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576046C2E08
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbjCUJiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCUJhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:37:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56C830E8D;
        Tue, 21 Mar 2023 02:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D36A7CE17F9;
        Tue, 21 Mar 2023 09:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A446C433EF;
        Tue, 21 Mar 2023 09:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679391464;
        bh=M2km7NeYtbDiNvCXTjsmLfBwsmrUm67rl9hiQ4CAzCo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VeQrEKjA92buWjy+LQhn80xdgzkiTvrIzUWOrQQ5Xa2D38LQGiGuyY/vyJZof+i6C
         et+G2qmFU439tDb3LlEA32s+D727+EVLLaxzI8h3fUacOQqQrAMDjkTSoIxJJ586TU
         3GWKE+RST/M0SzPJW/ume0Ssd7RMKNajVCYpfwSGjHRociXKDtPgxL/aO/q3j1FPmr
         v6HKmp2/RoEub9pakT8f5+bJRBYSWg9bLom6AlbaKThLYh+it3Ejz/XFepk6O5fuA2
         awa4uvR87SVg04kjSSwTt6AxG3jyWtNWVs8Ppb2Z0aCEj2xYbSNy1ZKxGRje0M55sN
         IqEonHN9szF4A==
Date:   Tue, 21 Mar 2023 10:37:40 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo.bianconi@redhat.com, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 00/10] mtk: wed: move cpuboot, ilm and dlm in
 dedicated dts nodes
Message-ID: <ZBl65HJ/C0OXbs8p@lore-desk>
References: <cover.1679330630.git.lorenzo@kernel.org>
 <20230320214356.27c62f9f@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7BR5PQLPyhuqm5AG"
Content-Disposition: inline
In-Reply-To: <20230320214356.27c62f9f@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7BR5PQLPyhuqm5AG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 20 Mar 2023 17:57:54 +0100 Lorenzo Bianconi wrote:
> >  arch/arm64/boot/dts/mediatek/mt7986a.dtsi     | 69 +++++++-------
>=20
> Do you know if this can go via our tree, or via arm/MediaTek ?

Since the series requires some network driver changes I would say it should=
 go
through the net-next tree but I do not have any strong opinion on it.

Regards,
Lorenzo

--7BR5PQLPyhuqm5AG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZBl64wAKCRA6cBh0uS2t
rB+oAPwP1g2z76hQlLN/oEDtcCxiY9GmZWFZZzNvBaPcTD27cQEA0RXphY5285ku
1RcoYXlNoBdNys3TTdVzRncL6v6GuwY=
=NAfq
-----END PGP SIGNATURE-----

--7BR5PQLPyhuqm5AG--
