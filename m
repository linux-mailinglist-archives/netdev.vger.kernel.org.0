Return-Path: <netdev+bounces-12046-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54CF8735CC9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44AA81C20BB1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7C013AF6;
	Mon, 19 Jun 2023 17:09:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930812B90;
	Mon, 19 Jun 2023 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E17C433C8;
	Mon, 19 Jun 2023 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687194567;
	bh=JAKwTrp1uinVAtoLWlXEGNS+fEBZEu6il2wWrUqzEzo=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
	b=YEOROC7YGunxOkL9NsbJwROPW3V877k09rIaiwwEQBd6bVLJWdMjusQxoVnbsuD5D
	 SKibXVd7FHc2nMr1tudbdYIZvJGYXAOuK4akurudUoPTNxoZjnK21I5AdFijJrVbol
	 wMmYZdLv8Hw2umDYdeUGRbNj+IGHaRZ0DomN5ubTCsJ6NBLT+yY4qE1y7ajOHRP1RW
	 KGFKHX9UnHaE0jcV0Lk398WnGNpxO+L8j061yUD+7F16bO6b13PKK3oASVquk5plTv
	 fi30eJK4gcno8KPn/VoCZ0cPaw9JHH45FBctirdWyvzfVojpY1MuX3tVhu6B84K6vz
	 1DQlrW9fvYTQw==
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailauth.nyi.internal (Postfix) with ESMTP id BDC6027C0054;
	Mon, 19 Jun 2023 13:09:24 -0400 (EDT)
Received: from imap48 ([10.202.2.98])
  by compute3.internal (MEProxy); Mon, 19 Jun 2023 13:09:24 -0400
X-ME-Sender: <xms:wouQZL1KKgLu09W-gITBMTpyAXyCop721KHeRNSzShP91di0wPWHmw>
    <xme:wouQZKG8Wf_3R-mPlBMuIdAgUtqSh1IoF1oSxFnk9i4TgZk6ENhss3V_yoaRPv-RL
    TAuvGDsGQbdSiWuWsY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeefvddguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    nhguhicunfhuthhomhhirhhskhhifdcuoehluhhtoheskhgvrhhnvghlrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpedvhfeuvddthfdufffhkeekffetgffhledtleegffetheeugeej
    ffduhefgteeihfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegrnhguhidomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudduiedu
    keehieefvddqvdeifeduieeitdekqdhluhhtoheppehkvghrnhgvlhdrohhrgheslhhinh
    hugidrlhhuthhordhush
X-ME-Proxy: <xmx:wouQZL5OetLa4Clx3-k8PoL2vfJibp2bgnqmJ2SvMc_usNTskAjOCQ>
    <xmx:wouQZA2n3SB0X1LUMOotkjWhlqzrq7LHl-_hgrAS7-wGIbb0zOE8Fw>
    <xmx:wouQZOGStaRHYVBRbGjqqlxYN_stg3xW85Vh8QJme5E9zOhMY7GQOQ>
    <xmx:xIuQZOK5iPdRAlFtT5-Mu5Cjdtszefp8KfJWF6OppfL2ayIjz9WFYA>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 5BFB531A0063; Mon, 19 Jun 2023 13:09:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-496-g8c46984af0-fm-20230615.001-g8c46984a
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <a17c65c6-863f-4026-9c6f-a04b659e9ab4@app.fastmail.com>
In-Reply-To: <20230618080027.GA52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-3-rppt@kernel.org>
 <f9a7eebe-d36e-4587-b99d-35d4edefdd14@app.fastmail.com>
 <20230618080027.GA52412@kernel.org>
Date: Mon, 19 Jun 2023 10:09:02 -0700
From: "Andy Lutomirski" <luto@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Kees Cook" <keescook@chromium.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "David S. Miller" <davem@davemloft.net>,
 "Dinh Nguyen" <dinguyen@kernel.org>,
 "Heiko Carstens" <hca@linux.ibm.com>, "Helge Deller" <deller@gmx.de>,
 "Huacai Chen" <chenhuacai@kernel.org>,
 "Kent Overstreet" <kent.overstreet@linux.dev>,
 "Luis Chamberlain" <mcgrof@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nadav Amit" <nadav.amit@gmail.com>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>,
 "Puranjay Mohan" <puranjay12@gmail.com>,
 "Rick P Edgecombe" <rick.p.edgecombe@intel.com>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>,
 "Song Liu" <song@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
 "Thomas Gleixner" <tglx@linutronix.de>, "Will Deacon" <will@kernel.org>,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org,
 linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 loongarch@lists.linux.dev, netdev@vger.kernel.org,
 sparclinux@vger.kernel.org, "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: [PATCH v2 02/12] mm: introduce execmem_text_alloc() and jit_text_alloc()
Content-Type: text/plain



