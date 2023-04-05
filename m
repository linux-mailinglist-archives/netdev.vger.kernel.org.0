Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA956D7D8C
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbjDENTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbjDENTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:19:32 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7921059C4;
        Wed,  5 Apr 2023 06:19:28 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pk32g-0003y8-KI; Wed, 05 Apr 2023 15:19:14 +0200
Message-ID: <62f97c5c-4b18-181b-c541-9b19900a7cd8@leemhuis.info>
Date:   Wed, 5 Apr 2023 15:19:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: Bug report: UDP ~20% degradation
Content-Language: en-US, de-DE
To:     Vincent Guittot <vincent.guittot@linaro.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>, Malek Imam <mimam@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Talat Batheesh <talatb@nvidia.com>
References: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
 <CAKfTPtCO=GFm6nKU0DVa-aa3f1pTQ5vBEF+9hJeTR9C_RRRZ9A@mail.gmail.com>
 <8f95150d-db0d-d9e5-4eff-2196d5e8de05@gmail.com>
 <6f90f500-ed4c-0650-0044-1cd1e3a632c3@gmail.com>
 <CAKfTPtCSw4QL6F7sR+JVSJE2+_zhZ4eNdBtyQx6KZSD_b2kdhw@mail.gmail.com>
From:   "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
In-Reply-To: <CAKfTPtCSw4QL6F7sR+JVSJE2+_zhZ4eNdBtyQx6KZSD_b2kdhw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680700768;208748d8;
X-HE-SMSGID: 1pk32g-0003y8-KI
X-Spam-Status: No, score=-1.4 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
for once, to make this easily accessible to everyone.

