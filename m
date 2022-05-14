Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6449D5270BA
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 12:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiENKkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiENKkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 06:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364152EE;
        Sat, 14 May 2022 03:40:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8C3860DE0;
        Sat, 14 May 2022 10:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91419C340EE;
        Sat, 14 May 2022 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652524808;
        bh=4B87Dg5JEAiRvyLZbJTaN/WeL9pNY+QGuStUoeJtY1g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dPtKMtXNytmIKKo1oUxAIsPREfJ317GRHL/kAOcQykFNOokYbXVLJvD2DUKO7kNFj
         +RJGfPYl5sJzSAPS7UoKXXQjuvLA9DvNdJRzmjqlJUTMEVp8z4R/9rVP0d1u2jNU08
         4vmzlBI41/Plw1krjFHj/HxjUzM3DFQZ7v9jjtojXs9GX91Z7+9izAO9Fm8rAmoqG9
         F9QSguVrQnfuhtcvXxV9Oryu0EcudMhy7JUeIJcboLnIfyP4l8yCmvzDEuefoQsNnq
         jAqt/FfHwvCAyJ1GRWrHb8fixqWaHB8rrGtPVJTjs/pEzNu87MpkW9/dvXgIujuCkC
         JyNhlBi3g5Pjg==
Date:   Sat, 14 May 2022 12:40:04 +0200
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
Message-ID: <Yn+HBKbo5eoYBPzj@lore-desk>
References: <cover.1652372970.git.lorenzo@kernel.org>
 <4841edea5de2ce5898092c057f61d45dec3d9a34.1652372970.git.lorenzo@kernel.org>
 <CAADnVQKys77rY+FLkGJwdmdww+h2pGosx08RxVvYwwkjZLSwEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4yjOvuKC16P+H2Ce"
Content-Disposition: inline
In-Reply-To: <CAADnVQKys77rY+FLkGJwdmdww+h2pGosx08RxVvYwwkjZLSwEQ@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--4yjOvuKC16P+H2Ce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, May 12, 2022 at 9:34 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > Install a new ct entry in order to perform a successful lookup and
> > test bpf_ct_refresh_timeout kfunc helper.
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> CI is failing:
> test_bpf_nf_ct:FAIL:flush ct entries unexpected error: 32512 (errno 2)
> test_bpf_nf_ct:FAIL:create ct entry unexpected error: 32512 (errno 2)
>=20
> Please follow the links from patchwork for details.

Hi Alexei,

tests failed because conntrack is not installed on the system:

2022-05-14T00:12:09.0799053Z sh: line 1: conntrack: command not found

Is it ok to just skip the test if conntrack is not installed on the system
or do you prefer to directly send netlink messages to ct in order to add a
new ct entry?

Regards,
Lorenzo

--4yjOvuKC16P+H2Ce
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYn+HAwAKCRA6cBh0uS2t
rKTbAP9DKc0/cw1Wwk0okYUArRS3CB76jUusRG+O1E/vh6PHwgD/U4jnv/4OqKe/
I2lAS247dHiSVbyUHgdqAqdNvs+FfQU=
=jA6b
-----END PGP SIGNATURE-----

--4yjOvuKC16P+H2Ce--
