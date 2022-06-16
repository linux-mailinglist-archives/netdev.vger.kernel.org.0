Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355C054E2C6
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377392AbiFPOAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 10:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377302AbiFPN77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 09:59:59 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0354EA30
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:59:28 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o8so2014784wro.3
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 06:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vj6Kj0IvvuQhE+SIog7hTAPbatIe4FWGXBBu0itej/s=;
        b=TMt5+ZheG/fSOuLk+WKYiyOc5z70JRmj8/pM2ZvrchiUpDI0YKHXQcIqobvrt0xD0e
         EAEaQ17kZrLUEYCiMaOYDTsr0EdslHiYHmbk6hR8SQ7wbNHazyPp4HMGfp6zqLxEdkf+
         wPf/BX5DBXD8cFU+wbTunV4KVQyexQIkHdtqdWQ8vdze9UTrf+yq6viidMYk3IvRJvuP
         PhM7t20tQ7cnSo2i0rQvr/JgPp3Uxibbx6ULKiJA0u/YfNAO2RRXEAszFN4zgbvPDnpx
         AdtQnDVgEw2RTuM8gI/ZxjjWz5QsGIHmrZ5/wUKVgP4B9137hm5pgkFR1Wd2+2op1Z3J
         0Crw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vj6Kj0IvvuQhE+SIog7hTAPbatIe4FWGXBBu0itej/s=;
        b=zFVtzmgIic6w0hO4qbDFqxs6BtbLSjXCuIsjcUVc1ZBmi0DSmf1zXjhXIJIgVfUk/e
         w2E7dVNFh/Dm0ylen5VZW4fJDhPdvuLHDwyXwL25NGYvk/fy+ecMDf59MIP9hVo7Yxlc
         tps97OpXnfvg2T1TUmQcBFBQdftz3z7eUP6agxjuUYI+bKAkGJSUi574rXEuN95qAOAY
         LxrxJ3y7eVDMP9xw3H3GAKH46ALO/Bn7MI00Px0wAxBxm10zrrKsCSwyoiaePpn7mNjS
         di4RB6slITD6EzhWi/IBDKu888Y6qZZVTvQZdZuKyHlkrUaLiVoQ7rJfcNuqGLIYWdpb
         eoAw==
X-Gm-Message-State: AJIora+0FdVMcCt2j5KUR0wPDG/iRfsh9QA2Mcsh/K45HFED2y8FgF86
        DUHigN+SCBJ3vggDf92XovBLag==
X-Google-Smtp-Source: AGRyM1tXkwRSndByniuYkCQM744wXW5cMnG0FoM7qGl/0Mub0Td9o7qW7UX+zD6qaWRzfD6Wb8C2gw==
X-Received: by 2002:adf:d84b:0:b0:212:1c7c:5790 with SMTP id k11-20020adfd84b000000b002121c7c5790mr4619613wrl.366.1655387966441;
        Thu, 16 Jun 2022 06:59:26 -0700 (PDT)
Received: from [192.168.178.21] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id n68-20020a1c2747000000b0039c5a765388sm2435702wmn.28.2022.06.16.06.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 06:59:25 -0700 (PDT)
Message-ID: <68e789f7-aa68-cc6a-fb33-b686d14f80a5@isovalent.com>
Date:   Thu, 16 Jun 2022 14:59:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next 1/2] Revert "bpftool: Use libbpf 1.0 API mode
 instead of RLIMIT_MEMLOCK"
Content-Language: en-GB
To:     Yafang Shao <laoar.shao@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Harsh Modi <harshmodi@google.com>,
        Paul Chaignon <paul@cilium.io>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20220610112648.29695-1-quentin@isovalent.com>
 <20220610112648.29695-2-quentin@isovalent.com> <YqNsWAH24bAIPjqy@google.com>
 <cb05a59e-07d5-ddd1-b028-82133faaf67e@isovalent.com>
 <CAKH8qBvvq0f+D8BXChw_8krH896J_cYg0yhRfnDOSO_U1n394w@mail.gmail.com>
 <71b56050-11ad-bd06-09c9-1a8c61b4c1b4@isovalent.com>
 <CAKH8qBsFyakQRd1q6XWggdv4F5+HrHoC4njg9jQFDOfq+kRBCQ@mail.gmail.com>
 <CALOAHbCvWzOJ169fPTCp1KsFpkEVukKgGnH4mDeYGOEv6hsEpQ@mail.gmail.com>
 <e9aa57d2-4ce7-23f2-0ba1-ea58f3254353@isovalent.com>
 <CALOAHbDDx_xDeUk8R+y-aREX9KMRbo+CqCV7m5dADdvijuHRQw@mail.gmail.com>
 <CAKH8qBuPh4aaEz_vv1s2gWYYPRm8e5gMaM-RcuCqg+AeaeZcPg@mail.gmail.com>
 <CALOAHbAfjegzchFOb9b1+4d0OLsVWOpnr7ARMXqcKbnbG=u2BA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <CALOAHbAfjegzchFOb9b1+4d0OLsVWOpnr7ARMXqcKbnbG=u2BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-06-16 00:05 UTC+0800 ~ Yafang Shao <laoar.shao@gmail.com>
