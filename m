Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD567ECDB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbjA0R6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbjA0R6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:58:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CCF7CCA5;
        Fri, 27 Jan 2023 09:58:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A608461D78;
        Fri, 27 Jan 2023 17:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA23C433D2;
        Fri, 27 Jan 2023 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674842311;
        bh=N+Ds2WLgmVpIO+ReMX/s0l2bz1e2AaUGR7Xqr/UAV/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cvo+RMDb5M1imZ4EUjn/FmCL+dbQyExp9U+EHugl4V3FcZnSJACnF23vXUb6kF/yp
         uFKycAOAGWH/WBQH9UjUen+q1jJGjmCorJIb0PBU1/57Swzm50oiYx94IphJt46n15
         HvjY0VP0KhbJX9Geit2xfTvCLq9QQ/CVaTVj/YfPrKI7HoMsZW+AAJTj2I9tO4jQzc
         Jxnvs292NlPHJ52zv681r+cX+xRzFkvKtO14C4SRanIFz/IA+xr1e7eFbUMidNA3/A
         H0Kf7oW0/IgkTWloqC0iQEpqF0inMYyeF5b5uJIGcQK1wOLVY19hLqm3koGrbT4hLC
         PSgK+WxCl14dw==
Date:   Fri, 27 Jan 2023 18:58:28 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        memxor@gmail.com, alardam@gmail.com, saeedm@nvidia.com,
        anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Subject: Re: [PATCH v3 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y9QQxMIVd+1chwm3@lore-desk>
References: <cover.1674737592.git.lorenzo@kernel.org>
 <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
 <Y9LIPaojtpTjYlNu@google.com>
 <Y9QJQHq8X9HZxoW3@lore-desk>
 <CAKH8qBv9wKzkW8Qk+hDKCmROKem6ajkqhF_KRqdEKWSLL6_HsA@mail.gmail.com>
 <874jsblv9h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="atQHAAWLKsFpGAis"
Content-Disposition: inline
In-Reply-To: <874jsblv9h.fsf@toke.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--atQHAAWLKsFpGAis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 27, Toke wrote:
> Stanislav Fomichev <sdf@google.com> writes:
>=20
> >> > > +
> >> > > +   ctrl_sockfd =3D accept(sockfd, (struct sockaddr *)&ctrl_addr, =
&len);
> >> > > +   if (ctrl_sockfd < 0) {
> >> > > +           fprintf(stderr, "Failed to accept connection on DUT so=
cket\n");
> >> > > +           close(sockfd);
> >> > > +           return -errno;
> >> > > +   }
> >> > > +
> >>
> >> [...]
> >>
> >> >
> >> > There is also connect_to_fd, maybe we can use that? It should take
> >> > care of the timeouts.. (requires plumbing server_fd, not sure whether
> >> > it's a problem or not)
> >>
> >> please correct me if I am wrong, but in order to have server_fd it is =
mandatory
> >> both tester and DUT are running on the same process, right? Here, I gu=
ess 99% of
> >> the times DUT and tester will run on two separated devices. Agree?
> >
> > Yes, it's targeting more the case where you have a server fd and a
> > bunch of clients in the same process. But I think it's still usable in
> > your case, you're not using fork() anywhere afaict, so even if these
> > are separate devices, connect_to_fd should still work. (unless I'm
> > missing something, haven't looked too closely)
>=20
> Just to add a bit of context here, "separate devices" can refer to the
> hosts as well as the netdevs. I.e., it should also be possible to run
> this in a mode where the client bit runs on a different physical machine
> than the server bit (as it will not be feasible in any case to connect
> things with loopback cables).

yes, this is what I meant with 'DUT and tester will run on two separated
devices' (sorry to have not been so clear). Looking at the code server_fd
is always obtained from start_server(), while here the client on the tester
just knows the IPv4/IPv6 address and the port of the server running on the =
DUT.

Regards,
Lorenzo

>=20
> -Toke
>=20

--atQHAAWLKsFpGAis
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9QQwwAKCRA6cBh0uS2t
rAjaAQDsR6t3WrY32n3NIiX7fqsZbZp73P9DDPn+2OTKiToLfAD/UmUgOjbXpIpG
5TOf4FhHFCV/Eo4xke2f+//CBQTeFwc=
=simG
-----END PGP SIGNATURE-----

--atQHAAWLKsFpGAis--
