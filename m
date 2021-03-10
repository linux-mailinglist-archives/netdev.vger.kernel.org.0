Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21637334158
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhCJPTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:19:12 -0500
Received: from elvis.franken.de ([193.175.24.41]:42337 "EHLO elvis.franken.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhCJPS6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 10:18:58 -0500
Received: from uucp (helo=alpha)
        by elvis.franken.de with local-bsmtp (Exim 3.36 #1)
        id 1lK0bw-00088y-03; Wed, 10 Mar 2021 16:18:56 +0100
Received: by alpha.franken.de (Postfix, from userid 1000)
        id 948BDC1D54; Wed, 10 Mar 2021 16:08:16 +0100 (CET)
Date:   Wed, 10 Mar 2021 16:08:16 +0100
From:   Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH 2/2] MIPS: Remove KVM_TE support
Message-ID: <20210310150816.GD12960@alpha.franken.de>
References: <20210301152958.3480-1-tsbogend@alpha.franken.de>
 <20210301152958.3480-2-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301152958.3480-2-tsbogend@alpha.franken.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 01, 2021 at 04:29:57PM +0100, Thomas Bogendoerfer wrote:
> After removal of the guest part of KVM TE (trap and emulate), also remove
> the host part.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  arch/mips/configs/loongson3_defconfig |    1 -
>  arch/mips/include/asm/kvm_host.h      |  238 ----
>  arch/mips/kvm/Kconfig                 |   34 -
>  arch/mips/kvm/Makefile                |    7 +-
>  arch/mips/kvm/commpage.c              |   32 -
>  arch/mips/kvm/commpage.h              |   24 -
>  arch/mips/kvm/dyntrans.c              |  143 ---
>  arch/mips/kvm/emulate.c               | 1688 +------------------------
>  arch/mips/kvm/entry.c                 |   33 -
>  arch/mips/kvm/interrupt.c             |  123 +-
>  arch/mips/kvm/interrupt.h             |   20 -
>  arch/mips/kvm/mips.c                  |   68 +-
>  arch/mips/kvm/mmu.c                   |  405 ------
>  arch/mips/kvm/tlb.c                   |  174 ---
>  arch/mips/kvm/trap_emul.c             | 1306 -------------------
>  arch/mips/kvm/vz.c                    |    5 +-
>  16 files changed, 31 insertions(+), 4270 deletions(-)
>  delete mode 100644 arch/mips/kvm/commpage.c
>  delete mode 100644 arch/mips/kvm/commpage.h
>  delete mode 100644 arch/mips/kvm/dyntrans.c
>  delete mode 100644 arch/mips/kvm/trap_emul.c

applied to mips-next.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
