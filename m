Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4768B42F33A
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbhJONca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239724AbhJONb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF79B61151;
        Fri, 15 Oct 2021 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634304562;
        bh=3rf7kkaFFfGvpxInDkMyDX53tjfu1Wz10azRKgKwfV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tccNC7YJO/WCwtQEvB9fvP41WoRsiBeBP99qeZLuIIH+cC78EfvzdFAm9aTvCyHzw
         ywc2haNaKleWiixXbZ3D/QX0PJ1JvJut7NsM5ehYsOTWD+hyaa1aSuQXqh3LYktz9M
         RJtR+uT7yFjcwM9prbcHcX7KU0dQtVDmjB4p1IatqtJSOmLfgug95D6D8kEI14W/5F
         nd+MZ3+PS2WwRMg96Y5tvbieTaK2ZxYsoIpUN0anOrSnX+9QcLeT8TwSMdw+/zWYcV
         4nWFzs8GwyjqLNcQ29MM4bIJCJ6LzW2vuQ2mydi1F4Jzd+vqdd/0tY/XSoKqM/UvPo
         qcrTxVCk16y7w==
Date:   Fri, 15 Oct 2021 15:29:18 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v16 bpf-next 09/20] bpf: introduce BPF_F_XDP_MB flag in
 prog_flags loading the ebpf program
Message-ID: <YWmCLlLelmG2ElyV@lore-desk>
References: <cover.1634301224.git.lorenzo@kernel.org>
 <0a48666cfb23d1ceef8d529506e7ad2da90079de.1634301224.git.lorenzo@kernel.org>
 <87y26uzalk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q9NZZ+2B9Fmrq9wr"
Content-Disposition: inline
In-Reply-To: <87y26uzalk.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Q9NZZ+2B9Fmrq9wr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > Introduce BPF_F_XDP_MB and the related field in bpf_prog_aux in order to
> > notify the driver the loaded program support xdp multi-buffer.
>=20
> We should also add some restrictions in the BPF core. In particular,
> tail call, cpumap and devmap maps should not be able to mix multi-buf
> and non-multibuf programs.

ack. How can we detect if a cpumap or a devmap is running in XDP multi-buff
mode in order to reject loading the legacy XDP program?
Should we just discard the XDP multi-buff in this case?

Lorenzo

>=20
> -Toke
>=20

--Q9NZZ+2B9Fmrq9wr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYWmCLgAKCRA6cBh0uS2t
rL+/AP0QNwItRbRAy/t+VAYxtdtU+e03pOMptI1jdw5WdHi9yAD+M1KtCdfPTVJL
O0sNoQA5XCfrVd7PTEO3SNnB6fxPkQU=
=grYt
-----END PGP SIGNATURE-----

--Q9NZZ+2B9Fmrq9wr--
