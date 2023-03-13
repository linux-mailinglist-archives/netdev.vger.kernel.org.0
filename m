Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDE6B7E09
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjCMQsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbjCMQsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D98A56;
        Mon, 13 Mar 2023 09:47:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39615B81150;
        Mon, 13 Mar 2023 16:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BFFC433AE;
        Mon, 13 Mar 2023 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678726073;
        bh=O0k8dCmgNKsBDzjXFjjwe97dKJxvw+naBwBLaX7J2hs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dEUlkiUR/Y66YdOSgGsg+sdH1voBSfomApHILq5vwIRkwzRM8Pw38qS3pHiqupBT9
         yE0HHPgvAJTbdKPhP+cv2FMZDI/sceZwJSZl1aum4b1MbLL4x1t2m+uH/1rJSNKsvr
         XyQq4lKgyQeiMO5mbWSvRP9pDgcH0HvcWNeERD/gRtaSXQPPYuSmPSWioD8C/gq8t3
         bSlWKg0KJuBx4XOW0bSIccqvK5PKSQW0UhPrm1L2GYccznclWmoUkrFF3U5lGZv8Yi
         5cTaMfcHclFehxl8Jyy8f8oXWKvdcAqZjIXmJtKpz+kG8KU7oG1lwwuFgWtKKoWhZ7
         /4aBd05n+ZscA==
Date:   Mon, 13 Mar 2023 17:47:49 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, leon@kernel.org, shayagr@amazon.com,
        akiyano@amazon.com, darinzon@amazon.com, sgoutham@marvell.com,
        lorenzo.bianconi@redhat.com, toke@redhat.com, teknoraver@meta.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net v2 6/8] veth: take into account device
 reconfiguration for xdp_features flag
Message-ID: <ZA9TtSkEYavvdd0f@lore-desk>
References: <cover.1678364612.git.lorenzo@kernel.org>
 <f20cfdb08d7357b0853d25be3b34ace4408693be.1678364613.git.lorenzo@kernel.org>
 <f5167659-99d7-04a1-2175-60ff1dabae71@tessares.net>
 <CANn89i+4F0QUqyDTqJ8GWrWvGnTyLTxja2hbL1W_rVdMqqmxaQ@mail.gmail.com>
 <CANn89iL=zQQygGg4mkAG+MES6-CpkYBL5KY+kn4j=hAowexVZw@mail.gmail.com>
 <ZA9Q7fvuf4oGh9PY@lore-desk>
 <CANn89iJEtCp1jUDkW9e4v0tbB0w8TjFczS0YSJcYDOVBeL5zhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ERSyJMPtEtDms7QR"
Content-Disposition: inline
In-Reply-To: <CANn89iJEtCp1jUDkW9e4v0tbB0w8TjFczS0YSJcYDOVBeL5zhA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ERSyJMPtEtDms7QR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, Mar 13, 2023 at 9:36=E2=80=AFAM Lorenzo Bianconi <lorenzo@kernel.=
org> wrote:
> >
> > > On Mon, Mar 13, 2023 at 8:50=E2=80=AFAM Eric Dumazet <edumazet@google=
=2Ecom> wrote:
> > > >
> > > > On Mon, Mar 13, 2023 at 7:15=E2=80=AFAM Matthieu Baerts
> > > > <matthieu.baerts@tessares.net> wrote:
> > > > >
> > > > > Hi Lorenzo,
> > > > >
> > > > > On 09/03/2023 13:25, Lorenzo Bianconi wrote:
> > > > > > Take into account tx/rx queues reconfiguration setting device
> > > > > > xdp_features flag. Moreover consider NETIF_F_GRO flag in order =
to enable
> > > > > > ndo_xdp_xmit callback.
> > > > > >
> > > > > > Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > >
> > > > > Thank you for the modification.
> > > > >
> > > > > Unfortunately, 'git bisect' just told me this modification is the=
 origin
> > > > > of a new WARN when using veth in a netns:
> > > > >
> > > > >
> > > > > ###################### 8< ######################
> > > > >
> > > > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > WARNING: suspicious RCU usage
> > > > > 6.3.0-rc1-00144-g064d70527aaa #149 Not tainted
> > > > > -----------------------------
> > > > > drivers/net/veth.c:1265 suspicious rcu_dereference_check() usage!
> > > > >
> > > > > other info that might help us debug this:
> > > > >
> > > >
> > > > Same observation here, I am releasing a syzbot report with a repro.
> > > >
> > > >
> > >
> > > I guess a fix would be:
> > >
> >
> > Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Can you submit a formal fix ?

ack, will do.

Regards,
Lorenzo

>=20
> Thanks.

--ERSyJMPtEtDms7QR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZA9TtQAKCRA6cBh0uS2t
rLxmAQDqU9+1YtSH9qB4uwPQKIRA4ig0qjQkBotaVjxtEno7OAEAg7d0NSwerNjh
vq9Af4+3csM0fA/EeIY6OvkYfa9ltgo=
=m2VX
-----END PGP SIGNATURE-----

--ERSyJMPtEtDms7QR--
