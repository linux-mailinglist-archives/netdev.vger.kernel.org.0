Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB101FDA0F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgFRAI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbgFRAI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:08:57 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6D9C06174E;
        Wed, 17 Jun 2020 17:08:57 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49nMjc6DYcz9sRR;
        Thu, 18 Jun 2020 10:08:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1592438934;
        bh=1uuGnZJh9DL8LYySnaRbYolRbTQoDPuj4QyDuhe+DxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ltif/x24QiqFQhtCnA0NodWnY8k8zhSvU39bGkr0utN4TIKPpFMrVdP4MonA7attJ
         abefy7eloSqahdMhbrciVRpsZvHpYIocesQuAk49VPheiZr2facjz0jLy09C01o11o
         pt0GUW6CJelGIOhB/fX1G4Cq8maO/d4KhiojzT5YKISLad4mKSuCXxVmne1yTtrCQH
         K4D9wQ43sG/2gjYgVKdLM1LyFNkBpgFbAnM9KmrSNH0RVv0EIba61W5WcsvLsVpU6v
         1EwtNz4SR7rfwHACgoTsjism5RK9b4HLRiN7kUapVlQclwNe1rsLc9229c8nN9S86v
         crrP7k5r9WZzQ==
Date:   Thu, 18 Jun 2020 10:08:51 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failures after merge of the vfs tree
Message-ID: <20200618100851.0f77ed52@canb.auug.org.au>
In-Reply-To: <20200617073845.GA20077@gondor.apana.org.au>
References: <20200616103330.2df51a58@canb.auug.org.au>
        <20200616103440.35a80b4b@canb.auug.org.au>
        <20200616010502.GA28834@gondor.apana.org.au>
        <20200616033849.GL23230@ZenIV.linux.org.uk>
        <20200616143807.GA1359@gondor.apana.org.au>
        <20200617165715.577aa76d@canb.auug.org.au>
        <20200617070316.GA30348@gondor.apana.org.au>
        <20200617173102.2b91c32d@canb.auug.org.au>
        <20200617073845.GA20077@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4elSaFtvS3bf8v7iB29dHx2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4elSaFtvS3bf8v7iB29dHx2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 17 Jun 2020 17:38:45 +1000 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> On Wed, Jun 17, 2020 at 05:31:02PM +1000, Stephen Rothwell wrote:
> > > >=20
> > > > Presumably another include needed:
> > > >=20
> > > > arch/s390/lib/test_unwind.c:49:2: error: implicit declaration of fu=
nction 'kmalloc' [-Werror=3Dimplicit-function-declaration]
> > > > arch/s390/lib/test_unwind.c:99:2: error: implicit declaration of fu=
nction 'kfree' [-Werror=3Dimplicit-function-declaration]   =20
> >=20
> > And more (these are coming from other's builds):
> >=20
> >   drivers/remoteproc/qcom_q6v5_mss.c:772:3: error: implicit declaration=
 of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> >   drivers/remoteproc/qcom_q6v5_mss.c:808:2: error: implicit declaration=
 of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> >   drivers/remoteproc/qcom_q6v5_mss.c:1195:2: error: implicit declaratio=
n of function 'kfree' [-Werror,-Wimplicit-function-declaration]
> >=20
> > They may have other causes as they are full linux-next builds (not just
> > after the merge of the vfs tree), but the timing is suspicious. =20
>=20
> OK, here's a patch for both of these together:
>=20
> diff --git a/arch/s390/lib/test_unwind.c b/arch/s390/lib/test_unwind.c
> index 32b7a30b2485..eb382ceaa116 100644
> --- a/arch/s390/lib/test_unwind.c
> +++ b/arch/s390/lib/test_unwind.c
> @@ -9,6 +9,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/kthread.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/kprobes.h>
>  #include <linux/wait.h>
> diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom=
_q6v5_mss.c
> index feb70283b6a2..903b2bb97e12 100644
> --- a/drivers/remoteproc/qcom_q6v5_mss.c
> +++ b/drivers/remoteproc/qcom_q6v5_mss.c
> @@ -26,6 +26,7 @@
>  #include <linux/reset.h>
>  #include <linux/soc/qcom/mdt_loader.h>
>  #include <linux/iopoll.h>
> +#include <linux/slab.h>
> =20
>  #include "remoteproc_internal.h"
>  #include "qcom_common.h"

I have applied those 2 by hand for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/4elSaFtvS3bf8v7iB29dHx2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7qsJMACgkQAVBC80lX
0GzZogf/YlCcqyBNZhz6hGdAjes2O3a3PDAoIK01bHwa/VGSSz9i3tJoe/Axuvvp
4Zq/E+/CMHAgnv1a9cD2aqUC2zfDZtAFrwjMlbsHFxNKm1K4eEWhfjXwL+lgFZuA
7jZTN9ObipaBR/0YJdo47a1VraD3uOuw+L9/zcUedDeKZvOmspTxlf2cra1dNXvt
jWrWzerZJnuCZsNP93AlMq1gEUf3sqRH4039JI/KW1Sh2BzZVBsisCfH4PtQvK+t
PKE/qpg62DPWvnQ1nmswpDosICXXgzxe9/Y2POnQwI7Yhq6/UlvjFYFgxq8qSO6f
Q+GjeEwe5eL+3QJkAEe8dXVmiGyvqQ==
=TIUL
-----END PGP SIGNATURE-----

--Sig_/4elSaFtvS3bf8v7iB29dHx2--
