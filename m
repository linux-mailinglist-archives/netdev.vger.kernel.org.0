Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D9231B866
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 12:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhBOLxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 06:53:03 -0500
Received: from ozlabs.org ([203.11.71.1]:54097 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229974AbhBOLwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 06:52:49 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DfMsL06wJz9sS8;
        Mon, 15 Feb 2021 22:52:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613389926;
        bh=MsFd0H1vboXWoJgTolHQFt3c8tMk6G8b9iiP36p17kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ie4zeLmtZsdjPF5/RkIBnRskfeMoI9LKBOH2cOTH5vKv8aoLqSbejddJNThIjo+KT
         1pt5gpTXT5/9euKKm5sR4oxJFC/yZIihzm9MlLVjoz9YUUzhhE7juFA2zS7QIdSAje
         O79jld2H45ZlFZhMuk3Fr/puxuVYlZWZnlO1/qeJXwDElcw41JLBwLLIwhJ9fE7Fpc
         xc0AxLAE/1hq3WjDEVcxgYkiHTQ3i2hthWlqXcBcCHVm3eefvAJerszuO/3ncGxe80
         QlUd0Csua7mRyRtPPnHqE/114SPVg1IQt7BGes2J01b+0WAxQ29x6j8qFY7t7+uGU1
         U8zVAMtxf79pg==
Date:   Mon, 15 Feb 2021 22:52:04 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210215225204.744d43c4@canb.auug.org.au>
In-Reply-To: <72bb7b9fc0cf7afc308e284c72c363e80df8e734.camel@redhat.com>
References: <20210215114354.6ddc94c7@canb.auug.org.au>
        <20210215110154.GA28453@linux.home>
        <72bb7b9fc0cf7afc308e284c72c363e80df8e734.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nGeH_70nOB4WzFqrUL/3fcj";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nGeH_70nOB4WzFqrUL/3fcj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Davide,

On Mon, 15 Feb 2021 12:35:37 +0100 Davide Caratti <dcaratti@redhat.com> wro=
te:
>
> On Mon, 2021-02-15 at 12:01 +0100, Guillaume Nault wrote:
> > Before these commits, ALL_TESTS listed the tests in the order they were
> > implemented in the rest of the file. So I'd rather continue following
> > this implicit rule, if at all possible. Also it makes sense to keep
> > grouping all match_ip_*_test together. =20
>=20
> yes, it makes sense. I can follow-up with a commit for net-next (when
> tree re-opens), where the "ordering" in ALL_TESTS is restored. Ok?

The ordering is not set in stone yet (I have only done the merge in the
linux-next tree), just make sure that Dave knows what it should look
like when he merges the net and net-next trees.

--=20
Cheers,
Stephen Rothwell

--Sig_/nGeH_70nOB4WzFqrUL/3fcj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAqYGQACgkQAVBC80lX
0GwAtwf/R7yQPmv5KYJEjloWrlfUFfpTbD4F0C9RPbM9H4ckozF0WypKlfE5b6i0
4K89y1Hoxicz1XfTkNLDIDGdgvYIp6LEX8nexv1NSZdxRBd2lhkKciA/ubAhNtxQ
9YNi0rhIbkJ7vbOMo85xqTeYOha6/ezoeyuBpgUaCmnayYw/9s0cjBMN1N5HXkJ6
M8nzSLdd8DmZ8+H+lboUrEzg65K6b3F5j97VGJIFFOwqWscoy2rhRZgeQo7xrtSp
nCRHlZf5jDiQJu6DRSUFDUR5idh7vtTLOADPyGpjnXzDMVJDdc0uXHR18FiCABHD
QSWWoIAlvEDGwdEP+2LmQ/ldRVqvgw==
=1lUg
-----END PGP SIGNATURE-----

--Sig_/nGeH_70nOB4WzFqrUL/3fcj--
