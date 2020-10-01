Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF07D280314
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbgJAPol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:44:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731885AbgJAPol (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:44:41 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0017206C1;
        Thu,  1 Oct 2020 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601567080;
        bh=Jlly4eapdvT903hd4O4q0aNjzvZrOOqyK7rRmdTeae8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z45d0AfAb5gY4rnO39GwQ5PO4GDOlOasLCuC+n13RVZ6DinGOWg/QhNFE7swNd+FP
         E6okpID/TPwHH7YOYuxTyzum6M9BrUawLzNvIOlffNY27Sn1I+XKfdXMLrqXWaxtmH
         WkZcdUy/ZYkNz8LJIJqXBEEt49F/ZCPgHsHu6Uog=
Date:   Thu, 1 Oct 2020 17:44:35 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, shayagr@amazon.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
Message-ID: <20201001154435.GF13449@lore-desk>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
 <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
 <20201001150535.GE13449@lore-desk>
 <CAADnVQ+syU=oF1C3eDp-ggP-D1PyH1JvJdNFjxm4ABZ0JGyYNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="V4b9U9vrdWczvw78"
Content-Disposition: inline
In-Reply-To: <CAADnVQ+syU=oF1C3eDp-ggP-D1PyH1JvJdNFjxm4ABZ0JGyYNQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--V4b9U9vrdWczvw78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > >
> > > Please route the set via bpf-next otherwise merge conflicts will be s=
evere.
> >
> > ack, fine
> >
> > in bpf-next the following two commits (available in net-next) are curre=
ntly missing:
> > - 632bb64f126a: net: mvneta: try to use in-irq pp cache in mvneta_txq_b=
ufs_free
> > - 879456bedbe5: net: mvneta: avoid possible cache misses in mvneta_rx_s=
wbm
> >
> > is it ok to rebase bpf-next ontop of net-next in order to post all the =
series
> > in bpf-next? Or do you prefer to post mvneta patches in net-next and bpf
> > related changes in bpf-next when it will rebased ontop of net-next?
>=20
> bpf-next will receive these patches later today,
> so I prefer the whole thing on top of bpf-next at that time.

sounds good, thx.

Regards,
Lorenzo

--V4b9U9vrdWczvw78
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3X5YAAKCRA6cBh0uS2t
rAq/AQDqorGwEBeOT6y/UkEhIDI3MUjIB9+A76iW2N5X3v+wHgD+InSw+fy+uJwb
UW0G2hApIO0iekwDTZpGUs0W6sUKGws=
=ekbK
-----END PGP SIGNATURE-----

--V4b9U9vrdWczvw78--
