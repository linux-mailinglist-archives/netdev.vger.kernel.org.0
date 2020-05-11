Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185F31CDA8A
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgEKMzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgEKMzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 08:55:23 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8853F20722;
        Mon, 11 May 2020 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589201722;
        bh=fI1SN20EX/4GtN+QbDDKwe0uGIQ2raxx/8QClojgIe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etOzo4t5b4u6f5ics6j3+lhzkrKUN/2V1AICzngaF8C0uUKuW8Mg5PQfavbLP/Ovc
         sB1hhGd6UUAkEK/1bnpkLITxHhaSbNAe+g5FLXAxJwbL26/zxpkAUIqj2BqmopS1Ia
         y9wb2cFrwTuWkWbxBEuqFfsqITcTFm8x4t6TYtAw=
From:   Will Deacon <will@kernel.org>
To:     Luke Nelson <lukenels@cs.washington.edu>, bpf@vger.kernel.org
Cc:     catalin.marinas@arm.com, Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Andrii Nakryiko <andriin@fb.com>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>,
        Yonghong Song <yhs@fb.com>, clang-built-linux@googlegroups.com,
        Alexios Zavras <alexios.zavras@intel.com>
Subject: Re: [PATCH bpf-next v2 0/3] arm64 BPF JIT Optimizations
Date:   Mon, 11 May 2020 13:55:08 +0100
Message-Id: <158919609995.133008.6274359604607907270.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200508181547.24783-1-luke.r.nels@gmail.com>
References: <20200508181547.24783-1-luke.r.nels@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 11:15:43 -0700, Luke Nelson wrote:
> This patch series introduces several optimizations to the arm64 BPF JIT.
> The optimizations make use of arm64 immediate instructions to avoid
> loading BPF immediates to temporary registers, when possible.
> 
> In the process, we discovered two bugs in the logical immediate encoding
> function in arch/arm64/kernel/insn.c using Serval. The series also fixes
> the two bugs before introducing the optimizations.
> 
> [...]

Applied to arm64 (for-next/bpf), thanks!

[1/3] arm64: insn: Fix two bugs in encoding 32-bit logical immediates
      https://git.kernel.org/arm64/c/579d1b3faa37
[2/3] bpf, arm64: Optimize AND,OR,XOR,JSET BPF_K using arm64 logical immediates
      https://git.kernel.org/arm64/c/fd49591cb49b
[3/3] bpf, arm64: Optimize ADD,SUB,JMP BPF_K using arm64 add/sub immediates
      https://git.kernel.org/arm64/c/fd868f148189

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
