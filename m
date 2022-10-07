Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107475F75CC
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 11:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJGJMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJGJMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 05:12:37 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682DBDED22
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 02:12:32 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso6675235pjf.5
        for <netdev@vger.kernel.org>; Fri, 07 Oct 2022 02:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWfgfYA0Y7Bsea8YsJLHPPRZpIuS1ctJ2qwzsdNXRQQ=;
        b=cJidoh6H1uADw+7tISOibhEtRZw6/8LgPK8xnUPP26DeNpl86nNCrmcFETPzQcR1HU
         EeiKEtiHa/TEq2yCVbkNPAuc0vW4RKnX+gsl1ZZdlofZ75a90WDG3Vuzc+Qbf0Eo+Zf4
         txkWoGs9n/ABfCltcqS9/k5qefNE2E91YJPQeX59PyxFsA0iBom6oJW7gXuQRehm5R+4
         u79Pg1a2OJi1CJGNwWNEXpxA6O24alQwdDRv7Arndr0yRXAp2xeICJvSl9kHElUmPkl2
         afuzKnPKiHF2/N8t6hdI7rgCS5NbRQl5q0FjalEDXUOlmkHUNJaylPxO8O4zBhTsnOAY
         fWdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XWfgfYA0Y7Bsea8YsJLHPPRZpIuS1ctJ2qwzsdNXRQQ=;
        b=PPnQz0mmpLKY0acxLZ/PIR7yBeMblN4XgNEiLpywkv9K+wGZ3erXax3iO+OLYfqHmP
         HrU4fn00ldv+o1HCm4yOreLp/DE2/1yTqhYGht8MhDBRTvAnCXZfl2O8BtanbnEu0YaN
         MgUSzM8I+F8hO24VZ97NG7L3jP6f/3wAl1k1r5bpcLLQV/I3JVAnWQc/0dntvbRyvXlu
         I9aUIUr0GxQpxLkMMrAOOBN2SjcgnFLrY7vQBryaJ2NM1nibBu1DB8PlwYZ0avj+zVgx
         cb0Y+ERAIoldimj7PVqdiqNyPzHLvmRrP8pPsHOgT9TnlK3mME5VhE63udQZQ9P0oqyY
         N+NA==
X-Gm-Message-State: ACrzQf0wYuQHShNVhtVWc3frCBAxJIMcUuCfc+4tUqtlQHfun1V+YFtC
        SVLxTFUiUrcbNU6HMnCnjbJELhp/CTfvmaHFBKJBjg==
X-Google-Smtp-Source: AMsMyM6zPtbJGyFd5+PZ/YLbHOSjqHhuMJPpmd2X/NiEKV7uyszzQEkaDQfomvJJ+WgdnhP03Ir6+teXOvtZIUZdWhs=
X-Received: by 2002:a17:903:246:b0:179:96b5:1ad2 with SMTP id
 j6-20020a170903024600b0017996b51ad2mr4017157plh.37.1665133951783; Fri, 07 Oct
 2022 02:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20221006165346.73159-1-Jason@zx2c4.com>
