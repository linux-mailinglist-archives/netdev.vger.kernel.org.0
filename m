Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B5B17E654
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgCISEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:04:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33300 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgCISEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:04:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so8631207wrd.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y2tpKqAf3rQTYR4mUDC6sUFd5aNYh6l+JU3PDognweE=;
        b=0okYvM9vrbg91gYE1BIpymy24Yw4OLl3QzH6nPrFrq9HRICpUKTx62V0NVhLi1YX+n
         RTdjQt2SdLmYxfC/GH2qBsJFKvy56gp2B5KcWzdeyD/xD9f52Ywt6/aSTiRptYX/oJWX
         Kh+5lnGpvnvKORny4IGIfITyK2EHgF0RfFQrb4rDBdw0W9rxVKao0h7/0DWuoZSrspAy
         DFQLxt0eDllKLRL3oTeHO9/QBC4NkO2IX75RB7R3nx2wFojvnuG/ds5SXveOK4bC5rSF
         n0dF6dpj8jak8VZ0ryxx7MUrN2rTL6k7XGHRVyQFos0CC5PaRkR4td9fPflVZ31rsHMh
         FDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y2tpKqAf3rQTYR4mUDC6sUFd5aNYh6l+JU3PDognweE=;
        b=TWC7QCpP6d2X7R67Eb4lT5u3cs+gM4O4CFQv0hAZG04sNvH4j838hibIEdBUYYTtVs
         QYfQasVMZKiQ7LhbJZo22gB/JyjiAsJ8cEWB620rskA5p6fo50aPr8bt/ioIaXWtC88V
         Hh35zbpAPnnSZO3SvTxJyib3tT/R1mYE0a1rq5mHzxGm1HYE/RFxhGONE2jJNpHRtLLI
         8zaCkhL+/RswwTUIIzgSSH57KNIXxyP6mjJ4t5YlEKpMsciiU2vZI/U5TFytNK9a5HHT
         66v0RUkWMxs5N5bK9V6COAti9d1SEM6vJtpuhmK8nAMe1ClaPqqX5gd08w720PvVKEoB
         NMUA==
X-Gm-Message-State: ANhLgQ1pKQbelCROiEAZWLHcWJ61WVNy1ohsJCjjACu/cYYUe2o4tGZp
        LX31Vagwj3vekTm4ibMkUgrlxg==
X-Google-Smtp-Source: ADFU+vsLBdTIo2RFC6eor4lQSXcgoFNef7Q0wqww0m22ki11qoYH8MfjaPvXFc0FSpKP8PRJNO7Ksg==
X-Received: by 2002:adf:a285:: with SMTP id s5mr23447337wra.118.1583777084033;
        Mon, 09 Mar 2020 11:04:44 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.123])
        by smtp.gmail.com with ESMTPSA id b141sm459389wme.2.2020.03.09.11.04.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 11:04:43 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
To:     Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava> <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com> <20200304212931.GE168640@krava>
 <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <4d3b2e44-48bd-ece2-a1c7-16b7950bc472@isovalent.com>
