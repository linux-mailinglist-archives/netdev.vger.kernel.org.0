Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AC31C683F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgEFGPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726495AbgEFGPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:15:09 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB101C061A0F;
        Tue,  5 May 2020 23:15:07 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id n14so830109qke.8;
        Tue, 05 May 2020 23:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IbAkNjcaFmar4aPjN7+DvzPMwhKo6sHjCis4p0bqYOY=;
        b=T/HlFfPUdAjwdFgOBelJYC1zALFgT0/GuvvG8mePq5sVOdbsuSlNhFCX7HHZLecf9Y
         ujxRoySYk5Hyq5Ve38uUJmEM05fAeiLrvibsnasD0jydl/oGK69FopkMhqwtaNPL8Jdm
         RITkSYjrpNfJazsS/m56knCnm3lLp2TtfIJ1wxd591ANX9uoGYfVbPyl7azzZUqCXZD5
         j6na4d9uUNDlPPVnLiyVmUwxSjnuj+aXK1yV0H5zgAriZ616DLw8TP8oo7gAub+gj7p7
         saQSb64rll3gIH3fTAo9oZCNgZAJwfF8dwYepnkBvn7KKcTaqS5b87LJKQfu1ly9WuZg
         080Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IbAkNjcaFmar4aPjN7+DvzPMwhKo6sHjCis4p0bqYOY=;
        b=ieesnKv6C0+F7VvHA5VGA2blBt/c6ARb+J8T9Qk9ZQaQHAQKtF9DtZ98dSvsh8DiQW
         4IhsyTLIBPacs0uRt2W21y2R75Gz1847rvaIL7ENux/Astb2uVCExPbjLN6dIlqozUh9
         JMceQCrJ+q8NRPYCgfWbJX9OHLxBVdeasJGvocbWWgtyqxvFOv6IiitZCLW79OuAsHg/
         nO5angRMyc6vz50t8zA+qcRtoZc5gYt1glzfRNo0qQ4Bn2arKmGiYtaDYxrLb1VqIm3p
         LVy0ZVNIgGSK5Dr2iG6ZYCpd+MbhNfSq+6it8BWlxq9sg1EkrsgSmEG4Q8Mom9KfiF7j
         wuGw==
X-Gm-Message-State: AGi0Pub2QkQi4+Vq9vXcOHJoSuyITElr3bfMChfv92Ubt4CwTMMmCkMT
        VhEYVHUHl9lJsRpH9boS0v7/fLYb2/lIoYlS+dujDg==
X-Google-Smtp-Source: APiQypIeXDRf934Bxr5hKdZWWGztldMWyL8G2QSZ7bpigJ1mXcBoSOG1f2yLCP106B7E8HRoAqgYPvVDn9WNWQq0Thg=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr7094835qkj.92.1588745707169;
 Tue, 05 May 2020 23:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062609.2049143-1-yhs@fb.com>
In-Reply-To: <20200504062609.2049143-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 23:14:56 -0700
Message-ID: <CAEf4BzazZ4esM0z5ZTM9PGfODfTtQB1AskPc1g139t5emUWb1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 19/20] tools/bpf: selftests: add iter progs
 for bpf_map/task/task_file
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

On Sun, May 3, 2020 at 11:27 PM Yonghong Song <yhs@fb.com> wrote:
>
> The implementation is arbitrary, just to show how the bpf programs
> can be written for bpf_map/task/task_file. They can be costomized
> for specific needs.
>
> For example, for bpf_map, the iterator prints out:
>   $ cat /sys/fs/bpf/my_bpf_map
>       id   refcnt  usercnt  locked_vm
>        3        2        0         20
>        6        2        0         20
>        9        2        0         20
>       12        2        0         20
>       13        2        0         20
>       16        2        0         20
>       19        2        0         20
>       === END ===
>
> For task, the iterator prints out:
>   $ cat /sys/fs/bpf/my_task
>     tgid      gid
>        1        1
>        2        2
>     ....
>     1944     1944
>     1948     1948
>     1949     1949
>     1953     1953
>     === END ===
>
> For task/file, the iterator prints out:
>   $ cat /sys/fs/bpf/my_task_file
>     tgid      gid       fd      file
>        1        1        0 ffffffff95c97600
>        1        1        1 ffffffff95c97600
>        1        1        2 ffffffff95c97600
>     ....
>     1895     1895      255 ffffffff95c8fe00
>     1932     1932        0 ffffffff95c8fe00
>     1932     1932        1 ffffffff95c8fe00
>     1932     1932        2 ffffffff95c8fe00
>     1932     1932        3 ffffffff95c185c0
>
> This is able to print out all open files (fd and file->f_op), so user can compare
> f_op against a particular kernel file operations to find what it is.
> For example, from /proc/kallsyms, we can find
>   ffffffff95c185c0 r eventfd_fops
> so we will know tgid 1932 fd 3 is an eventfd file descriptor.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/progs/bpf_iter_bpf_map.c    | 29 +++++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_task.c       | 26 +++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_task_file.c  | 27 +++++++++++++++++
>  3 files changed, 82 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_file.c
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
> new file mode 100644
> index 000000000000..d0af0e82b74c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_map.c
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Facebook */
> +#include "vmlinux.h"
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_endian.h>

bpf_endian.h doesn't seem to be really used and it's actually
incompatible with vmlinux.h, so maybe let's drop it?
Same for previous patch, I believe.

> +
> +char _license[] SEC("license") = "GPL";
> +

[...]
