Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17C45698
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 09:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfFNHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 03:43:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35424 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfFNHnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 03:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nXnEEiNY+lMHz0FD6eOUxvG6zddBANH1BMFzA31kGM0=; b=GUalq9RtnbNgX/TS40RS2QM4S
        BlNBeH4Hqf5ia/FIjTbFYMUx6z7obuR4j50Pstq4SQgex1E7iy8dfzSn5TTclW0Z+f7wwLVFFX8md
        zwV+oTiQy3WVoSMh/FxKU2rG2WNJOQmy0HbsuYuDp2n7QDzyr4hMNZQmnKLddTsIlqNSJeaevhy6z
        22eynMpu6lVaYGHKhyCF+tbanCjRRnsn8B3XQ3lOp1KrHT/FgeWlQgWpnwm0FDpxskm6Hm8T0CByK
        RFiq//qqaprlJdcGf6a++oDZSfYkII3YabMEd+UtR/UnAce1e11w181Ld+jV5Zy+kDZTYD5h6rp2/
        YZSVwx6sw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbgrG-0004oc-Qv; Fri, 14 Jun 2019 07:42:47 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4D76A209C9EB8; Fri, 14 Jun 2019 09:42:45 +0200 (CEST)
Date:   Fri, 14 Jun 2019 09:42:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kairui Song <kasong@redhat.com>
Subject: Re: [PATCH 8/9] x86/bpf: Convert asm comments to AT&T syntax
Message-ID: <20190614074245.GS3436@hirez.programming.kicks-ass.net>
References: <cover.1560431531.git.jpoimboe@redhat.com>
 <77fe02f7d575091b06f68f8eed256da94aee653f.1560431531.git.jpoimboe@redhat.com>
 <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8372F56-269A-48A4-B80B-14FA664F8D41@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 13, 2019 at 06:52:24PM +0000, Song Liu wrote:
> > On Jun 13, 2019, at 6:21 AM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> > @@ -403,11 +403,11 @@ static void emit_mov_imm64(u8 **pprog, u32 dst_reg,
> > 		 * For emitting plain u32, where sign bit must not be
> > 		 * propagated LLVM tends to load imm64 over mov32
> > 		 * directly, so save couple of bytes by just doing
> > -		 * 'mov %eax, imm32' instead.
> > +		 * 'mov imm32, %eax' instead.
> > 		 */
> > 		emit_mov_imm32(&prog, false, dst_reg, imm32_lo);
> > 	} else {
> > -		/* movabsq %rax, imm64 */
> > +		/* movabs imm64, %rax */
> 
> 		^^^^^ Should this be moveabsq? 
> 
> > 		EMIT2(add_1mod(0x48, dst_reg), add_1reg(0xB8, dst_reg));
> > 		EMIT(imm32_lo, 4);
> > 		EMIT(imm32_hi, 4);

Song, can you please trim replies; I only found what you said because of
Josh's reply.
