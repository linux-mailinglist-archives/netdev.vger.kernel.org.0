Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12933145C1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBIBmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhBIBlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:41:02 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF67C061788;
        Mon,  8 Feb 2021 17:40:21 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id l18so702658pji.3;
        Mon, 08 Feb 2021 17:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rGns9Si4hklyYlr4xa8f+5lVK+CURy/S5nAUBEm39b0=;
        b=czAuHghGLiyHJO6GvCnpR2Nfl8PlNE1LIvk/heLXFi0hCJkeSOj+yiJmSfT2zcaSyH
         LCN9o/ztaIyvg5TroK/Lq62XLkY8MZvRb93KK/4H2/Gi9DYXIqfKKdgipFYMwi9/hQQN
         jIYLCnkoZbk+m9y925041GQZj2UJjByK7qnwHdkhQe2YgUMoHBX1Pwlk+F2l8Kbi4fxV
         qk95s4OZdQxuFZAKutDIrQqsoNWVMwg4amPv4Q84RtGMBt1iIdRynVkyry9sZBQGNdgp
         Rb9exFYd6B8MnZjLpX1aFdU9sJlC1UvtR6V2BSBGCmE+UH6rDqffLeAQQxx6HWuCz3G0
         kFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rGns9Si4hklyYlr4xa8f+5lVK+CURy/S5nAUBEm39b0=;
        b=twr9B38HxQDmihh3O78vhDMCwJcWJPcX45ReKsNyScgdRVtIGyfN6qnJjCYNfICqiR
         IpOkKXznuwpyRqBO8MVHCyxYOmI+wyIIoDFnYJUG4J8c/aVUcrN+JyPaF7iT9R9e4anC
         ZyxTgID9IEk4U67CraP/ZVCRutjQ3otK+OcDdmFlWYktZEBztOdse5lv1if9vblpR8pz
         4TyL79KHxE6+v7PDlSjbd11fYLuViz27UWTa3aXzhIYolRJtwsjRvgmnQND1TD6yQoHd
         uDETQtZvTq++4kRcfDY3htOR/tdOXlaCHm85yqgal9pzeqysjbxa4dtJ0t4/AUDVwZh0
         CQMw==
X-Gm-Message-State: AOAM531GhHoL/G5/8Uv2AN9oTASga83dkcYtBYLL4w4nLNymBmDYQzuX
        pt/oAYwnlx/lBoLV8TrqUjJnsadDhQFm16Nnk+o=
X-Google-Smtp-Source: ABdhPJwgc+HfKjDRfpse67GJBMHHYKgRHUCN4SdBzwu6uUSFAcl8khk0Offdjt/1D02F/sR1CQqVZrWPEH0ygMOY2qA=
X-Received: by 2002:a17:90a:5287:: with SMTP id w7mr1683222pjh.52.1612834821220;
 Mon, 08 Feb 2021 17:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-2-xiyou.wangcong@gmail.com> <87im764xez.fsf@cloudflare.com>
In-Reply-To: <87im764xez.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 17:40:10 -0800
Message-ID: <CAM_iQpWJifJ0QGJ4F_B67KkuGTOwtzsLJYfMfqz48ZSmm1n9ZQ@mail.gmail.com>
Subject: Re: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to BPF_SOCK_MAP
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:32 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Feb 03, 2021 at 05:16 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Before we add non-TCP support, it is necessary to rename
> > BPF_STREAM_PARSER as it will be no longer specific to TCP,
> > and it does not have to be a parser either.
> >
> > This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
> > that sock_map.c hopefully would be protocol-independent.
> >
> > Also, improve its Kconfig description to avoid confusion.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  include/linux/bpf.h       |  4 ++--
> >  include/linux/bpf_types.h |  2 +-
> >  include/net/tcp.h         |  4 ++--
> >  include/net/udp.h         |  4 ++--
> >  net/Kconfig               | 13 ++++++-------
> >  net/core/Makefile         |  2 +-
> >  net/ipv4/Makefile         |  2 +-
> >  net/ipv4/tcp_bpf.c        |  4 ++--
> >  8 files changed, 17 insertions(+), 18 deletions(-)
>
> We also have a couple of references to CONFIG_BPF_STREAM_PARSER in
> tools/tests:
>
> $ git grep -i bpf_stream_parser
> ...
> tools/bpf/bpftool/feature.c:            { "CONFIG_BPF_STREAM_PARSER", },
> tools/testing/selftests/bpf/config:CONFIG_BPF_STREAM_PARSER=y

I think I did a grep in the whole tree, but still missed these two.

Thanks for catching it!
