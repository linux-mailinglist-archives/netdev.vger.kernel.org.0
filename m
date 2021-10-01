Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8552241EB64
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353730AbhJALIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353454AbhJALIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:08:30 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A29DC061775
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 04:06:46 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso6498211wme.0
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 04:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Ic8xXiFIaM5JGwOBFHZCQicrwrYtjcMu6SEU2TZ/HzU=;
        b=xveUO6JABTX6wVw2mDKiysxksM8SH6FnuIPhIoGVMSaHIn6H0VD9NKBKFi+sOge3lN
         J+k3GBgST1yZyd2ZsjRmG1Yzo17/kj6ISXX1WoMhqpVXcYkxo/6T6CM9JhcHjyd7qUOl
         MhO4lqeNb3C+6WtpbOwfhT3UqYukYb+VXdrlPmchA8pr/eWa9DuPP7LCFTLiGlwEklXp
         Gt2p+vk42HNGfSSqk4R8/gxL+fCDqE+gCjRiGvfndDdOjf/G7UfRziAm3yyPlGkV/g0A
         N3c6l5+FfalAY3woJmPZj3CcHbUhz+WUevTW3lKIw+2uJOa2jBJxID/XRTyEzJdwRSY1
         7oBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Ic8xXiFIaM5JGwOBFHZCQicrwrYtjcMu6SEU2TZ/HzU=;
        b=NkYwLt7lgp5nbU7IMf2QrWg7tcjod5ITBnYy7bGQk4KI23zCGaGn0MYeY0yzVIxp2K
         v+QTEDOlKYvH2sg/DEv5wz+RRL0XpGRV4cqq1zqkkaWe24CdWqbhbv8nM33gHT8ZqY5m
         mCV0TFHLP+inQMGaFTRVAB6DVsSCPd0peVEKNqx7psTrYY+lVBpY4quB3en9Ke9RNwRg
         eN22aS2JnNuu3/0VR92AEohDo5TrLFY5wXC1gU4FuUnkwfTRF4Lf68+dzCfGBZwmBl9P
         aHUijE9nqYIIh8Fe5FVCG5wUuT9aYUw+NmWYcAOGuyInUnxvc/pKSwosVwDzPE5RhAG+
         Iqqw==
X-Gm-Message-State: AOAM5325EcIQF3oyLNj3R9C0OSUrQnZ8YbjdG+QH1MhPX9Sb6JWmWupg
        ey6LiGsQM7/VMlFudDRjti+9Pg==
X-Google-Smtp-Source: ABdhPJxbDoDy2kazexW//RNpVrkMlwjdEz2/ZLPKYlKUl3giJE+FrAoXmwQECe+3ot8yERe4gzizgA==
X-Received: by 2002:a1c:7d44:: with SMTP id y65mr3728469wmc.181.1633086405139;
        Fri, 01 Oct 2021 04:06:45 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.91.69])
        by smtp.gmail.com with ESMTPSA id f15sm5221859wrd.44.2021.10.01.04.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 04:06:44 -0700 (PDT)
Message-ID: <37d25d01-c6ad-4ff9-46e2-236c60369171@isovalent.com>
Date:   Fri, 1 Oct 2021 12:06:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH bpf-next 6/9] bpf: iterators: install libbpf headers when
 building
Content-Language: en-US
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210930113306.14950-1-quentin@isovalent.com>
 <20210930113306.14950-7-quentin@isovalent.com>
 <354d2a7b-3dfc-f1b2-e695-1b77d013c621@isovalent.com>
In-Reply-To: <354d2a7b-3dfc-f1b2-e695-1b77d013c621@isovalent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-09-30 13:17 UTC+0100 ~ Quentin Monnet <quentin@isovalent.com>
> 2021-09-30 12:33 UTC+0100 ~ Quentin Monnet <quentin@isovalent.com>
>> API headers from libbpf should not be accessed directly from the
>> library's source directory. Instead, they should be exported with "make
>> install_headers". Let's make sure that bpf/preload/iterators/Makefile
>> installs the headers properly when building.
> 
> CI complains when trying to build
> kernel/bpf/preload/iterators/iterators.o. I'll look more into this.

My error was in fact on the previous patch for kernel/preload/Makefile,
where iterators.o is handled. The resulting Makefile in my v1 contained:

	bpf_preload_umd-objs := iterators/iterators.o
	bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz

	$(obj)/bpf_preload_umd: $(LIBBPF_A)

This declares a dependency on $(LIBBPF_A) for building the final
bpf_preload_umd target, when iterators/iterators.o is linked against the
libraries. It does not declare the dependency for iterators/iterators.o
itself. So when we attempt to build the object file, libbpf has not been
compiled yet (not an issue per se), and the API headers from libbpf have
not been installed and made available to iterators.o, causing the build
to fail.

Before this patch, there was no issue because the headers would be
included directly from tools/lib/bpf, so they would always be present.
I'll fix this by adding the relevant dependency, and send a v2.

As a side note, I couldn't reproduce the issue locally or in the VM for
the selftests, I'm not sure why. I struggled to get helpful logs from
the kernel CI (kernel build in non-verbose mode), so I ended up copying
the CI infra (running on kernel-patches/bpf on GitHub) to my own GitHub
repository to add debug info and do other runs without re-posting every
time to the mailing list. In case anyone else is interested, I figured I
might share the steps:

- Clone the linux repo on GitHub, push the bpf-next branch
- Copy all files and directories from the kernel-patches/vmtest GitHub
repo (including the .github directory) to the root of my linux repo, on
my development branch.
- Update the checks on "kernel-patches/bpf" repository name in
.github/workflows/test.yaml, to avoid pulling new Linux sources and
overwriting the files on my branch.
- (Add as much build debug info as necessary.)
- Push the branch to GitHub and open a PR against my own bpf-next
branch. This should trigger the Action.

Or was there a simpler way to test my set on the CI, that I ignore?

Quentin
