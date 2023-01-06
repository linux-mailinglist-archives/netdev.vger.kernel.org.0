Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1043565FD50
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjAFJME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjAFJMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:12:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73741007
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 01:11:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 565CEB81CDC
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 09:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FCEC433EF;
        Fri,  6 Jan 2023 09:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672996315;
        bh=hwYF8sQ1hbsW3p2mh1zLVxDNNwkqFYQUd+lsO9xwLvo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MMXs2eHpbajlfIhByNWzzm83UvpdH2WLdvPrT18iySgxH0Z9quvFOsCZ28vcfp6dq
         sxpsi12oh83+dHRtR4kUTr9AQEPJQaWGK1grp6rWBw8CIXBlHblx0t6FEOd5eNoNCm
         wedrLRl2kRT2oAKi0pMXf/rUMcJ1O2L7AtQI5X1M+Py9r7uuaf9Yis05HgCfjwnGQg
         n6g+Mmj8zBGDoL1WTSV9CnsjKiNg5RD+H83vww3/e2Y2rvdxwmvZ2X6ov9+U5SYUpC
         e+IVmF45xhqJL/3OGf0MJ4KMvRIAlHQ7VyHyYAA47tQqbZsPkKA1Y8+XHb/qfzcxyH
         dhehEIB57ENbg==
Date:   Fri, 6 Jan 2023 10:11:52 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org, kvalo@kernel.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7fl2AlCwepPx6Gq@lore-desk>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
 <Y7WKcdWap3SrLAp3@unreal>
 <Y7WURTK70778grfD@lore-desk>
 <Y7aW3k4xZVfDb6oh@unreal>
 <Y7a5XeLjTj1MNCDz@lore-desk>
 <20230105214832.7a73d6ed@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Rc5lWFUTISwO9aH0"
Content-Disposition: inline
In-Reply-To: <20230105214832.7a73d6ed@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Rc5lWFUTISwO9aH0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 05, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 12:49:49 +0100 Lorenzo Bianconi wrote:
> > > > These callbacks are implemented in the mt76 driver. I have not adde=
d these
> > > > patches to the series since mt76 patches usually go through Felix/K=
alle's
> > > > trees (anyway I am fine to add them to the series if they can go in=
to net-next
> > > > directly). =20
> > >=20
> > > Usually patches that use specific functionality are submitted together
> > > with API changes. =20
> >=20
> > I would say it is better mt76 patches go through Felix/Kalle's tree in =
order to avoid
> > conflicts.
> >=20
> > @Felix, Kalle: any opinions?
>=20
> FWIW as long as the implementation is in net-next before the merge
> window I'm fine either way. But it would be good to see the
> implementation, a co-posted RFC maybe?

ack, I will post mt76 series to wireless mailing list just after the new ve=
rsion
of this one.

Regards,
Lorenzo

--Rc5lWFUTISwO9aH0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY7fl1wAKCRA6cBh0uS2t
rAZmAQCqN1SkKaImFaEleynUG6+81m2zSrDcEpLKpgkdkPK7pQEAjjfk9vTexUop
PNsL/x4tKete0qZVCGqkEV5LZwgEng4=
=R7JT
-----END PGP SIGNATURE-----

--Rc5lWFUTISwO9aH0--
