Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E2059E49B
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiHWNn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241050AbiHWNnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:43:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801031F95CD
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED284B81CD9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E287C433D6;
        Tue, 23 Aug 2022 10:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661251616;
        bh=D1lCmDl3kZ3oppeDaUnuKslu+45Wjj5DjxvNo9AZ6Aw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HIe9w6lSdAOT+YkYvAfmv8vxbbA0JNvzeL7vbxyCY+pTiXGZKRqsZDBL1SPK2X+Ww
         0RzI23LXGczeX+00LKZfOfAwm8/GCnMvT+HBdEX0JnY+BwJhjXu2OgXmFpk0A94Rpj
         w0tmibpFcms6ylN756FehbGCsUhNtpBCwlqgFrQ2ktOS8ARMaLUv0Tj0+xdTpJqXyG
         tQKMTsgnmBl0AwqytxemiG6I9nF6oh9p0lKL7FB3bFMqXOhVP0tniCBIFHCNbAyiDl
         KX/N9BK8xghvZqdmhxneI9wvvvl9z0I9wy9gXy55fzrzJ5qvNX6tfM9fVa/riRsajl
         G6oKKUP0cwDMw==
Date:   Tue, 23 Aug 2022 12:46:52 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: fix hw hash
 reporting for MTK_NETSYS_V2
Message-ID: <YwSwHE7ArgX5nRe+@lore-desk>
References: <890fc9b747e7729fb6b082a1f7fd309a58768cca.1661012748.git.lorenzo@kernel.org>
 <abce7e128957b3e86a6d73a7b383b6404ba2db65.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W2RK5J5HQDSleOZC"
Content-Disposition: inline
In-Reply-To: <abce7e128957b3e86a6d73a7b383b6404ba2db65.camel@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W2RK5J5HQDSleOZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hello,

Hi Paolo,

>=20
> On Sat, 2022-08-20 at 18:27 +0200, Lorenzo Bianconi wrote:
> > Properly report hw rx hash for mt7986 chipset accroding to the new dma
> > descriptor layout.
> >=20
> > Fixes: 197c9e9b17b11 ("net: ethernet: mtk_eth_soc: introduce support fo=
r mt7986 chipset")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> This looks like a simple fix and the commit pointed by the 'fixes' tag
> is already on -net. Would you mind to repost this targeting the
> appropriate tree? Or there is any special reason to target net-next
> instead?

ack, I will repost for net. thx.

Regards,
Lorenzo

>=20
> Thanks!
>=20
> Paolo
>=20

--W2RK5J5HQDSleOZC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYwSwHAAKCRA6cBh0uS2t
rG8zAP9A/Qk++Ac84U0PbJY7rfyuWpSIEA3FZbjBd4sVYeRjvAD/fiT1tUd5bbKx
R/8oeCWQ2stUkEkpRQE3NWqRvZzBjw4=
=1csL
-----END PGP SIGNATURE-----

--W2RK5J5HQDSleOZC--
