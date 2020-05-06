Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55E71C6916
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgEFGj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEFGj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:39:57 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B0C061A0F;
        Tue,  5 May 2020 23:39:56 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id p13so193246qvt.12;
        Tue, 05 May 2020 23:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/Sv+P+9llwkKL5rRoqkcSud7Yg3ZcZ2k+WEatZrTTw=;
        b=CwVtsZzE0QC5J8DCTwC5TG0u93u4uB9TGg9srs4xZW0eovhU471fNAaqkRbOVmO8Fp
         YaqZUiVgsDy/6LAVPXIFSYjUNUfW8TPDoM1Lf5YYvzcy7AHcb3gEYaMr3rmVo9BsLtPG
         i0TBWSUEZS9rGGcFyH49t8ppXmAdmctZ6N/i3PsfMnnd/0zI6o5C4jHc70SzWHP8u06z
         v2EMgYmSmSR4aljBpiiX6fO2+nPe/wJ+kX7RcnfXBycQH58vYsRZgjPjP4I5uLqu/HiQ
         tvg6TVePV0AMzQNNkTSkQjLxHg2AQtJZ9lvJMjDT0XNZcXfXFwSwnrceBEJpu1gX4gyE
         ziJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/Sv+P+9llwkKL5rRoqkcSud7Yg3ZcZ2k+WEatZrTTw=;
        b=goSxhgxFySWTPzAbm0JlsldoSyShRioqBpWoJIyCrfWzZ1ZkrMHyjmJEbBsHlVB+Ch
         4eG+e3SJdD+zlNPMkyINYxScmhEgVn1tkjs17ndbxFnm35yY74QyFibDEqLJ+KGk5bRr
         bDE0O/fyjagqEPCen3CmdhTkZ4jG8bOiO4XBqCH0sg1gOpV6nFlxDl8Dseo5VomDALTL
         8SIwImfq4Gw3Us/ePYXyLBy81bk10lR0VYg5y3x5YTrT3mDGMBivuKArw0Zq+HTvuIIj
         ZmPdFW3YmGhg42v6mrzQYPjF1WVShkALxdlLMefWN3C+w39z1Pt0HtS8k8EOz4N3rrat
         ZCpQ==
X-Gm-Message-State: AGi0PuY6GeVOmVXBVC0m+fF7AI6rul0TY0L03oTaocCgv25tj7UK97rp
        7DgGBztignhEpixVRhMcV1MjCQB38ddyFmnbVs4=
X-Google-Smtp-Source: APiQypLxCced2MRd2SxGb2UL9AaXz5iFoKjtI/uM+9glYvIdeZLEhNZVpiASZTnCMLYTAfItGcHf1V+LvV+NAOar01k=
X-Received: by 2002:ad4:4c03:: with SMTP id bz3mr6426901qvb.224.1588747195968;
 Tue, 05 May 2020 23:39:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062610.2049229-1-yhs@fb.com>
In-Reply-To: <20200504062610.2049229-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 23:39:44 -0700
Message-ID: <CAEf4BzZ7Jx9ZkHbRpj4Nzy1nJLhLaUoX6MTiTKvrLO2zPKFrBg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 20/20] tools/bpf: selftests: add bpf_iter selftests
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

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> The added test includes the following subtests:
>   - test verifier change for btf_id_or_null
>   - test load/create_iter/read for
>     ipv6_route/netlink/bpf_map/task/task_file
>   - test anon bpf iterator
>   - test anon bpf iterator reading one char at a time
>   - test file bpf iterator
>   - test overflow (single bpf program output not overflow)
>   - test overflow (single bpf program output overflows)
>
> Th ipv6_route tests the following verifier change
>   - access fields in the variable length array of the structure.
>
> The netlink load tests th following verifier change
>   - put a btf_id ptr value in a stack and accessible to
>     tracing/iter programs.
>
>   $ test_progs -n 2
>   #2/1 btf_id_or_null:OK
>   #2/2 ipv6_route:OK
>   #2/3 netlink:OK
>   #2/4 bpf_map:OK
>   #2/5 task:OK
>   #2/6 task_file:OK
>   #2/7 anon:OK
>   #2/8 anon-read-one-char:OK
>   #2/9 file:OK
>   #2/10 overflow:OK
>   #2/11 overflow-e2big:OK
>   #2 bpf_iter:OK
>   Summary: 1/11 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks good overall. bpf_link__disconnect() is wrong, though, please
remove it. With that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/bpf_iter.c       | 390 ++++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
>  .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
>  .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 +
>  .../selftests/bpf/progs/bpf_iter_test_kern4.c |  48 +++
>  .../bpf/progs/bpf_iter_test_kern_common.h     |  22 +
>  6 files changed, 486 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
>

[...]

> +
> +free_link:
> +       bpf_link__disconnect(link);

bpf_link__disconnect() actually will make destroy() below not close
link. So no need for it. Same below in few places.

> +       bpf_link__destroy(link);
> +}
> +

[...]
