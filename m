Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 652B5184FFA
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 21:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgCMUQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 16:16:44 -0400
Received: from 8.mo69.mail-out.ovh.net ([46.105.56.233]:36068 "EHLO
        8.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCMUQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 16:16:44 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Mar 2020 16:16:43 EDT
Received: from player788.ha.ovh.net (unknown [10.108.42.196])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 70AC1888E0
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 21:08:45 +0100 (CET)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
        (Authenticated sender: steve@sk2.org)
        by player788.ha.ovh.net (Postfix) with ESMTPSA id C03D510713CE3;
        Fri, 13 Mar 2020 20:08:31 +0000 (UTC)
Date:   Fri, 13 Mar 2020 21:08:24 +0100
From:   Stephen Kitt <steve@sk2.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the jc_docs
 tree
Message-ID: <20200313210824.177688ba@heffalump.sk2.org>
In-Reply-To: <CAADnVQ+r3hMEtqbkhm1j9HyXYxSNihbX=VCR9erUGXoE72Pwsg@mail.gmail.com>
References: <20200313135850.2329f480@canb.auug.org.au>
        <CAADnVQ+r3hMEtqbkhm1j9HyXYxSNihbX=VCR9erUGXoE72Pwsg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/2PzWJQucE+G5Q=dyzzxVk2k"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 16739035391216012653
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddvjedgudeffecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkjghfofggtgesghdtreerredtjeenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejkeekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2PzWJQucE+G5Q=dyzzxVk2k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Mar 2020 12:51:54 -0700, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Thu, Mar 12, 2020 at 7:59 PM Stephen Rothwell <sfr@canb.auug.org.au>
> wrote:
> > Today's linux-next merge of the bpf-next tree got a conflict in:
> >
> >   Documentation/admin-guide/sysctl/kernel.rst
> >
> > between commit:
> >
> >   a3cb66a50852 ("docs: pretty up sysctl/kernel.rst")
> >
> > from the jc_docs tree and commit:
> >
> >   c480a3b79cbc ("docs: sysctl/kernel: Document BPF entries")
> >
> > from the bpf-next tree. =20
>=20
> I dropped this commit from bpf-next, since it causes unnecessary conflict=
s.
> Please steer it via Jon's tree.

OK, I=E2=80=99ll do that.

Regards,

Stephen

--Sig_/2PzWJQucE+G5Q=dyzzxVk2k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl5r6DgACgkQgNMC9Yht
g5y4KA/+OXRIzjiG6db3rZOSUGlJes+prq9WGuRY85rB7yud6Ohfj9RAITPQkFjv
uDfvkiI8ctrDhJ3dAo06dG9GPj8S0PHHoig5jKBvXQ/cHPHeeDpAvXXM/1PUFENC
mDt3KZQ+XfiJjThCx40/cNmEnEYJUX93KlheJddmJplZzdbFOnHZ/Ww9dfE88yH7
4xByXsy8IBgCZ+JLwOAawC3TICOTGi96mgrkhCvwFzUI7HeU0Y6VRKV5SiP/hW1B
+3yrgxTRPKzZcQfTgsXaeY6141+FSaTDQrGtM02THs6+IKwjcPcZCSG0EHROxWds
jvZxJIph2+il4L0Sqw89xx0TG7lYmrqnpmHDFUYx0NqeGlAcxeLhSVKfDPCCdSDu
LYWk+whzj5zoZjqYK5Twhw34S3ScQPC8dtcIico9plGsLur7iwajAHpO0JyTlmh/
CBTHY2JHaY7SKzaBoBx1dsQcM6phNx3+WEIZY91JKXZkIK2aMmYdVH1bfEAvoGDH
lcGCT5YWWxkG1DbLT6h5BnXHg196xR2e4wLagDTYnbd0KueEf70v7GFUf3o2Pg7Y
FRwtvpt3AZejSK7ScKyZ/mAi85XFuAU5hmrzvpciJXzQWTfC0tey98QkwzJ1Q05s
/Gf11/7pLXNQXzVOw5kiYQMbgGwhbUtrR+YSU++apusiEv4hD3k=
=o9fM
-----END PGP SIGNATURE-----

--Sig_/2PzWJQucE+G5Q=dyzzxVk2k--
