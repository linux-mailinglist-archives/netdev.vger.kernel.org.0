Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0CD030EFD7
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhBDJjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:39:21 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35547 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234689AbhBDJjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 04:39:17 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DWYQL6g3Vz9sWl;
        Thu,  4 Feb 2021 20:38:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612431515;
        bh=GkEx+xpyKg8YhSyS0+o+FLZ1T3oYaokZiUmnkX7fgzM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnbeILr2JrQhMuSCD4Ub9RJKyJFQ4f2LLWHTVwzSdJjB8PUsWEr97YEHcNwFHxT9w
         eXou7cobOTkLey4PxS0HT7PaOd9U2mLMi60PfPwcxAGypYXbzbk01fJCOuIK2zZJMZ
         MZgVGRpvUo7Fblwlt6Xo1zGqbEjsCF+YWPMvubtyHPkKom/1J9dgJeTsV8pz6HkJdF
         e4FKzt4V2F9WUFgRcA2jdgWIVcGl34cd8skxtvM6xxvbtJEq2MoOirqdQLl6TDHlKg
         ZvjeAHOAgZKRoycmSthOVz6fWKrXE815akxms4iSKLGrtq2Zg2FEtcZGZzj8aqDM1y
         MA4u83k9J+2dw==
Date:   Thu, 4 Feb 2021 20:38:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Brian Vazquez <brianvv@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210204203834.4cc1a307@canb.auug.org.au>
In-Reply-To: <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com>
References: <20210204123331.21e4598b@canb.auug.org.au>
        <CAMzD94RaWQM3J8LctNE_C1fHKYCW8WkbVMda4UV95YbYskQXZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/670ir_=mK2RASorDf90bdFe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/670ir_=mK2RASorDf90bdFe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Brian,

On Wed, 3 Feb 2021 19:52:08 -0800 Brian Vazquez <brianvv@google.com> wrote:
>
> Hi Stephen, thanks for the report. I'm having trouble trying to
> compile for ppc, but I believe this should fix the problem, could you
> test this patch, please? Thanks!

That fixed it, thanks (though the patch was badly wrapped and
whitespace damaged :-))

--=20
Cheers,
Stephen Rothwell

--Sig_/670ir_=mK2RASorDf90bdFe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAbwJoACgkQAVBC80lX
0GzWmgf/ZtCWjBm9z2ozvoasLSnlBHdRPZzOHIXAkhz/oKuqcU6Eya01heYx2zLT
PQ9IRtSZInOdOAjXR16DOZ6rxKN/iFvGTfRag/b8Ba33U1+L48FQIsYe52T1Twm0
3geKBo5GkonvJ32y8umffd/9B27543E2Pt3ntfMetl5gLh+Vqas3YqS7YDy483I8
V3ZRAk18sSW794scEb5TpIfGJqTJHUlGLz2LtMHzMov4VP9RZYHMWSMskNngi2hg
vUMEwF4AhXM2GYkiIwJdBrgONwW3GrPddBSd89Zb3d79ufUKIKMzTssBsovq3zoY
myfPOAn3wF2esBto7fIt+qOiQCaCOQ==
=Bgem
-----END PGP SIGNATURE-----

--Sig_/670ir_=mK2RASorDf90bdFe--
