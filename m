Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50F52D4F40
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgLJAQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgLJAQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:16:27 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA8C0613CF;
        Wed,  9 Dec 2020 16:15:46 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id w127so3056022ybw.8;
        Wed, 09 Dec 2020 16:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vLDEYYkT2hpiBULyrspPEgHbJL3ArZe0mPVQDQCmdE=;
        b=NoSpu5AjIWRE7XTDyPFeoWEF9hXZj9zh+RvAG9oJpWwmg4bmY2ZioLjmX6El0YgiHR
         GUJOHKtze1UrFNU3LQcXAdQu9zHcBro+DMkjyfFVACJzx4d8ytmKkGVcgak4OKjph1vq
         Y3SY6cEUdxy3g7gIEeUJYqNwONE5GQIHmJnidcSNv/xpFYtmy83hrxfYCDVSBKNlqn1x
         Dti5wHHdo1U8jp4u9RURuhWlZKZQkneM6MOrJsQoi9Ps1Qa+JQsbNzs9VWKy9TTJ+Slv
         Imdv96LCY6xybLFu40x25ZL/uIOdBrcYRg3TSF8DumMHN/5EaR8pXnIlflBY45htjwpo
         E14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vLDEYYkT2hpiBULyrspPEgHbJL3ArZe0mPVQDQCmdE=;
        b=opfkhBOuQjvHY0TtIxPkigSdCZMxDzYZE7udwTQ90VCKGQDqP6fpm97t1eqFrRN+Py
         d1JlW6MXlyRd5Q1pfshhiVej9Y1k7hAsV9VbDV3kgounDSkwzhK6XG7IeCBg/uWlpTXs
         BDHH1nHQDkKbhtTFRzvd3qe/TyGegsMzHQxyn+0b7q1C/dkL8lww+XeFTjRHcdpFOlOr
         eBiz19ZX9VVISj+PtJvDDsD5MKzU5XbcjUHZ6IrVhZEYjzmu26YKfVsvX0ifI8iimCKl
         gytZFiNWfuDpJGZ919GclqO0k5XKPOax0KcCwAUfS3INu+Nmtt0bwtvxvfuHIB5uBm40
         oiTQ==
X-Gm-Message-State: AOAM532iq0b2iGG3AmQ+Xw18BhuO4wL1ZKDU4ll6jVuOaEhhPK0eNnof
        cBrF2XIsnyvPrVebjZ7CYoJiMM0Ii+mi77Klww8=
X-Google-Smtp-Source: ABdhPJz9+9UeJEXAHIfSxiKDbo6dBfe5/LMe9BQn4fxXlRn7LwtR9bNM970fC1rO2yGWy+mJdxcO1Z4dLgX7FIDfMsY=
X-Received: by 2002:a25:6a05:: with SMTP id f5mr7285931ybc.459.1607559345847;
 Wed, 09 Dec 2020 16:15:45 -0800 (PST)
MIME-Version: 1.0
References: <X9FOSImMbu0/SV5B@ubuntu-x1>
In-Reply-To: <X9FOSImMbu0/SV5B@ubuntu-x1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Dec 2020 16:15:35 -0800
Message-ID: <CAEf4BzYAptUF+AxmkVk7BjJWRE6UaLkPowKM+pWbFuOV9Z4GGg@mail.gmail.com>
Subject: Re: BPF selftests build failure in 5.10-rc
To:     Seth Forshee <seth.forshee@canonical.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 2:24 PM Seth Forshee <seth.forshee@canonical.com> wrote:
>
> Building the BPF selftests with clang 11, I'm getting the following
> error:
>
>    CLNG-LLC [test_maps] profiler1.o
>  In file included from progs/profiler1.c:6:
>  progs/profiler.inc.h:260:17: error: use of unknown builtin '__builtin_preserve_enum_value' [-Wimplicit-function-declaration]
>                  int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
>                                ^
>  /home/ubuntu/unstable/tools/testing/selftests/bpf/tools/include/bpf/bpf_core_read.h:179:2: note: expanded from macro 'bpf_core_enum_value'
>          __builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENUMVAL_VALUE)
>          ^
>  1 error generated.
>  llc: error: llc: <stdin>:1:1: error: expected top-level entity
>  BPF obj compilation failed

Addressed by fb3558127cb6 ("bpf: Fix selftest compilation on clang 11")

>
> I see that test_core_reloc_enumval.c takes precautions around the use of
> __builtin_preserve_enum_value as it is currently only available in clang
> 12 nightlies. Is it possible to do something similar here? Though I see
> that the use of the builtin is not nearly so neatly localized as it is
> in test_core_reloc_enumval.c.
>
> Thanks,
> Seth
