Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCBF3FD40C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 08:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhIAGzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 02:55:50 -0400
Received: from ozlabs.org ([203.11.71.1]:43681 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242018AbhIAGzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 02:55:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1630479292;
        bh=8in+o9eQYIw6XWOk9CBFWjFkIuqjaSRJ7Zk7g5capZ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gXJjiVBjffRDhssKOHck3zDVxDu3dn5OEk++s5pVkO5TLCxZwNNAo1KSA2B3gNWcw
         DZJnjebapj40SuVoTxG3s20P18ibKQzrRycqlL4gmOKsyQGJ0oCSyB5baY+RJzIThl
         HGutrpVB8O2HunsovmE8kcpmvMKCqUT6OFaiOL7u4vutOPbGyY4EGzVEAA1evCuBgD
         9q30EHjgVzCwtTU3OTf4I6j06s85IsYDuwvjAeDYTctspeD7HY8DQ2ebW/RHHC00Rh
         R9rZfetDNeMgIdo56cw3/5Y2uXNRFgyNvCkCUhXrmJT2JpPYaRXX+ZT1BX4njoW3Jv
         OAn2Y2tTSj74w==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gzvtz2sLvz9sPf;
        Wed,  1 Sep 2021 16:54:51 +1000 (AEST)
Date:   Wed, 1 Sep 2021 16:54:50 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210901165450.5898f1c7@canb.auug.org.au>
In-Reply-To: <20210901163822.65beb208@canb.auug.org.au>
References: <20210901163822.65beb208@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fmZPoL0t3G9NQ0UmjEren57";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fmZPoL0t3G9NQ0UmjEren57
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

This was not actually the net-next tree (except that the net-next tree
was updated before I merged it to include a whole new section of Linus'
tree after Linus merged the net-next tree).  Sorry about that.

On Wed, 1 Sep 2021 16:38:22 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (X86_64
> allnoconfig) failed like this:
>=20
> arch/x86/kernel/setup.c: In function 'setup_arch':
> arch/x86/kernel/setup.c:916:6: error: implicit declaration of function 'a=
cpi_mps_check' [-Werror=3Dimplicit-function-declaration]
>   916 |  if (acpi_mps_check()) {
>       |      ^~~~~~~~~~~~~~
> arch/x86/kernel/setup.c:1110:2: error: implicit declaration of function '=
acpi_table_upgrade' [-Werror=3Dimplicit-function-declaration]
>  1110 |  acpi_table_upgrade();
>       |  ^~~~~~~~~~~~~~~~~~
> arch/x86/kernel/setup.c:1112:2: error: implicit declaration of function '=
acpi_boot_table_init' [-Werror=3Dimplicit-function-declaration]
>  1112 |  acpi_boot_table_init();
>       |  ^~~~~~~~~~~~~~~~~~~~
> arch/x86/kernel/setup.c:1120:2: error: implicit declaration of function '=
early_acpi_boot_init'; did you mean 'early_cpu_init'? [-Werror=3Dimplicit-f=
unction-declaration]
>  1120 |  early_acpi_boot_init();
>       |  ^~~~~~~~~~~~~~~~~~~~
>       |  early_cpu_init
> arch/x86/kernel/setup.c:1162:2: error: implicit declaration of function '=
acpi_boot_init' [-Werror=3Dimplicit-function-declaration]
>  1162 |  acpi_boot_init();
>       |  ^~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   342f43af70db ("iscsi_ibft: fix crash due to KASLR physical memory remap=
ping")
>=20
> Unfortunately that commit has now been merged into Linus' tree as well.

And. unfortunately, that commit had not been in linux-next until today.

--=20
Cheers,
Stephen Rothwell

--Sig_/fmZPoL0t3G9NQ0UmjEren57
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEvI7oACgkQAVBC80lX
0Gx+IQf/U5nLpIo5GVcS8M8YiE5WZV8eGIE1o4a9sSbw5zWjFFBIJiLgM6mLCzqY
JLmLeinIZq3A8Lz3VS7cSAxwOXguCIsbFFwP3HcGkZga8qSQdt1vFnORSlHrLWy9
SA76u7oSUzqJKglgb4DjEXzaox3KQyEbJSlKVoCGiyzaZO3Xxzy7jMLAYxKAxxFF
IWt1HkhiBxbkvJ5+OA3BwjDW1805aYAFz9h/ZWq00Fva1Hl6tf2hfRmuYgHXxZN7
pDs4wYDHyQHynnhncTKuAj2/q14lQTaibrvStJ23EEirXVHaQAoODWdFXQAkAI/k
bIyRkg1slARHvkQ1y9raSVgayRaYYQ==
=wjut
-----END PGP SIGNATURE-----

--Sig_/fmZPoL0t3G9NQ0UmjEren57--