Date:   Mon, 9 Mar 2020 18:04:42 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-04 21:39 UTC+0000 ~ Song Liu <songliubraving@fb.com>
> 
> 
>> On Mar 4, 2020, at 1:29 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>>
>> On Wed, Mar 04, 2020 at 09:16:29PM +0000, Song Liu wrote:
>>>
>>>
>>>> On Mar 4, 2020, at 12:41 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>>>>
>>>> On Wed, Mar 04, 2020 at 08:08:07PM +0100, Jiri Olsa wrote:
>>>>> On Wed, Mar 04, 2020 at 10:07:06AM -0800, Song Liu wrote:
>>>>>> This set introduces bpftool prog profile command, which uses hardware
>>>>>> counters to profile BPF programs.
>>>>>>
>>>>>> This command attaches fentry/fexit programs to a target program. These two
>>>>>> programs read hardware counters before and after the target program and
>>>>>> calculate the difference.
>>>>>>
>>>>>> Changes v3 => v4:
>>>>>> 1. Simplify err handling in profile_open_perf_events() (Quentin);
>>>>>> 2. Remove redundant p_err() (Quentin);
>>>>>> 3. Replace tab with space in bash-completion; (Quentin);
>>>>>> 4. Fix typo _bpftool_get_map_names => _bpftool_get_prog_names (Quentin).
>>>>>
>>>>> hum, I'm getting:
>>>>>
>>>>> 	[jolsa@dell-r440-01 bpftool]$ pwd
>>>>> 	/home/jolsa/linux-perf/tools/bpf/bpftool
>>>>> 	[jolsa@dell-r440-01 bpftool]$ make
>>>>> 	...
>>>>> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
>>>>> 	  LINK     _bpftool
>>>>> 	make: *** No rule to make target 'skeleton/profiler.bpf.c', needed by 'skeleton/profiler.bpf.o'.  Stop.
>>>>
>>>> ok, I had to apply your patches by hand, because 'git am' refused to
>>>> due to fuzz.. so some of you new files did not make it to my tree ;-)
>>>>
>>>> anyway I hit another error now:
>>>>
>>>> 	  CC       prog.o
>>>> 	In file included from prog.c:1553:
>>>> 	profiler.skel.h: In function ‘profiler_bpf__create_skeleton’:
>>>> 	profiler.skel.h:136:35: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>>>> 	  136 |  s->maps[4].mmaped = (void **)&obj->rodata;
>>>> 	      |                                   ^~
>>>> 	prog.c: In function ‘profile_read_values’:
>>>> 	prog.c:1650:29: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>>>> 	 1650 |  __u32 m, cpu, num_cpu = obj->rodata->num_cpu;
>>>>
>>>> I'll try to figure it out.. might be error on my end
>>>>
>>>> do you have git repo with these changes?
>>>
>>> I pushed it to 
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/linux.git/tree/?h=bpf-per-prog-stats
>>
>> still the same:
>>
>> 	[jolsa@dell-r440-01 bpftool]$ git show --oneline HEAD | head -1
>> 	7bbda5cca00a bpftool: fix typo in bash-completion
>> 	[jolsa@dell-r440-01 bpftool]$ make 
>> 	make[1]: Entering directory '/home/jolsa/linux-perf/tools/lib/bpf'
>> 	make[1]: Leaving directory '/home/jolsa/linux-perf/tools/lib/bpf'
>> 	  CC       prog.o
>> 	In file included from prog.c:1553:
>> 	profiler.skel.h: In function ‘profiler_bpf__create_skeleton’:
>> 	profiler.skel.h:136:35: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	  136 |  s->maps[4].mmaped = (void **)&obj->rodata;
>> 	      |                                   ^~
>> 	prog.c: In function ‘profile_read_values’:
>> 	prog.c:1650:29: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1650 |  __u32 m, cpu, num_cpu = obj->rodata->num_cpu;
>> 	      |                             ^~
>> 	prog.c: In function ‘profile_open_perf_events’:
>> 	prog.c:1810:19: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
>> 	      |                   ^~
>> 	prog.c:1810:42: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1810 |   sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
>> 	      |                                          ^~
>> 	prog.c:1825:26: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1825 |   for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
>> 	      |                          ^~
>> 	prog.c: In function ‘do_profile’:
>> 	prog.c:1904:13: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1904 |  profile_obj->rodata->num_cpu = num_cpu;
>> 	      |             ^~
>> 	prog.c:1905:13: error: ‘struct profiler_bpf’ has no member named ‘rodata’
>> 	 1905 |  profile_obj->rodata->num_metric = num_metric;
>> 	      |             ^~
>> 	make: *** [Makefile:129: prog.o] Error 1
> 
> I guess you need a newer version of clang that supports global data in BPF programs. 
> 
> Thanks,
> Song
> 

Thinking about this requirement again... Do you think it would be worth
adding (as a follow-up) a feature check on the availability of clang
with global data support to bpftool's Makefile? So that we could compile
out program profiling if clang is not present or does not support it.
Just like libbfd support is optional already.

I'm asking mostly because a number of distributions now package bpftool,
and e.g. Ubuntu builds it from kernel source when creating its
linux-images and linux-tools-* packages. And I am pretty sure the build
environment does not have latest clang/LLVM, but it would be great to
remain able to build bpftool.

Best regards,
Quentin
