Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298905FD704
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 11:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiJMJZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 05:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiJMJZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 05:25:33 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6251ED73C1
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 02:25:31 -0700 (PDT)
Received: (qmail 7803 invoked from network); 13 Oct 2022 09:25:01 -0000
Received: from p200300cf070ada0076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:70a:da00:76d4:35ff:feb7:be92]:60562 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <linux-kernel@vger.kernel.org>; Thu, 13 Oct 2022 11:25:01 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Graf <tgraf@suug.ch>, kasan-dev@googlegroups.com
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v6 5/7] treewide: use get_random_u32() when possible
Date:   Thu, 13 Oct 2022 11:25:11 +0200
Message-ID: <3026360.ZldQQBzMgz@eto.sf-tec.de>
In-Reply-To: <20221010230613.1076905-6-Jason@zx2c4.com>
References: <20221010230613.1076905-1-Jason@zx2c4.com> <20221010230613.1076905-6-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3480752.mCL07Ym2y3"; micalg="pgp-sha1"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart3480752.mCL07Ym2y3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; protected-headers="v1"
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Date: Thu, 13 Oct 2022 11:25:11 +0200
Message-ID: <3026360.ZldQQBzMgz@eto.sf-tec.de>
In-Reply-To: <20221010230613.1076905-6-Jason@zx2c4.com>
MIME-Version: 1.0

Am Dienstag, 11. Oktober 2022, 01:06:11 CEST schrieb Jason A. Donenfeld:
> The prandom_u32() function has been a deprecated inline wrapper around
> get_random_u32() for several releases now, and compiles down to the
> exact same code. Replace the deprecated wrapper with a direct call to
> the real function. The same also applies to get_random_int(), which is
> just a wrapper around get_random_u32(). This was done as a basic find
> and replace.
>=20
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Reviewed-by: Yury Norov <yury.norov@gmail.com>
> Acked-by: Toke H=F8iland-J=F8rgensen <toke@toke.dk> # for sch_cake
> Acked-by: Chuck Lever <chuck.lever@oracle.com> # for nfsd
> Reviewed-by: Jan Kara <jack@suse.cz> # for ext4
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com> # for
> thunderbolt Acked-by: Darrick J. Wong <djwong@kernel.org> # for xfs
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  Documentation/networking/filter.rst            |  2 +-
>  arch/parisc/kernel/process.c                   |  2 +-
>  arch/parisc/kernel/sys_parisc.c                |  4 ++--
>  arch/s390/mm/mmap.c                            |  2 +-
>  arch/x86/kernel/cpu/amd.c                      |  2 +-
>  drivers/gpu/drm/i915/i915_gem_gtt.c            |  6 +++---
>  drivers/gpu/drm/i915/selftests/i915_selftest.c |  2 +-
>  drivers/gpu/drm/tests/drm_buddy_test.c         |  2 +-
>  drivers/gpu/drm/tests/drm_mm_test.c            |  2 +-
>  drivers/infiniband/hw/cxgb4/cm.c               |  4 ++--
>  drivers/infiniband/hw/hfi1/tid_rdma.c          |  2 +-
>  drivers/infiniband/hw/mlx4/mad.c               |  2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c        |  2 +-
>  drivers/md/raid5-cache.c                       |  2 +-
>  .../media/test-drivers/vivid/vivid-touch-cap.c |  4 ++--
>  drivers/misc/habanalabs/gaudi2/gaudi2.c        |  2 +-
>  drivers/net/bonding/bond_main.c                |  2 +-
>  drivers/net/ethernet/broadcom/cnic.c           |  2 +-
>  .../chelsio/inline_crypto/chtls/chtls_cm.c     |  2 +-
>  drivers/net/ethernet/rocker/rocker_main.c      |  6 +++---
>  .../wireless/broadcom/brcm80211/brcmfmac/pno.c |  2 +-
>  .../net/wireless/marvell/mwifiex/cfg80211.c    |  4 ++--
>  .../net/wireless/microchip/wilc1000/cfg80211.c |  2 +-
>  .../net/wireless/quantenna/qtnfmac/cfg80211.c  |  2 +-
>  drivers/net/wireless/ti/wlcore/main.c          |  2 +-
>  drivers/nvme/common/auth.c                     |  2 +-
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |  4 ++--
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c        |  2 +-
>  drivers/thunderbolt/xdomain.c                  |  2 +-
>  drivers/video/fbdev/uvesafb.c                  |  2 +-
>  fs/exfat/inode.c                               |  2 +-
>  fs/ext4/ialloc.c                               |  2 +-
>  fs/ext4/ioctl.c                                |  4 ++--
>  fs/ext4/mmp.c                                  |  2 +-
>  fs/f2fs/namei.c                                |  2 +-
>  fs/fat/inode.c                                 |  2 +-
>  fs/nfsd/nfs4state.c                            |  4 ++--
>  fs/ntfs3/fslog.c                               |  6 +++---
>  fs/ubifs/journal.c                             |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c                     |  2 +-
>  fs/xfs/xfs_icache.c                            |  2 +-
>  fs/xfs/xfs_log.c                               |  2 +-
>  include/net/netfilter/nf_queue.h               |  2 +-
>  include/net/red.h                              |  2 +-
>  include/net/sock.h                             |  2 +-
>  kernel/bpf/bloom_filter.c                      |  2 +-
>  kernel/bpf/core.c                              |  2 +-
>  kernel/bpf/hashtab.c                           |  2 +-
>  kernel/bpf/verifier.c                          |  2 +-
>  kernel/kcsan/selftest.c                        |  2 +-
>  lib/random32.c                                 |  2 +-
>  lib/reed_solomon/test_rslib.c                  |  6 +++---
>  lib/test_fprobe.c                              |  2 +-
>  lib/test_kprobes.c                             |  2 +-
>  lib/test_min_heap.c                            |  6 +++---
>  lib/test_rhashtable.c                          |  6 +++---
>  mm/shmem.c                                     |  2 +-
>  mm/slab.c                                      |  2 +-
>  net/core/pktgen.c                              |  4 ++--
>  net/ipv4/route.c                               |  2 +-
>  net/ipv4/tcp_cdg.c                             |  2 +-
>  net/ipv4/udp.c                                 |  2 +-
>  net/ipv6/ip6_flowlabel.c                       |  2 +-
>  net/ipv6/output_core.c                         |  2 +-
>  net/netfilter/ipvs/ip_vs_conn.c                |  2 +-
>  net/netfilter/xt_statistic.c                   |  2 +-
>  net/openvswitch/actions.c                      |  2 +-
>  net/sched/sch_cake.c                           |  2 +-
>  net/sched/sch_netem.c                          | 18 +++++++++---------
>  net/sunrpc/auth_gss/gss_krb5_wrap.c            |  4 ++--
>  net/sunrpc/xprt.c                              |  2 +-
>  net/unix/af_unix.c                             |  2 +-
>  72 files changed, 101 insertions(+), 101 deletions(-)
>=20

> diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
> index 5a1dd4736b56..b358a74ed7ed 100644
> --- a/lib/test_rhashtable.c
> +++ b/lib/test_rhashtable.c
> @@ -291,7 +291,7 @@ static int __init test_rhltable(unsigned int entries)
>  	if (WARN_ON(err))
>  		goto out_free;
>=20
> -	k =3D prandom_u32();
> +	k =3D get_random_u32();
>  	ret =3D 0;
>  	for (i =3D 0; i < entries; i++) {
>  		rhl_test_objects[i].value.id =3D k;

This one looks ok.

> @@ -369,12 +369,12 @@ static int __init test_rhltable(unsigned int entrie=
s)
>  	pr_info("test %d random rhlist add/delete operations\n", entries);
>  	for (j =3D 0; j < entries; j++) {
>  		u32 i =3D prandom_u32_max(entries);
> -		u32 prand =3D prandom_u32();
> +		u32 prand =3D get_random_u32();
>=20
>  		cond_resched();
>=20
>  		if (prand =3D=3D 0)
> -			prand =3D prandom_u32();
> +			prand =3D get_random_u32();
>=20
>  		if (prand & 1) {
>  			prand >>=3D 1;

But this doesn't make any sense to me. It needs a bit more context:

>			continue;
>		}

Why would one change prand wen it will be overwritten in the next loop anyw=
ay?

>		err =3D rhltable_remove(&rhlt, &rhl_test_objects[i].list_node, test_rht_=
params);
>		if (test_bit(i, obj_in_table)) {
>			clear_bit(i, obj_in_table);
>			if (WARN(err, "cannot remove element at slot %d", i))
>				continue;
>		} else {
>			if (WARN(err !=3D -ENOENT, "removed non-existent element %d, error %d n=
ot %d",
>			     i, err, -ENOENT))
>				continue;
>		}
>
>		if (prand & 1) {
>			prand >>=3D 1;
>			continue;
>		}

The same code again, and in this case it is impossible to reach, as the che=
ck=20
already returned false before.

Should these have been something like this in the first place:

	if (prand & 1)
		prand >>=3D1;
	else
		continue;

At least as the code looks now this only ever needs a single bit of randomn=
ess,
and the later checks and the shift can go away, but I suspect that somethin=
g=20
else was meant with that code.

=46lorian, can you comment and maybe fix it? When possible use prandom_u8()=
 as=20
it seems to me that you only need 3 bytes of randomness here anyway.

Or you wanted to move the variable before the loop and keep the random state
between the loops and only reseed when all '1' bits have been consumed. But=
=20
even in this case the later checks seem wrong as the value has not changed =
in=20
between.

Eike
--nextPart3480752.mCL07Ym2y3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCY0fZeAAKCRBcpIk+abn8
TntwAJ9xzxWkK3p1U0eDZrP7KBVqifG2qQCfX+QJlO38O9/0GmN/6UVEEt2C1l8=
=+1Dc
-----END PGP SIGNATURE-----

--nextPart3480752.mCL07Ym2y3--



