Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DE8361648
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 01:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhDOXbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 19:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236421AbhDOXa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 19:30:59 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246E061152;
        Thu, 15 Apr 2021 23:30:34 +0000 (UTC)
Date:   Thu, 15 Apr 2021 19:30:32 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210415193032.34aec994@oasis.local.home>
In-Reply-To: <YHi09yyqVEkZsn7p@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <YHh6YeOPh0HIlb3e@krava>
        <20210415141831.7b8fbe72@gandalf.local.home>
        <20210415142120.7427b4bd@gandalf.local.home>
        <YHi09yyqVEkZsn7p@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 23:49:43 +0200
Jiri Olsa <jolsa@redhat.com> wrote:


> right, I quickly checked on that and it looks exactly like
> the thing we need
> 
> I'll try to rebase that on the current code and try to use
> it with the bpf ftrace probe to see how it fits
> 
> any chance you could plan on reposting it? ;-)

I'm currently working on cleaning up code for the next merge window,
but I did go ahead and rebase it on top of my for-next branch. I didn't
event try to compile it, but at least it's rebased ;-)

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

Branch: ftrace/fgraph-multi

-- Steve
