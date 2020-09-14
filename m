Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED9269931
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgINWqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINWqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 18:46:13 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC43C06174A;
        Mon, 14 Sep 2020 15:46:11 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v60so1029600ybi.10;
        Mon, 14 Sep 2020 15:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k2UJEMuWShlhG8uDGunQkhT3s33ehsHuyzJVHV4mf8I=;
        b=JAfgqjJOjYZA+H4sD0N5lxDp/gTZv/Mu5g4tuMq0sDoFcBLdPOumJzO7Uq7PfrJDXi
         IAVc6CS6FNevKWKcp7eqje4DQNzkXRHBKKuSM+BZpJ1+EsSbwcORhkOh0HfAWcoL+WIc
         oaO2MOt7cE6qiVf7VgZkqPP+Lj5XZNMt8Z0YlXkn61YFI59a3GAijmxdJz0dnLE8dI4H
         fj5xY2iSFHIBRNsKA+8IUjHTzM+OP2wQYurDODkw3ziyj/hPA+PYfkWcN/L4oKQXIxki
         3YkxiRyl26xTeWxNgFfcUJIOptPJPPIoWSbGsLpnVq3mzM6WOkCY6rlhKV0/oZzsWYQp
         4Gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k2UJEMuWShlhG8uDGunQkhT3s33ehsHuyzJVHV4mf8I=;
        b=t5G3XA7RQ6INVK8YRnEp4QxI4WSjFnbIYJKa+0Fqjj2tdYHbGcDJ08Xsj8VLp3l02F
         JU3WvFPw9bsAbq92MCyQRDo1A15li6H15qw+No7gdg75qIOIt11Fv+hdMNHleUn+vOPm
         A1T/7BlGM/tQHBRTkpzXN7G8bG79NyLZEKea53hIzy+/aV/A23J3j9hDkZ8tUN4k3HDc
         eiyZWYgqyA8SSFRAbAQvB02aXeiP3lzdGWJv2kuNoIDEFH/U2ILsudYHif7xZOOC/eXV
         HIwlCluL7hjUHQ/Oy5gk9DfwxCK/EfW21brVFV1hcF3qybLuBK7MXw35hfDC+CPBtLkj
         NHig==
X-Gm-Message-State: AOAM531zJQX/FFBKhQmUdjNxJwTaTcA7eki4D+kfTMpKyc11i/DABemq
        XkhYzPMBlonC1xrtJdd31mJP5Yia8RYxuc1uAy0oM8T4yUHNww==
X-Google-Smtp-Source: ABdhPJxBISLMBVpPxVNxfZPn/YEGAVjBXmGOdCLDtSFaxjXIEItlUSRFh7niK+uYLxC52RgQD/X5zLJJsVtHBRlFiSI=
X-Received: by 2002:a25:c049:: with SMTP id c70mr24301878ybf.403.1600123570802;
 Mon, 14 Sep 2020 15:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200914223210.1831262-1-yhs@fb.com>
In-Reply-To: <20200914223210.1831262-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 15:45:59 -0700
Message-ID: <CAEf4BzYAg0ox=yTWAzKjXZbCWuDEMvKzwW1KmJ5C8NGPkecpAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix a compilation error with xsk.c for
 ubuntu 16.04
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 3:32 PM Yonghong Song <yhs@fb.com> wrote:
>
> When syncing latest libbpf repo to bcc, ubuntu 16.04 (4.4.0 LTS kernel)
> failed compilation for xsk.c:
>   In file included from /tmp/debuild.0jkauG/bcc/src/cc/libbpf/src/xsk.c:2=
3:0:
>   /tmp/debuild.0jkauG/bcc/src/cc/libbpf/src/xsk.c: In function =E2=80=98x=
sk_get_ctx=E2=80=99:
>   /tmp/debuild.0jkauG/bcc/src/cc/libbpf/include/linux/list.h:81:9: warnin=
g: implicit
>   declaration of function =E2=80=98container_of=E2=80=99 [-Wimplicit-func=
tion-declaration]
>            container_of(ptr, type, member)
>            ^
>   /tmp/debuild.0jkauG/bcc/src/cc/libbpf/include/linux/list.h:83:9: note: =
in expansion
>   of macro =E2=80=98list_entry=E2=80=99
>            list_entry((ptr)->next, type, member)
>   ...
>   src/cc/CMakeFiles/bpf-static.dir/build.make:209: recipe for target
>   'src/cc/CMakeFiles/bpf-static.dir/libbpf/src/xsk.c.o' failed
>
> Commit 2f6324a3937f ("libbpf: Support shared umems between queues and dev=
ices")
> added include file <linux/list.h>, which uses macro "container_of".
> xsk.c file also includes <linux/ethtool.h> before <linux/list.h>.
>
> In a more recent distro kernel, <linux/ethtool.h> includes <linux/kernel.=
h>
> which contains the macro definition for "container_of". So compilation is=
 all fine.
> But in ubuntu 16.04 kernel, <linux/ethtool.h> does not contain <linux/ker=
nel.h>
> which caused the above compilation error.
>
> Let explicitly add <linux/kernel.h> in xsk.c to avoid compilation error
> in old distro's.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and dev=
ices")
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/xsk.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 49c324594792..30b4ca5d2ac7 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -20,6 +20,7 @@
>  #include <linux/if_ether.h>
>  #include <linux/if_packet.h>
>  #include <linux/if_xdp.h>
> +#include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/sockios.h>
>  #include <net/if.h>
> --
> 2.24.1
>
