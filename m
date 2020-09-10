Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEA226547A
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725320AbgIJV5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgIJV4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 17:56:39 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9250CC061573;
        Thu, 10 Sep 2020 14:56:38 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id k2so2501400ybp.7;
        Thu, 10 Sep 2020 14:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TsJS6ZP23FD5KuVRGm6KvjtgRaAotH6WX6sJU4ADvk=;
        b=hlt4Jg3nXi6FXtRbwrY62gWtJpDG+ujXIeqxJNFuND67w5xCdYfL0/KMaSqRoqGdAT
         dbV+TKVLzo78ZcwvUPETDfdlZT9S6Q0h2ZgTssV5mLLP/myxCiP0TBEml7oeOujp/b0h
         sP6dQn446WPGcYGTBqgQTXWvAuY6z67qfw6VOoqamYOwgHUmgtrck0ggkDPxxsd01NxT
         POMkERrnj0NxoyHzocIBYiRgFjFN+A1TZnkVFsvldfiHaGY647F1BcL/JfE48ZiCWn1h
         4/h463SVpy+X53Sv06qu/XkJUvio2dKy0xqu1aF+MLj+epKFDUocz4FwgYaLsWWIHS0O
         rnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TsJS6ZP23FD5KuVRGm6KvjtgRaAotH6WX6sJU4ADvk=;
        b=gG/ifh6juxYB1veORxsWA8N7bs8W5vbliwBckRMMivJJigpFkK016RwQO1u+KVLD0v
         7ILdJS8Uri9zfIS3rTPV5D/IrJAFMJBKGARGUJlBZaxEhpVHFxgNMw6yPiZtkPT4Ir01
         xw9YPdSb0TTF1aLe0M0Gezg+r0wLKjC6GidBsWILyTbcYbuMsOLCz96MTwSmzvszPZuP
         W89RgUl28ifVrdznNZoKsVYvt6x5xVwNSceMscaCO7K92gVPllz4dmqruNQujA9a7Y3k
         y+RmstLOoAWuOxeRbbSq/ptei5BmaQN0N28gcOi+8XOVhDGLJAUVUtomCJQ1iUX9kOIw
         9OOg==
X-Gm-Message-State: AOAM533vHSXcoaDmKReD9AMnQrGgb0HUxcuE7mzDazx8QswwdBXAq/ph
        hEuBE8k4cHeu+DES+AA+kd6TQz3ztEahp/ZWCIfYiJJPp24=
X-Google-Smtp-Source: ABdhPJxTiAH33iaNv5w3B+v5GaYno8ohAIxDKoDcVeEdgzu8JdWtT30YiyFimleu0o96zL9DQtyXxT5XvMnlHCx2d80=
X-Received: by 2002:a25:c049:: with SMTP id c70mr16077351ybf.403.1599774997775;
 Thu, 10 Sep 2020 14:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202718.956042-1-yhs@fb.com>
In-Reply-To: <20200910202718.956042-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 14:56:27 -0700
Message-ID: <CAEf4Bza3=W5GaVuRFbvQvCKD3WQ9PVnuYJGPdF21zcaztJFBFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: define string const as global for test_sysctl_prog.c
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

On Thu, Sep 10, 2020 at 1:30 PM Yonghong Song <yhs@fb.com> wrote:
>
> When tweaking llvm optimizations, I found that selftest build failed
> with the following error:
>   libbpf: elf: skipping unrecognized data section(6) .rodata.str1.1
>   libbpf: prog 'sysctl_tcp_mem': bad map relo against '.L__const.is_tcp_mem.tcp_mem_name'
>           in section '.rodata.str1.1'
>   Error: failed to open BPF object file: Relocation failed
>   make: *** [/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h] Error 255
>   make: *** Deleting file `/work/net-next/tools/testing/selftests/bpf/test_sysctl_prog.skel.h'
>
> The local string constant "tcp_mem_name" is put into '.rodata.str1.1' section
> which libbpf cannot handle. Using untweaked upstream llvm, "tcp_mem_name"
> is completely inlined after loop unrolling.
>
> Commit 7fb5eefd7639 ("selftests/bpf: Fix test_sysctl_loop{1, 2}
> failure due to clang change") solved a similar problem by defining
> the string const as a global. Let us do the same here
> for test_sysctl_prog.c so it can weather future potential llvm changes.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/progs/test_sysctl_prog.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
> index 50525235380e..5489823c83fc 100644
> --- a/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_prog.c
> @@ -19,11 +19,11 @@
>  #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>  #endif
>
> +const char tcp_mem_name[] = "net/ipv4/tcp_mem";

nit: I'd prefer keeping an empty line between variables and functions

>  static __always_inline int is_tcp_mem(struct bpf_sysctl *ctx)
>  {
> -       char tcp_mem_name[] = "net/ipv4/tcp_mem";
>         unsigned char i;
> -       char name[64];
> +       char name[sizeof(tcp_mem_name)];
>         int ret;
>
>         memset(name, 0, sizeof(name));
> --
> 2.24.1
>
