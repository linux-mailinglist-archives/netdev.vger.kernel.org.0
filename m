Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB628021F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732511AbgJAPFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:05:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732361AbgJAPFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:05:41 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18024207DE;
        Thu,  1 Oct 2020 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601564740;
        bh=JLDT1OxqCDa0s5KtzfAv0cTuykvPiJBccjb2ADRYB44=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+UKtbwYO6fQ7+Nh7MdPXJN8bENSC+BfMHieiCAp5FjuCXAINlcokUP7OfXbbpWeu
         F97N8fIOSXmUix7rKltMbEnNrXWDO+hrUBXRaYNx3CF0ziyUKMzjxmLxL2SIHfFoXk
         aQ1XR7MwHXXLiW+2KUEGdX0ujpgYC1S1EyrO3VMU=
Date:   Thu, 1 Oct 2020 17:05:35 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, kuba@kernel.org, john.fastabend@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com,
        brouer@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 06/12] bpf: helpers: add multibuffer support
Message-ID: <20201001150535.GE13449@lore-desk>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <5e248485713d2470d97f36ad67c9b3ceedfc2b3f.1601478613.git.lorenzo@kernel.org>
 <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <20200930191121.jm62rlopekegbjx5@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Sep 30, 2020 at 05:41:57PM +0200, Lorenzo Bianconi wrote:

Hi Alexei,

> > From: Sameeh Jubran <sameehj@amazon.com>
> >=20
> > The implementation is based on this [0] draft by Jesper D. Brouer.
> >=20
> > Provided two new helpers:
> >=20
> > * bpf_xdp_get_frag_count()
> > * bpf_xdp_get_frags_total_size()
> >=20
> > + * int bpf_xdp_get_frag_count(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the number of fragments for a given xdp multi-buffer.
> > + *	Return
> > + *		The number of fragments
> > + *
> > + * int bpf_xdp_get_frags_total_size(struct xdp_buff *xdp_md)
> > + *	Description
> > + *		Get the total size of fragments for a given xdp multi-buffer.
> > + *	Return
> > + *		The total size of fragments for a given xdp multi-buffer.
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)		\
> >  	FN(unspec),			\
> > @@ -3737,6 +3749,8 @@ union bpf_attr {
> >  	FN(inode_storage_delete),	\
> >  	FN(d_path),			\
> >  	FN(copy_from_user),		\
> > +	FN(xdp_get_frag_count),		\
> > +	FN(xdp_get_frags_total_size),	\
> >  	/* */
>=20
> Please route the set via bpf-next otherwise merge conflicts will be sever=
e.

ack, fine

in bpf-next the following two commits (available in net-next) are currently=
 missing:
- 632bb64f126a: net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_=
free
- 879456bedbe5: net: mvneta: avoid possible cache misses in mvneta_rx_swbm

is it ok to rebase bpf-next ontop of net-next in order to post all the seri=
es
in bpf-next? Or do you prefer to post mvneta patches in net-next and bpf
related changes in bpf-next when it will rebased ontop of net-next?

Regards,
Lorenzo

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3XwPAAKCRA6cBh0uS2t
rFxNAP4ytRu+hBRyuLdequMfjaMXvREmUZ53BX7opXqakMR+GAEA3q1YM5dm+uj/
a+HZNa5l4SKJi0033m9l7LtxmRh3ygo=
=uA1M
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
