Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79794573140
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbiGMIgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiGMIgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E5CC0521
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBFD2B81D5D
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 08:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B98C341C8;
        Wed, 13 Jul 2022 08:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657701409;
        bh=A6tA3sMNTJ+pfpG/2lKC//CPyCDix7bT9c5q9QV/Y/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ry8hELMwHNQ2QhoXuTTwsF7tgUFIR9eGcSpsok6XkU+nhmiywMwWA/kOVVEODTPmT
         8mwVXpOal3j3vrM0RFCAEXdD7f2SrSnTYEuee65gAhq+zBaO4AqCZWkQX3mapiXnD6
         xBEQwEz1aELGXCh3Xl253e9+XqEfIzCuhbfwyW08k0Fm6s5fFPWM6qTVlyxygYgprm
         AL06vjm8Aw7bpm4IfZM1lzY3MXnbGySXxkONCZ/9QC6p/UYxi6C2AZOqxlHCpg8xhu
         A7bWfqG0iC91M2uPgQTHzBU8YYNZnm/Ci924hBh+VkSIjXFMy+1H4Gl11+Z2cCT8mN
         rBJxVyy40VwLw==
Date:   Wed, 13 Jul 2022 10:36:44 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        jbrouer@redhat.com
Subject: Re: [PATCH v2 net-next 2/4] net: ethernet: mtk_eth_soc: add basic
 XDP support
Message-ID: <Ys6EHHsFegBNX7AD@localhost.localdomain>
References: <cover.1657660277.git.lorenzo@kernel.org>
 <660481b3292e8438b08d129d74e3bf62fab51db7.1657660277.git.lorenzo@kernel.org>
 <20220712205655.3d3ac17e@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5VjmywQPtWCzzGKa"
Content-Disposition: inline
In-Reply-To: <20220712205655.3d3ac17e@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5VjmywQPtWCzzGKa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 12 Jul 2022 23:16:15 +0200 Lorenzo Bianconi wrote:
> > Introduce basic XDP support to mtk_eth_soc driver.
> > Supported XDP verdicts:
> > - XDP_PASS
> > - XDP_DROP
> > - XDP_REDIRECT
>=20
> Looks like you're missing some rcu_access_pointer uses here.
> sparse is not happy (2 new warnings)

ack, right. I missed them. I will fix in v3. Thanks.

Regards,
Lorenzo

--5VjmywQPtWCzzGKa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYs6EGQAKCRA6cBh0uS2t
rLWjAPwI6shWgE43M/Xpb/QhSWb4o2/OdUberrqRR/xZqqx26gD/bMqP6MJE1rkf
aYlOtz6trKkcARZsrHcOwkzCRYgRdwU=
=JkcI
-----END PGP SIGNATURE-----

--5VjmywQPtWCzzGKa--
