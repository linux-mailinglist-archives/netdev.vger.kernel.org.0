Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FF745D794
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354199AbhKYJwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:52:43 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:55683 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348015AbhKYJum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 04:50:42 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J0Chx2Xtwz4xcb;
        Thu, 25 Nov 2021 20:47:29 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     ast@kernel.org, daniel@iogearbox.net, naveen.n.rao@linux.ibm.com,
        mpe@ellerman.id.au, christophe.leroy@csgroup.eu,
        Hari Bathini <hbathini@linux.ibm.com>
Cc:     songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, paulus@samba.org,
        kpsingh@kernel.org, kafai@fb.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20211012123056.485795-1-hbathini@linux.ibm.com>
References: <20211012123056.485795-1-hbathini@linux.ibm.com>
Subject: Re: [RESEND PATCH v4 0/8] bpf powerpc: Add BPF_PROBE_MEM support in powerpc JIT compiler
Message-Id: <163783298812.1228879.148537426457628310.b4-ty@ellerman.id.au>
Date:   Thu, 25 Nov 2021 20:36:28 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 18:00:48 +0530, Hari Bathini wrote:
> Patch #1 & #2 are simple cleanup patches. Patch #3 refactors JIT
> compiler code with the aim to simplify adding BPF_PROBE_MEM support.
> Patch #4 introduces PPC_RAW_BRANCH() macro instead of open coding
> branch instruction. Patch #5 & #7 add BPF_PROBE_MEM support for PPC64
> & PPC32 JIT compilers respectively. Patch #6 & #8 handle bad userspace
> pointers for PPC64 & PPC32 cases respectively.
> 
> [...]

Applied to powerpc/next.

[1/8] bpf powerpc: Remove unused SEEN_STACK
      https://git.kernel.org/powerpc/c/c9ce7c36e4870bd307101ba7a00a39d9aad270f3
[2/8] bpf powerpc: Remove extra_pass from bpf_jit_build_body()
      https://git.kernel.org/powerpc/c/04c04205bc35d0ecdc57146995ca9eb957d4f379
[3/8] bpf powerpc: refactor JIT compiler code
      https://git.kernel.org/powerpc/c/efa95f031bf38c85cf865413335a3dc044e3194e
[4/8] powerpc/ppc-opcode: introduce PPC_RAW_BRANCH() macro
      https://git.kernel.org/powerpc/c/f15a71b3880bf07b40810644e5ac6f177c2a7c8f
[5/8] bpf ppc64: Add BPF_PROBE_MEM support for JIT
      https://git.kernel.org/powerpc/c/983bdc0245a29cdefcd30d9d484d3edbc4b6d787
[6/8] bpf ppc64: Access only if addr is kernel address
      https://git.kernel.org/powerpc/c/9c70c7147ffec31de67d33243570a533b29f9759
[7/8] bpf ppc32: Add BPF_PROBE_MEM support for JIT
      https://git.kernel.org/powerpc/c/23b51916ee129833453d8a3d6bde0ff392f82fce
[8/8] bpf ppc32: Access only if addr is kernel address
      https://git.kernel.org/powerpc/c/e919c0b2323bedec00e1ecc6280498ff81f59b15

cheers
