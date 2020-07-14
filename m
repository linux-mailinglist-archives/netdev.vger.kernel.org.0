Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEED221F640
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgGNPfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:35:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgGNPfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 11:35:36 -0400
Received: from localhost (unknown [151.48.133.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7740622285;
        Tue, 14 Jul 2020 15:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594740936;
        bh=o03IaugiXuFQkpghN262MfmrETsK3WmVt5Q50CRSV8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MVT1SCjWP9uQko93sI0x3BUC1mXfGYFF8PvmoWxpXjIMqYPBx4MHcOqjEcZ2VYS7D
         qlKtp11qD6Q7PxBJLHAW9qywJsmJpb6KdV7y0UPAG0gg6xXQWDdST4BtePuYXVeWIa
         54xOVWjOysDmvuQJ0yERU5XzlFIaQeM0IpGC3OAc=
Date:   Tue, 14 Jul 2020 17:35:30 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in
 CPUMAP
Message-ID: <20200714153530.GC2174@localhost.localdomain>
References: <cover.1594734381.git.lorenzo@kernel.org>
 <CAADnVQLNuStgi45XT0nUDifg7yHxKFn04Ufs=fQr5DYnoMshzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <CAADnVQLNuStgi45XT0nUDifg7yHxKFn04Ufs=fQr5DYnoMshzQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jul 14, 2020 at 6:56 AM Lorenzo Bianconi <lorenzo@kernel.org> wro=
te:
> >
> > Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
> > capability to attach and run a XDP program to CPUMAP entries.
> > The idea behind this feature is to add the possibility to define on whi=
ch CPU
> > run the eBPF program if the underlying hw does not support RSS.
> > I respin patch 1/6 from a previous series sent by David [2].
> > The functionality has been tested on Marvell Espressobin, i40e and mlx5.
> > Detailed tests results can be found here:
> > https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpu=
map04-map-xdp-prog.org
> >
> > Changes since v6:
> > - rebase on top of bpf-next
> > - move bpf_cpumap_val and bpf_prog in the first bpf_cpu_map_entry cache=
-line
>=20
> fyi. I'm waiting on Daniel to do one more look, since he commented in the=
 past.

ack, thx. I have just figured out today that v6 is not applying anymore.

Regards,
Lorenzo

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXw3QwAAKCRA6cBh0uS2t
rG57AQCh4qihBCUfdDrLKtK3vMEN8EJqe7nSNg7u8+MbmmqWhwD+MsoryLM4tWw8
p3AaSEzkpBX4NFJ0UyKUFCIL+gMyaAM=
=6lDP
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
