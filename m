Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAFA393F27
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhE1JGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 05:06:01 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:45183 "EHLO
        outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236272AbhE1JF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:05:59 -0400
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp02.blacknight.com (Postfix) with ESMTPS id 0F233BAADB
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 10:04:23 +0100 (IST)
Received: (qmail 29895 invoked from network); 28 May 2021 09:04:22 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 28 May 2021 09:04:22 -0000
Date:   Fri, 28 May 2021 10:04:21 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Andrii Nakryiko' <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <20210528090421.GK30378@techsingularity.net>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org>
 <20210527090422.GA30378@techsingularity.net>
 <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
 <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 08:09:39AM +0000, David Laight wrote:
> From: Andrii Nakryiko
> > Sent: 27 May 2021 15:42
> ...
> > I agree that empty structs are useful, but here we are talking about
> > per-CPU variables only, which is the first use case so far, as far as
> > I can see. If we had pahole 1.22 released and widely packaged it could
> > have been a viable option to force it on everyone. 
> ...
> 
> Would it be feasible to put the sources for pahole into the
> kernel repository and build it at the same time as objtool?
> 

We don't store other build dependencies like compilers, binutils etc in
the kernel repository even though minimum versions are mandated.
Obviously tools/ exists but for the most part, they are tools that do
not exist in other repositories and are kernel-specific. I don't know if
pahole would be accepted and it introduces the possibility that upstream
pahole and the kernel fork of it would diverge.

-- 
Mel Gorman
SUSE Labs
