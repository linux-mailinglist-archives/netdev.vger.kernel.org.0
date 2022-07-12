Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7E79572089
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbiGLQP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiGLQPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:15:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF0CC766C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 09:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 832E9B817B7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 16:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EA4C3411C;
        Tue, 12 Jul 2022 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657642552;
        bh=z75XBxac83AD/01WNBjzMKhL34pl8GUpHS9djLaniSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNqdeFyiuaMMJRziNdEeeeQAk8KUgVepagmGp3kn9ZfVYGAYJi9OhMKdPM2wEn0np
         YNAqQ2KPfPC8vOwC+tuVFLAq6AipH3ciqQW25APyAQvTg+mBqdki5TE49d4LeG1Fro
         FPjdc7vDLIU7OgdJMQTs4WWbIcGpqD6Ih/pICfXV9S2y8l6A3AOi21mpxtpulTiHU+
         nMtZnPD4sPwiQh7SLg3tvbegddT8ZjOAXMn6biZoj+O8nbUQCGE7h8jdpKFE/3IZj6
         9YBdqjPJRCT+vuQM7xPunSlhVSPy14rvSP4AxtvAwuMR1YfutI8rFz6nPMI90TzBZV
         l8KoxMZ1KFNXw==
Date:   Tue, 12 Jul 2022 18:15:48 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        jbrouer@redhat.com
Subject: Re: [PATCH net-next 2/4] net: ethernet: mtk_eth_soc: add basic XDP
 support
Message-ID: <Ys2eNDOEkxV2adQ3@lore-desk>
References: <cover.1657381056.git.lorenzo@kernel.org>
 <dc3235fd20b74f78f4f42550ca7513063269a752.1657381057.git.lorenzo@kernel.org>
 <9c0b3cef3029ea71f7802eab6214062aad48d509.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="m2G/tHNH8cP3VjQK"
Content-Disposition: inline
In-Reply-To: <9c0b3cef3029ea71f7802eab6214062aad48d509.camel@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--m2G/tHNH8cP3VjQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 2022-07-09 at 17:48 +0200, Lorenzo Bianconi wrote:

[...]
>=20
> The XDP program is apparently under an RCU protection schema (otherwise
> you will get UaF when replacing it). Why don't you have explicit RCU
> annotations? (here, and where the 'prog' field is touched).

ack, I will fix it in v2.

Regards,
Lorenzo

>=20
> Thanks!
>=20
> Paolo
>=20

--m2G/tHNH8cP3VjQK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYs2eNAAKCRA6cBh0uS2t
rGsIAQCsl8FNCzvD1YvUChkEmwGLZV26abfGh19wBclm5RwHDwD+J3HnUaPkNOcp
5icwhyCR3aYCMzmmSnpei5cFRx5OiQM=
=tt8/
-----END PGP SIGNATURE-----

--m2G/tHNH8cP3VjQK--
