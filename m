Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA8E1B1B7E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 03:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgDUB4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 21:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgDUB4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 21:56:54 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0BFC061A0E;
        Mon, 20 Apr 2020 18:56:54 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id t3so13071517qkg.1;
        Mon, 20 Apr 2020 18:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5YVEd1ET0/pk9XX+2bqTIcsqg30O9ow/SjyP8w4DeI0=;
        b=ZHyjj3a/dJfXapD6ocbpQsERHg37DN6WFLGOm9ZmH9PeDbUIPOJUhSjxAwfBAWpWII
         DROjIkGwddttk/lr+vMCRvXjQJNXE9o91Ui4l4SMt5edhXciI77JvgdC2YKqaiQtnLHF
         pwBpIm9dkj9T2QqHsiXZBsU4GYMi1a69WUhn5o9xACbhLbtVcC/6qflxYTs8wN0fGAqQ
         P4lohSZiHGPgHY4u2kS0SlkzWZ+0lN117O3e9lCUDfjWyP3eTCetE3cN6HGNXyIhk95B
         r1BSqQGG/VBWwaf0H0Vb9ipHQ18DcmX/FwhDvaF+gT9Gm0J/MSYghAVL885uDBhLqeQQ
         8CFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5YVEd1ET0/pk9XX+2bqTIcsqg30O9ow/SjyP8w4DeI0=;
        b=ari5SBzleD+xcwerUotkCWkSYpZaKZZRWGTz99PEKI6CulhzbKCPfnol4be0+d2PaU
         uItuJxiJdl3I2+Q4eMG0zhCFvFm/G5IvDQXuEWqRG7gAO4u4ShsyEwpDSDXv+HrpNY7j
         eQyl57HwnDw4fckLw4ENcFKEPVC+rXikmKyeQ32DiZjtKZcHNm6pTr2bOl0OuMY5yP6w
         Tqt+TcYZ4KL93pyQZByJ0acSWW4mez4q9OpZV5U+zhiq/3r7quRqCaX69UjVmZaaX/0x
         I1xQ923oYYGYYS0aITTVtMD8b1jLIdJUtJm173njALx4IiS1Kckes5f22FbqrxDdVF2p
         I91A==
X-Gm-Message-State: AGi0PuY+LyLD+EZNvjhm7q4BFn4PgTSb4LF5eWPXCow0e0/xnvCm4mpZ
        WHNSLoLroyQgHWTOZHRKxgph45AHVkZuT0EAMA3sG5an
X-Google-Smtp-Source: APiQypJIxpykiS2C8+f9ygR/YSy54GVLzhUEEFRQzq2ms8KQxC7lMszZCe1Ztq9BCm1MFushZlWrAZyK3N6MHtkxcoE=
X-Received: by 2002:a37:787:: with SMTP id 129mr17524833qkh.92.1587434213669;
 Mon, 20 Apr 2020 18:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <1587427527-29399-1-git-send-email-komachi.yoshiki@gmail.com>
In-Reply-To: <1587427527-29399-1-git-send-email-komachi.yoshiki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Apr 2020 18:56:42 -0700
Message-ID: <CAEf4BzbK-kBmjp0X3n2EBB0A6HhhP385pxQYUDHZk2FpE23JCw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf_helpers.h: Add note for building with
 vmlinux.h or linux/types.h
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 5:06 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> The following error was shown when a bpf program was compiled without
> vmlinux.h auto-generated from BTF:
>
>  # clang -I./linux/tools/lib/ -I/lib/modules/$(uname -r)/build/include/ \
>    -O2 -Wall -target bpf -emit-llvm -c bpf_prog.c -o bpf_prog.bc
>  ...
>  In file included from linux/tools/lib/bpf/bpf_helpers.h:5:
>  linux/tools/lib/bpf/bpf_helper_defs.h:56:82: error: unknown type name '__u64'
>  ...
>
> It seems that bpf programs are intended for being built together with
> the vmlinux.h (which will have all the __u64 and other typedefs). But
> users may mistakenly think "include <linux/types.h>" is missing
> because the vmlinux.h is not common for non-bpf developers. IMO, an
> explicit comment therefore should be added to bpf_helpers.h as this
> patch shows.
>
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/bpf_helpers.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index f69cc208778a..60aad054eea1 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -2,6 +2,12 @@
>  #ifndef __BPF_HELPERS__
>  #define __BPF_HELPERS__
>
> +/*
> + * Note that bpf programs need to include either
> + * vmlinux.h (auto-generated from BTF) or linux/types.h
> + * in advance since bpf_helper_defs.h uses such types
> + * as __u64.
> + */
>  #include "bpf_helper_defs.h"
>
>  #define __uint(name, val) int (*name)[val]
> --
> 2.24.1
>
