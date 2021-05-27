Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8CD3392961
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhE0IUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:20:01 -0400
Received: from mail.loongson.cn ([114.242.206.163]:59164 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235169AbhE0IUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 04:20:01 -0400
Received: from [10.130.0.135] (unknown [113.200.148.30])
        by mail.loongson.cn (Coremail) with SMTP id AQAAf9Bx0OLHVa9gMycFAA--.3842S3;
        Thu, 27 May 2021 16:18:17 +0800 (CST)
Subject: Re: [QUESTION] BPF kernel selftests failed in the LTS stable kernel
 4.19.x
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <2988ff60-2d79-b066-6c02-16e5fe8b69db@loongson.cn>
 <YK8e+iLPjkmuO793@kroah.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
From:   Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <9671b7f4-b827-3c81-f1e5-2836c701495b@loongson.cn>
Date:   Thu, 27 May 2021 16:18:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <YK8e+iLPjkmuO793@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: AQAAf9Bx0OLHVa9gMycFAA--.3842S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFyUtFWDtr17Jr17Cry3Jwb_yoW8Gryfpa
        1fKa45Krs5Jw47Janrtr10vFyfZ395Jw43Ww1UtFy8Z3WDur10qr4F9a1avFsxKrn7ua1Y
        yr4xWasIqw1xZa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9lb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
        0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
        A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xII
        jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
        C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
        0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Gr0_Cr
        1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7
        Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI48JMxC20s
        026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_
        JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14
        v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xva
        j40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r
        4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUx6wCDUUUU
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/27/2021 12:24 PM, Greg Kroah-Hartman wrote:
> On Thu, May 27, 2021 at 10:27:51AM +0800, Tiezhu Yang wrote:
>> Hi all,
>>
>> When update the following LTS stable kernel 4.19.x,
>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/log/?h=linux-4.19.y
>>
>> and then run BPF selftests according to
>> https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html#q-how-to-run-bpf-selftests
>>
>> $ cd tools/testing/selftests/bpf/
>> $ make
>> $ sudo ./test_verifier
>> $ sudo make run_tests
>>
>> there exists many failures include verifier tests and run_tests,
>> (1) is it necessary to make sure that there are no any failures in the LTS
>> stable kernel 4.19.x?
> Yes, it would be nice if that did not happen.
>
>> (2) if yes, how to fix these failures in the LTS stable kernel 4.19.x?
> Can you find the offending commits by using `git bisect` and find the
> upstream commits that resolve this and let us know so we can backport
> them?
>
> thanks,
>
> greg k-h

I compared the related code in 4.19.y and upstream mainline, some failures
disappeared after add ".flags = F_NEEDS_EFFICIENT_UNALIGNED_ACCESS,", but
other failures still exist, and I didn't have enough in-depth knowledge to
touch things elsewhere.

The failures can be easily reproduced, I would greatly appreciate it if 
anyone
is interested to fix them.

