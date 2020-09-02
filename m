Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8025B58A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgIBU7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgIBU7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:59:02 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F61C061244;
        Wed,  2 Sep 2020 13:59:02 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 195so560482ybl.9;
        Wed, 02 Sep 2020 13:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5ZfPemBjYkOodSo7EFsnzTfP5gdkrDYRzDlndFSMw+8=;
        b=QRlkPHCcnmNz6eji4IWONJT8m+Atj+DoBEocfspqhw0714Z9K8VhP/ST74E39K1bye
         fyTK+xRfucKFv5wO72u0p1VwsVP2ARDrLUAA5kIlZj/+mObRCghHJh9IAfxQ7ativhmx
         /qnCgAKDKyE7Sk12kcXjBh2XCyIPx14J0k2KWc3PGVyM8+K9SNJKKcniuytPsZg11Ids
         0mE4a5FiZCeolfXBtSEpGpoUSWIZXS5Y6uw9ugyRBKkf0HEa9bg/UY6A7plqC9GfSc3B
         SJ3H+c3JNiH6LaJ13l0ej1GzPl5Tm5Xi2CfCB6dweAHr7aof+6tLWOmC11MaXw7aTsnW
         CI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5ZfPemBjYkOodSo7EFsnzTfP5gdkrDYRzDlndFSMw+8=;
        b=rZBOip6Jsmj2mcyI1CesoMcfKUhrV04D43UnLu7Teq2X0a3xhDYpdLdbi6teCl0+GW
         uR1yKn0sshz9YWzXjy7oGkAg6BQixjBU5fFVphbRAdG/kGrEzS+VjFyXsk2Zoa55EhbZ
         meXZkK7/kM3X1B44LvXdnzXPQ7azwr/UW/TrbIaWjfD9IOG2JcWbJXBB4Nnty5vLdeB7
         9LYx9LA2eepAMn8shxIbzm1/2jBfBdUlnukDxzTIe1HqSnIAIczlYDpr8o8TFGEf+I8y
         soiuhtj9La3QSnbzXAtFN9FtKn4Bc3IYuI9ZHv6B4EUokrwn6+IW92Vcx5zvTHdERggw
         0hZg==
X-Gm-Message-State: AOAM530E1zk080mgbEs5XHqsfcnXhM+2diJlANvW2YclyZv7lMAbuEov
        mv7kdwurxNf6CzRB97ZPpO0MxGAM8FUR4aTtP0pvH8nXkd4=
X-Google-Smtp-Source: ABdhPJzO/IczDEfTQHXjFwjRDbR1jrxJyatELa/KD/yXoHQyrF0XPe/72IqQH6pVDKrkuhBRpcLTRQFnqPc3eeAFl9Q=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr12771711ybp.403.1599080341639;
 Wed, 02 Sep 2020 13:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <20200902084246.1513055-1-naveen.n.rao@linux.vnet.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 13:58:50 -0700
Message-ID: <CAEf4BzZXyJsJ6rFp7pj_0PhyE_df9Z08wE9pUkZBp8i1qz_h1Q@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Remove arch-specific include path in Makefile
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@redhat.com>,
        Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 1:43 AM Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:
>
> Ubuntu mainline builds for ppc64le are failing with the below error (*):
>     CALL    /home/kernel/COD/linux/scripts/atomic/check-atomics.sh
>     DESCEND  bpf/resolve_btfids
>
>   Auto-detecting system features:
>   ...                        libelf: [ [32mon[m  ]
>   ...                          zlib: [ [32mon[m  ]
>   ...                           bpf: [ [31mOFF[m ]
>
>   BPF API too old
>   make[6]: *** [Makefile:295: bpfdep] Error 1
>   make[5]: *** [Makefile:54: /home/kernel/COD/linux/debian/build/build-generic/tools/bpf/resolve_btfids//libbpf.a] Error 2
>   make[4]: *** [Makefile:71: bpf/resolve_btfids] Error 2
>   make[3]: *** [/home/kernel/COD/linux/Makefile:1890: tools/bpf/resolve_btfids] Error 2
>   make[2]: *** [/home/kernel/COD/linux/Makefile:335: __build_one_by_one] Error 2
>   make[2]: Leaving directory '/home/kernel/COD/linux/debian/build/build-generic'
>   make[1]: *** [Makefile:185: __sub-make] Error 2
>   make[1]: Leaving directory '/home/kernel/COD/linux'
>
> resolve_btfids needs to be build as a host binary and it needs libbpf.
> However, libbpf Makefile hardcodes an include path utilizing $(ARCH).
> This results in mixing of cross-architecture headers resulting in a
> build failure.
>
> The specific header include path doesn't seem necessary for a libbpf
> build. Hence, remove the same.
>
> (*) https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.9-rc3/ppc64el/log
>
> Reported-by: Vaidyanathan Srinivasan <svaidy@linux.ibm.com>
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---

This seems to still build fine for me, so I seems fine. Not sure why
that $(ARCH)/include/uapi path is there.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> This is a simpler fix that seems to work and I saw the proper headers
> from within tools/ being included in both cross-architecture builds as
> well as a native ppc64le build. I am not sure if there is a better way
> to ask kbuild to build resolve_btfids/libbpf for the host architecture,
> and if that will set $(ARCH) appropriately.
>
> - Naveen
>
>
>  tools/lib/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index adbe994610f2..fccc4dcda4b6 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -62,7 +62,7 @@ FEATURE_USER = .libbpf
>  FEATURE_TESTS = libelf zlib bpf
>  FEATURE_DISPLAY = libelf zlib bpf
>
> -INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/arch/$(ARCH)/include/uapi -I$(srctree)/tools/include/uapi
> +INCLUDES = -I. -I$(srctree)/tools/include -I$(srctree)/tools/include/uapi
>  FEATURE_CHECK_CFLAGS-bpf = $(INCLUDES)
>
>  check_feat := 1
>
> base-commit: 0697fecf7ecd8abf70d0f46e6a352818e984cc9f
> --
> 2.25.4
>
