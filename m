Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412FA284586
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 07:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJFFl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 01:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFFl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 01:41:28 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AB0C0613A7;
        Mon,  5 Oct 2020 22:41:28 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C55tY0nfDz9sSG;
        Tue,  6 Oct 2020 16:41:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601962886;
        bh=ikESFfcRC4tBYcPMUJ4Xq5Q0lFmdUMPSxYua/LbJa44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dHU5TN+DvnimAIYm1L3ulcbdQX9TWFquAkSuLpofMuXMU+4LIYx7GWZW9E+UgROmS
         Zo5zUGsOcIhqWc5NEwxbLNE5RbqwfcUwbUP9LfM2pxVc62uVX7Y1tHEKUJ1+iCMsHG
         VG8KAl8DTkNU8piFK1DZOMNvtR3DTnIejUysP2/xeWmJlgLJAnu3EUTmA6BDYKXw3Y
         LGaZ+eqolXh3sZ0IAszC5P24DfF190eqHMioFykMHhsMPt5CTmtuZ5bXFfIcTSLQ95
         Xg2p9n690queOiIfD50fY/a28CuTd4zOnWAhVFpO/GOvRfG14U3+V+ec6VFVS8ek/O
         GoL8fRFQYnqGQ==
Date:   Tue, 6 Oct 2020 16:41:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Christoph Hellwig <hch@lst.de>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20201006164124.1dfa2543@canb.auug.org.au>
In-Reply-To: <20201006051301.GA5917@lst.de>
References: <20201006145847.14093e47@canb.auug.org.au>
        <20201006051301.GA5917@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tvQ9uHJiyurvGljcUYc8aAR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tvQ9uHJiyurvGljcUYc8aAR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Tue, 6 Oct 2020 07:13:01 +0200 Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Oct 06, 2020 at 02:58:47PM +1100, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > After merging the net-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this: =20
>=20
> It actually doesn't need that or the two other internal headers.
> Bjoern has a fixed, and it was supposed to be queued up according to
> patchwork.

Yeah, it is in the bpf-next tree but not merged into the net-next tree
yet.

--=20
Cheers,
Stephen Rothwell

--Sig_/tvQ9uHJiyurvGljcUYc8aAR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl98A4QACgkQAVBC80lX
0GwcdAf/V8X39M331bbePWerqdE8ffZwC8FwZXh0cn5toFHc7v0ALoA/jBx57+DT
eNGStnkdrtpL7ZRxQZy2VvLujgYV+vB6Yk6qpl1Rhj0N7Qc6b4li8m9W/b425rCG
DQ2UwMNklanLhHhdnQmnDanVNsGAgU8gsZZxIizdnB1GpDw1J3uvg6lkjUBNFGOT
RnIqklYjFEL3fnHrbziJGW251tSbsTwnWhcUIm2W3eaL+jC/d1Equg0ZTTQ/ugpZ
pKkE66s5jrY1hkX04cwr2aT4WGnQGeYxmKin5G8AI8GHZVpdNtInSNRKKX7lrRs1
1O7hmiHS2H+V+LI1qmCtFH6ziGVbDQ==
=ysHf
-----END PGP SIGNATURE-----

--Sig_/tvQ9uHJiyurvGljcUYc8aAR--
