Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8FA1E728B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 04:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405089AbgE2CYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 22:24:50 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:41046 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404312AbgE2CYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 22:24:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0TzwUFZy_1590719085;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0TzwUFZy_1590719085)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 May 2020 10:24:46 +0800
Subject: Re: [RFC PATCH] samples:bpf: introduce task detector
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
References: <6561a67d-6dac-0302-8590-5f46bb0205c2@linux.alibaba.com>
 <CAEf4BzYwO59x0kJWNk1sfwKz=Lw+Sb_ouyRpx8-v1x8XFoqMOw@mail.gmail.com>
 <9a78329c-8bfe-2b83-b418-3de88e972c5a@linux.alibaba.com>
 <CAEf4BzYHFAbOeVbs8Y2j5HjYOavDC+M+HtOst69Qtm2h5A3M=A@mail.gmail.com>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <0c8ec8d5-22df-8380-1ebf-e7f124dbe801@linux.alibaba.com>
Date:   Fri, 29 May 2020 10:24:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYHFAbOeVbs8Y2j5HjYOavDC+M+HtOst69Qtm2h5A3M=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/29 上午2:34, Andrii Nakryiko wrote:
[snip]
>>>
>>> With CO-RE, it also will allow to compile this tool once and run it on
>>> many different kernels without recompilation. Please do take a look
>>> and submit a PR there, it will be a good addition to the toolkit (and
>>> will force you write a bit of README explaining use of this tool as
>>> well ;).
>>
>> Aha, I used to think bcc only support python and cpp :-P
>>
> 
> libbpf-tools don't use BCC at all, they are just co-located with BCC
> and BCC tools in the same repository and are lightweight alternatives
> to BCC-based tools. But it needs kernel with BTF built-in, which is
> the only (temporary) downside.

I see, thanks for the explain :-)

We prefer libbpf since we feel it's more friendly for kernel folks to
do develop, less suspects when meet any BUG, while BCC is a good way
to package and distribute, glad to know that we can have them in one
piece now.

Regards,
Michael Wang

> 
>> I'll try to rework it and submit PR, I'm glad to know that you think
>> this tool as a helpful one, we do solved some tough issue with it
>> already.
>>
>>>
>>> As for the code itself, I haven't gone through it much, but please
>>> convert map definition syntax to BTF-defined one. The one you are
>>> using is a legacy one. Thanks!
>>>
>>>   [0] https://github.com/iovisor/bcc/tree/master/libbpf-tools
>>
>> Will check the example there :-)
>>
>> Regards,
>> Michael Wang
>>
>>>
>>>>  samples/bpf/Makefile             |   3 +
>>>>  samples/bpf/task_detector.h      | 382 +++++++++++++++++++++++++++++++++++++++
>>>>  samples/bpf/task_detector_kern.c | 329 +++++++++++++++++++++++++++++++++
>>>>  samples/bpf/task_detector_user.c | 314 ++++++++++++++++++++++++++++++++
>>>>  4 files changed, 1028 insertions(+)
>>>>  create mode 100644 samples/bpf/task_detector.h
>>>>  create mode 100644 samples/bpf/task_detector_kern.c
>>>>  create mode 100644 samples/bpf/task_detector_user.c
>>>>
>>>
>>> [...]
>>>
