Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F90277505
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgIXPQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgIXPQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 11:16:45 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EEBC0613CE;
        Thu, 24 Sep 2020 08:16:45 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id c13so4010122oiy.6;
        Thu, 24 Sep 2020 08:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ZjFFs9XvjNSC7lSQpGCgKAj11NusgQTDJrB1/7OLZrk=;
        b=KHhYhm7Ggj9Dam8InybGCK1XIIvYpyUzPUlVm7j30Up6K2tVVT1jScBsgU3QOy+IhL
         SGgZo9idby8zzuCQ90U9ra791GVtw4D704yhRNIiz40tP1of5aSCx0p1g3hBo4Pzu1Iq
         VBdifk6W6hXQYejBWOV70a2cidjsjN9vDYK5L5lpBD6naKHyA3U/KqZNL2evmxnmFzG+
         CyqrTvtQ4wLLYWOTxKplVBmWpw0L3PwxmrU7ZJZXW3/fLc/G5u1Mom0phXYh3XAWCguG
         1qVvdtUwjIXplOn/7yuohNCo9krxIh4Vq93UEFRRl9eWTQPNp78J1qXnECYZ2ybndzAJ
         e8Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ZjFFs9XvjNSC7lSQpGCgKAj11NusgQTDJrB1/7OLZrk=;
        b=cnQ16q65kCTns9BGEf5w/MoP7G3Fojkc82Axiyz6XTBCU6iWr/QZivmaxZ3pM04kAO
         +vCsXpVy3qy9EDjcK5s2jAAAYmVKWsw3+VnoQ/0ugdcYwQxaQrmwfnimy3sgows5S+sR
         KhSj21vYCHEllD9dWqu8fT8YwGV5JLqwxkxIp4pFB5i+HYuCtb1/xTqZfPeGKr1EyQzR
         Tw8U6a8e5E/HKv7zS6VFpHoMB2zVjLH1+WmTZf9OCWkVY6rTE9bAFrQ5KgpYkIDb1S1z
         sfB2FoK9PUboVSjCWof75xM+E689avhOhhmiKCUwRwKK6WettlUum915VKM4Srrn0jR8
         96og==
X-Gm-Message-State: AOAM531oVxnsf2pAY9UcFu70/ptMqcaSzn8P45MATjhbsxaqN518BU+T
        186gyJHXXnp/7pR6yBTGfQg3ZVEACCkUQw==
X-Google-Smtp-Source: ABdhPJzYR6rmJ2LQvsaitrtmVE4mw2vSSuf0PAQ3HK6fOJuFIF1P3yaXPsIpNwjggTePffAC1r9XGg==
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr2805769oij.154.1600960605128;
        Thu, 24 Sep 2020 08:16:45 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j34sm854982otc.15.2020.09.24.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 08:16:44 -0700 (PDT)
Date:   Thu, 24 Sep 2020 08:16:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <5f6cb85452d72_4939c20820@john-XPS-13-9370.notmuch>
In-Reply-To: <20200923155436.2117661-1-andriin@fb.com>
References: <20200923155436.2117661-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next 0/9] libbpf: BTF writer APIs
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> This patch set introduces a new set of BTF APIs to libbpf that allow to
> conveniently produce BTF types and strings. Internals of struct btf were
> changed such that it can transparently and automatically switch to writable
> mode, which allows appending BTF types and strings. This will allow for libbpf
> itself to do more intrusive modifications of program's BTF (by rewriting it,
> at least as of right now), which is necessary for the upcoming libbpf static
> linking. But they are complete and generic, so can be adopted by anyone who
> has a need to produce BTF type information.


I had this floating around on my todo list thanks a lot for doing it. I can
remove a couple more silly hacks I have floating around now!

> 
> One such example outside of libbpf is pahole, which was actually converted to
> these APIs (locally, pending landing of these changes in libbpf) completely
> and shows reduction in amount of custom pahole code necessary and brings nice
> savings in memory usage (about 370MB reduction at peak for my kernel
> configuration) and even BTF deduplication times (one second reduction,
> 23.7s -> 22.7s). Memory savings are due to avoiding pahole's own copy of
> "uncompressed" raw BTF data. Time reduction comes from faster string
> search and deduplication by relying on hashmap instead of BST used by pahole's
> own code. Consequently, these APIs are already tested on real-world
> complicated kernel BTF, but there is also pretty extensive selftest doing
> extra validations.
> 
> Selftests in patch #9 add a set of generic ASSERT_{EQ,STREQ,ERR,OK} macros
> that are useful for writing shorter and less repretitive selftests. I decided
> to keep them local to that selftest for now, but if they prove to be useful in
> more contexts we should move them to test_progs.h. And few more (e.g.,
> inequality tests) macros are probably necessary to have a more complete set.
> 
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>

For the series, I have a few nits I'll put in the patches, mostly spelling 
errors and a couple questions, otherwise this is awesome thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> Andrii Nakryiko (9):
>   libbpf: refactor internals of BTF type index
>   libbpf: remove assumption of single contiguous memory for BTF data
>   libbpf: generalize common logic for managing dynamically-sized arrays
>   libbpf: extract generic string hashing function for reuse
>   libbpf: allow modification of BTF and add btf__add_str API
>   libbpf: add btf__new_empty() to create an empty BTF object
>   libbpf: add BTF writing APIs
>   libbpf: add btf__str_by_offset() as a more generic variant of
>     name_by_offset
>   selftests/bpf: test BTF writing APIs
> 
>  tools/lib/bpf/bpf.c                           |    2 +-
>  tools/lib/bpf/bpf.h                           |    2 +-
>  tools/lib/bpf/btf.c                           | 1311 +++++++++++++++--
>  tools/lib/bpf/btf.h                           |   41 +
>  tools/lib/bpf/btf_dump.c                      |    9 +-
>  tools/lib/bpf/hashmap.h                       |   12 +
>  tools/lib/bpf/libbpf.map                      |   22 +
>  tools/lib/bpf/libbpf_internal.h               |    3 +
>  .../selftests/bpf/prog_tests/btf_write.c      |  271 ++++
>  9 files changed, 1553 insertions(+), 120 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c
> 
> -- 
> 2.24.1
> 


