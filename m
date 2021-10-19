Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8421F434244
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 01:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhJSXrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 19:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJSXrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 19:47:31 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC96BC06161C;
        Tue, 19 Oct 2021 16:45:16 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id a7so7873418yba.6;
        Tue, 19 Oct 2021 16:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LbLwDrQNcMmSK7vk+8VpqyJYarzvbON0cV44V+1rMes=;
        b=YwxH+X3IV8XuaEFXyTf5LsL9vKhC9WSLzWI5tc3dWmxhlfvOIHXWR/wMxApeTwvfYT
         C04c2Mc0mhHX/VMv11mmZXyvVabfYsbp+fPWY/o5WTpoYIEkF9YuidwYAk/KGU/0xEFR
         DmO3QlPGjuXyAm0bypVTZwjDMX+Z7dQh+ca+sRWZberHYqUhcYR7cHn1R9b4Im/Cw36D
         6f7BNcNhGjXclN4wy+GcDjRLQKgEJkvjNeLwKq3rHhkZv1bTg1miV967bdBzExD95sq2
         /yFoKN2QIoHmKIXlkirWBBoboN5V6PoztsfaQVceQC4OWQ3XCT+OXvSNQqzvEkFlpRsa
         7MYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LbLwDrQNcMmSK7vk+8VpqyJYarzvbON0cV44V+1rMes=;
        b=Lh9stBnLxg92SNWz4DL7CERLbu9JRjDGCFCOgmNNXeGqfQnnZaf7pWWZusLDllzMYf
         lCt6ZGz79a+lVAM5fFi0Dga9b6tJxUAXipD0ZYRkxLaa8ZcDUqZkPGwKdxWnJ2OeiwSx
         wZeqViTVrlz7elB1nhC/+h/CMrk089ioBv4q9IuBa9F3YIGbDgqPQHBSKVSGWUVLGaX1
         54pHgOLkChNpwO5w1uGdGc7X1Wu9Op9ouxlzDWw+2ewi1lDEHTgRdCugV0sphAAIoxzP
         qffiVyHTNyXeY8law2JEWd91SO62GegRSp+bE+kbq1einNUQyKLtyNb+JX1xI8iR9Ody
         niLQ==
X-Gm-Message-State: AOAM532h4Y6PmPnxRuhY5S/Uo/fgQFLYTIBeyZV2wa757Gm2Ps1bpKK+
        EhOGBfZ3b2lehXa3NN97J+Ih5VJH34j0h3xq2oM=
X-Google-Smtp-Source: ABdhPJwttS3HzMlcP8qkMgKGSxWqf3OK6eeCRD2j+t2mE24GS3Y9rONCA9sHCTtjvz80zRVUsD9kU/VALNO+YiQ7Aag=
X-Received: by 2002:a05:6902:154d:: with SMTP id r13mr3231188ybu.114.1634687115984;
 Tue, 19 Oct 2021 16:45:15 -0700 (PDT)
MIME-Version: 1.0
References: <20211010002528.9772-1-quentin@isovalent.com>
In-Reply-To: <20211010002528.9772-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 19 Oct 2021 16:45:05 -0700
Message-ID: <CAEf4BzZVBOXNC=88f1Mmepvk2xoG1HM+aEtKx+4qeSS_ED3JcQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Remove Makefile warnings on out-of-sync netlink.h/if_link.h
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 9, 2021 at 5:25 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Although relying on some definitions from the netlink.h and if_link.h
> headers copied into tools/include/uapi/linux/, libbpf does not need
> those headers to stay entirely up-to-date with their original versions,
> and the warnings emitted by the Makefile when it detects a difference
> are usually just noise. Let's remove those warnings.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/Makefile | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 9c6804ca5b45..b393b5e82380 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -146,12 +146,6 @@ $(BPF_IN_SHARED): force $(BPF_GENERATED)
>         @(test -f ../../include/uapi/linux/bpf_common.h -a -f ../../../include/uapi/linux/bpf_common.h && ( \
>         (diff -B ../../include/uapi/linux/bpf_common.h ../../../include/uapi/linux/bpf_common.h >/dev/null) || \
>         echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/bpf_common.h' differs from latest version at 'include/uapi/linux/bpf_common.h'" >&2 )) || true
> -       @(test -f ../../include/uapi/linux/netlink.h -a -f ../../../include/uapi/linux/netlink.h && ( \
> -       (diff -B ../../include/uapi/linux/netlink.h ../../../include/uapi/linux/netlink.h >/dev/null) || \
> -       echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/netlink.h' differs from latest version at 'include/uapi/linux/netlink.h'" >&2 )) || true
> -       @(test -f ../../include/uapi/linux/if_link.h -a -f ../../../include/uapi/linux/if_link.h && ( \
> -       (diff -B ../../include/uapi/linux/if_link.h ../../../include/uapi/linux/if_link.h >/dev/null) || \
> -       echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_link.h' differs from latest version at 'include/uapi/linux/if_link.h'" >&2 )) || true


Great. Applied to bpf-next. Thanks.

>         @(test -f ../../include/uapi/linux/if_xdp.h -a -f ../../../include/uapi/linux/if_xdp.h && ( \
>         (diff -B ../../include/uapi/linux/if_xdp.h ../../../include/uapi/linux/if_xdp.h >/dev/null) || \
>         echo "Warning: Kernel ABI header at 'tools/include/uapi/linux/if_xdp.h' differs from latest version at 'include/uapi/linux/if_xdp.h'" >&2 )) || true
> --
> 2.30.2
>
