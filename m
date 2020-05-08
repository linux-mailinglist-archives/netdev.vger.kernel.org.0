Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460E61CB8B2
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEHT6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHT6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:58:04 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630D6C061A0C;
        Fri,  8 May 2020 12:58:04 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g16so1662632qtp.11;
        Fri, 08 May 2020 12:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7AMlxAnIK8qYxwBNYZC5I95MD3pbRM5AHaqha3x5DY=;
        b=gi4z4brafd4CNkAiZNwjr5E96RfekteLpddfJyV0X0IOl3yuKBMP3TozlDtYgYEGQY
         6qHSo9vNOaabdEyYmM+atN8sMsbHXceLSnse9Hsm/4GaWlAE6BJia8YZ3pu4vH7m28hv
         yvAd98YRIuL1/K1j7lApfEWQixJf/+lEu5Ll7Pa/xaPw62KTDM03aFl+IBrFF63EOCrL
         9DlMCSPb0Yz6v2j2lFwtyw9/abR0Nk/DpxrQb2gP/0zrjDNZCTkCfDAMeS00GyWGgT0P
         ugPsf2ua8S6oyNYTTlbmHpGISbKL6amOI8EmSlp907Kh7lIMkaU5XbBLgO7eHQUsWsEO
         bzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7AMlxAnIK8qYxwBNYZC5I95MD3pbRM5AHaqha3x5DY=;
        b=ILJ6NMOj9UUvENP/yDjIRbHSElj5b4r7yZKX0VNCRG7W9dY+GK+ub0wcEVRQVdy3Xs
         m/e6MjxQGs6yrR6qJtNwOCK6CWS3wMKUDjHB9/dq+mTps83eA5bz1Ym9sZoAZFlWfBr0
         uRsLUrdbBFql/UXU9wTi0gVk7qVdnGr//Qn/dDg0UqrOueYCT46RDuxPTKZwUJwTdHOn
         CsuuzF9103DK+dQnbJrZl6b+IbxGPLx2RystTAZkYd+yiqUF5mQA+IhiNLT8kqeU1OaQ
         D8TyKWRU+vdRdnWlFfW217sY9K1TkM5wnpMbcmM2/IJBmPUUhRc2eUMX8aYj70OrgI3H
         6O6A==
X-Gm-Message-State: AGi0PuaNA3CBkAh5TgW8aWasQC+WX9C3lH6XxDdHaPKNUPxlPaxHly2T
        H+rIFOsIQvMOMla8AkRrj/D0Ld0FWVrxAGJG2AI=
X-Google-Smtp-Source: APiQypKe77gdoI1QE5qUEnsOmoEIuDgl712DkoBK1kXzE57lMio77ialctJvn3mW4ltO7pFyrGnr8VOCYusaAF5BTyg=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4642663qtn.141.1588967882430;
 Fri, 08 May 2020 12:58:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053940.1545530-1-yhs@fb.com>
In-Reply-To: <20200507053940.1545530-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:57:51 -0700
Message-ID: <CAEf4BzbLqD-mgdgUxOmc=TmEok+FFUm5ZKLUSS2sL7iXq72H-A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 21/21] tools/bpf: selftests: add bpf_iter selftests
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

On Wed, May 6, 2020 at 10:41 PM Yonghong Song <yhs@fb.com> wrote:
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
>   - test bpf prog returning 1
>
> The ipv6_route tests the following verifier change
>   - access fields in the variable length array of the structure.
>
> The netlink load tests the following verifier change
>   - put a btf_id ptr value in a stack and accessible to
>     tracing/iter programs.
>
> The anon bpf iterator also tests link auto attach through skeleton.
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
>   #2/12 prog-ret-1:OK
>   #2 bpf_iter:OK
>   Summary: 1/12 PASSED, 0 SKIPPED, 0 FAILED
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

I'm personally not a big fan of bpf_iter_test_kern_common.h approach
(including it and parameterizing with #define), I'd rather just
copy/paste BPF program code (it's just a few lines) and maybe even put
them in the same file/skeleton, less files to jump between. But that's
just personal preferences, so:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../selftests/bpf/prog_tests/bpf_iter.c       | 408 ++++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
>  .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
>  .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 +
>  .../selftests/bpf/progs/bpf_iter_test_kern4.c |  52 +++
>  .../bpf/progs/bpf_iter_test_kern_common.h     |  22 +
>  6 files changed, 508 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
>

[...]
