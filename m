Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590D71A5E5E
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 13:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDLL4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 07:56:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44170 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDLL43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 07:56:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id z26so6163383ljz.11
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 04:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BjDcmqGEVd5mzlVwvO39Yh+BVh+W5KIn0cKexVoZutM=;
        b=OJyMhPABh3x1XouvlsElUh2YR+uox+dJPCZftCoI7Dfx+mTb9ufBFLAMJy0+qw+KFo
         i8bbthWdyYp/AiYbNuXw8eiEeqiwjKJdtl90poKuaazvj8H/IMxJ+B9hhNZ0/0jSGnnw
         UbwEFwzXMSjMnv9uj7cZ3EZqhN63QGPN8n6oap1ut9t1wiTLc0tdP5pPRPuRvyCGQ7kj
         AIHZA+9yJwfZx6A2RASM1Kac3ISamhD8fhHveUgnYu+XyCwSzKcb+8hAiLN4hLl1djac
         dvYCaxnpeHJLPCY9ELfVp+d1mxUhHOfxxlUxIUM+jpfcBCWTrvTLCA7MXLLvsO0bXv38
         HFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BjDcmqGEVd5mzlVwvO39Yh+BVh+W5KIn0cKexVoZutM=;
        b=p5oAdq64QofRzSmAPpoFimXTyUboCIViixlUULle3KwP9domrJ1b+RLBt3DPR14oKd
         GnBub4m768VzFWbxgCNZTPMcSMmuiH643PW9AOnjk1pq1ofgcy4PRI0OcEpGfgiS6MFq
         9lfQHOitlvPQldUcOCWIr2vKdGM7w0s1kB2hlkWmWY2RTZIe4XMeGT6kLcJMXmhz+5l6
         mbGHqzlgJOdU99QQ8gGIViRrH2rScKxL9EkY4L47UryKc3zXnUfIuNSooPUcJXUz/n+2
         F2DakNO7YVoQBHPcNT7zTbnpca0Us1nUX9MJBTd1eRbm3cEtlDBWw01OxadFnVJvVgTb
         l0kQ==
X-Gm-Message-State: AGi0PuZ5N36TXfCB5n1Sg9b83LAuKLYn5KVP5S6o7Pf/PLR4QKOkbh8k
        f3YfKo3HsPSvzr71qWvUBkVGHSXV
X-Google-Smtp-Source: APiQypJFAdgm4xMBeQ2z8M58kql3/rOwpuFArBnFPow4o78QsYBrmayt9gxTzi6xNt9Tdnj8aOAPhw==
X-Received: by 2002:a2e:b241:: with SMTP id n1mr7280278ljm.22.1586692587382;
        Sun, 12 Apr 2020 04:56:27 -0700 (PDT)
Received: from [192.168.1.134] (dsl-olubng11-54f81e-195.dhcp.inet.fi. [84.248.30.195])
        by smtp.gmail.com with ESMTPSA id k16sm5199659ljk.64.2020.04.12.04.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Apr 2020 04:56:26 -0700 (PDT)
Subject: Re: About r8169 regression 5.4
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Vincas Dargis <vindrg@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
 <20200215161247.GA179065@eldamar.local>
From:   Lauri Jakku <ljakku77@gmail.com>
Message-ID: <673c3c72-001e-a7b8-86a7-35772d719a9c@gmail.com>
Date:   Sun, 12 Apr 2020 14:56:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200215161247.GA179065@eldamar.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have patch ready for it

On 2020-02-15 18:12, Salvatore Bonaccorso wrote:
> Hi Vincas,
>
> On Sat, Feb 15, 2020 at 11:22:01AM +0200, Vincas Dargis wrote:
>> 2020-02-14 22:14, Heiner Kallweit rašė:
>>> On 14.02.2020 18:21, Vincas Dargis wrote:
>>>> Hi,
>>>>
>>>> I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:
>>>>
>>> Thanks for reporting. As you refer to [0], do you use jumbo packets?
>> Not sure, I guess not, because "1500"?
>>
>> $ ip link | fgrep enp
>> 2: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
>> state UP mode DEFAULT group default qlen 1000
>>
>>> Best of course would be a bisect between 5.3 and 5.4. Can you do this?
>>> I have no test hardware with this chip version (RTL8411B).
>> Uhm, never done that, I'll have to research how do I "properly" build kernel in "Debian way" first.
>>
>>> You could also try to revert a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
>>> and check whether this fixes your issue.
>>> In addition you could test latest 5.5-rc, or linux-next.
>> I've tried linux-image-5.5.0-rc5-amd64  (5.5~rc5-1~exp1) package form Debian
>> experimental, issue "WARNING: CPU: 6 PID: 0 at net/sched/sch_generic.c:447
>> dev_watchdog+0x248/0x250" still occurs after some time after boot.
>>
>> I'll try first to rebuild one of the Debian kernels after reverting that
>> a7a92cf81589 patch, for starters.
> You can generate the a7a92cf81589 revert patch, and then for simple
> testing of a patch and build have a look at the Simple patching and
> building[1] section of the kernel handbook.
>
> Hope this helps,
>
> Regards,
> Salvatore
>
>  [1] https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s4.2.2
