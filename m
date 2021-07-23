Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324703D30A4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 02:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhGVX0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbhGVX0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 19:26:01 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0EEC061575;
        Thu, 22 Jul 2021 17:06:36 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id r135so7950872ybc.0;
        Thu, 22 Jul 2021 17:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OxX3u3vyVwfMtMFMwC4VOTjPYyMSKaTBMRYibA2fugg=;
        b=UEn/P+gTIyrfPLUbFwbMce25DuNDpPag+mC91IGpJ60LlQ44udGnbbFbC7MWVibEdf
         RuzAqTo5T292GNegcl+VAfLWV4jkfz1UnotPrxZm1O9IORh/x8aaI3S0Y4kPQpBo8sUs
         QTSJBSqEEfC5M/O7yJrBAIuh0qPieCo6V/1zokm7avSUvPxRxxjFH2EB2Iea/PTf9+B5
         3S7knwxQ3i+xhRs+1aiMNqr/uiqj7Zx4Peku2LTT/tr4DJlB9+RcX4d6mgIQQDGcoDr4
         h3ijv0LgWqhUC92rU0WTtXnfo1G92QePytp75DdIOAoEqe2a6PbxI0w5sCc44rnaYqx4
         3K+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OxX3u3vyVwfMtMFMwC4VOTjPYyMSKaTBMRYibA2fugg=;
        b=MXAAy73HmuSw1gS0WJ5i7+DYra4NrwYnRvVZiXbuGFgBKPeNrSYqZN3NkitksUYCft
         HJ0S8DNfmXQuC5qoR9RvynuFUl1Q8p6aizXMj8k9ZbEgatv8YzpwEe/2zJhflqT+vRPd
         9KJFfNpoRda4P2Ypleu5hTR+2MBuKlFqF80IZP83BWPmYKrFnPMCakA99iiVNuFXnwfF
         5SFrqRYpixCaVmAO0zZbqxNvIOx+9A6ES/WrBx2h08cgBww88OHLJreo+/IjL47ML5ne
         ocLPe3+cftAU7WB50Gy2WCE30ylY7Dlfjpu5M0kccAoR/GNv0pc5ecb/V1pXmLdoimTX
         XF+A==
X-Gm-Message-State: AOAM531KR60HRlsiU+f80DtV1Cfndf2bH29b7F3Z0rpijKy71d2kJ9xI
        sRQf0rCE8FT9y+fLnLPbUjcuIVOGWXYT7WVTcwo=
X-Google-Smtp-Source: ABdhPJwNjARTV/H7GFz5/9S9NqCy8arkNHmIx/TYuAMt8yesm74gD6Qc8+F6ZCs4XhklquRcO45SNT3Pq9bcEM62Ozg=
X-Received: by 2002:a25:bd09:: with SMTP id f9mr2894797ybk.27.1626998795359;
 Thu, 22 Jul 2021 17:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <1626991540-21097-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1626991540-21097-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 17:06:24 -0700
Message-ID: <CAEf4BzbrFTPf80z6oomqrnY0dHieEBbVRuK-5D0XT=j_JaShJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add multidimensional array
 BTF-based data dump test
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 22, 2021 at 3:06 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> There are currently no multidimensional array tests for
> BTF-based data dumping.  In BTF, a multidimensional array is
> represented as an array with an element type of array.  However,
> pahole and llvm collapse multidimensional arrays into a
> one-dimensional array [1].  Accordingly, the test uses the BTF
> add interfaces to create a multidimensional char [2][4] array,
> and tests type-based display matches expectations.
>
> [1] See Documentation/bpf/btf.rst Section 2.2.3
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 39 +++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> index 52ccf0c..70d26cf 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> @@ -681,6 +681,45 @@ static void test_btf_dump_struct_data(struct btf *btf, struct btf_dump *d,
>  "}",
>                            { .cb = { 0, 0, 1, 0, 0},});
>
> +       /* multidimensional array; because pahole and llvm collapse arrays

Are you sure about llvm collapsing multi-dimensional arrays?... There
is entire progs/btf_dump_test_case_multidim.c testing
multi-dimensional array ;)

> +        * with multiple dimensions into a single dimension, we add a
> +        * multidimensional array explicitly.
> +        */
> +       type_id = btf__find_by_name(btf, "char");
> +       if (ASSERT_GT(type_id, 0, "find char")) {
> +               __s32 index_id, array1_id, array2_id;
> +               char strs[2][4] = { "one", "two" };

oh, it's a way too happy case :) can you try { "a", "", "abc", "ab" } as well?

> +
> +               index_id = btf__find_by_name(btf, "int");
> +               ASSERT_GT(index_id, 0, "find int");
> +
> +               array2_id = btf__add_array(btf, index_id, type_id, 4);
> +               ASSERT_GT(array2_id, 0, "add multidim 2");
> +
> +               array1_id = btf__add_array(btf, index_id, array2_id, 2);
> +               ASSERT_GT(array1_id, 0, "add multidim 1");
> +
> +               str[0] = '\0';
> +               ret = btf_dump__dump_type_data(d, array1_id, &strs, sizeof(strs), &opts);
> +               ASSERT_GT(ret, 0, "dump multidimensional array");
> +
> +               ASSERT_STREQ(str,
> +"(char[2][4])[\n"
> +"      [\n"
> +"              'o',\n"
> +"              'n',\n"
> +"              'e',\n"
> +"      ],\n"
> +"      [\n"
> +"              't',\n"
> +"              'w',\n"
> +"              'o',\n"
> +"      ],\n"
> +"]",

maybe use compact output for such tests, it won't lose much in terms
of readability and will be way more compact


> +                            "multidimensional char array matches");
> +       }
> +
> +
>         /* struct with bitfields */
>         TEST_BTF_DUMP_DATA_C(btf, d, "struct", str, struct bpf_insn, BTF_F_COMPACT,
>                 {.code = (__u8)1,.dst_reg = (__u8)0x2,.src_reg = (__u8)0x3,.off = (__s16)4,.imm = (__s32)5,});
> --
> 1.8.3.1
>
