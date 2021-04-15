Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE08361207
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhDOSVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:21:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhDOSVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 14:21:48 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E419760249;
        Thu, 15 Apr 2021 18:21:21 +0000 (UTC)
Date:   Thu, 15 Apr 2021 14:21:20 -0400
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
Message-ID: <20210415142120.7427b4bd@gandalf.local.home>
In-Reply-To: <20210415141831.7b8fbe72@gandalf.local.home>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <YHh6YeOPh0HIlb3e@krava>
        <20210415141831.7b8fbe72@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 14:18:31 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> My last release of that code is here:
> 
>   https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> 
> It allows you to "reserve data" to pass from the caller to the return, and
> that could hold the arguments. See patch 15 of that series.

Note that implementation only lets you save up to 4 words on the stack, but
that can be changed. Or you could have a separate shadow stack for saving
arguments, and only pass the pointer to the location on the other stack
where those arguments are.

-- Steve
