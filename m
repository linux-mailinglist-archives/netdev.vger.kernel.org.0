Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187BD52A51A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 16:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349150AbiEQOm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 10:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349131AbiEQOmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 10:42:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6507335857;
        Tue, 17 May 2022 07:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF8EB81882;
        Tue, 17 May 2022 14:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C2C385B8;
        Tue, 17 May 2022 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652798541;
        bh=Z9/e+OWfp+7R1xPJIDE0/n70s8MO3E+bncv8jpwAhqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L+eRWHydU3gYaPAfi2auwzftOFDzIF2dRsCPWSKDW/2l/AGUdsqNbk/f+gMWL5rmp
         UFfowYFlYod5enOGxg4PMhem/HNQarLhyBX5iVEeHoDH2/wf/aGAQQYyUxOjWHlLg9
         IZsqC1OrH6QeTLFf9vrKU31atUfJ2cfNXB9v68aHOD3fV7YMQh5fxRv4ztogECIJJ1
         wU6fz2ckUzq3HMrSy5qbs9LwnlsE3qqmbw6H2GyO3y6zCeP3nGTYBqunVQAwDPncR+
         HSA0HOaINjXF7YILh2ZiXCX3iU97J7pheG6z8MViOSvsQUV1pyId/yfL+hgEhkv11E
         ITmI3tfNbnF3w==
Date:   Tue, 17 May 2022 16:42:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/2] selftests/bpf: add selftest for
 bpf_ct_refresh_timeout kfunc
Message-ID: <YoO0SXy9DA3ESWE+@lore-desk>
References: <cover.1652372970.git.lorenzo@kernel.org>
 <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
 <CAADnVQKys77rY+FLkGJwdmdww+h2pGosx08RxVvYwwkjZLSwEQ@mail.gmail.com>
 <Yn+HBKbo5eoYBPzj@lore-desk>
 <CAADnVQJbOZAg-nGrVutwCA5r=VATXVOXD5Y2EtbfkZHtCsrBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XGayC4HemFmqoBlp"
Content-Disposition: inline
In-Reply-To: <CAADnVQJbOZAg-nGrVutwCA5r=VATXVOXD5Y2EtbfkZHtCsrBbg@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XGayC4HemFmqoBlp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, May 14, 2022 at 3:40 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > > On Thu, May 12, 2022 at 9:34 AM Lorenzo Bianconi <lorenzo@kernel.org>=
 wrote:
> > > >
> > > > Install a new ct entry in order to perform a successful lookup and
> > > > test bpf_ct_refresh_timeout kfunc helper.
> > > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > >
> > > CI is failing:
> > > test_bpf_nf_ct:FAIL:flush ct entries unexpected error: 32512 (errno 2)
> > > test_bpf_nf_ct:FAIL:create ct entry unexpected error: 32512 (errno 2)
> > >
> > > Please follow the links from patchwork for details.
> >
> > Hi Alexei,
> >
> > tests failed because conntrack is not installed on the system:
> >
> > 2022-05-14T00:12:09.0799053Z sh: line 1: conntrack: command not found
> >
> > Is it ok to just skip the test if conntrack is not installed on the sys=
tem
> > or do you prefer to directly send netlink messages to ct in order to ad=
d a
> > new ct entry?
>=20
> It will take a long time to update x86 and s390 images.
> Maybe we should add a kfunc that creates a ct entry?

ack, I added the support for it. I will post it soon.

Regards,
Lorenzo

--XGayC4HemFmqoBlp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYoO0SQAKCRA6cBh0uS2t
rGI8AP49d/EC0PE7uNPVHS33AfOY5EI09ZQ/gxwxMbVXqa2PAgEAyWOAaNwk/WCG
lxIRMn1eiQ2iJyaqtqk5tT04NgR1hws=
=kxEr
-----END PGP SIGNATURE-----

--XGayC4HemFmqoBlp--
