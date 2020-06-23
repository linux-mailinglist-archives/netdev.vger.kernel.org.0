Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7BD3204A55
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbgFWG7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbgFWG7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:59:15 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23598C061573;
        Mon, 22 Jun 2020 23:59:15 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b4so17862144qkn.11;
        Mon, 22 Jun 2020 23:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WQzlXAsRjgoDusDLra7x31pERX5MV7Kea86vGTDVs+8=;
        b=D0TOU/gBJLAFlXM4aB++HKNkJ+jOfDJ1Oz2J44lurmLINZlqIEnXinqLQtlLCFTNew
         INjR9vJ2D6eNaYhd9HsbuIh4947zg9NWwICmR0GXqytHhIPRo1Tc20PwnHksO9kqn986
         Wwi/7Me/cPJEcMatNsfFmrPc5mgLehq9E5IeBJES7/HYXcIr1w6y9Uh6ncpcCLDKTbcx
         yIRWbCsBYsa8k8qibb2SOEu7Lxrl6aFl2OikQ6nN6Kq5YKdl4noC1tqYFUDnbo6Q2tph
         wYKys+1iuq1+rS4L7tsxs6trzYbiwKAXCscNzNu+qB5SWR1af8nc5azouPXxbajC9JPd
         ueTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WQzlXAsRjgoDusDLra7x31pERX5MV7Kea86vGTDVs+8=;
        b=VqwPoxHnlRXyqeZJ03/CwSuQGWwgSQeEmqVTkDx40OKACbl3+YvVIbeuxTiUOfsEog
         OXQCLk4hhK3xT+hzpcwkKSxsULnzpoqB+5mVOsfYEb7lOY/uEvOEBHc1had7UXKINY2X
         ZcYvHq4EMLgwQwLB55b0Wb7Sga7hbtaxNT8UQEP3mlVCiYd1sENx7D3d81bVLB/JUE2I
         uAM0mkUpO/kLntp48MIV26sFhxK1djqgK0+LbZqHlXe+woPtY330bMG8X7azWIXsmpsd
         1Hf2zUQSFmZGlOKbtSwdxRJSeO+zonhe/gI8OI0L/K1I4N8IDJ9SHGSyHi0OczsVU7+K
         OrEA==
X-Gm-Message-State: AOAM531RMmgsinwGlFxs9uDxRO/krh7y+vfTQcfFzzb/WxN6k0Ye8VmG
        Z0JfmGW0/R60FXezX3t6ivKuxCBkvWc9ogGQJLcEeuoX
X-Google-Smtp-Source: ABdhPJxFThcbIEs2+NSAFU4rdTkqpqGHSgxFAxm3K2HoAC/aVF0zKTi+TvZMe023LsOKS6psxO8poSG8ViuDMbp7Ds0=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr19240669qkh.39.1592895554325;
 Mon, 22 Jun 2020 23:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003643.3075182-1-yhs@fb.com>
In-Reply-To: <20200623003643.3075182-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:59:03 -0700
Message-ID: <CAEf4BzYBx+DxWuufmmX7qxN+GLwoN217d6OkV08dFToU_QmXcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 15/15] bpf/selftests: add tcp/udp iterator
 programs to selftests
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>
> Added tcp{4,6} and udp{4,6} bpf programs into test_progs
> selftest so that they at least can load successfully.
>   $ ./test_progs -n 3
>   ...
>   #3/7 tcp4:OK
>   #3/8 tcp6:OK
>   #3/9 udp4:OK
>   #3/10 udp6:OK
>   ...
>   #3 bpf_iter:OK
>   Summary: 1/16 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

nit: subject "bpf/selftest" -> "selftests/bpf"

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/bpf_iter.c       | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>

[...]