> On Wed, Jun 15, 2022 at 11:52 PM Stanislav Fomichev <sdf@google.com> wrote:
>>
>> On Wed, Jun 15, 2022 at 6:23 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>>>
>>> On Tue, Jun 14, 2022 at 10:20 PM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>
>>>> 2022-06-14 20:37 UTC+0800 ~ Yafang Shao <laoar.shao@gmail.com>
>>>>> On Sat, Jun 11, 2022 at 1:17 AM Stanislav Fomichev <sdf@google.com> wrote:
>>>>>>
>>>>>> On Fri, Jun 10, 2022 at 10:00 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>>>
>>>>>>> 2022-06-10 09:46 UTC-0700 ~ Stanislav Fomichev <sdf@google.com>
>>>>>>>> On Fri, Jun 10, 2022 at 9:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>>>>>>>
>>>>>>>>> 2022-06-10 09:07 UTC-0700 ~ sdf@google.com
>>>>>>>>>> On 06/10, Quentin Monnet wrote:
>>>>>>>>>>> This reverts commit a777e18f1bcd32528ff5dfd10a6629b655b05eb8.
>>>>>>>>>>
>>>>>>>>>>> In commit a777e18f1bcd ("bpftool: Use libbpf 1.0 API mode instead of
>>>>>>>>>>> RLIMIT_MEMLOCK"), we removed the rlimit bump in bpftool, because the
>>>>>>>>>>> kernel has switched to memcg-based memory accounting. Thanks to the
>>>>>>>>>>> LIBBPF_STRICT_AUTO_RLIMIT_MEMLOCK, we attempted to keep compatibility
>>>>>>>>>>> with other systems and ask libbpf to raise the limit for us if
>>>>>>>>>>> necessary.
>>>>>>>>>>
>>>>>>>>>>> How do we know if memcg-based accounting is supported? There is a probe
>>>>>>>>>>> in libbpf to check this. But this probe currently relies on the
>>>>>>>>>>> availability of a given BPF helper, bpf_ktime_get_coarse_ns(), which
>>>>>>>>>>> landed in the same kernel version as the memory accounting change. This
>>>>>>>>>>> works in the generic case, but it may fail, for example, if the helper
>>>>>>>>>>> function has been backported to an older kernel. This has been observed
>>>>>>>>>>> for Google Cloud's Container-Optimized OS (COS), where the helper is
>>>>>>>>>>> available but rlimit is still in use. The probe succeeds, the rlimit is
>>>>>>>>>>> not raised, and probing features with bpftool, for example, fails.
>>>>>>>>>>
>>>>>>>>>>> A patch was submitted [0] to update this probe in libbpf, based on what
>>>>>>>>>>> the cilium/ebpf Go library does [1]. It would lower the soft rlimit to
>>>>>>>>>>> 0, attempt to load a BPF object, and reset the rlimit. But it may induce
>>>>>>>>>>> some hard-to-debug flakiness if another process starts, or the current
>>>>>>>>>>> application is killed, while the rlimit is reduced, and the approach was
>>>>>>>>>>> discarded.
>>>>>>>>>>
>>>>>>>>>>> As a workaround to ensure that the rlimit bump does not depend on the
>>>>>>>>>>> availability of a given helper, we restore the unconditional rlimit bump
>>>>>>>>>>> in bpftool for now.
>>>>>>>>>>
>>>>>>>>>>> [0]
>>>>>>>>>>> https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
>>>>>>>>>>> [1] https://github.com/cilium/ebpf/blob/v0.9.0/rlimit/rlimit.go#L39
>>>>>>>>>>
>>>>>>>>>>> Cc: Yafang Shao <laoar.shao@gmail.com>
>>>>>>>>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>>>>>>>>>> ---
>>>>>>>>>>>   tools/bpf/bpftool/common.c     | 8 ++++++++
>>>>>>>>>>>   tools/bpf/bpftool/feature.c    | 2 ++
>>>>>>>>>>>   tools/bpf/bpftool/main.c       | 6 +++---
>>>>>>>>>>>   tools/bpf/bpftool/main.h       | 2 ++
>>>>>>>>>>>   tools/bpf/bpftool/map.c        | 2 ++
>>>>>>>>>>>   tools/bpf/bpftool/pids.c       | 1 +
>>>>>>>>>>>   tools/bpf/bpftool/prog.c       | 3 +++
>>>>>>>>>>>   tools/bpf/bpftool/struct_ops.c | 2 ++
>>>>>>>>>>>   8 files changed, 23 insertions(+), 3 deletions(-)
>>>>>>>>>>
>>>>>>>>>>> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
>>>>>>>>>>> index a45b42ee8ab0..a0d4acd7c54a 100644
>>>>>>>>>>> --- a/tools/bpf/bpftool/common.c
>>>>>>>>>>> +++ b/tools/bpf/bpftool/common.c
>>>>>>>>>>> @@ -17,6 +17,7 @@
>>>>>>>>>>>   #include <linux/magic.h>
>>>>>>>>>>>   #include <net/if.h>
>>>>>>>>>>>   #include <sys/mount.h>
>>>>>>>>>>> +#include <sys/resource.h>
>>>>>>>>>>>   #include <sys/stat.h>
>>>>>>>>>>>   #include <sys/vfs.h>
>>>>>>>>>>
>>>>>>>>>>> @@ -72,6 +73,13 @@ static bool is_bpffs(char *path)
>>>>>>>>>>>       return (unsigned long)st_fs.f_type == BPF_FS_MAGIC;
>>>>>>>>>>>   }
>>>>>>>>>>
>>>>>>>>>>> +void set_max_rlimit(void)
>>>>>>>>>>> +{
>>>>>>>>>>> +    struct rlimit rinf = { RLIM_INFINITY, RLIM_INFINITY };
>>>>>>>>>>> +
>>>>>>>>>>> +    setrlimit(RLIMIT_MEMLOCK, &rinf);
>>>>>>>>>>
>>>>>>>>>> Do you think it might make sense to print to stderr some warning if
>>>>>>>>>> we actually happen to adjust this limit?
>>>>>>>>>>
>>>>>>>>>> if (getrlimit(MEMLOCK) != RLIM_INFINITY) {
>>>>>>>>>>     fprintf(stderr, "Warning: resetting MEMLOCK rlimit to
>>>>>>>>>>     infinity!\n");
>>>>>>>>>>     setrlimit(RLIMIT_MEMLOCK, &rinf);
>>>>>>>>>> }
>>>>>>>>>>
>>>>>>>>>> ?
>>>>>>>>>>
>>>>>>>>>> Because while it's nice that we automatically do this, this might still
>>>>>>>>>> lead to surprises for some users. OTOH, not sure whether people
>>>>>>>>>> actually read those warnings? :-/
>>>>>>>>>
>>>>>>>>> I'm not strictly opposed to a warning, but I'm not completely sure this
>>>>>>>>> is desirable.
>>>>>>>>>
>>>>>>>>> Bpftool has raised the rlimit for a long time, it changed only in April,
>>>>>>>>> so I don't think it would come up as a surprise for people who have used
>>>>>>>>> it for a while. I think this is also something that several other
>>>>>>>>> BPF-related applications (BCC I think?, bpftrace, Cilium come to mind)
>>>>>>>>> have been doing too.
>>>>>>>>
>>>>>>>> In this case ignore me and let's continue doing that :-)
>>>>>>>>
>>>>>>>> Btw, eventually we'd still like to stop doing that I'd presume?
>>>>>>>
>>>>>>> Agreed. I was thinking either finding a way to improve the probe in
>>>>>>> libbpf, or waiting for some more time until 5.11 gets old, but this may
>>>>>>> take years :/
>>>>>>>
>>>>>>>> Should
>>>>>>>> we at some point follow up with something like:
>>>>>>>>
>>>>>>>> if (kernel_version >= 5.11) { don't touch memlock; }
>>>>>>>>
>>>>>>>> ?
>>>>>>>>
>>>>>>>> I guess we care only about <5.11 because of the backports, but 5.11+
>>>>>>>> kernels are guaranteed to have memcg.
>>>>>>>
>>>>>>> You mean from uname() and parsing the release? Yes I suppose we could do
>>>>>>> that, can do as a follow-up.
>>>>>>
>>>>>> Yeah, uname-based, I don't think we can do better? Given that probing
>>>>>> is problematic as well :-(
>>>>>> But idk, up to you.
>>>>>>
>>>>>
>>>>> Agreed with the uname-based solution. Another possible solution is to
>>>>> probe the member 'memcg' in struct bpf_map, in case someone may
>>>>> backport memcg-based  memory accounting, but that will be a little
>>>>> over-engineering. The uname-based solution is simple and can work.
>>>>>
>>>>
>>>> Thanks! Yes, memcg would be more complex: the struct is not exposed to
>>>> user space, and BTF is not a hard dependency for bpftool. I'll work on
>>>> the uname-based test as a follow-up to this set.
>>>>
>>>
>>> After a second thought, the uname-based test may not work, because
>>> CONFIG_MEMCG_KMEM can be disabled.
>>
>> Does it matter? Regardless of whether there is memcg or not, we
>> shouldn't touch ulimit on 5.11+
>> If there is no memcg, there is no bpf memory enforcement.
> 
> Right, rlimit-based accounting is totally removed, that is not the
> same with what I thought before, while I thought it will fallback to
> rlimit-based if kmemcg is disabled.

Agreed, and so I've got a patch ready for the uname-based probe.

But talking about this with Daniel, we were wondering if it would make
sense instead to have the probe I had initially submitted (lower the
rlimit to 0, attempt to load a program, reset rlimit - see [0]), but
only for bpftool instead of libbpf? My understanding is that the memlock
rlimit is per-process, right? So this shouldn't affect any other
process, and because bpftool is not multithreaded, nothing other than
probing would happen while the rlimit is at zero? Or is it just simpler,
if less accurate, to stick to the uname probe?

Quentin

[0]
https://lore.kernel.org/bpf/20220609143614.97837-1-quentin@isovalent.com/