Tariq Toukanm: it looks like you never provided the data Vincent asked
for (see below). Did you stop caring, did this discussion continue
somewhere else (doesn't look like it one lore), did the problem vanish,
or was it fixed somehow? I for now assume it's one of the two latter
option and will stop tracking this. If that was a bad assumption and
worth continue tracking, please let me know -- otherwise consider this a
"JFYI" mail.

#regzbot inconclusive: lack of data to debug, as it looks like the
reporter stopped caring
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.

On 22.02.23 17:51, Vincent Guittot wrote:
> On Wed, 22 Feb 2023 at 09:49, Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>> On 12/02/2023 13:50, Tariq Toukan wrote:
>>> On 08/02/2023 16:12, Vincent Guittot wrote:
>>>> On Wed, 8 Feb 2023 at 12:09, Tariq Toukan <tariqt@nvidia.com> wrote:
>>>>>
>>>>> Our performance verification team spotted a degradation of up to ~20% in
>>>>> UDP performance, for a specific combination of parameters.
>>>>>
>>>>> Our matrix covers several parameters values, like:
>>>>> IP version: 4/6
>>>>> MTU: 1500/9000
>>>>> Msg size: 64/1452/8952 (only when applicable while avoiding ip
>>>>> fragmentation).
>>>>> Num of streams: 1/8/16/24.
>>>>> Num of directions: unidir/bidir.
>>>>>
>>>>> Surprisingly, the issue exists only with this specific combination:
>>>>> 8 streams,
>>>>> MTU 9000,
>>>>> Msg size 8952,
>>>>> both ipv4/6,
>>>>> bidir.
>>>>> (in unidir it repros only with ipv4)
>>>>>
>>>>> The reproduction is consistent on all the different setups we tested
>>>>> with.
>>>>>
>>>>> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
>>>>> (Bad), with ConnectX-6DX NIC.
>>>>>
>>>>> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
>>>>>
>>>>> We couldn't come up with a good explanation how this patch causes this
>>>>> issue. We also looked for related changes in the networking/UDP stack,
>>>>> but nothing looked suspicious.
>>>>>
>>>>> Maybe someone here can help with this.
>>>>> We can provide more details or do further tests/experiments to progress
>>>>> with the debug.
>>>>
>>>> Could you share more details about your system and the cpu topology ?
>>>>
>>>
>>> output for 'lscpu':
>>>
>>> Architecture:                    x86_64
>>> CPU op-mode(s):                  32-bit, 64-bit
>>> Address sizes:                   40 bits physical, 57 bits virtual
>>> Byte Order:                      Little Endian
>>> CPU(s):                          24
>>> On-line CPU(s) list:             0-23
>>> Vendor ID:                       GenuineIntel
>>> BIOS Vendor ID:                  QEMU
>>> Model name:                      Intel(R) Xeon(R) Platinum 8380 CPU @
>>> 2.30GHz
>>> BIOS Model name:                 pc-q35-5.0
>>> CPU family:                      6
>>> Model:                           106
>>> Thread(s) per core:              1
>>> Core(s) per socket:              1
>>> Socket(s):                       24
>>> Stepping:                        6
>>> BogoMIPS:                        4589.21
>>> Flags:                           fpu vme de pse tsc msr pae mce cx8 apic
>>> sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx
>>> pdpe1gb rdtscp lm constant_tsc arch_perfmon rep_good nopl xtopology
>>> cpuid tsc_known_freq pni pclmulqdq vmx ssse3 fma cx16 pdcm pcid sse4_1
>>> sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
>>> hypervisor lahf_lm abm 3dnowprefetch cpuid_fault invpcid_single ssbd
>>> ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid
>>> ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f
>>> avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni
>>> avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves wbnoinvd arat
>>> avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni
>>> avx512_bitalg avx512_vpopcntdq rdpid md_clear arch_capabilities
>>> Virtualization:                  VT-x
>>> Hypervisor vendor:               KVM
>>> Virtualization type:             full
>>> L1d cache:                       768 KiB (24 instances)
>>> L1i cache:                       768 KiB (24 instances)
>>> L2 cache:                        96 MiB (24 instances)
>>> L3 cache:                        384 MiB (24 instances)
>>> NUMA node(s):                    1
>>> NUMA node0 CPU(s):               0-23
>>> Vulnerability Itlb multihit:     Not affected
>>> Vulnerability L1tf:              Not affected
>>> Vulnerability Mds:               Not affected
>>> Vulnerability Meltdown:          Not affected
>>> Vulnerability Mmio stale data:   Vulnerable: Clear CPU buffers
>>> attempted, no microcode; SMT Host state unknown
>>> Vulnerability Retbleed:          Not affected
>>> Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass
>>> disabled via prctl
>>> Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers
>>> and __user pointer sanitization
>>> Vulnerability Spectre v2:        Vulnerable: eIBRS with unprivileged eBPF
>>> Vulnerability Srbds:             Not affected
>>> Vulnerability Tsx async abort:   Not affected
>>>
>>>> The commit  c82a69629c53 migrates a task on an idle cpu when the task
>>>> is the only one running on local cpu but the time spent by this local
>>>> cpu under interrupt or RT context becomes significant (10%-17%)
>>>> I can imagine that 16/24 stream overload your system so load_balance
>>>> doesn't end up in this case and the cpus are busy with several
>>>> threads. On the other hand, 1 stream is small enough to keep your
>>>> system lightly loaded but 8 streams make your system significantly
>>>> loaded to trigger the reduced capacity case but still not overloaded.
>>>>
>>>
>>> I see. Makes sense.
>>> 1. How do you check this theory? Any suggested tests/experiments?
> 
> Could you get some statistics about the threads involved in your tests
> ? Like the number of migrations as an example.
> 
> Or a trace but that might be a lot of data. I haven't tried to
> reproduce this on a local system yet.
> 
> You can fall in the situation where the tasks of your bench are
> periodically moved to the next cpu becoming idle.
> 
> Which cpufreq driver and governor are you using ? Could you also check
> the average frequency of your cpu ? Another cause could be that we
> spread tasks and irq on different cpus which then trigger a freq
> decrease
> 
>>> 2. How do you suggest this degradation should be fixed?
>>>
>>
>> Hi,
>> A kind reminder.
