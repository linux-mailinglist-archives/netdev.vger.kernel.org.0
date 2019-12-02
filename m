Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EC110F22E
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfLBVaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:30:39 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:35063 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfLBVai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:30:38 -0500
Received: by mail-qv1-f66.google.com with SMTP id d17so558006qvs.2;
        Mon, 02 Dec 2019 13:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4zi5mDjG7GvuPI/H2ovSKyzODiKJhmZrfb3z2/tiX+o=;
        b=ht6DXfgqJyVY+0ZSWtSXYjOjoPv9CbCN6Hq4g+TplNaU2DfkOhDt9BQAuEqiNYFMsg
         hj2tGbWs/YBWh1gSZeN5HTZBQYM1R1m6Per/hLxj4qPOdE6UxTEFmK+lMjdTJZYXex6R
         Tol1EY2pRS6SqsmxDQvlEkmMDwusQlQYmpJqL64FAs0pp1qhqJ4Y9kj4ipc9eVsIRU1I
         4Sko7ALCn8phcphk3D1sWfZpZrZjS4ht/SfvH4v2sJSbIYS9YnrcmPIbdmYrt+v1g53/
         DGTDTKZhShaXKoCFiBl60EsFp18v2QBw3GGX8UKHLwAViqTkApD7z9sR9lZajioNDK4b
         UDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4zi5mDjG7GvuPI/H2ovSKyzODiKJhmZrfb3z2/tiX+o=;
        b=CaoLVghqaPI8depM5sCot6OMz9+CyeogFiXOuwslF3FFYyE+ODyhN7fM/AJaw9PwWC
         8mk5vl6IGfMF/8T2oKIfsdQVaaI6ZSXEyx+F9CtLljG2Fhk2G400HPbg/f23b+SvPHcR
         y3DW6upW5GoF10+RRYST4GWdIFh7FD4mEhQ7kBA5a7hhUTeypkJzi1C+MVwT6MfBB7MF
         aBweI8A1Ca7vj28ZosadN99dN1ZxMopY8ywjGOEogz9k5dNyjQdUr4W8oNp6cn4NwJgq
         AGYinbAioKkLjKM7ulRl9U4XuO9ZYiZBHZkCk65K0qkISGcJKwEcZG2OYGRJnlUE9Cc9
         IS1g==
X-Gm-Message-State: APjAAAUgAlGhxIZ9MK6UFGQotNQHp0DQYA8xMqy6Flk9nX9m213YDJ7p
        XaHkHePiVcCSdPPpYV+tbqSQyHsjLrHMqj3hVsO/MekC
X-Google-Smtp-Source: APXvYqw11ld9qTVeKypVE7HqkXxx41KhtL8KBb47z5uxgrapXr4RC7a6VyDpOdMd6M4yo29BtuMooD+FFusjqUTmuKg=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr1401994qvb.163.1575322236949;
 Mon, 02 Dec 2019 13:30:36 -0800 (PST)
MIME-Version: 1.0
References: <20191202202112.167120-1-sdf@google.com>
In-Reply-To: <20191202202112.167120-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 13:30:25 -0800
Message-ID: <CAEf4BzZGOSAFU-75hymmv2pThs_WJd+o25zFO0q4XQ=mWpYgZA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: bring back c++ include/link test
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 12:28 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> converted existing c++ test to c. We still want to include and
> link against libbpf from c++ code, so reinstate this test back,
> this time in a form of a selftest with a clear comment about
> its purpose.
>
> Fixes: 5c26f9a78358 ("libbpf: Don't use cxx to test_libpf target")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

thanks for clean up! Looks good except for explicit -lelf below.

>  tools/lib/bpf/.gitignore                                    | 1 -
>  tools/lib/bpf/Makefile                                      | 5 +----
>  tools/testing/selftests/bpf/.gitignore                      | 1 +
>  tools/testing/selftests/bpf/Makefile                        | 6 +++++-
>  .../test_libbpf.c => testing/selftests/bpf/test_cpp.cpp}    | 0
>  5 files changed, 7 insertions(+), 6 deletions(-)
>  rename tools/{lib/bpf/test_libbpf.c => testing/selftests/bpf/test_cpp.cpp} (100%)
>

[...]

>
> @@ -317,6 +317,10 @@ verifier/tests.h: verifier/*.c
>  $(OUTPUT)/test_verifier: test_verifier.c verifier/tests.h $(BPFOBJ) | $(OUTPUT)
>         $(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
>
> +# Make sure we are able to include and link libbpf against c++.
> +$(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
> +       $(CXX) $(CFLAGS) $^ -lelf -o $@

let's use $(LDLIBS) instead here

> +
>  EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)                                    \
>         prog_tests/tests.h map_tests/tests.h verifier/tests.h           \
>         feature $(OUTPUT)/*.o $(OUTPUT)/no_alu32 $(OUTPUT)/bpf_gcc
> diff --git a/tools/lib/bpf/test_libbpf.c b/tools/testing/selftests/bpf/test_cpp.cpp
> similarity index 100%
> rename from tools/lib/bpf/test_libbpf.c
> rename to tools/testing/selftests/bpf/test_cpp.cpp
> --
> 2.24.0.393.g34dc348eaf-goog
>
