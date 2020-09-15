Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAAA269DD1
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 07:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgIOF1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 01:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgIOF1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 01:27:03 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CF7C06174A;
        Mon, 14 Sep 2020 22:27:03 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id s19so1683036ybc.5;
        Mon, 14 Sep 2020 22:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lk+CY6J81kHHm/fhYkEfth8p3cjmwEi9LJuhc81snMk=;
        b=UzK6G/p3IBlITVRQCJ5QgIPFnBBZO9livPGtyDEqHLmLpLvi1aJYc3iAtHxe8ZOJfe
         v2RuS5bL2nH2p8n4/Kd09OMjnYHOZ2Dl5VD4vPUyLnIoyqBUAdW2GpFw7lFlUtoCUP3w
         hbjCc5tbZ5tNngMhAlWCAo1CQqfo6LT6zu5lw4QH33s6X713WMLAkkLNfcnzERxCQcjb
         6nwHv4XreM7/dRKXuqlEoJzsHoZ3YNGJcTr2Ednw42o3RHc6+nWKAAA4PpdaUz6yRd6v
         8sJpqsPY5qTCtxRS/SQ8Cx0/uOq/Ybd68aZUBuSORSYFV2OHnbHGjxTFMh0mZOiB8GeZ
         y30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lk+CY6J81kHHm/fhYkEfth8p3cjmwEi9LJuhc81snMk=;
        b=BuS5ZWoblvospFiqi7ns4Zq/ylCn1m5mhm7W8RfoIDb3tuHIXAVfEDxXFV/H3HUvMd
         Xz0MTcpVrQAz/z/kjNSH8Zev1EQJO3ZCjSA9Bbgg9wBH3aAN2ZfAa0XbY7Gn7PG2GINy
         yCGVOJHnIqDaNMbxGIlt2pM/LhBqUJ5rEtXT3DmiWz5VrHWmbkieVmAPJfx3pCp+dyCS
         6y6C7Q5B6Gn8YwDzRRX+153CmPvjX/0JF/c6Gfr40Gu8pMB3mhV2+HjSEYvXim8Ute1E
         AcYtCC2/kDNc1vKBFuWSrApQVR3PQK8BD0kX9ekJnkazeSZt9R3X+u8yXLRUfZAzKJSO
         nhpQ==
X-Gm-Message-State: AOAM533QOFuwujKyxBGTHUsIY7OEGvrRQskDIW/K36pbDvdPNTSFCeB0
        I/pNc6/pKNK8KlINxLJmfYcPXIYgkkCMZGTfw+0=
X-Google-Smtp-Source: ABdhPJzY1Ywzl+bYjFE3S5D78wZR80KKz9P/8wY9KRhG9x0U0+sUVLwFZvPYXz/OjrMJAsEz4ch7DPwnXNYRYYkh9nM=
X-Received: by 2002:a25:c049:: with SMTP id c70mr26007937ybf.403.1600147622477;
 Mon, 14 Sep 2020 22:27:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200915014341.2949692-1-andriin@fb.com>
In-Reply-To: <20200915014341.2949692-1-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 22:26:51 -0700
Message-ID: <CAEf4BzarJgmvKXwEL+48QvWZRxzx_035ovSFRfVRodZKra+pTw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: merge most of test_btf into test_progs
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 6:43 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Move almost 200 tests from test_btf into test_progs framework to be exercised
> regularly. Pretty-printing tests were left alone and renamed into
> test_btf_pprint because they are very slow and were not even executed by
> default with test_btf.
>
> All the test_btf tests that were moved are modeled as proper sub-tests in
> test_progs framework for ease of debugging and reporting.
>
> No functional or behavioral changes were intended, I tried to preserve
> original behavior as close to the original as possible. `test_progs -v` will
> activate "always_log" flag to emit BTF validation log.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>
> v1->v2:
>  - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
>    allowed GIT to detect that majority of  test_btf code was moved into
>    prog_tests/btf.c; so diff is much-much smaller;
>
>  tools/testing/selftests/bpf/.gitignore        |    2 +-
>  .../bpf/{test_btf.c => prog_tests/btf.c}      | 1069 +----------------
>  tools/testing/selftests/bpf/test_btf_pprint.c |  969 +++++++++++++++
>  3 files changed, 1033 insertions(+), 1007 deletions(-)
>  rename tools/testing/selftests/bpf/{test_btf.c => prog_tests/btf.c} (85%)
>  create mode 100644 tools/testing/selftests/bpf/test_btf_pprint.c

Looks like I forgot to check in a trivial Makefile change (test_btf ->
test_btf_pprint), but I'll hold off until we decided where
pretty-print BTF tests should live.

[...]
