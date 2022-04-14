Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03010500C20
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 13:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242665AbiDNL1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 07:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbiDNL1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 07:27:54 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85E916B098;
        Thu, 14 Apr 2022 04:25:26 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:53300.829768023
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.42 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 299A6100180;
        Thu, 14 Apr 2022 19:25:24 +0800 (CST)
Received: from  ([123.150.8.42])
        by gateway-153622-dep-749df8664c-cv9r2 with ESMTP id f4c7d0cadc754fd4ac18aa9e8d26d809 for daniel@iogearbox.net;
        Thu, 14 Apr 2022 19:25:25 CST
X-Transaction-ID: f4c7d0cadc754fd4ac18aa9e8d26d809
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.42
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
Message-ID: <ac371d36-2624-cdd8-0c15-62ccf53bed81@189.cn>
Date:   Thu, 14 Apr 2022 19:25:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH 0/1] sample: bpf: introduce irqlat
Content-Language: en-US
To:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1649927240-18991-1-git-send-email-chensong_2000@189.cn>
 <2e6ee265-903c-2b5c-aefd-ec24f930c999@iogearbox.net>
From:   Song Chen <chensong_2000@189.cn>
In-Reply-To: <2e6ee265-903c-2b5c-aefd-ec24f930c999@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Daniel,

Thanks for liking the idea.

My target is embedded devices, that's why i get started from ebpf C.bcc 
and bpftrace is a good idea, but i prefer taking one thing at a time, 
what's more, i'm not familiar with python, it might take longer.

Once C code is accepted, i will move myself to bcc and bpftrace. Is it 
ok for you?

BR

Song


在 2022/4/14 17:47, Daniel Borkmann 写道:
> On 4/14/22 11:07 AM, Song Chen wrote:
>> I'm planning to implement a couple of ebpf tools for preempt rt,
>> including irq latency, preempt latency and so on, how does it sound
>> to you?
> 
> Sounds great, thanks! Please add these tools for upstream inclusion 
> either to bpftrace [0] or
> bcc [1], then a wider range of users would be able to benefit from them 
> as well as they are
> also shipped as distro packages and generally more widely used compared 
> to kernel samples.
> 
> Thanks Song!
> 
>    [0] https://github.com/iovisor/bpftrace/tree/master/tools
>    [1] https://github.com/iovisor/bcc/tree/master/libbpf-tools
> 
>> Song Chen (1):
>>    sample: bpf: introduce irqlat
>>
>>   samples/bpf/.gitignore    |   1 +
>>   samples/bpf/Makefile      |   5 ++
>>   samples/bpf/irqlat_kern.c |  81 ++++++++++++++++++++++++++++++
>>   samples/bpf/irqlat_user.c | 100 ++++++++++++++++++++++++++++++++++++++
>>   4 files changed, 187 insertions(+)
>>   create mode 100644 samples/bpf/irqlat_kern.c
>>   create mode 100644 samples/bpf/irqlat_user.c
>>
> 
> 
