Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0B35C77D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhDLNZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 09:25:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48284 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237277AbhDLNZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 09:25:44 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3069B62C0E;
        Mon, 12 Apr 2021 15:25:01 +0200 (CEST)
Date:   Mon, 12 Apr 2021 15:25:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210412132522.GA1302@salvia>
References: <20210412150416.4465b518@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20210412150416.4465b518@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 12, 2021 at 03:04:16PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the net-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from include/asm-generic/bug.h:20,
>                  from arch/x86/include/asm/bug.h:93,
>                  from include/linux/bug.h:5,
>                  from include/linux/mmdebug.h:5,
>                  from include/linux/gfp.h:5,
>                  from include/linux/umh.h:4,
>                  from include/linux/kmod.h:9,
>                  from net/bridge/netfilter/ebtables.c:14:
> net/bridge/netfilter/ebtables.c: In function '__ebt_find_table':
> net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no =
member named 'tables'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |                                 ^
> include/linux/kernel.h:708:26: note: in definition of macro 'container_of'
>   708 |  void *__mptr =3D (void *)(ptr);     \
>       |                          ^~~
> include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>   522 |  list_entry((ptr)->next, type, member)
>       |  ^~~~~~~~~~
> include/linux/list.h:628:13: note: in expansion of macro 'list_first_entr=
y'
>   628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
>       |             ^~~~~~~~~~~~~~~~
> net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list=
_for_each_entry'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |  ^~~~~~~~~~~~~~~~~~~
> In file included from <command-line>:
> net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no =
member named 'tables'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |                                 ^
> include/linux/compiler_types.h:300:9: note: in definition of macro '__com=
piletime_assert'
>   300 |   if (!(condition))     \
>       |         ^~~~~~~~~
> include/linux/compiler_types.h:320:2: note: in expansion of macro '_compi=
letime_assert'
>   320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COU=
NTER__)
>       |  ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime=
_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), m=
sg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_M=
SG'
>   709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>       |  ^~~~~~~~~~~~~~~~
> include/linux/kernel.h:709:20: note: in expansion of macro '__same_type'
>   709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>       |                    ^~~~~~~~~~~
> include/linux/list.h:511:2: note: in expansion of macro 'container_of'
>   511 |  container_of(ptr, type, member)
>       |  ^~~~~~~~~~~~
> include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>   522 |  list_entry((ptr)->next, type, member)
>       |  ^~~~~~~~~~
> include/linux/list.h:628:13: note: in expansion of macro 'list_first_entr=
y'
>   628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
>       |             ^~~~~~~~~~~~~~~~
> net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list=
_for_each_entry'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |  ^~~~~~~~~~~~~~~~~~~
> net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no =
member named 'tables'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |                                 ^
> include/linux/compiler_types.h:300:9: note: in definition of macro '__com=
piletime_assert'
>   300 |   if (!(condition))     \
>       |         ^~~~~~~~~
> include/linux/compiler_types.h:320:2: note: in expansion of macro '_compi=
letime_assert'
>   320 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COU=
NTER__)
>       |  ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime=
_assert'
>    39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), m=
sg)
>       |                                     ^~~~~~~~~~~~~~~~~~
> include/linux/kernel.h:709:2: note: in expansion of macro 'BUILD_BUG_ON_M=
SG'
>   709 |  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
>       |  ^~~~~~~~~~~~~~~~
> include/linux/kernel.h:710:6: note: in expansion of macro '__same_type'
>   710 |     !__same_type(*(ptr), void),   \
>       |      ^~~~~~~~~~~
> include/linux/list.h:511:2: note: in expansion of macro 'container_of'
>   511 |  container_of(ptr, type, member)
>       |  ^~~~~~~~~~~~
> include/linux/list.h:522:2: note: in expansion of macro 'list_entry'
>   522 |  list_entry((ptr)->next, type, member)
>       |  ^~~~~~~~~~
> include/linux/list.h:628:13: note: in expansion of macro 'list_first_entr=
y'
>   628 |  for (pos =3D list_first_entry(head, typeof(*pos), member); \
>       |             ^~~~~~~~~~~~~~~~
> net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list=
_for_each_entry'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |  ^~~~~~~~~~~~~~~~~~~
> In file included from include/linux/preempt.h:11,
>                  from include/linux/spinlock.h:51,
>                  from include/linux/mmzone.h:8,
>                  from include/linux/gfp.h:6,
>                  from include/linux/umh.h:4,
>                  from include/linux/kmod.h:9,
>                  from net/bridge/netfilter/ebtables.c:14:
> net/bridge/netfilter/ebtables.c:1248:33: error: 'struct netns_xt' has no =
member named 'tables'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |                                 ^
> include/linux/list.h:619:20: note: in definition of macro 'list_entry_is_=
head'
>   619 |  (&pos->member =3D=3D (head))
>       |                    ^~~~
> net/bridge/netfilter/ebtables.c:1248:2: note: in expansion of macro 'list=
_for_each_entry'
>  1248 |  list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
>       |  ^~~~~~~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   5b53951cfc85 ("netfilter: ebtables: use net_generic infra")
>=20
> interacting with commit
>=20
>   7ee3c61dcd28 ("netfilter: bridge: add pre_exit hooks for ebtable unregi=
stration")
>=20
> from the netfilter tree.
>=20
> I have applied the following merge fix patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 12 Apr 2021 14:58:20 +1000
> Subject: [PATCH] merger fix for "netfilter: bridge: add pre_exit hooks for
>  ebtable unregistration"

Thanks.

I'll include this merge conflict in my next pull request.

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAmB0Sj8ACgkQ1GSBvS7Z
kBm5qxAAw9lgQx7PmEXw7+Ji1y8xQZgXtahCa+Ze2PLxCIPkREzsrTats5EdGJRb
PpGUCraQh2r8YB2xdAGaAaBGmGa2WRBgDriRYbGtQwMLmBy6ICnD7z5u734aHEhK
7sYyJK/HK+ZuPxB0YdXX/djFJz0IiIAKZIyMRk1ZLU9wR9IIKTlmXyOLQ+H6Z7E8
ORNML/q13F6zuVeEOM02j4TPDxcpv26mDlp6Of4IwybTXEvsF4Mpim8NaFNZamcg
e30rx6V5JT+5VVfgkFuXl72E0Zc2n7ia4TakDGzLnNnu9w/lUL8b2Ox+d9o3H3xS
BqPWRectRHW5LyUHuPQ1tu85pvdOcAHXaFKX8cbFh18SfUA86/fnlUWo55GpRBTW
o0b+6wYdoUZNNeBn86FwtlC0muRkArdTTyLdDOXOG01nAHQbQqtNZtRWVYh64E1r
D5htL4tutvJ+pcAXg9vsGFI5puIIp3YB9usOiHQOIPiDnC0Kd8eU+1qDdZ9DOm9N
fEoiEuwg7ejfkFScJVkwb9fQDnSD3vCYNVFFRJGOyghE7pbIp+6Sa4OZOExpDCsm
qp+6WynLkYks4KuivoBpdSjTdelQ44FHovIC0TzaBA+jjm4kmX7znaKM7FvUsZSz
fD5sWPWntxX8UYrXv84/q72qMYi1KFwu7sJJ8ecKztzukUs9jXo=
=sY+L
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
