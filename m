Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD5626F3B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729886AbfEVTzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:55:33 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41857 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730197AbfEVTzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 15:55:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id q17so1869182pfq.8;
        Wed, 22 May 2019 12:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dkz+uMfQ4vVtX4Z57u9xC58rrVWkexD1pHBhDv3CnWw=;
        b=HvudDPF+KevQPPLS50w5VVfYbTyT/HSSccgs7KNEDiQlGjjGVza2G1drC4CnVs+CcJ
         K2WQk3HlAiAiK7afohlFEfA7AmqIsaVgAEOb/bSfWVKDDnXCAaJzofoV15AGCWxN6UbC
         wU60jUxa/ajyydKuvPWfILaGtLw7J25wuxlFfSpdELB0YHwA3v/NCE6BQsOVBzc2dky/
         Aeb8EvG8EnI6Xwzx3V+dvOodQz1+jxAKvxPsaJwBrq5xzUX1ENgbt42IC3NE2T1OBVYp
         u9AgscgfhH2vNiCQCKMtlrbj4WMghTu8RuMmZV2v5rvP4fGyM+PdThKoOAA9ad+orqQM
         0pGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dkz+uMfQ4vVtX4Z57u9xC58rrVWkexD1pHBhDv3CnWw=;
        b=pCf3Wd6KgnBpoNYz8d6JYt2ZboL1hqmdiVufxpIfck1cjSrGxIiluuDlXb+u6ut7/s
         9kh2BQqCqHu88DpRoxK25uJQ9yp3Kbta1UJAjmJMxcrv3Gtiq4NLeTjBbb0rwvG2PkWY
         3TRgLPDk77i7OWvqCLaGuxoWLP1MrigWvHLgJRe7Xxgv/fYk8YuL+H/Ig/jwzI73o0La
         84VJHKxnT7tmcfmjHw4OxnFwVg+AsGQyTC6vddb4G0zqSbAmmi7Il5HRfclmGcPciAkQ
         ekkvpIzF8ybyjSogFu2lXoCPDWHgiPXilkiebQnJZP6SpI177y6R09+0cOEGSZ6g+hNY
         q9Ng==
X-Gm-Message-State: APjAAAUM2halQ+f2U0DdRgYQjfpxf5gC1j74b70NiJ7lgggdPYBnMn3s
        EflODPgW0Y56bMUSzST5i0oMzSbH
X-Google-Smtp-Source: APXvYqzuFNwwqWce3oARO3MYbQ8QDsnhxBa3bPsJce9d8mfJhpoeRGDAkM1CNEoTvjLbDrHsL1Pbjw==
X-Received: by 2002:a63:7413:: with SMTP id p19mr89950878pgc.259.1558554930988;
        Wed, 22 May 2019 12:55:30 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6565])
        by smtp.gmail.com with ESMTPSA id x18sm32697904pfj.17.2019.05.22.12.55.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 12:55:30 -0700 (PDT)
Date:   Wed, 22 May 2019 12:55:27 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190522195526.mayamzc7gstqzcpr@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190522142531.GE16275@worktop.programming.kicks-ass.net>
 <20190522182215.GO2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522182215.GO2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 02:22:15PM -0400, Kris Van Hees wrote:
> On Wed, May 22, 2019 at 04:25:32PM +0200, Peter Zijlstra wrote:
> > On Tue, May 21, 2019 at 10:56:18AM -0700, Alexei Starovoitov wrote:
> > 
> > > and no changes are necessary in kernel/events/ring_buffer.c either.
> > 
> > Let me just NAK them on the principle that I don't see them in my inbox.
> 
> My apologies for failing to include you on the Cc for the patches.  That was
> an oversight on my end and certainly not intentional.
> 
> > Let me further NAK it for adding all sorts of garbage to the code --
> > we're not going to do gaps and stay_in_page nonsense.
> 
> Could you give some guidance in terms of an alternative?  The ring buffer code
> provides both non-contiguous page allocation support and a vmalloc-based
> allocation, and the vmalloc version certainly would avoid the entire gap and
> page boundary stuff.  But since the allocator is chosen at build time based on
> the arch capabilities, there is no way to select a specific memory allocator.
> I'd be happy to use an alternative approach that allows direct writing into
> the ring buffer.

You do not _need_ direct write from bpf prog.
dtrace language doesn't mandate direct write.
'direct write into ring buffer form bpf prog' is an interesting idea and
may be nice performance optimization, but in no way it's a blocker for dtrace scripts.
Also it's far from clear that it actually brings performance benefits.
Letting bpf progs write directly into ring buffer comes with
a lot of corner cases. It's something to carefully analyze.
I suggest to proceed with user space dtrace conversion to bpf
without introducing kernel changes.

