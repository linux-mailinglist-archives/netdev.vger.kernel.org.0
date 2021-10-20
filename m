Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8617A4347F7
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhJTJc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhJTJc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:32:27 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC98C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:30:12 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id s198-20020a1ca9cf000000b0030d6986ea9fso8640206wme.1
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=18unRjIEgtu53s2AOFSBOaihnZgi6/yiKrjjisGxHnA=;
        b=UoQeY4iYZjQ1L7P59cZltNOmPD6mVN2WULLC0cZ2ymMnEXtTKVlHaOZlrJGDImu1eA
         vppuhyaEosK9YouBjU0LEm7XonjhN9Pg7gWsGru5ZOJaOcPvMDIk3WqampBf7VR/KsTj
         a7SWEHDcFQHeNeRCtsBMO4z5Q04Ts0RdSvTJTin1mTPZ/6Bb9CpEqksf0hp1g4voval6
         zPGBhyMmlFtZn/CEQBal27vF9OlzYDD1xFnQ70Cc5vUw7ub3lFi3PdHSTAz+UgE7HYbG
         dlTYES4M2cX5pveONmb8jNFsZpkNAQX5S8kUaWhecZLEXi4DYNmvafw909eXEK1gu25G
         9/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=18unRjIEgtu53s2AOFSBOaihnZgi6/yiKrjjisGxHnA=;
        b=ZEJClHGI2tHUV4tw2bME2JoPCH424fb/N5dUtjYHJE9gXEjN8a68bh+3NX1VXC9i3O
         PLke8ukHCY8rxvmSqltOrWO4byUb42fTKK13LH6snBMq4OwvPoxu+YAx139DowtSJiZI
         HyU7tfoRISmOqji6RwgEDEgYu3OaG4rZOl/QGTdimaRm9nK3hN2fUXR8zn61gw+5wZir
         IxEcYdOyc10USC/PtYX3ZqSYZPuKEaXFZ7AP3yd85Vk3XxCLj50JbWOOLfrvCxt3aEd+
         +ZIoPCQ0FmWg9lZHGu2zLHvKmedj1IxiOZnhPhE6SiInqQblfqOy5ymC/5zHXWWbFXrX
         KJbA==
X-Gm-Message-State: AOAM530vRQvYIMzwV+S3pBLVrmuXbfdXXxOPzttUcw2o69S5NPn7tEC2
        oQD4k+xMBLx1U3Vz1bEjKlx9VA==
X-Google-Smtp-Source: ABdhPJyQRfrhWDEz5irhwOalGLfEAeIJ9712M/2WBMHGpdm+WMijti8hSEWBEy5SK0NwHr/aolvW7w==
X-Received: by 2002:a05:6000:188d:: with SMTP id a13mr50654955wri.243.1634722210672;
        Wed, 20 Oct 2021 02:30:10 -0700 (PDT)
Received: from [192.168.1.8] ([149.86.78.224])
        by smtp.gmail.com with ESMTPSA id j7sm1833615wmq.32.2021.10.20.02.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 02:30:10 -0700 (PDT)
Message-ID: <73ba260f-c634-0955-2111-6c12c1b8b79f@isovalent.com>
Date:   Wed, 20 Oct 2021 10:30:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next] bpf/preload: Clean up .gitignore and
 "clean-files" target
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20211010002400.9339-1-quentin@isovalent.com>
 <CAEf4Bza1K2-ncAqmvri=4apP9Bzv9gX7e8YAu4GWgk_kM48Jgw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CAEf4Bza1K2-ncAqmvri=4apP9Bzv9gX7e8YAu4GWgk_kM48Jgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-10-19 16:50 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Sat, Oct 9, 2021 at 5:24 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> kernel/bpf/preload/Makefile was recently updated to have it install
>> libbpf's headers locally instead of pulling them from tools/lib/bpf. But
>> two items still need to be addressed.
>>
>> First, the local .gitignore file was not adjusted to ignore the files
>> generated in the new kernel/bpf/preload/libbpf output directory.
>>
>> Second, the "clean-files" target is now incorrect. The old artefacts
>> names were not removed from the target, while the new ones were added
>> incorrectly. This is because "clean-files" expects names relative to
>> $(obj), but we passed the absolute path instead. This results in the
>> output and header-destination directories for libbpf (and their
>> contents) not being removed from kernel/bpf/preload on "make clean" from
>> the root of the repository.
>>
>> This commit fixes both issues. Note that $(userprogs) needs not be added
>> to "clean-files", because the cleaning infrastructure already accounts
>> for it.
>>
>> Cleaning the files properly also prevents make from printing the
>> following message, for builds coming after a "make clean":
>> "make[4]: Nothing to be done for 'install_headers'."
>>
>> Fixes: bf60791741d4 ("bpf: preload: Install libbpf headers when building")
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  kernel/bpf/preload/.gitignore | 4 +---
>>  kernel/bpf/preload/Makefile   | 3 +--
>>  2 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/kernel/bpf/preload/.gitignore b/kernel/bpf/preload/.gitignore
>> index 856a4c5ad0dd..9452322902a5 100644
>> --- a/kernel/bpf/preload/.gitignore
>> +++ b/kernel/bpf/preload/.gitignore
>> @@ -1,4 +1,2 @@
>> -/FEATURE-DUMP.libbpf
>> -/bpf_helper_defs.h
>> -/feature
>> +/libbpf
>>  /bpf_preload_umd
>> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
>> index 469d35e890eb..d8379af88161 100644
>> --- a/kernel/bpf/preload/Makefile
>> +++ b/kernel/bpf/preload/Makefile
>> @@ -27,8 +27,7 @@ userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
>>
>>  userprogs := bpf_preload_umd
>>
>> -clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
>> -clean-files += $(LIBBPF_OUT) $(LIBBPF_DESTDIR)
>> +clean-files := $(subst $(abspath $(obj))/,,$(LIBBPF_OUT) $(LIBBPF_DESTDIR))
> 
> why so complicated? also isn't LIBBPF_OUT and LIBBPF_DESTDIR the same?

They're the same. My reasoning was that since we had these two variables
for output directories, it felt logical somehow to add both, in case one
changes in the future.

> Wouldn't just this work and be super clear:
> 
> clean-files: libbpf/

It does look simpler. OK I'll change and submit a new version.

Thanks,
Quentin
