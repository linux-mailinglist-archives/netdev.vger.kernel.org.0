Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16B923133C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728856AbgG1T4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728567AbgG1T4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:56:14 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2D9C061794;
        Tue, 28 Jul 2020 12:56:13 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id x69so19976040qkb.1;
        Tue, 28 Jul 2020 12:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJP1AxLMAkAXNjIXT2QYjjZKu+zrqi6ZQ8MjHCkzEQY=;
        b=bMiViWhcNc8eurQHFF7gEo0b0AE1ZzuplLLnV5578pbu3xdCErqsqSXkkh/v4DGb1L
         HdYJRQwpE/I1Da6fAQF7gUWTCC/o1BCSopOuClrdVRIs8+yuIPtpNaXES6JWAqCph13F
         LAgxPty2yO/fFBsmaLVbDssY5XYobj1FP77Q9FZ7YZn6C+kiAZpCaJrznmawf3R3ZMYd
         g3MjmkpBhT7A+TghSTVG1l1tLRzGa72xNe3IBgWjgPMWhvThtWwj+jAEu9iWL4vw8KDp
         a1Q1PrbYnG5ttlB456mHM+VIZOb1QeLZsDQ8XifHlFt70DDqxh3e9d8BBHI/st6lM6ce
         g/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJP1AxLMAkAXNjIXT2QYjjZKu+zrqi6ZQ8MjHCkzEQY=;
        b=siqUJ6GEDoE6kO1Ecb85smQaXuzQghUp78scB3id2zdU737Ig4JqtdTK5K4UBj56OR
         OdPGC9PiHCycnY182aE3DhVTFDhJjGquCD1oenauXemiwUINaOY2ncrmYIJJe5QYeBLD
         oL+yDABXlcCfG//968U0+xyJJR2qj+8ZJsiEVJI3uN8em1ubNW0dh72xrKNUvvFNPx26
         BQ6qH6DaT5+yXdMUP4TEz69B2kUCwOAU8xCoUCLRnKZt9V739taPvjflmqcO2FZpLrkS
         GGAhdfOQG8iJwCfB2tf9miLgiWE32nmek+fxpnW95RXsOjHOUsgJLNCrSInwyOsse1gn
         13Eg==
X-Gm-Message-State: AOAM530wspudSNDlQDwWv4QcfxbtlzyKpzUh9GT0tJpWFCnVsrj/C+Ez
        zbBkDrVjD2+RidjNcuUFtNi0FI90Z5h/gQ5cOZY=
X-Google-Smtp-Source: ABdhPJy9/2VM5/20ii6Eb2JoyCxvCGwmKSRUDwheKTEL7UC02O04unk0tJDZaR0psmqnovsmUSKQ1VwVq1WvjDipuF8=
X-Received: by 2002:a37:a655:: with SMTP id p82mr29238102qke.92.1595966173091;
 Tue, 28 Jul 2020 12:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200722211223.1055107-1-jolsa@kernel.org> <20200722211223.1055107-14-jolsa@kernel.org>
In-Reply-To: <20200722211223.1055107-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 12:56:02 -0700
Message-ID: <CAEf4BzbMNZdiD_hqReei2HKziTTNoWFymE5g7SzvSR7=QdWxrw@mail.gmail.com>
Subject: Re: [PATCH v8 bpf-next 13/13] selftests/bpf: Add set test to resolve_btfids
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 2:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test to for sets resolve_btfids. We're checking that
> testing set gets properly resolved and sorted.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  .../selftests/bpf/prog_tests/resolve_btfids.c | 33 +++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> index 101785b49f7e..cc90aa244285 100644
> --- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> +++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> @@ -48,6 +48,15 @@ BTF_ID(struct,  S)
>  BTF_ID(union,   U)
>  BTF_ID(func,    func)
>
> +BTF_SET_START(test_set)
> +BTF_ID(typedef, S)
> +BTF_ID(typedef, T)
> +BTF_ID(typedef, U)
> +BTF_ID(struct,  S)
> +BTF_ID(union,   U)
> +BTF_ID(func,    func)
> +BTF_SET_END(test_set)
> +
>  static int
>  __resolve_symbol(struct btf *btf, int type_id)
>  {
> @@ -126,5 +135,29 @@ int test_resolve_btfids(void)
>                 }
>         }
>
> +       /* Check BTF_SET_START(test_set) IDs */
> +       for (i = 0; i < test_set.cnt && !ret; i++) {

nit: usual we just do `goto err_out;` instead of complicating exit
condition in a for loop

> +               bool found = false;
> +
> +               for (j = 0; j < ARRAY_SIZE(test_symbols); j++) {
> +                       if (test_symbols[j].id != test_set.ids[i])
> +                               continue;
> +                       found = true;
> +                       break;
> +               }
> +
> +               ret = CHECK(!found, "id_check",
> +                           "ID %d for %s not found in test_symbols\n",
> +                           test_symbols[j].id, test_symbols[j].name);

j == ARRAY_SIZE(test_symbols), you probably meant to get
test_set.ids[i] instead of test_symbol name/id?

> +               if (ret)
> +                       break;
> +
> +               if (i > 0) {
> +                       ret = CHECK(test_set.ids[i - 1] > test_set.ids[i],

nit: >= would be the invalid condition

> +                                   "sort_check",
> +                                   "test_set is not sorted\n");
> +               }
> +       }
> +
>         return ret;
>  }
> --
> 2.25.4
>
