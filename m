Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17FF175513
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 19:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbfGYRF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 13:05:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42882 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbfGYRF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 13:05:26 -0400
Received: by mail-qt1-f193.google.com with SMTP id h18so49791506qtm.9
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 10:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ut6hFBrFnGKe0mpKp6qcHRNZGdFalNpeh95hk6/89Ss=;
        b=ItPHLPmOwn5mUXNzueE9TRwwcQAQhJcH0Sv0IfwvePdyCoJv9IyEHnvLMH0BSvjJBZ
         3nrv+KtM63EY8uCQzyXZbvbaVWMUs72dp0NHpG7vxfMF/uB/vUoBPxe2IipeO79kUIKx
         iWPYW3XvpN4WgOl6PK3JhrgO1EZ6oqzVv2wi5vrxKqELpqmFGHbcT6Cd4CeBoV4DZaXq
         /gG9aGzTHHcKgWfKcSRx1VUXYARTqJWxdv+/CoBK/JyG+5AQ+PcE3tvE2TILMbBJhc7b
         R1kNwl843mauGbTCzBBvR9bEL6edSEytHdWsGWoNeVHCNXMaH95kQ1a1hL2tFvMAnfr6
         G7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ut6hFBrFnGKe0mpKp6qcHRNZGdFalNpeh95hk6/89Ss=;
        b=mACTfeVJeyATGcmdce5VxvjeAcWjvOlmeLjjrjdm9R4KKFIyp4uz4cKVjHmU9RGymE
         AMqeeC5QFODJ8XSE4sgSurMcwQd1HQQ433Z0wDyouLNkguR5OXbGaNq4pNamPVmRYcCJ
         bfFQLYA+epN1Azp/78CvGLZukvi2JNLq9qb98qSJwcyky2eU78lp4UdxyYoOIEZ6xGcY
         kaZsed8qUR4K9jHnTO4qu/JjShTX+BjyHpnst0AcqHNLeNZ4QzuIGCh04Ej13gcR6CxJ
         NDyNutrFbbOSCHDjfOOW7OiVaw0IIXMSNm7TPyb55Nbzfdlm0xx2cv6vjk1nfGtTV0Vu
         hR3g==
X-Gm-Message-State: APjAAAUB2vklH3n2f63Ht6IO895JiKJr8q6fGtJ8qpqwhdRVTbBO806c
        IISg2T4f1eRDlK3ZDvOqfm2tqRlYSxfFIPqH54/7Lg==
X-Google-Smtp-Source: APXvYqzgEoRAqKMO9PTHDW3sV+Uw58MVcPR9KD6txH/Ae/GwAGQtpefaeIvnWFCEInHk4TvYm1HwBeXWvjd36h644FM=
X-Received: by 2002:ac8:688f:: with SMTP id m15mr6753317qtq.26.1564074324811;
 Thu, 25 Jul 2019 10:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
From:   Petar Penkov <ppenkov@google.com>
Date:   Thu, 25 Jul 2019 10:05:12 -0700
Message-ID: <CAG4SDVVe5s-MZJDQjMGS9_QkTnSsaP7MRuxXs-AHp8bA6sSiPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/7] bpf/flow_dissector: support input flags
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks! For the series:

Acked-by: Petar Penkov <ppenkov@google.com>

On Thu, Jul 25, 2019 at 8:33 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> C flow dissector supports input flags that tell it to customize parsing
> by either stopping early or trying to parse as deep as possible.
> BPF flow dissector always parses as deep as possible which is sub-optimal.
> Pass input flags to the BPF flow dissector as well so it can make the same
> decisions.
>
> Series outline:
> * remove unused FLOW_DISSECTOR_F_STOP_AT_L3 flag
> * export FLOW_DISSECTOR_F_XXX flags as uapi and pass them to BPF
>   flow dissector
> * add documentation for the export flags
> * support input flags in BPF_PROG_TEST_RUN via ctx_{in,out}
> * sync uapi to tools
> * support FLOW_DISSECTOR_F_PARSE_1ST_FRAG in selftest
> * support FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL in kernel and selftest
> * support FLOW_DISSECTOR_F_STOP_AT_ENCAP in selftest
>
> Pros:
> * makes BPF flow dissector faster by avoiding burning extra cycles
> * existing BPF progs continue to work by ignoring the flags and always
>   parsing as deep as possible
>
> Cons:
> * new UAPI which we need to support (OTOH, if we need to deprecate some
>   flags, we can just stop setting them upon calling BPF programs)
>
> Some numbers (with .repeat = 4000000 in test_flow_dissector):
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>
> The improvement is around 10%, but it's in a tight cache-hot
> BPF_PROG_TEST_RUN loop.
>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
>
> Stanislav Fomichev (7):
>   bpf/flow_dissector: pass input flags to BPF flow dissector program
>   bpf/flow_dissector: document flags
>   bpf/flow_dissector: support flags in BPF_PROG_TEST_RUN
>   tools/bpf: sync bpf_flow_keys flags
>   selftests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
>   bpf/flow_dissector: support ipv6 flow_label and
>     FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
>   selftests/bpf: support FLOW_DISSECTOR_F_STOP_AT_ENCAP
>
>  Documentation/bpf/prog_flow_dissector.rst     |  18 ++
>  include/linux/skbuff.h                        |   2 +-
>  include/net/flow_dissector.h                  |   4 -
>  include/uapi/linux/bpf.h                      |   6 +
>  net/bpf/test_run.c                            |  39 ++-
>  net/core/flow_dissector.c                     |  14 +-
>  tools/include/uapi/linux/bpf.h                |   6 +
>  .../selftests/bpf/prog_tests/flow_dissector.c | 242 +++++++++++++++++-
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  46 +++-
>  9 files changed, 359 insertions(+), 18 deletions(-)
>
> --
> 2.22.0.657.g960e92d24f-goog
