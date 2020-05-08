Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9C11CB88C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgEHTpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbgEHTpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:45:03 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CF0C061A0C;
        Fri,  8 May 2020 12:45:02 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id i68so2394347qtb.5;
        Fri, 08 May 2020 12:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CLoXogYT6eDReWHnMq2ZAz0NW+OJb5gmwN5c8u8bjlo=;
        b=Mqn6wjVSwQhFoMTaELZUxbJDIV+79EZdfBbf/P7qKNojaOcqB3dfOkLCa5K3Oa6xaL
         +k8/JNPZ8U7FidvCuC5kq9uYKJQwzFY2lwqxeX1oaLT38X4X/oGRHkwK2PTueKcj2Tv3
         v5CW9tP7EM1Ru2rvTNVdl0phRzhC8HxEqkl/VQhlozfdZohvCnL1Skg02uCuevkhmDAY
         SJHLOm0B762uJwGdHvjkBqYGmiM+fcveRXtx9F9tlFywNyyJ6F3ceXmRaTTaS4wRQw9X
         W11QXmWAkobOR+syCLCOvK05bbJrEKNh+CzxyW/YqdRzbLBMtOvvbxB680KpgS32/hHX
         kDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CLoXogYT6eDReWHnMq2ZAz0NW+OJb5gmwN5c8u8bjlo=;
        b=bTRFw0xURSnwj7PVG4P5xUI3ZiBB+/WyloTDFMC3e0/LROQ6OPQe3SgQ1HcZFcVfjn
         1mPpRad2os45CmJ4gWnylAF5BMaxHym5apwuZfRsNLVJeCrdl3c6dpU+JmPsQJ04vKLZ
         eCb10vT0wLW1OF/RBo4txw9CwwuLAdHoIlrQlUOCXrIs1NAomDKSBL42e5rQG+SfbEDI
         XY46Kt76B3IUNULNDXxBdmYSukcNgS3ZugyufCXiU61tknVCqS31cNvC2wM3ZRzjE7KX
         ifyQQD3RHN1PcI+Z30gitIDavtHQ+BK+u/5zVEaBaxTKt8spXL1Da7Sf+At7RlWg/RSm
         144Q==
X-Gm-Message-State: AGi0PubpJVhl6/6Gkoc1WbDyhK7B6u6GB6Ma3aR0PHlhAcs8a0tXr2tQ
        3xs2HFGv+4xEXuHPLvLzlyoN975rGn67HT3ofUg2jbzN
X-Google-Smtp-Source: APiQypJr7EUUdpNMEDoWsG8jekWypEMvZE+sGncyfrPieqy1gSsAw6kxJY/Zi0KakLpUl08io0FluZl5DYjUY3NuVSQ=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr4449862qtj.93.1588967102041;
 Fri, 08 May 2020 12:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053930.1544090-1-yhs@fb.com>
In-Reply-To: <20200507053930.1544090-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:44:50 -0700
Message-ID: <CAEf4BzabLpaMvJtTNtb88xJZzdjwwvcnfqSH=hq3bMiEt-gtmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 13/21] bpf: add bpf_seq_printf and
 bpf_seq_write helpers
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two helpers bpf_seq_printf and bpf_seq_write, are added for
> writing data to the seq_file buffer.
>
> bpf_seq_printf supports common format string flag/width/type
> fields so at least I can get identical results for
> netlink and ipv6_route targets.
>
> For bpf_seq_printf and bpf_seq_write, return value -EOVERFLOW
> specifically indicates a write failure due to overflow, which
> means the object will be repeated in the next bpf invocation
> if object collection stays the same. Note that if the object
> collection is changed, depending how collection traversal is
> done, even if the object still in the collection, it may not
> be visited.
>
> bpf_seq_printf may return -EBUSY meaning that internal percpu
> buffer for memory copy of strings or other pointees is
> not available. Bpf program can return 1 to indicate it
> wants the same object to be repeated. Right now, this should not
> happen on no-RT kernels since migrate_disable(), which guards
> bpf prog call, calls preempt_disable().
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/uapi/linux/bpf.h       |  32 +++++-
>  kernel/trace/bpf_trace.c       | 200 +++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |   2 +
>  tools/include/uapi/linux/bpf.h |  32 +++++-
>  4 files changed, 264 insertions(+), 2 deletions(-)
>

Was a bit surprised by behavior on failed memory read, I think it's
important to emphasize and document this. But otherwise:

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

> +               if (fmt[i] == 's') {
> +                       /* try our best to copy */
> +                       if (memcpy_cnt >= MAX_SEQ_PRINTF_MAX_MEMCPY) {
> +                               err = -E2BIG;
> +                               goto out;
> +                       }
> +
> +                       bufs->buf[memcpy_cnt][0] = 0;
> +                       strncpy_from_unsafe(bufs->buf[memcpy_cnt],
> +                                           (void *) (long) args[fmt_cnt],
> +                                           MAX_SEQ_PRINTF_STR_LEN);

So the behavior is that we try to read string, but if it fails, we
treat it as empty string? That needs to be documented, IMHO. My
expectation was that entire printf would fail.

Same for pointers below, right?

> +                       params[fmt_cnt] = (u64)(long)bufs->buf[memcpy_cnt];
> +
> +                       fmt_cnt++;
> +                       memcpy_cnt++;
> +                       continue;
> +               }
> +

[...]
