Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E12442CE1
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 12:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhKBLlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 07:41:40 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:50537 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKBLlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 07:41:18 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hk7Fs6FVvz4xdN;
        Tue,  2 Nov 2021 22:38:41 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     jniethe5@gmail.com, christophe.leroy@csgroup.eu,
        Hari Bathini <hbathini@linux.ibm.com>,
        naveen.n.rao@linux.ibm.com, daniel@iogearbox.net, ast@kernel.org,
        mpe@ellerman.id.au
Cc:     john.fastabend@gmail.com, kpsingh@kernel.org, yhs@fb.com,
        bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        andrii@kernel.org, paulus@samba.org, kafai@fb.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com
In-Reply-To: <20211025055649.114728-1-hbathini@linux.ibm.com>
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
Message-Id: <163584792256.1845480.13895202988410061927.b4-ty@ellerman.id.au>
Date:   Tue, 02 Nov 2021 21:12:02 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 11:26:49 +0530, Hari Bathini wrote:
> Running program with bpf-to-bpf function calls results in data access
> exception (0x300) with the below call trace:
> 
>     [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (unreliable)
>     [c00000000037d2f8] bpf_check+0x2008/0x2710
>     [c000000000360050] bpf_prog_load+0xb00/0x13a0
>     [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>     [c000000000363f0c] sys_bpf+0x2c/0x40
>     [c000000000032434] system_call_exception+0x164/0x330
>     [c00000000000c1e8] system_call_vectored_common+0xe8/0x278
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc/bpf: fix write protecting JIT code
      https://git.kernel.org/powerpc/c/44a8214de96bafb5210e43bfa2c97c19bf75af3d

cheers
