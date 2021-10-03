Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17281420396
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhJCTWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 15:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhJCTWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 15:22:36 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD21FC061780
        for <netdev@vger.kernel.org>; Sun,  3 Oct 2021 12:20:47 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t2so2814756wrb.8
        for <netdev@vger.kernel.org>; Sun, 03 Oct 2021 12:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=l8KalBRoprd2/whbgXpOCEgrvg7EJ+HvtGGElZ3g6D8=;
        b=mRPKPjrhQhvRtxSSp3rysn9li3GQ0xI8MuedB9Ar59NthQQSKr+zNa7fAUGqnl5wrv
         E+q5sGzNhBhezCRC/FbGW8qQo1g1GjzIIchesTVeg/kbmZYv3A3mz5bqqJ8ut1PEDLA4
         y/Fs5ZfMgLrqe86YfVmz7zp1/QLZOAvepK/PMUQbnphVx3RIqvnCHMdv0tBsyQ7EHhRe
         zVxInQCZDseEtDVQEadRs783T/2X14izQt/x4dGlXihLJS4dGHetu+XdRwCgVdOp+yyk
         3NMqX05L3ZiyKenvOrGlIyNFXExffUnK3tPulZ0wbDZG4I61O1wXDT4EK094TiZYI6Ce
         NMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=l8KalBRoprd2/whbgXpOCEgrvg7EJ+HvtGGElZ3g6D8=;
        b=tP86zv3LMCW9rCvJS+In4/dRA0I7oXmsDEkZTaTjFKBfBFDrOFObFbipVTKaPZ8XZw
         amR68zAY9LBioAcAve6ebOynb74uueemI2xY17GDiYHujbnuEQgh+5mj4dlab7uj4ExO
         v/vQNkw/eH0yeQ3+4RCDpDx8ZPK1V5zAKLkR99X0h7iTp9IhYTDGRlN9jictgXKZTA7w
         mbnnqkV5lfYiwRUbotPdOFmyC4bTMH9tlcNxXBRlqHc3oqA17or2fy3TJTe49L8FlaEY
         MstlijkifnWGArGo3BLyl2xRVvkRuKn2N4JzYzTQOwpROLmml68vuV/AUfeSFM6zTtbl
         6nwg==
X-Gm-Message-State: AOAM532+DwbQlt8cG4Kc6CbhGIoiR2XZ3Bb0T/68Grwzsf5TkDAyOEuQ
        /q1LNuLkPENiwDDf7dinT8LlqnxExsjDLFMA
X-Google-Smtp-Source: ABdhPJytdYBtP58n1cMZAlf4PVaZc1+caK/+MHANAKaMmk0SPthS/5Aq3zrFfczqAfKbsz3WqJps3A==
X-Received: by 2002:adf:de02:: with SMTP id b2mr10290219wrm.42.1633288846284;
        Sun, 03 Oct 2021 12:20:46 -0700 (PDT)
Received: from [192.168.1.11] ([149.86.88.77])
        by smtp.gmail.com with ESMTPSA id m4sm13679120wrx.81.2021.10.03.12.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Oct 2021 12:20:45 -0700 (PDT)
Message-ID: <9e1461e2-7062-df4f-a6e7-bf64988aa52d@isovalent.com>
Date:   Sun, 3 Oct 2021 20:20:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH bpf-next v2 0/9] install libbpf headers when using the
 library
Content-Language: en-US
From:   Quentin Monnet <quentin@isovalent.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211001110856.14730-1-quentin@isovalent.com>
 <CAEf4Bza+C5cNJbvw_n_pR_mVL0rPH2VkZd-AJMx78Fp_m+CpRQ@mail.gmail.com>
 <CACdoK4LU-uigbtQw63Yacd_AOzv+_fWuhL-ur20GyqFbE4doqw@mail.gmail.com>
In-Reply-To: <CACdoK4LU-uigbtQw63Yacd_AOzv+_fWuhL-ur20GyqFbE4doqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-02 21:40 UTC+0100 ~ Quentin Monnet <quentin@isovalent.com>
> On Sat, 2 Oct 2021 at 00:05, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>>
>> On Fri, Oct 1, 2021 at 4:09 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>
>>> Libbpf is used at several locations in the repository. Most of the time,
>>> the tools relying on it build the library in its own directory, and include
>>> the headers from there. This works, but this is not the cleanest approach.
>>> It generates objects outside of the directory of the tool which is being
>>> built, and it also increases the risk that developers include a header file
>>> internal to libbpf, which is not supposed to be exposed to user
>>> applications.
>>>
>>> This set adjusts all involved Makefiles to make sure that libbpf is built
>>> locally (with respect to the tool's directory or provided build directory),
>>> and by ensuring that "make install_headers" is run from libbpf's Makefile
>>> to export user headers properly.
>>>
>>> This comes at a cost: given that the libbpf was so far mostly compiled in
>>> its own directory by the different components using it, compiling it once
>>> would be enough for all those components. With the new approach, each
>>> component compiles its own version. To mitigate this cost, efforts were
>>> made to reuse the compiled library when possible:
>>>
>>> - Make the bpftool version in samples/bpf reuse the library previously
>>>   compiled for the selftests.
>>> - Make the bpftool version in BPF selftests reuse the library previously
>>>   compiled for the selftests.
>>> - Similarly, make resolve_btfids in BPF selftests reuse the same compiled
>>>   library.
>>> - Similarly, make runqslower in BPF selftests reuse the same compiled
>>>   library; and make it rely on the bpftool version also compiled from the
>>>   selftests (instead of compiling its own version).
>>> - runqslower, when compiled independently, needs its own version of
>>>   bpftool: make them share the same compiled libbpf.
>>>
>>> As a result:
>>>
>>> - Compiling the samples/bpf should compile libbpf just once.
>>> - Compiling the BPF selftests should compile libbpf just once.
>>> - Compiling the kernel (with BTF support) should now lead to compiling
>>>   libbpf twice: one for resolve_btfids, one for kernel/bpf/preload.
>>> - Compiling runqslower individually should compile libbpf just once. Same
>>>   thing for bpftool, resolve_btfids, and kernel/bpf/preload/iterators.
>>
>> The whole sharing of libbpf build artifacts is great, I just want to
>> point out that it's also dangerous if those multiple Makefiles aren't
>> ordered properly. E.g., if you build runqslower and the rest of
>> selftests in parallel without making sure that libbpf already
>> completed its build, you might end up building libbpf in parallel in
>> two independent make instances and subsequently corrupting generated
>> object files. I haven't looked through all the changes (and I'll
>> confess that it's super hard to reason about dependencies and ordering
>> in Makefile) and I'll keep this in mind, but wanted to bring this up.
> 
> I'm not sure how Makefile handles this exactly, I don't know if it can
> possibly build the two in parallel or if it's smart enough to realise
> that the libbpf.a is the same object in both cases and should be built
> only once. Same as you, I didn't hit any issue of this kind when
> testing the patches.

Testing further with make, I don't think it's smart enough to avoid
building the object twice in the same directory. This probably didn't
show in practice because the parallel build tends to build the different
object files in parallel rather than libbpf and bpftool in parallel. But
to remain on the safe side, I'll just add a dependency on libbpf for
bpftool/runqslower etc. to make sure they are not all built together
(most locations had the dependency already). v3 is coming.

Quentin

