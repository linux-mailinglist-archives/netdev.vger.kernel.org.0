Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA0B29F650
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgJ2UjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:39:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:53445 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbgJ2UiB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 16:38:01 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 09TKVFK3008610;
        Thu, 29 Oct 2020 15:31:15 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 09TKVDiY008609;
        Thu, 29 Oct 2020 15:31:13 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Thu, 29 Oct 2020 15:31:13 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <bpf@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>,
        linux-toolchains@vger.kernel.org
Subject: Re: [PATCH v2 1/2] bpf: don't rely on GCC __attribute__((optimize)) to disable GCSE
Message-ID: <20201029203113.GJ2672@gate.crashing.org>
References: <20201028171506.15682-1-ardb@kernel.org> <20201028171506.15682-2-ardb@kernel.org> <20201028213903.fvdjydadqt6tx765@ast-mbp.dhcp.thefacebook.com> <CAMj1kXFHcM-Jb+MwsLtB4NMUmMyAGGLeNGNLC9vTATot3NJLrA@mail.gmail.com> <20201028225919.6ydy3m2u4p7x3to7@ast-mbp.dhcp.thefacebook.com> <CAMj1kXG8PmvO6bLhGXPWtzKMnAsip2WDa-qdrd+kFfr30sd8-A@mail.gmail.com> <20201028232001.pp7erdwft7oyt2xm@ast-mbp.dhcp.thefacebook.com> <20201029025745.GA2386070@rani.riverdale.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029025745.GA2386070@rani.riverdale.lan>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 10:57:45PM -0400, Arvind Sankar wrote:
> On Wed, Oct 28, 2020 at 04:20:01PM -0700, Alexei Starovoitov wrote:
> > All compilers have bugs. Kernel has bugs. What can go wrong?

Heh.

> +linux-toolchains. GCC updated the documentation in 7.x to discourage
> people from using the optimize attribute.
> 
> https://gcc.gnu.org/git/?p=gcc.git;a=commitdiff;h=893100c3fa9b3049ce84dcc0c1a839ddc7a21387

https://patchwork.ozlabs.org/project/gcc/patch/20151213081911.GA320@x4/
has all the discussion around that GCC patch.


Segher
