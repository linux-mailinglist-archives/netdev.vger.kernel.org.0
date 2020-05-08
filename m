Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FDD1CB7EA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbgEHTIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726807AbgEHTIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:08:00 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443C9C061A0C;
        Fri,  8 May 2020 12:08:00 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so1876091qkm.6;
        Fri, 08 May 2020 12:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJhpJQVrwpI8jjESK3Ar5T0fYNUUN9gvceX5UjwQhS4=;
        b=ao/ZPvBw4HIHlR/M/7SV23PDrSSYiMQ/M82PpjmpOom9o5jU/uM5Mm/s2V7WpVxwta
         q+cX10N/1YUenmWB7v7TJvOYiHnjga/6N612B127MZOSunxWlFsAcgEgQxQ23vdSYH0n
         wa+/0xPRx+ZNeYdQWx2akiShFc1hwkHFnyZDOdd+ZcEhVG4Pt1wS735QttvL/oz+3Jxj
         CFjNUG0OOTcbgbBQzWpkXHB/Bk70gaITFAEZ1bxfR+raM5ZuBdqRtdQ1VJCdLxflO2lU
         Jy5pB0A1eNBEG/b3nyQf58IJcprR9xslPGXlnLaXQoq54VuNbomzkIzmQT5+95Hn8zDm
         RsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJhpJQVrwpI8jjESK3Ar5T0fYNUUN9gvceX5UjwQhS4=;
        b=fHYseEIdk/N/OyFGjqQnd55ir0mSBmvWr+dCn/B3EXhhZQui3NPZYIg2jZgRjZZ0oD
         Ud+f/4MXkvpWcxPJGYEjzNoZj3hbpLFOeZlWwQyLGOgYKvSIivS9jQTjTu/QHW3J9uSV
         dUqsvQpR0mb5eTDgQmeDalXTeZd1hrkJ5Zh2zYME9dvmCm7ET6wR4lcWVOkBV+mWsEvQ
         /7NglMff7w8zpEmRNUUIWAOwDVV0k/GXfGMSR0XtKQgahcF2Ye6DI81ygzHa3U7Y5YAZ
         V7MllmqqgAJqiY4i+6mT2Gsx2RzulsD8tu+Jz8vuOWQ1COE1FrVbl/CuN7YOV176Nkha
         RptA==
X-Gm-Message-State: AGi0PuYuN+w7eeuaVH3tuZpVnJ9zE3qUMIlvaE+lXxmqMpZIF/DR+XGP
        KMVI39bzd3N60/7e6YWUGhj7LGu42m87n7clPdwkQu8e
X-Google-Smtp-Source: APiQypL80ObNgJMVAo/8CeFapg0XVJIviObRAZkADCoqAQtM9B8WbMyHc3Eod6CZ4xDx3oCR+9jjsEOXMkv6AX6o7n0=
X-Received: by 2002:a37:68f:: with SMTP id 137mr4351977qkg.36.1588964879303;
 Fri, 08 May 2020 12:07:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053924.1543103-1-yhs@fb.com>
In-Reply-To: <20200507053924.1543103-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:07:48 -0700
Message-ID: <CAEf4BzZ1vD_F74gy5mx_s8+cbw4OuZwJxpW36CijE-RWxOf__g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/21] bpf: implement common macros/helpers
 for target iterators
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
> Macro DEFINE_BPF_ITER_FUNC is implemented so target
> can define an init function to capture the BTF type
> which represents the target.
>
> The bpf_iter_meta is a structure holding meta data, common
> to all targets in the bpf program.
>
> Additional marker functions are called before or after
> bpf_seq_read() show()/next()/stop() callback functions
> to help calculate precise seq_num and whether call bpf_prog
> inside stop().
>
> Two functions, bpf_iter_get_info() and bpf_iter_run_prog(),
> are implemented so target can get needed information from
> bpf_iter infrastructure and can run the program.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h   | 11 ++++++
>  kernel/bpf/bpf_iter.c | 86 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 92 insertions(+), 5 deletions(-)
>

Looks good. I was worried about re-using seq_num when element is
skipped, but this could already happen that same seq_num is associated
with different objects: overflow + retry returns different object
(because iteration is not a snapshot, so the element could be gone on
retry). Both cases will have to be handled in about the same fashion,
so it's fine.

Hm... Could this be a problem for start() implementation? E.g., if
object is still there, but iterator wants to skip it permanently.
Re-using seq_num will mean that start() will keep trying to fetch same
to-be-skipped element? Not sure, please think about it, but we can fix
it up later, if necessary.

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]

> @@ -112,11 +143,16 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
>                         err = PTR_ERR(p);
>                         break;
>                 }
> +
> +               /* get a valid next object, increase seq_num */

typo: get -> got

> +               bpf_iter_inc_seq_num(seq);
> +
>                 if (seq->count >= size)
>                         break;
>
>                 err = seq->op->show(seq, p);
>                 if (err > 0) {
> +                       bpf_iter_dec_seq_num(seq);
>                         seq->count = offs;
>                 } else if (err < 0 || seq_has_overflowed(seq)) {
>                         seq->count = offs;

[...]
