Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7C135AE4F
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhDJO3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 10:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234820AbhDJO3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 10:29:50 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B36DC06138B;
        Sat, 10 Apr 2021 07:29:35 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4FHcp46kq2z9sWk; Sun, 11 Apr 2021 00:29:32 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        songliubraving@fb.com, Michael Ellerman <mpe@ellerman.id.au>,
        kafai@fb.com, naveen.n.rao@linux.ibm.com,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        daniel@iogearbox.net, john.fastabend@gmail.com,
        sandipan@linux.ibm.com, yhs@fb.com, ast@kernel.org,
        kpsingh@chromium.org, andrii@kernel.org,
        Paul Mackerras <paulus@samba.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
In-Reply-To: <cover.1616430991.git.christophe.leroy@csgroup.eu>
References: <cover.1616430991.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH v2 0/8] Implement EBPF on powerpc32
Message-Id: <161806493489.1467223.13057218503369355190.b4-ty@ellerman.id.au>
Date:   Sun, 11 Apr 2021 00:28:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 16:37:45 +0000 (UTC), Christophe Leroy wrote:
> This series implements extended BPF on powerpc32. For the implementation
> details, see the patch before the last.
> 
> The following operations are not implemented:
> 
> 		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst /= src */
> 		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst %= src */
> 		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
> 
> [...]

Applied to powerpc/next.

[1/8] powerpc/bpf: Remove classical BPF support for PPC32
      https://git.kernel.org/powerpc/c/6944caad78fc4de4ecd0364bbc9715b62b020965
[2/8] powerpc/bpf: Change register numbering for bpf_set/is_seen_register()
      https://git.kernel.org/powerpc/c/ed573b57e77a7860fe4026e1700faa2f6938caf1
[3/8] powerpc/bpf: Move common helpers into bpf_jit.h
      https://git.kernel.org/powerpc/c/f1b1583d5faa86cb3dcb7b740594868debad7c30
[4/8] powerpc/bpf: Move common functions into bpf_jit_comp.c
      https://git.kernel.org/powerpc/c/4ea76e90a97d22f86adbb10044d29d919e620f2e
[5/8] powerpc/bpf: Change values of SEEN_ flags
      https://git.kernel.org/powerpc/c/c426810fcf9f96e3b43d16039e41ecb959f6dc29
[6/8] powerpc/asm: Add some opcodes in asm/ppc-opcode.h for PPC32 eBPF
      https://git.kernel.org/powerpc/c/355a8d26cd0416e7e764e4db766cf91e773a03e7
[7/8] powerpc/bpf: Implement extended BPF on PPC32
      https://git.kernel.org/powerpc/c/51c66ad849a703d9bbfd7704c941827aed0fd9fd
[8/8] powerpc/bpf: Reallocate BPF registers to volatile registers when possible on PPC32
      https://git.kernel.org/powerpc/c/40272035e1d0edcd515ad45be297c4cce044536d

cheers
