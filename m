Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2592191D4
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgGHUuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHUuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:50:46 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB0FC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:50:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id gc9so86334pjb.2
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=modKgMpq32pPIjRtuXqEqAyb2UOtoHCMn57r/3zMYRM=;
        b=Vou6NPumD+5VHGAbG2LzQ6I5KYGr1ETd2WRDh+JF0qwaRpxNP8ZFiLcPNBeP3RhPYX
         BzonGkAkS9v0ejuzDpD7UQWxmMf4hfdVfYER+b/36WCSnMt0FS1wxFvmUsECS9BXRB0T
         Qa9rVajM63R7Xu4F6k0CxCLOOeQXNNXx1YuGTOGhjg6joBm3zMm8m/ajLKvOgx/+3kL3
         86QJsP+UJLJetz5cUGW+1LXyYEmnYMdfwJcH2ZGgzoIuqtXcOHwSXOnWS1aWjVGeXbp0
         YTAtDFtSlXFxiOMItjStvIsWJwyzVmuosOGnBNjDpO3a8mpvKhoBtGMWJ+ZrP3pPReGR
         1a0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=modKgMpq32pPIjRtuXqEqAyb2UOtoHCMn57r/3zMYRM=;
        b=UZZ/fDLAGWmL3DZgk2UyT8bJNvyd5OUT+VDN4HlMks12kkt5C2b1STF9kaCWqsbt/T
         tPaaYrLIwQKiqnAgMwQoiISmvVYRbXGteJUg1eW+++Lc6B+5yITXbJUr0DJRhYnwJ+dC
         oGu0FDFdpn3fJlc/qAKjVXCbc5jbPQa88Qk7d1rA4rgl1tpDZ7FvgLmg5M6KfyqICcXu
         jOby6CMyVg0dh+mOB4OQU0+adAMxrxcURyfi0fPzaeeaQnk4MQ8MXLM+u8kwvfW7kPXg
         fXbDM1jgQOJ0IKrlaeTDL0sALJ3kkiT9khrz3hXDVwo4a/mrCiyAaJfMdN7uSFTj+UA4
         /RmQ==
X-Gm-Message-State: AOAM530jCHxPnBNkVm19xKbI/nU9FZr7pdoMOSb583SYQ2DLAMGAYBy0
        LoF1qw3R/wMsY7kHdgYFKvCaOhDP
X-Google-Smtp-Source: ABdhPJwgvwPeexqEC+lo+3WltnnDRYkUmTySwpnexUklXGCJ2yWmWG+b1Fn9WE6fa9eqMvX0GmHSUw==
X-Received: by 2002:a17:902:bccc:: with SMTP id o12mr53987898pls.29.1594241445229;
        Wed, 08 Jul 2020 13:50:45 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n11sm627133pgm.1.2020.07.08.13.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 13:50:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] irq_work: Export symbol
 "irq_work_queue_on"
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Miller <davem@davemloft.net>, xiangning.yu@alibaba-inc.com
Cc:     netdev@vger.kernel.org
References: <12188783-aa3c-9a83-1e9f-c92e37485445@alibaba-inc.com>
 <20200708.123750.2177855708364007871.davem@davemloft.net>
 <e6ff5906-45a6-79c7-7f91-830eccea8a58@gmail.com>
Message-ID: <9732a72b-a217-b182-194c-38666d40cf53@gmail.com>
Date:   Wed, 8 Jul 2020 13:50:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e6ff5906-45a6-79c7-7f91-830eccea8a58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 1:27 PM, Eric Dumazet wrote:
> 
> 
> On 7/8/20 12:37 PM, David Miller wrote:
>> From: "YU, Xiangning" <xiangning.yu@alibaba-inc.com>
>> Date: Thu, 09 Jul 2020 00:38:16 +0800
>>
>>> @@ -111,7 +111,7 @@ bool irq_work_queue_on(struct irq_work *work, int cpu)
>>>  	return true;
>>>  #endif /* CONFIG_SMP */
>>>  }
>>> -
>>> +EXPORT_SYMBOL_GPL(irq_work_queue_on);
>>
>> You either removed the need for kthreads or you didn't.
>>
>> If you are queueing IRQ work like this, you're still using kthreads.
>>
>> That's why Eric is asking why you still need this export.
>>
> 
> I received my copy of the 2/2 patch very late, I probably misunderstood
> the v2 changes.
> 
> It seems irq_work_queue_on() is till heavily used, and this makes me nervous.
> 
> Has this thing being tested on 256 cores platform ?
> 

Oh well, the answer is no.
...
#define    MAX_CPU_COUNT       128 /* make it dynamic */ 
...
ltb->num_cpus = num_online_cpus();
if (ltb->num_cpus > MAX_CPU_COUNT)
    return (ltb->num_cpus > MAX_CPU_COUNT)

