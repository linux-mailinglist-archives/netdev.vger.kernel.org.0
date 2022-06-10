Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59F546A8B
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349773AbiFJQff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349774AbiFJQfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:35:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4009256F95
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:34:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v14so10977735wra.5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hWmTHzeJ7LLCWgq5ZaSnXt7Oc8qo/rMKpNHQ9yrt1Qc=;
        b=Bu5jzBOk61aAQk5Bc/WUTd8pRtciBgX0PKuqgykQLJZhLKrAvpdoydl6fsITgaucf0
         X/qgWQKYaGRpCz9o905waICabXUsctKm0WjUo3ZH1TBke1a+W66fTyV1ygtFDmWwKMWS
         lwijBvm73I0pAZC0PQm3m3Rds1A6ApLM+wyvkWdMwL6U7jNBjq468V7vB11bmR8iVUss
         pTRGc9PMvMym49XMJ8FMelhVQCMfQvWXdtpzoXIo4KMBEZGp0VB8Ad6PXOsrugkSM9mp
         PGZOmpOWcIz5i6DGBGwP+1tKj0ZeWuT6ZRTVUbmnoHm8MaDr4xIoW4LQo4d9S30FzrPY
         +Odg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hWmTHzeJ7LLCWgq5ZaSnXt7Oc8qo/rMKpNHQ9yrt1Qc=;
        b=YUGwiMuLgX6NElPnzHxeakUCT9XSbuFHzFxdby3QjZWe72ruxjZvh214uyJcxVBpSE
         U38+YAOUuosFuJT9xK28PeR7gZ4wLxjV+sOtmAnCqpixHNY2zVNtbV0bU5pX9WsiV2Se
         aYfeFPzdLeCAqhw7JMVJHOv/Zl69cWH9Sv1As8blcaXkEDdMB///zmGYEYKysB6AoPOs
         521BOkc62C7Jo7wdIK3Iq4OQ5onRY+O0/p/DB6iO10S64zULFj4OXEdVG9AJ67a4zItL
         gzYH3BSLltJGwHfIiaCYbqXuWm2DEoWn598WDF0Rp146qG6E+KvsXRDEPVL0paOBENmF
         8wKA==
X-Gm-Message-State: AOAM5335eRjWyCtdmKOkrUffuG0i4I1DAKph2sjQEhF+D2GSdQQ2JGpj
        timXeJ4XnO2sPPG8LtBi/zc5TQ==
X-Google-Smtp-Source: ABdhPJycH1MCJm4GWBSrD4Wp9OJUT6py82j/uRSoeKccN2E1PUjWHZl5HuAOog6vFR16rGzgToqUeA==
X-Received: by 2002:a5d:65c1:0:b0:210:33b7:4525 with SMTP id e1-20020a5d65c1000000b0021033b74525mr45341201wrw.494.1654878891585;
        Fri, 10 Jun 2022 09:34:51 -0700 (PDT)
Received: from [192.168.178.21] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id u2-20020a7bcb02000000b0039c5cecf206sm3565168wmj.4.2022.06.10.09.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jun 2022 09:34:51 -0700 (PDT)
Message-ID: <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
Date:   Fri, 10 Jun 2022 17:34:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
Content-Language: en-GB
To:     sdf@google.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220610112648.29695-1-quentin@isovalent.com>
 <20220610112648.29695-2-quentin@isovalent.com> <YqNsWAH24bAIPjqy@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <YqNsWAH24bAIPjqy@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-06-10 09:07 UTC-0700 ~ sdf@google.com
> On 06/10, Quentin Monnet wrote:
>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
> 
>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
>> kernel has switched to memcg-based memory accounting. Thanks to the
>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
>> with other systems and ask libbpf to raise the limit for us if
>> necessary.
> 
>> How do we know if memcg-based accounting is supported? There is a probe
>> in libbpf to check this. But this probe currently relies on the
>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
>> landed in the same kernel version as the memory accounting change. This
>> works in the generic case, but it may fail, for example, if the helper
>> function has been backported to an older kernel. This has been observed
>> for Google Cloud's Container-Optimized OS (COS), where the helper is
>> available but rlimit is still in use. The probe succeeds, the rlimit is
>> not raised, and probing features with bpftool, for example, fails.
> 
>> A patch was submitted [0] to update this probe in libbpf, based on what
>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
>> some hard-to-debug flakiness if another process starts, or the current
>> application is killed, while the rlimit is reduced, and the approach was
>> discarded.
> 
>> As a workaround to ensure that the rlimit bump does not depend on the
>> availability of a given helper, we restore the unconditional rlimit bump
>> in bpftool for now.
> 
>> [0]
>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
> 
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>   tools/bpf/bpftool/common.c     | 8 ++++++++
>>   tools/bpf/bpftool/feature.c    | 2 ++
>>   tools/bpf/bpftool/main.c       | 6 +++---
>>   tools/bpf/bpftool/main.h       | 2 ++
>>   tools/bpf/bpftool/map.c        | 2 ++
>>   tools/bpf/bpftool/pids.c       | 1 +
>>   tools/bpf/bpftool/prog.c       | 3 +++
>>   tools/bpf/bpftool/struct_ops.c | 2 ++
>>   8 files changed, 23 insertions(+), 3 deletions(-)
> 
>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>> index a45b42ee8ab0..a0d4acd7c54a 100644
>> --- a/tools/bpf/bpftool/common.c
>> +++ b/tools/bpf/bpftool/common.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/magic.h>
>>   #include <net/if.h>
>>   #include <sys/mount.h>
>> +#include <sys/resource.h>
>>   #include <sys/stat.h>
>>   #include <sys/vfs.h>
> 
>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
>>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>>   }
> 
>> +void set_max_rlimit(void)
>> +{
>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
>> +
>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
> 
> Do you think it might make sense to print to stderr some warning if
> we actually happen to adjust this limit?
> 
> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
>     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
>     infinity!\n");
>     setrlimit(RLIMIT_MEMLOCK, &rinf);
> }
> 
> ?
> 
> Because while it's nice that we automatically do this, this might still
> lead to surprises for some users. OTOH, not sure whether people
> actually read those warnings? :-/

I'm not strictly opposed to a warning, but I'm not completely sure this
is desirable.

Bpftool has raised the rlimit for a long time, it changed only in April,
so I don't think it would come up as a surprise for people who have used
it for a while. I think this is also something that several other
BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
have been doing too.

For new users, I agree the warning may be helpful. But then the message
is likely to appear the very first time a user runs the command - likely
as root - and I fear this might worry people not familiar with rlimits,
who would wonder if they just broke something on their system? Maybe
with a different phrasing.

Alternatively we could document it in the relevant man pages (not that
people would see it better, but at least it would be mentioned somewhere
if people take the time to read the docs)? What do you think?

Quentin