In-Reply-To: <20221006165346.73159-1-Jason@zx2c4.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Fri, 7 Oct 2022 11:11:54 +0200
Message-ID: <CAPDyKFoTLHULeGJMgDxGKci+HvHjE6K8G1JLuYmXHCch+=WUKw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] treewide cleanup of random integer usage
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Christoph_B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Oct 2022 at 18:54, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Changes v2->v3:
> - Handle get_random_int() conversions too, which were overlooked before,
>   in the same way as the rest.
>
> Hi folks,
>
> This is a five part treewide cleanup of random integer handling. The
> rules for random integers are:
>
> - If you want a secure or an insecure random u64, use get_random_u64().
> - If you want a secure or an insecure random u32, use get_random_u32().
>   * The old function prandom_u32() has been deprecated for a while now
>     and is just a wrapper around get_random_u32(). Same for
>     get_random_int().
> - If you want a secure or an insecure random u16, use get_random_u16().
> - If you want a secure or an insecure random u8, use get_random_u8().
> - If you want secure or insecure random bytes, use get_random_bytes().
>   * The old function prandom_bytes() has been deprecated for a while now
>     and has long been a wrapper around get_random_bytes().
> - If you want a non-uniform random u32, u16, or u8 bounded by a certain
>   open interval maximum, use prandom_u32_max().
>   * I say "non-uniform", because it doesn't do any rejection sampling or
>     divisions. Hence, it stays within the prandom_* namespace.
>
> These rules ought to be applied uniformly, so that we can clean up the
> deprecated functions, and earn the benefits of using the modern
> functions. In particular, in addition to the boring substitutions, this
> patchset accomplishes a few nice effects:
>
> - By using prandom_u32_max() with an upper-bound that the compiler can
>   prove at compile-time is =E2=89=A465536 or =E2=89=A4256, internally get=
_random_u16()
>   or get_random_u8() is used, which wastes fewer batched random bytes,
>   and hence has higher throughput.
>
> - By using prandom_u32_max() instead of %, when the upper-bound is not a
>   constant, division is still avoided, because prandom_u32_max() uses
>   a faster multiplication-based trick instead.
>
> - By using get_random_u16() or get_random_u8() in cases where the return
>   value is intended to indeed be a u16 or a u8, we waste fewer batched
>   random bytes, and hence have higher throughput.
>
> So, based on those rules and benefits from following them, this patchset
> breaks down into the following five steps, which were done mostly
> manually:
>
> 1) Replace `prandom_u32() % max` and variants thereof with
>    prandom_u32_max(max).
>
> 2) Replace `(type)get_random_u32()` and variants thereof with
>    get_random_u16() or get_random_u8(). I took the pains to actually
>    look and see what every lvalue type was across the entire tree.
>
> 3) Replace remaining deprecated uses of prandom_u32() and
>    get_random_int() with get_random_u32().
>
> 4) Replace remaining deprecated uses of prandom_bytes() with
>    get_random_bytes().
>
> 5) Remove the deprecated and now-unused prandom_u32() and
>    prandom_bytes() inline wrapper functions.
>
> I was thinking of taking this through my random.git tree (on which this
> series is currently based) and submitting it near the end of the merge
> window, or waiting for the very end of the 6.1 cycle when there will be
> the fewest new patches brewing. If somebody with some treewide-cleanup
> experience might share some wisdom about what the best timing usually
> winds up being, I'm all ears.
>
> Please take a look! At "379 insertions(+), 422 deletions(-)", this
> should be a somewhat small patchset to review, despite it having the
> scary "treewide" moniker on it.
>
> Thanks,
> Jason
>
> Cc: Andreas Noever <andreas.noever@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Christoph B=C3=B6hmwalder <christoph.boehmwalder@linbit.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>
> Cc: Jan Kara <jack@suse.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: KP Singh <kpsingh@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Marco Elver <elver@google.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Vignesh Raghavendra <vigneshr@ti.com>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Will Deacon <will@kernel.org>
> Cc: Yury Norov <yury.norov@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: kasan-dev@googlegroups.com
> Cc: kernel-janitors@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-block@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-mmc@vger.kernel.org
> Cc: linux-mtd@lists.infradead.org
> Cc: linux-nvme@lists.infradead.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-rdma@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-usb@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: loongarch@lists.linux.dev
> Cc: netdev@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: x86@kernel.org
>
> Jason A. Donenfeld (5):
>   treewide: use prandom_u32_max() when possible
>   treewide: use get_random_{u8,u16}() when possible
>   treewide: use get_random_u32() when possible
>   treewide: use get_random_bytes when possible
>   prandom: remove unused functions
>
>  Documentation/networking/filter.rst           |  2 +-
>  arch/arm/kernel/process.c                     |  2 +-
>  arch/arm/kernel/signal.c                      |  2 +-
>  arch/arm64/kernel/process.c                   |  2 +-
>  arch/arm64/kernel/syscall.c                   |  2 +-
>  arch/loongarch/kernel/process.c               |  2 +-
>  arch/loongarch/kernel/vdso.c                  |  2 +-
>  arch/mips/kernel/process.c                    |  2 +-
>  arch/mips/kernel/vdso.c                       |  2 +-
>  arch/parisc/kernel/process.c                  |  2 +-
>  arch/parisc/kernel/sys_parisc.c               |  4 +-
>  arch/parisc/kernel/vdso.c                     |  2 +-
>  arch/powerpc/crypto/crc-vpmsum_test.c         |  2 +-
>  arch/powerpc/kernel/process.c                 |  2 +-
>  arch/s390/kernel/process.c                    |  4 +-
>  arch/s390/kernel/vdso.c                       |  2 +-
>  arch/s390/mm/mmap.c                           |  2 +-
>  arch/sparc/vdso/vma.c                         |  2 +-
>  arch/um/kernel/process.c                      |  2 +-
>  arch/x86/entry/vdso/vma.c                     |  2 +-
>  arch/x86/kernel/cpu/amd.c                     |  2 +-
>  arch/x86/kernel/module.c                      |  2 +-
>  arch/x86/kernel/process.c                     |  2 +-
>  arch/x86/mm/pat/cpa-test.c                    |  4 +-
>  block/blk-crypto-fallback.c                   |  2 +-
>  crypto/async_tx/raid6test.c                   |  2 +-
>  crypto/testmgr.c                              | 94 +++++++++----------
>  drivers/block/drbd/drbd_receiver.c            |  4 +-
>  drivers/char/random.c                         | 11 +--
>  drivers/dma/dmatest.c                         |  2 +-
>  .../gpu/drm/i915/gem/i915_gem_execbuffer.c    |  2 +-
>  drivers/gpu/drm/i915/i915_gem_gtt.c           |  6 +-
>  .../gpu/drm/i915/selftests/i915_selftest.c    |  2 +-
>  drivers/gpu/drm/selftests/test-drm_buddy.c    |  2 +-
>  drivers/gpu/drm/selftests/test-drm_mm.c       |  2 +-
>  drivers/infiniband/core/cma.c                 |  2 +-
>  drivers/infiniband/hw/cxgb4/cm.c              |  4 +-
>  drivers/infiniband/hw/cxgb4/id_table.c        |  4 +-
>  drivers/infiniband/hw/hfi1/tid_rdma.c         |  2 +-
>  drivers/infiniband/hw/hns/hns_roce_ah.c       |  5 +-
>  drivers/infiniband/hw/mlx4/mad.c              |  2 +-
>  drivers/infiniband/ulp/ipoib/ipoib_cm.c       |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  3 +-
>  drivers/md/bcache/request.c                   |  2 +-
>  drivers/md/raid5-cache.c                      |  2 +-
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |  2 +-
>  .../media/test-drivers/vivid/vivid-radio-rx.c |  4 +-
>  .../test-drivers/vivid/vivid-touch-cap.c      |  6 +-
>  drivers/misc/habanalabs/gaudi2/gaudi2.c       |  2 +-
>  drivers/mmc/core/core.c                       |  4 +-
>  drivers/mmc/host/dw_mmc.c                     |  2 +-
>  drivers/mtd/nand/raw/nandsim.c                |  8 +-
>  drivers/mtd/tests/mtd_nandecctest.c           | 12 +--
>  drivers/mtd/tests/speedtest.c                 |  2 +-
>  drivers/mtd/tests/stresstest.c                | 19 +---
>  drivers/mtd/ubi/debug.c                       |  2 +-
>  drivers/mtd/ubi/debug.h                       |  6 +-
>  drivers/net/bonding/bond_main.c               |  2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
>  drivers/net/ethernet/broadcom/cnic.c          |  5 +-
>  .../chelsio/inline_crypto/chtls/chtls_cm.c    |  4 +-
>  .../chelsio/inline_crypto/chtls/chtls_io.c    |  4 +-
>  drivers/net/ethernet/rocker/rocker_main.c     |  8 +-
>  drivers/net/hamradio/baycom_epp.c             |  2 +-
>  drivers/net/hamradio/hdlcdrv.c                |  2 +-
>  drivers/net/hamradio/yam.c                    |  2 +-
>  drivers/net/phy/at803x.c                      |  2 +-
>  drivers/net/wireguard/selftest/allowedips.c   | 16 ++--
>  .../broadcom/brcm80211/brcmfmac/p2p.c         |  2 +-
>  .../broadcom/brcm80211/brcmfmac/pno.c         |  2 +-
>  .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
>  .../net/wireless/marvell/mwifiex/cfg80211.c   |  4 +-
>  .../wireless/microchip/wilc1000/cfg80211.c    |  2 +-
>  .../net/wireless/quantenna/qtnfmac/cfg80211.c |  2 +-
>  drivers/net/wireless/st/cw1200/wsm.c          |  2 +-
>  drivers/net/wireless/ti/wlcore/main.c         |  2 +-
>  drivers/nvme/common/auth.c                    |  2 +-
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c            |  4 +-
>  drivers/scsi/fcoe/fcoe_ctlr.c                 |  4 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c              |  6 +-
>  drivers/scsi/qedi/qedi_main.c                 |  2 +-
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c       |  2 +-
>  drivers/thunderbolt/xdomain.c                 |  2 +-
>  drivers/video/fbdev/uvesafb.c                 |  2 +-
>  fs/ceph/inode.c                               |  2 +-
>  fs/ceph/mdsmap.c                              |  2 +-
>  fs/exfat/inode.c                              |  2 +-
>  fs/ext2/ialloc.c                              |  3 +-
>  fs/ext4/ialloc.c                              |  7 +-
>  fs/ext4/ioctl.c                               |  4 +-
>  fs/ext4/mmp.c                                 |  2 +-
>  fs/ext4/super.c                               |  7 +-
>  fs/f2fs/gc.c                                  |  2 +-
>  fs/f2fs/namei.c                               |  2 +-
>  fs/f2fs/segment.c                             |  8 +-
>  fs/fat/inode.c                                |  2 +-
>  fs/nfsd/nfs4state.c                           |  4 +-
>  fs/ntfs3/fslog.c                              |  6 +-
>  fs/ubifs/debug.c                              | 10 +-
>  fs/ubifs/journal.c                            |  2 +-
>  fs/ubifs/lpt_commit.c                         | 14 +--
>  fs/ubifs/tnc_commit.c                         |  2 +-
>  fs/xfs/libxfs/xfs_alloc.c                     |  2 +-
>  fs/xfs/libxfs/xfs_ialloc.c                    |  4 +-
>  fs/xfs/xfs_error.c                            |  2 +-
>  fs/xfs/xfs_icache.c                           |  2 +-
>  fs/xfs/xfs_log.c                              |  2 +-
>  include/linux/nodemask.h                      |  2 +-
>  include/linux/prandom.h                       | 12 ---
>  include/linux/random.h                        |  5 -
>  include/net/netfilter/nf_queue.h              |  2 +-
>  include/net/red.h                             |  2 +-
>  include/net/sock.h                            |  2 +-
>  kernel/bpf/bloom_filter.c                     |  2 +-
>  kernel/bpf/core.c                             |  6 +-
>  kernel/bpf/hashtab.c                          |  2 +-
>  kernel/bpf/verifier.c                         |  2 +-
>  kernel/kcsan/selftest.c                       |  4 +-
>  kernel/locking/test-ww_mutex.c                |  4 +-
>  kernel/time/clocksource.c                     |  2 +-
>  lib/cmdline_kunit.c                           |  4 +-
>  lib/fault-inject.c                            |  2 +-
>  lib/find_bit_benchmark.c                      |  4 +-
>  lib/kobject.c                                 |  2 +-
>  lib/random32.c                                |  4 +-
>  lib/reed_solomon/test_rslib.c                 | 12 +--
>  lib/sbitmap.c                                 |  4 +-
>  lib/test-string_helpers.c                     |  2 +-
>  lib/test_fprobe.c                             |  2 +-
>  lib/test_hexdump.c                            | 10 +-
>  lib/test_kasan.c                              |  6 +-
>  lib/test_kprobes.c                            |  2 +-
>  lib/test_list_sort.c                          |  2 +-
>  lib/test_min_heap.c                           |  6 +-
>  lib/test_objagg.c                             |  2 +-
>  lib/test_rhashtable.c                         |  6 +-
>  lib/test_vmalloc.c                            | 19 +---
>  lib/uuid.c                                    |  2 +-
>  mm/migrate.c                                  |  2 +-
>  mm/shmem.c                                    |  2 +-
>  mm/slab.c                                     |  2 +-
>  mm/slub.c                                     |  2 +-
>  net/802/garp.c                                |  2 +-
>  net/802/mrp.c                                 |  2 +-
>  net/ceph/mon_client.c                         |  2 +-
>  net/ceph/osd_client.c                         |  2 +-
>  net/core/neighbour.c                          |  2 +-
>  net/core/pktgen.c                             | 47 +++++-----
>  net/core/stream.c                             |  2 +-
>  net/dccp/ipv4.c                               |  4 +-
>  net/ipv4/datagram.c                           |  2 +-
>  net/ipv4/igmp.c                               |  6 +-
>  net/ipv4/inet_connection_sock.c               |  2 +-
>  net/ipv4/inet_hashtables.c                    |  2 +-
>  net/ipv4/ip_output.c                          |  2 +-
>  net/ipv4/route.c                              |  4 +-
>  net/ipv4/tcp_cdg.c                            |  2 +-
>  net/ipv4/tcp_ipv4.c                           |  4 +-
>  net/ipv4/udp.c                                |  2 +-
>  net/ipv6/addrconf.c                           |  8 +-
>  net/ipv6/ip6_flowlabel.c                      |  2 +-
>  net/ipv6/mcast.c                              | 10 +-
>  net/ipv6/output_core.c                        |  2 +-
>  net/mac80211/rc80211_minstrel_ht.c            |  2 +-
>  net/mac80211/scan.c                           |  2 +-
>  net/netfilter/ipvs/ip_vs_conn.c               |  2 +-
>  net/netfilter/ipvs/ip_vs_twos.c               |  4 +-
>  net/netfilter/nf_nat_core.c                   |  4 +-
>  net/netfilter/xt_statistic.c                  |  2 +-
>  net/openvswitch/actions.c                     |  2 +-
>  net/packet/af_packet.c                        |  2 +-
>  net/rds/bind.c                                |  2 +-
>  net/sched/act_gact.c                          |  2 +-
>  net/sched/act_sample.c                        |  2 +-
>  net/sched/sch_cake.c                          |  8 +-
>  net/sched/sch_netem.c                         | 22 ++---
>  net/sched/sch_pie.c                           |  2 +-
>  net/sched/sch_sfb.c                           |  2 +-
>  net/sctp/socket.c                             |  4 +-
>  net/sunrpc/auth_gss/gss_krb5_wrap.c           |  4 +-
>  net/sunrpc/cache.c                            |  2 +-
>  net/sunrpc/xprt.c                             |  2 +-
>  net/sunrpc/xprtsock.c                         |  2 +-
>  net/tipc/socket.c                             |  2 +-
>  net/unix/af_unix.c                            |  2 +-
>  net/xfrm/xfrm_state.c                         |  2 +-
>  186 files changed, 379 insertions(+), 422 deletions(-)
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

Kind regards
Uffe