On Sun, Jun 18, 2023, at 1:00 AM, Mike Rapoport wrote:
> On Sat, Jun 17, 2023 at 01:38:29PM -0700, Andy Lutomirski wrote:
>> On Fri, Jun 16, 2023, at 1:50 AM, Mike Rapoport wrote:
>> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>> >
>> > module_alloc() is used everywhere as a mean to allocate memory for code.
>> >
>> > Beside being semantically wrong, this unnecessarily ties all subsystems
>> > that need to allocate code, such as ftrace, kprobes and BPF to modules
>> > and puts the burden of code allocation to the modules code.
>> >
>> > Several architectures override module_alloc() because of various
>> > constraints where the executable memory can be located and this causes
>> > additional obstacles for improvements of code allocation.
>> >
>> > Start splitting code allocation from modules by introducing
>> > execmem_text_alloc(), execmem_free(), jit_text_alloc(), jit_free() APIs.
>> >
>> > Initially, execmem_text_alloc() and jit_text_alloc() are wrappers for
>> > module_alloc() and execmem_free() and jit_free() are replacements of
>> > module_memfree() to allow updating all call sites to use the new APIs.
>> >
>> > The intention semantics for new allocation APIs:
>> >
>> > * execmem_text_alloc() should be used to allocate memory that must reside
>> >   close to the kernel image, like loadable kernel modules and generated
>> >   code that is restricted by relative addressing.
>> >
>> > * jit_text_alloc() should be used to allocate memory for generated code
>> >   when there are no restrictions for the code placement. For
>> >   architectures that require that any code is within certain distance
>> >   from the kernel image, jit_text_alloc() will be essentially aliased to
>> >   execmem_text_alloc().
>> >
>> 
>> Is there anything in this series to help users do the appropriate
>> synchronization when the actually populate the allocated memory with
>> code?  See here, for example:
>
> This series only factors out the executable allocations from modules and
> puts them in a central place.
> Anything else would go on top after this lands.

Hmm.

On the one hand, there's nothing wrong with factoring out common code. On the other hand, this is probably the right time to at least start thinking about synchronization, at least to the extent that it might make us want to change this API.  (I'm not at all saying that this series should require changes -- I'm just saying that this is a good time to think about how this should work.)

The current APIs, *and* the proposed jit_text_alloc() API, don't actually look like the one think in the Linux ecosystem that actually intelligently and efficiently maps new text into an address space: mmap().

On x86, you can mmap() an existing file full of executable code PROT_EXEC and jump to it with minimal synchronization (just the standard implicit ordering in the kernel that populates the pages before setting up the PTEs and whatever user synchronization is needed to avoid jumping into the mapping before mmap() finishes).  It works across CPUs, and the only possible way userspace can screw it up (for a read-only mapping of read-only text, anyway) is to jump to the mapping too early, in which case userspace gets a page fault.  Incoherence is impossible, and no one needs to "serialize" (in the SDM sense).

I think the same sequence (from userspace's perspective) works on other architectures, too, although I think more cache management is needed on the kernel's end.  As far as I know, no Linux SMP architecture needs an IPI to map executable text into usermode, but I could easily be wrong.  (IIRC RISC-V has very developer-unfriendly icache management, but I don't remember the details.)

Of course, using ptrace or any other FOLL_FORCE to modify text on x86 is rather fraught, and I bet many things do it wrong when userspace is multithreaded.  But not in production because it's mostly not used in production.)

But jit_text_alloc() can't do this, because the order of operations doesn't match.  With jit_text_alloc(), the executable mapping shows up before the text is populated, so there is no atomic change from not-there to populated-and-executable.  Which means that there is an opportunity for CPUs, speculatively or otherwise, to start filling various caches with intermediate states of the text, which means that various architectures (even x86!) may need serialization.

For eBPF- and module- like use cases, where JITting/code gen is quite coarse-grained, perhaps something vaguely like:

jit_text_alloc() -> returns a handle and an executable virtual address, but does *not* map it there
jit_text_write() -> write to that handle
jit_text_map() -> map it and synchronize if needed (no sync needed on x86, I think)

could be more efficient and/or safer.

(Modules could use this too.  Getting alternatives right might take some fiddling, because off the top of my head, this doesn't match how it works now.)

To make alternatives easier, this could work, maybe (haven't fully thought it through):

jit_text_alloc()
jit_text_map_rw_inplace() -> map at the target address, but RW, !X

write the text and apply alternatives

jit_text_finalize() -> change from RW to RX *and synchronize*

jit_text_finalize() would either need to wait for RCU (possibly extra heavy weight RCU to get "serialization") or send an IPI.

This is slower than the alloc, write, map solution, but allows alternatives to be applied at the final address.


Even fancier variants where the writing is some using something like use_temporary_mm() might even make sense.


To what extent does performance matter for the various users?  module loading is slow, and I don't think we care that much.  eBPF loaded is not super fast, and we care to a limited extent.  I *think* the bcachefs use case needs to be very fast, but I'm not sure it can be fast and supportable.

Anyway, food for thought.


