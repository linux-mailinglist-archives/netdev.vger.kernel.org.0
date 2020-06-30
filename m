Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7359520EB2E
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgF3B7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:59:03 -0400
Received: from ozlabs.org ([203.11.71.1]:53729 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgF3B7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:59:02 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49wnb64C6Xz9sDX;
        Tue, 30 Jun 2020 11:58:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1593482340;
        bh=5cPu6wsgH/MuuN6WquTB5OoBViBaqpyzg6+ERh6fgFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e/vudEKGo+PonMu/StaXpztVkrHZTgpNNCOQdpuRl+K0wWRVC5BhqogqLWsZx2mrb
         C7r2dLyhWo6GIOBlS8LK7z5R6Qn3LUuJuQ0hnW8xS3Tdq/4RWzfJ6UA1p1m5gXt0+J
         zcscJDAXN4nK4LKPLNunInxFkogcybp1KfSsFxAODCTWELQpTI3Ml6Mmvf2TNG/H9x
         TEIIydptycgC0LuPGh4O7iIcWhFgTZqVG3jE9Ux2Hax1XXHkKq3kICLvOaw4mtXK4e
         kA0lak9ejHWHnHmlxFXx/zmJh/4Qm2frNJy6CZMJ1XcGi1IH0c/HikegiCswzALfQZ
         qSQfhGMHAVSKg==
Date:   Tue, 30 Jun 2020 11:58:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200630115857.48eab55d@canb.auug.org.au>
In-Reply-To: <20200618100851.0f77ed52@canb.auug.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
        <20200616103440.35a80b4b@canb.auug.org.au>
        <20200616010502.GA28834@gondor.apana.org.au>
        <20200616033849.GL23230@ZenIV.linux.org.uk>
        <20200616143807.GA1359@gondor.apana.org.au>
        <20200617165715.577aa76d@canb.auug.org.au>
        <20200617070316.GA30348@gondor.apana.org.au>
        <20200617173102.2b91c32d@canb.auug.org.au>
        <20200617073845.GA20077@gondor.apana.org.au>
        <20200618100851.0f77ed52@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_0FRHZJ7r_fvKJCjf8vCyNz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_0FRHZJ7r_fvKJCjf8vCyNz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 18 Jun 2020 10:08:51 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 17 Jun 2020 17:38:45 +1000 Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> >
> > On Wed, Jun 17, 2020 at 05:31:02PM +1000, Stephen Rothwell wrote: =20
> > > > >=20
> > > > > Presumably another include needed:
> > > > >=20
> > > > > arch/s390/lib/test_unwind.c:49:2: error: implicit declaration of =
function 'kmalloc' [-Werror=3Dimplicit-function-declaration]
> > > > > arch/s390/lib/test_unwind.c:99:2: error: implicit declaration of =
function 'kfree' [-Werror=3Dimplicit-function-declaration]     =20
> > >=20
> > > And more (these are coming from other's builds):
> > >=20
> > >   drivers/remoteproc/qcom_q6v5_mss.c:772:3: error: implicit declarati=
on of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> > >   drivers/remoteproc/qcom_q6v5_mss.c:808:2: error: implicit declarati=
on of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> > >   drivers/remoteproc/qcom_q6v5_mss.c:1195:2: error: implicit declarat=
ion of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> > >=20
> > > They may have other causes as they are full linux-next builds (not ju=
st
> > > after the merge of the vfs tree), but the timing is suspicious.   =20
> >=20
> > OK, here's a patch for both of these together:
> >=20
> > diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
> > index 32b7a30b2485..eb382ceaa116 100644
> > --- a/arch/s390/lib/test_unwind.c
> > +++ b/arch/s390/lib/test_unwind.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/kthread.h>
> >  #include <linux/module.h>
> > +#include <linux/slab.h>
> >  #include <linux/string.h>
> >  #include <linux/kprobes.h>
> >  #include <linux/wait.h>
> > diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qc=
om_q6v5_mss.c
> > index feb70283b6a2..903b2bb97e12 100644
> > --- a/drivers/remoteproc/qcom_q6v5_mss.c
> > +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/reset.h>
> >  #include <linux/soc/qcom/mdt_loader.h>
> >  #include <linux/iopoll.h>
> > +#include <linux/slab.h>
> > =20
> >  #include "remoteproc_internal.h"
> >  #include "qcom_common.h" =20
>=20
> I have applied those 2 by hand for today.

I am still applying the above patch.

--=20
Cheers,
Stephen Rothwell

--Sig_/_0FRHZJ7r_fvKJCjf8vCyNz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl76nGEACgkQAVBC80lX
0GwBRggAgNcS26D8ioFjQ+eNTgaE+rGhw30ZcyikBkrj04MMls4rzmaAWMeVp/Qe
DH+A2nj0Zra8LQMNH8ZmhIa+HgluH2acwYvWvZ3a4oTDpVQ5riaszprgkXqiDEwT
x/L4gIt7ixHcqNwN4MO8unnR0jeV+vNprU+R1vAW6/il67qyo1TiSRvmngk+YyYX
H8sNoU12xjCGPvRvPOZWiSJ5svT8yncbmDtDJipDfwutsADfpkd6PFHwsf/wYo/H
Ljesigk7smwLbFZ74e0vVMQOS8ID4Q4WtACI961uzQEIaniuIY97MbG1IwZDLD3M
kW4NQ3htlcdGMWGgaVshjCxs/hwNgA==
=ROmu
-----END PGP SIGNATURE-----

--Sig_/_0FRHZJ7r_fvKJCjf8vCyNz--
