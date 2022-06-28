Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAA055C58C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbiF1A6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 20:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242060AbiF1A6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 20:58:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AA01CFE5;
        Mon, 27 Jun 2022 17:58:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD4F7B81C0A;
        Tue, 28 Jun 2022 00:58:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEABC341C8;
        Tue, 28 Jun 2022 00:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656377910;
        bh=x4KMhmowxPAczUMJ6x4nBeCjlIDio89Zlndd34Eza5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmtqPrxs/EakAnLyUZ+T1Y6Y2PuUVWE1p/lPmqQBXiapPC1WBd92tcHfgEnTJibSz
         8Cqh6wp+mGRPQenFwVH/ncudi5b7Tg0x4DYK6LYwUDkNgU3v8Yk/6Or0HzPxa5QXgF
         OYkHqjzJwOTAIzA6m0DkNzWrhG6StDZ8wiRdHVw+Wnp/Deq+bcAy4GlTPygKnkBgqV
         sUW1DRx9UPn831OT0MRefhs1kf7ZlvXFnW9s3XTKUzsS60aUSNGKPAXfxyQi7QqZvQ
         a8VxNxF80uRWuCVjsLU3WaCLAUnTapHIuQJvInOf0IrcXvC7dKlHhnQt1FhIxUdbDj
         Qy7qblTn3AnuA==
Date:   Tue, 28 Jun 2022 02:58:25 +0200
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org, dm-devel@redhat.com,
        linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-can@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, io-uring@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-mmc@vger.kernel.org,
        nvdimm@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-perf-users@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        v9fs-developer@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] treewide: uapi: Replace zero-length arrays with
 flexible-array members
Message-ID: <20220628005825.GA161566@embeddedor>
References: <20220627180432.GA136081@embeddedor>
 <6bc1e94c-ce1d-a074-7d0c-8dbe6ce22637@iogearbox.net>
 <20220628004052.GM23621@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220628004052.GM23621@ziepe.ca>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 09:40:52PM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 27, 2022 at 08:27:37PM +0200, Daniel Borkmann wrote:
> > On 6/27/22 8:04 PM, Gustavo A. R. Silva wrote:
> > > There is a regular need in the kernel to provide a way to declare
> > > having a dynamically sized set of trailing elements in a structure.
> > > Kernel code should always use “flexible array members”[1] for these
> > > cases. The older style of one-element or zero-length arrays should
> > > no longer be used[2].
> > > 
> > > This code was transformed with the help of Coccinelle:
> > > (linux-5.19-rc2$ spatch --jobs $(getconf _NPROCESSORS_ONLN) --sp-file script.cocci --include-headers --dir . > output.patch)
> > > 
> > > @@
> > > identifier S, member, array;
> > > type T1, T2;
> > > @@
> > > 
> > > struct S {
> > >    ...
> > >    T1 member;
> > >    T2 array[
> > > - 0
> > >    ];
> > > };
> > > 
> > > -fstrict-flex-arrays=3 is coming and we need to land these changes
> > > to prevent issues like these in the short future:
> > > 
> > > ../fs/minix/dir.c:337:3: warning: 'strcpy' will always overflow; destination buffer has size 0,
> > > but the source string has length 2 (including NUL byte) [-Wfortify-source]
> > > 		strcpy(de3->name, ".");
> > > 		^
> > > 
> > > Since these are all [0] to [] changes, the risk to UAPI is nearly zero. If
> > > this breaks anything, we can use a union with a new member name.
> > > 
> > > [1] https://en.wikipedia.org/wiki/Flexible_array_member
> > > [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> > > 
> > > Link: https://github.com/KSPP/linux/issues/78
> > > Build-tested-by: https://lore.kernel.org/lkml/62b675ec.wKX6AOZ6cbE71vtF%25lkp@intel.com/
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > ---
> > > Hi all!
> > > 
> > > JFYI: I'm adding this to my -next tree. :)
> > 
> > Fyi, this breaks BPF CI:
> > 
> > https://github.com/kernel-patches/bpf/runs/7078719372?check_suite_focus=true
> > 
> >   [...]
> >   progs/map_ptr_kern.c:314:26: error: field 'trie_key' with variable sized type 'struct bpf_lpm_trie_key' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
> >           struct bpf_lpm_trie_key trie_key;
> >                                   ^
> 
> This will break the rdma-core userspace as well, with a similar
> error:
> 
> /usr/bin/clang-13 -DVERBS_DEBUG -Dibverbs_EXPORTS -Iinclude -I/usr/include/libnl3 -I/usr/include/drm -g -O2 -fdebug-prefix-map=/__w/1/s=. -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -Wmissing-prototypes -Wmissing-declarations -Wwrite-strings -Wformat=2 -Wcast-function-type -Wformat-nonliteral -Wdate-time -Wnested-externs -Wshadow -Wstrict-prototypes -Wold-style-definition -Werror -Wredundant-decls -g -fPIC   -std=gnu11 -MD -MT libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o -MF libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o.d -o libibverbs/CMakeFiles/ibverbs.dir/cmd_flow.c.o   -c ../libibverbs/cmd_flow.c
> In file included from ../libibverbs/cmd_flow.c:33:
> In file included from include/infiniband/cmd_write.h:36:
> In file included from include/infiniband/cmd_ioctl.h:41:
> In file included from include/infiniband/verbs.h:48:
> In file included from include/infiniband/verbs_api.h:66:
> In file included from include/infiniband/ib_user_ioctl_verbs.h:38:
> include/rdma/ib_user_verbs.h:436:34: error: field 'base' with variable sized type 'struct ib_uverbs_create_cq_resp' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct ib_uverbs_create_cq_resp base;
>                                         ^
> include/rdma/ib_user_verbs.h:644:34: error: field 'base' with variable sized type 'struct ib_uverbs_create_qp_resp' not at the end of a struct or class is a GNU extension [-Werror,-Wgnu-variable-sized-type-not-at-end]
>         struct ib_uverbs_create_qp_resp base;
> 
> Which is why I gave up trying to change these..
> 
> Though maybe we could just switch off -Wgnu-variable-sized-type-not-at-end  during configuration ?

No. I think now we can easily workaround these sorts of problems with
something like this:

	struct flex {
		any_type any_member;
		union {
			type array[0];
			__DECLARE_FLEX_ARRAY(type, array_flex);
		};
	};

and use array_flex in kernel-space.

The same for the one-elment arrays in UAPI:

        struct flex {
                any_type any_member;
                union {
                        type array[1];
                        __DECLARE_FLEX_ARRAY(type, array_flex);
                };
        };

I'll use the idiom above to resolve all these warnings in a follow-up
patch. :)

Thanks
--
Gustavo
