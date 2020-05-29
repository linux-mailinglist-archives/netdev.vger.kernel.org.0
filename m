Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739AA1E81AC
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgE2PVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:21:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:37912 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgE2PVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:21:30 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jegp2-0004Pj-Uv; Fri, 29 May 2020 17:21:25 +0200
Date:   Fri, 29 May 2020 17:21:24 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        andrii.nakryiko@gmail.com, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/5] BPF ring buffer
Message-ID: <20200529152124.GA5264@pc-9.home>
References: <20200529075424.3139988-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529075424.3139988-1-andriin@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25827/Fri May 29 14:37:56 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:54:19AM -0700, Andrii Nakryiko wrote:
> Implement a new BPF ring buffer, as presented at BPF virtual conference ([0]).
> It presents an alternative to perf buffer, following its semantics closely,
> but allowing sharing same instance of ring buffer across multiple CPUs
> efficiently.
> 
> Most patches have extensive commentary explaining various aspects, so I'll
> keep cover letter short. Overall structure of the patch set:
> - patch #1 adds BPF ring buffer implementation to kernel and necessary
>   verifier support;
> - patch #2 adds libbpf consumer implementation for BPF ringbuf;
> - patch #3 adds selftest, both for single BPF ring buf use case, as well as
>   using it with array/hash of maps;
> - patch #4 adds extensive benchmarks and provide some analysis in commit
>   message, it builds upon selftests/bpf's bench runner.
> - patch #5 adds most of patch #1 commit message as a doc under
>   Documentation/bpf/ringbuf.rst.
> 
> Litmus tests, validating consumer/producer protocols and memory orderings,
> were moved out as discussed in [1] and are going to be posted against -rcu
> tree and put under Documentation/litmus-tests/bpf-rb.
> 
>   [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe0fAqcmJY95t_qr0w
>   [1] https://lkml.org/lkml/2020/5/22/1011
> 
> v3->v4:
> - fix ringbuf freeing (vunmap, __free_page); verified with a trivial loop
>   creating and closing ringbuf map endlessly (Daniel);

Applied, thanks!
