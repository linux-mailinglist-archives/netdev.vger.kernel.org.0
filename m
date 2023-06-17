Return-Path: <netdev+bounces-11687-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36671733ECB
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E658E28190B
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78B4B4C8A;
	Sat, 17 Jun 2023 06:45:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2912633FD;
	Sat, 17 Jun 2023 06:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC914C433C8;
	Sat, 17 Jun 2023 06:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984307;
	bh=Uw5cw1TPn0rntsQJRbeXZU+V2i3I8bpFiME/qcflP08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0C/04zwp8Svpx/hprFTuDwIwHJCnHpNRmn2tDdvfcmYt4wp3n7OAxHp5Py33C+kd
	 4kMHu8FACuUr1jN3jGFObWQ4Pw9NFQKQAIyO/G6pFYoVPUe76lGyVXZO3TQemSokHm
	 VXxdoS02gSAauNcMun3iVu1Zubv2t9PebDcIDYD6cqQx8/HkOPh4X4/5bVg3dgu6dB
	 sBHr55LVzNEboL0DRdq7gLRwtJOv/T3RNn91O3Tsgsn70wRNMkVoUNRgpMFOdo78UU
	 n4UYOHCQfFtBs9Glr8+Avi1tBIrn2kszVYZ167A35xKrcwfLNkZs7DpMC2d48GQpfN
	 ByDutHlpcGnYg==
Date: Sat, 17 Jun 2023 09:44:21 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>,
	"deller@gmx.de" <deller@gmx.de>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"puranjay12@gmail.com" <puranjay12@gmail.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"will@kernel.org" <will@kernel.org>,
	"dinguyen@kernel.org" <dinguyen@kernel.org>,
	"naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
	"sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"song@kernel.org" <song@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 06/12] mm/execmem: introduce execmem_data_alloc()
Message-ID: <20230617064421.GQ52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-7-rppt@kernel.org>
 <90a64b6f040491da16af0694172a6cbdaba33669.camel@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90a64b6f040491da16af0694172a6cbdaba33669.camel@intel.com>

On Fri, Jun 16, 2023 at 04:55:53PM +0000, Edgecombe, Rick P wrote:
> On Fri, 2023-06-16 at 11:50 +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> > 
> > Data related to code allocations, such as module data section, need
> > to
> > comply with architecture constraints for its placement and its
> > allocation right now was done using execmem_text_alloc().
> > 
> > Create a dedicated API for allocating data related to code
> > allocations
> > and allow architectures to define address ranges for data
> > allocations.
> 
> Right now the cross-arch way to specify kernel memory permissions is
> encoded in the function names of all the set_memory_foo()'s. You can't
> just have unified prot names because some arch's have NX and some have
> X bits, etc. CPA wouldn't know if it needs to set or unset a bit if you
> pass in a PROT.

The idea is that allocator never uses CPA. It allocates with the
permissions defined by architecture at the first place and then the callers
might use CPA to change them. Ideally, that shouldn't be needed for
anything but ro_after_init, but we are far from there.

> But then you end up with a new function for *each* combination (i.e.
> set_memory_rox()). I wish CPA has flags like mmap() does, and I wonder
> if it makes sense here instead of execmem_data_alloc().

I don't think execmem should handle all the combinations. The code is
always allocated as ROX for architectures that support text poking and as
RWX for those that don't.

Maybe execmem_data_alloc() will need to able to handle RW and RO data
differently at some point, but that's the only variant I can think of, but
even then I don't expect CPA will be used by execmem. 

We also might move resetting the permissions to default from vmalloc to
execmem, but again, we are far from there.
 
> Maybe that is an overhaul for another day though...

CPA surely needs some love :)

-- 
Sincerely yours,
Mike.

