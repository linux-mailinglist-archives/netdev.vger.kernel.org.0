Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDDB24CE15
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgHUGf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgHUGf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:35:57 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458BFC061385;
        Thu, 20 Aug 2020 23:35:57 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id e14so500840ybf.4;
        Thu, 20 Aug 2020 23:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zb/l7Ivui0Ry+MtDsS7eRNq9g7/oNBQvWGTCgvlWAWU=;
        b=X9sgeB6pZeq6cQ7FHcQUmghZeZz+iUBAdkYkzrYjc6RhBxT4KUFvqvDZfZvHigRIxl
         ONdEV+e5D5usc2JXwLCaEztZ96mrKkLrewgaexj4Oz3dwyFGlZz2nVRh24sQr5Zqp8O7
         LZyMOy7ZyQHJyrjo0ckapoHPb409hSvUHP1zML8B95MQjA8e4azZ+gA1jQnNDINtvGqK
         bj/YUeiVE5oBcpem/wu7eZeWYHj6XCwrOCGlSE7YzL2QQEvGfUpe9c1lxHZkCmv7/Q1O
         a5qZ6x65uzBh4PNEiIcDPrNUz4AVCV+KxmDyGVE8U4DAZnaN8J4OFGNey/YZavB1kRZb
         BiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zb/l7Ivui0Ry+MtDsS7eRNq9g7/oNBQvWGTCgvlWAWU=;
        b=EnOGkJlIl8NSRCMaOJsAEZo+j0+xUMD/uLubygLBCIIgc89cCIqIq+TVQ2lcYiJxSz
         2LQwzQnppQerzaYN3t77MlRNt9qz0bp/36WrAbz2u/3Ekc4pJd5ZiNRfxxBCC91icphC
         vhyjRqYUkFdJ9Gghnhhe5KvDuxezSkzwC04f/B537z805YMKZaPST13IVa9Sl7fvEqB4
         K3L0b1MOEIDAhWSejaC0CZvMucvD0b/vDG3yelBYc6N4qto/tNtgM3INwhcnp2zd8we2
         1+ZHfFD6lnQ1FCQjD5nMx+BJruSkpJDK+GvLkLS+e0iGKnesP+GDBSVRh3yIGVETm7oW
         hJPQ==
X-Gm-Message-State: AOAM5317L5Qso2oN3pWwCIH6gxZXKwlVYWM+P99pHZ7yfZf8WHcX9eUp
        Vcau13EPCEmRJuVgIJjWVZbWMmVk9vwsR2M0GUugpR+WAdo=
X-Google-Smtp-Source: ABdhPJxc1dBp/cEkdoDIv7NkVjk2kDsH+qyKTURmmFA9MgoIzAuTRFgupyF7KOFmD+dakIuCzQA2Td5U941iG5M8RRg=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr1762256ybm.425.1597991754830;
 Thu, 20 Aug 2020 23:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200820224917.483062-1-yhs@fb.com> <20200820224919.483478-1-yhs@fb.com>
In-Reply-To: <20200820224919.483478-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Aug 2020 23:35:44 -0700
Message-ID: <CAEf4BzYtATdmP7GCQahu6SiYRv+oxAxPm42icTbpDoAHFo8z=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpftool: implement link_query for bpf iterators
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 3:50 PM Yonghong Song <yhs@fb.com> wrote:
>
> The link query for bpf iterators is implemented.
> Besides being shown to the user what bpf iterator
> the link represents, the target_name is also used
> to filter out what additional information should be
> printed out, e.g., whether map_id should be shown or not.
> The following is an example of bpf_iter link dump,
> plain output or pretty output.
>
>   $ bpftool link show
>   11: iter  prog 59  target_name task
>           pids test_progs(1749)
>   34: iter  prog 173  target_name bpf_map_elem  map_id 127
>           pids test_progs_1(1753)
>   $ bpftool -p link show
>   [{
>           "id": 11,
>           "type": "iter",
>           "prog_id": 59,
>           "target_name": "task",
>           "pids": [{
>                   "pid": 1749,
>                   "comm": "test_progs"
>               }
>           ]
>       },{
>           "id": 34,
>           "type": "iter",
>           "prog_id": 173,
>           "target_name": "bpf_map_elem",
>           "map_id": 127,
>           "pids": [{
>                   "pid": 1753,
>                   "comm": "test_progs_1"
>               }
>           ]
>       }
>   ]
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/link.c | 44 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 3 deletions(-)
>

[...]
