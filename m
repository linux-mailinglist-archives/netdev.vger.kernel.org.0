Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C9967EC65
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 18:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbjA0R06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 12:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234535AbjA0R04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 12:26:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B35078AE4;
        Fri, 27 Jan 2023 09:26:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22944B821A5;
        Fri, 27 Jan 2023 17:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FC4C433EF;
        Fri, 27 Jan 2023 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674840412;
        bh=gYHGzcwIWB6r9pYDG7+Doxt3/yZ9rRNntWchRcQmgpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oH6NEamFnW04HpSJVChCO/sGKY2pAoO3wq1Rs31n6rlC6KKfZwS5YzGXGn8kAn7Qf
         8zEWOuGItp1ahLB4QLctQe1jwG6/XV1TftlxzFThFn3ealcDMCv2z9uVcXn2U2fGq5
         NhIX5e2pOli3RT6DeJE8NSNAKk7zTa9wM78dRvQ9nAtvZw6FwD5Sx5ngD4iMCgO24f
         TOwJQy0IJGTGMZHAsT+46ms3N46W9JeORQDBMreWt0OHpufYnZjrKGykLUjbwWJXv2
         fadEXch1JkwIdiDIxki8U59ZltVHGGoHCG5WvFIfT8ApLyLl6KngApNJx5oDSqxg6Y
         C4HCLYTRkCz8w==
Date:   Fri, 27 Jan 2023 18:26:49 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, mst@redhat.com, bjorn@kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com,
        sdf@google.com
Subject: Re: [PATCH v3 bpf-next 8/8] selftests/bpf: introduce XDP compliance
 test tool
Message-ID: <Y9QJWQvGKbSPK676@lore-desk>
References: <cover.1674737592.git.lorenzo@kernel.org>
 <0b05b08d4579b017dd96869d1329cd82801bd803.1674737592.git.lorenzo@kernel.org>
 <Y9LIPaojtpTjYlNu@google.com>
 <a208ed96-20e5-43d3-13e9-122776230da1@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KiRMcXiEPgyYvHA4"
Content-Disposition: inline
In-Reply-To: <a208ed96-20e5-43d3-13e9-122776230da1@linux.dev>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KiRMcXiEPgyYvHA4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 1/26/23 10:36 AM, sdf@google.com wrote:
> >=20
> > > +=A0=A0=A0 sockfd =3D socket(AF_INET, SOCK_DGRAM, 0);
> > > +=A0=A0=A0 if (sockfd < 0) {
> > > +=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Failed to create echo socket\=
n");
> > > +=A0=A0=A0=A0=A0=A0=A0 return -errno;
> > > +=A0=A0=A0 }
> > > +
> > > +=A0=A0=A0 err =3D setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &optv=
al,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(optval));
> > > +=A0=A0=A0 if (err < 0) {
> > > +=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Failed sockopt on echo socket=
\n");
> > > +=A0=A0=A0=A0=A0=A0=A0 return -errno;
> > > +=A0=A0=A0 }
> > > +
> > > +=A0=A0=A0 err =3D bind(sockfd, (struct sockaddr *)&addr, sizeof(addr=
));
> > > +=A0=A0=A0 if (err) {
> > > +=A0=A0=A0=A0=A0=A0=A0 fprintf(stderr, "Failed to bind echo socket\n"=
);
> > > +=A0=A0=A0=A0=A0=A0=A0 return -errno;
> > > +=A0=A0=A0 }
> >=20
> > IIRC, Martin mentioned IPv6 support in the previous version. Should we
> > also make the userspace v6 aware by at least using AF_INET6 dualstack
> > sockets? I feel like listening on inaddr_any with AF_INET6 should
> > get us there without too much pain..
>=20
> Yeah. Think about host that only has IPv6 address. A tool not supporting
> IPv6 is a no-go nowadays.

ack, I will add it in v4.

Regards,
Lorenzo

--KiRMcXiEPgyYvHA4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY9QJWQAKCRA6cBh0uS2t
rFw9AP9ousu//jWlNMITDvqrt7FJNIylXsgBvlR5WsQRpFpt6QD+PzACals6ZKT5
bOI6PXbXDrYTXIE9UV/wk/5H+bUbIwE=
=P+rQ
-----END PGP SIGNATURE-----

--KiRMcXiEPgyYvHA4--
