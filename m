Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF85938B0
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 21:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiHOSKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 14:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbiHOSKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 14:10:13 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4048D2A249
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:10:11 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id 7uA42800C4C55Sk06uA4oE; Mon, 15 Aug 2022 20:10:09 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oNeXL-001DJO-RF; Mon, 15 Aug 2022 20:10:03 +0200
Date:   Mon, 15 Aug 2022 20:10:03 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     linux-parisc@vger.kernel.org, linux-staging@lists.linux.dev,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org
Subject: Re: Build regressions/improvements in v6.0-rc1
In-Reply-To: <20220815180438.2875559-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2208152006320.289321@ramsan.of.borg>
References: <CAHk-=wgRFjPHV-Y_eKP9wQMLFDgG+dEUHiv5wC17OQHsG5z7BA@mail.gmail.com> <20220815180438.2875559-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022, Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v6.0-rc1[1] compared to v5.19[2].
>
> Summarized:
>  - build errors: +26/-15

   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: .cfi_endproc without corresponding .cfi_startproc:  => 32
   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: bad or irreducible absolute expression:  => 16
   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: junk at end of line, first unrecognized character is `:':  => 16
   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: no such instruction: `be 0x100(%sr2,%r0)':  => 29
   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: no such instruction: `ldi 0,%r20':  => 30
   + /kisskb/src/arch/parisc/kernel/vdso32/restart_syscall.S: Error: no such instruction: `ldw 0(%sp),%r31':  => 26
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: no such instruction: `ble 0x100(%sr2,%r0)':  => 51, 46
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: no such instruction: `ldi 0,%r25':  => 44
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: no such instruction: `ldi 1,%r25':  => 49
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: no such instruction: `ldi 173,%r20':  => 50, 45
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.callinfo':  => 40
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.entry':  => 41
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.exit':  => 54
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.proc':  => 39
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.procend':  => 55
   + /kisskb/src/arch/parisc/kernel/vdso32/sigtramp.S: Error: unknown pseudo-op: `.stringz':  => 76

parisc64-gcc11/generic-64bit_defconfig
parisc-gcc11/generic-32bit_defconfig
parisc-gcc11/parisc-{allmod,allno,def}config

   + /kisskb/src/arch/sh/include/asm/io.h: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]:  => 239:34

sh4-gcc11/sh-allmodconfig (drivers/staging/octeon/ethernet-mem.c)

   + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn30/display_mode_vba_30.c: error: the frame size of 2096 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  => 6806:1
   + /kisskb/src/drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.c: error: the frame size of 2160 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  => 3778:1

x86_64-gcc8/x86-allmodconfig

   + /kisskb/src/include/linux/bitfield.h: error: call to '__field_overflow' declared with attribute error: value doesn't fit into mask:  => 151:3

mipsel-gcc5/mips-allmodconfig (net/mac80211/tx.c)

   + /kisskb/src/include/linux/compiler_types.h: error: call to '__compiletime_assert_603' declared with attribute error: FIELD_GET: mask is not constant:  => 354:38

arm64-gcc5/arm64-allmodconfig (arch/arm64/kvm/arm.c)

   + /kisskb/src/include/linux/random.h: error: 'latent_entropy' undeclared (first use in this function):  => 25:39

powerpc-gcc5/powerpc-all{mod,yes}config
powerpc-gcc5/ppc32_allmodconfig
powerpc-gcc5/ppc64_book3e_allmodconfig
powerpc-gcc5/ppc64le_allmodconfig

   + /kisskb/src/include/linux/random.h: error: 'latent_entropy' undeclared (first use in this function); did you mean 'add_latent_entropy'?:  => 25:46

powerpc-gcc11/powerpc-all{mod,yes}config
powerpc-gcc11/ppc64_book3e_allmodconfig

   + {standard input}: Error: displacement to undefined symbol .L377 overflows 12-bit field:  => 2286
   + {standard input}: Error: displacement to undefined symbol .L378 overflows 8-bit field :  => 2302
   + {standard input}: Error: displacement to undefined symbol .L382 overflows 8-bit field :  => 2213

sh4-gcc11/sh-allmodconfig (seen before, root cause is internal compiler error)

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/568035b01cfb107af8d2e4bd2fb9aea22cf5b868/ (all 135 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/3d7cb6b04c3f3115719235cc6866b10326de34cd/ (all 135 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
