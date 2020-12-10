Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109A72D5BFB
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 14:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389519AbgLJNhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 08:37:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38039 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732914AbgLJNhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 08:37:18 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1knM7X-0005R0-PU
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 13:36:35 +0000
Received: by mail-il1-f200.google.com with SMTP id m14so4371297ila.16
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 05:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mwzWNqwukiO9666dcy5UFimaTAhAAx9w5jcf7BvZNzs=;
        b=tMGcIZ4eg+1ybIeoyJGAhaa84QqJOr4j2tQgsJt3tcl/6ENrC7WrzF0l7A4awOX+1X
         d0lucYd67FbcKNJpgsbiDmUg3G+3RvaXUWev711/TWOgGKWAIGmncbjajlf2fM3NFXyt
         e6t+FAZfgAdIvoi1wHGzQ5e1kWZjdOg6rqmbDdl5tS7Nkp+XGaujUmiDYfxviej/Ec7z
         eCROEgUiOZJ4yAusP6Vn6KbZacg+Oi/iByH5ZNuEQisIx/cQFMfQV4w3dRem8JNtyXFU
         Y1pm98CG0c0tcl5f3rI3RecvMzeIewq5UqNuWB+Q94vODork6uSjK6GPn7VrAqvzs/Qj
         HGuQ==
X-Gm-Message-State: AOAM533pa/D1SgHpUzNxJ1qW2CcBhvUyeQFkcpWXsOU4nz4MAIGeptm/
        M6+YdeE7puqqIzJMlpN2+RsmzCDeLzI8xRcuhu91LABb6hSJGbTtRteQjBNlHFPvvSjiphr7VRg
        j/nM0XrxyJQt4nP5tFqcbRe/7b3YqUp9DAA==
X-Received: by 2002:a05:6638:2a5:: with SMTP id d5mr8717989jaq.92.1607607394872;
        Thu, 10 Dec 2020 05:36:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDAlRH9nDs2/sDKF2FW7RjAYQtS5kLIoWftt3jEkBIPJZ2Ls4/PB9s1dnWAzZ7dDe7Fi0g6A==
X-Received: by 2002:a05:6638:2a5:: with SMTP id d5mr8717977jaq.92.1607607394700;
        Thu, 10 Dec 2020 05:36:34 -0800 (PST)
Received: from localhost ([2605:a601:ac0f:820:5f:df71:1517:60e9])
        by smtp.gmail.com with ESMTPSA id y14sm3240284ilb.66.2020.12.10.05.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 05:36:34 -0800 (PST)
Date:   Thu, 10 Dec 2020 07:36:33 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: BPF selftests build failure in 5.10-rc
Message-ID: <X9IkYa6D9QrjooOd@ubuntu-x1>
References: <X9FOSImMbu0/SV5B@ubuntu-x1>
 <CAEf4BzYAptUF+AxmkVk7BjJWRE6UaLkPowKM+pWbFuOV9Z4GGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYAptUF+AxmkVk7BjJWRE6UaLkPowKM+pWbFuOV9Z4GGg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 04:15:35PM -0800, Andrii Nakryiko wrote:
> On Wed, Dec 9, 2020 at 2:24 PM Seth Forshee <seth.forshee@canonical.com> wrote:
> >
> > Building the BPF selftests with clang 11, I'm getting the following
> > error:
> >
> >    CLNG-LLC [test_maps] profiler1.o
> >  In file included from progs/profiler1.c:6:
> >  progs/profiler.inc.h:260:17: error: use of unknown builtin '__builtin_preserve_enum_value' [-Wimplicit-function-declaration]
> >                  int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
> >                                ^
> >  /home/ubuntu/unstable/tools/testing/selftests/bpf/tools/include/bpf/bpf_core_read.h:179:2: note: expanded from macro 'bpf_core_enum_value'
> >          __builtin_preserve_enum_value(*(typeof(enum_type) *)enum_value, BPF_ENUMVAL_VALUE)
> >          ^
> >  1 error generated.
> >  llc: error: llc: <stdin>:1:1: error: expected top-level entity
> >  BPF obj compilation failed
> 
> Addressed by fb3558127cb6 ("bpf: Fix selftest compilation on clang 11")

Great, thanks!

> 
> >
> > I see that test_core_reloc_enumval.c takes precautions around the use of
> > __builtin_preserve_enum_value as it is currently only available in clang
> > 12 nightlies. Is it possible to do something similar here? Though I see
> > that the use of the builtin is not nearly so neatly localized as it is
> > in test_core_reloc_enumval.c.
> >
> > Thanks,
> > Seth
