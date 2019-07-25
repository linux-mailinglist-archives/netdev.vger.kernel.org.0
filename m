Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22812744B1
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390393AbfGYFEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:04:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38565 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390362AbfGYFEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 01:04:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so49208015wrr.5;
        Wed, 24 Jul 2019 22:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=L3y8eC1YuclFK7hkbXSnSrEEcZUpnhzJHsbuLqVifNc=;
        b=q9dPlklL5rXCpD7A83RKtz9wCstwLbnUviTpE/vD1Aga8gLxuWcfLGMAlemNHX3mpY
         SWyrx6/IAOIO8s1PqgPfNZfMuaNGNsQ/9yo7CefpiHSh22W2q33Lt9pfO8cItKDdXv2A
         14T8Mt8KAukz4RGykTJyND2vCEPqS/wUQyE+7+5Cy7aWk1J+nXiy3KYyR6gff0fxjd2Q
         3zNjFK2NArzweu0DyrivLKEP8aOsrCPxyLUphiq5juNtI2o5JaX32IJq5Mb+sGqGRios
         nbH+vUbmDqH2Q5ZkqVUBdV695MFZu8euLS89xOdrmrvyXjmUQQL/LvFlmPGagvO/Dc0g
         InOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L3y8eC1YuclFK7hkbXSnSrEEcZUpnhzJHsbuLqVifNc=;
        b=J1oZ87/tOVT0FuhmSTxxk8sfc5uljZ+pNm2I/Pjw4uJymRIVuoieNG3kzpgSlURg7y
         BleXjdf+6fqbv24AqqOv0eEZW4dqt+W94YDDBaTqqJ0nkwvwCJZ9mXcSmohffEVsxaRm
         F6eRfeSJcFipiP0CQRhXJuQbFrgkx394v+qz0Io+o0us/U7mueb6a/bL7nIK4i9lEKsE
         81OEPP9K2hA9LhjKlTOpamXneZGVMSIKhjwnbotLotGVmTrzrCF2jt4m5zR2FlqYUPUy
         lH1kwCW8s03sAT4w/qCo1f5NZaLVObkXCmU20H3s0tVKzUO+TlpnmhdXzFayxK4zdTiW
         H0Kw==
X-Gm-Message-State: APjAAAWlO+kUxE3iI+2cxvdHhQvBV+YFkODTSxl+gPwYgHls/M+ThQ80
        MAlRZaQz78th1QFwWKDROfg=
X-Google-Smtp-Source: APXvYqwbeu82ejFTSWXKLFdZY97MjPo8vdf0wiUiDfJNuujA1pYZkzS4KF9tqtwY2qYts4mA/wBZbA==
X-Received: by 2002:adf:db46:: with SMTP id f6mr40735548wrj.212.1564031090109;
        Wed, 24 Jul 2019 22:04:50 -0700 (PDT)
Received: from [192.168.8.147] (240.169.185.81.rev.sfr.net. [81.185.169.240])
        by smtp.gmail.com with ESMTPSA id j33sm95211179wre.42.2019.07.24.22.04.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 22:04:48 -0700 (PDT)
Subject: Re: Reminder: 99 open syzbot bugs in net subsystem
To:     David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        dvyukov@google.com, netdev@vger.kernel.org, fw@strlen.de,
        i.maximets@samsung.com, edumazet@google.com, dsahern@gmail.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <20190724163014.GC673@sol.localdomain>
 <20190724.111225.2257475150626507655.davem@davemloft.net>
 <20190724183710.GF213255@gmail.com>
 <20190724.130928.1854327585456756387.davem@davemloft.net>
 <20190724210950.GH213255@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1e07462d-61e2-9885-edd0-97a82dd7883e@gmail.com>
Date:   Thu, 25 Jul 2019 07:04:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190724210950.GH213255@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/19 11:09 PM, Eric Biggers wrote:
> On Wed, Jul 24, 2019 at 01:09:28PM -0700, David Miller wrote:
>> From: Eric Biggers <ebiggers@kernel.org>
>> Date: Wed, 24 Jul 2019 11:37:12 -0700
>>
>>> We can argue about what words to use to describe this situation, but
>>> it doesn't change the situation itself.
>>
>> And we should argue about those words because it matters to humans and
>> effects how they feel, and humans ultimately fix these bugs.
>>
>> So please stop with the hyperbole.
>>
>> Thank you.
> 
> Okay, there are 151 bugs that syzbot saw on the mainline Linux kernel in the
> last 7 days (90.1% with reproducers).  Of those, 59 were reported over 3 months
> ago (89.8% with reproducers).  Of those, 12 were reported over a year ago (83.3%
> with reproducers).
> 
> No opinion on whether those are small/medium/large numbers, in case it would
> hurt someone's feelings.
> 
> These numbers do *not* include bugs that are still valid but weren't seen on
> mainline in last 7 days, e.g.:
> 
> - Bugs that are seen only rarely, so by chance weren't seen in last 7 days.
> - Bugs only in linux-next and/or subsystem branches.
> - Bugs that were seen in mainline more than 7 days ago, and then only on
>   linux-next or subsystem branch in last 7 days.
> - Bugs that stopped being seen due to a change in syzkaller.
> - Bugs that stopped being seen due to a change in kernel config.
> - Bugs that stopped being seen due to other environment changes such as kernel
>   command line parameters.
> - Bugs that stopped being seen due to a kernel change that hid the bug but
>   didn't actually fix it, i.e. still reachable in other ways.
> 

We do not doubt syzkaller is an incredible tool.

But netdev@ and lkml@ are mailing lists for humans to interact,
exchange ideas, send patches and review them.

To me, an issue that was reported to netdev by a real user is _way_ more important
than potential issues that a bot might have found doing crazy things.

We need to keep optimal S/N on mailing lists, so any bots trying to interact
with these lists must be very cautious and damn smart.

When I have time to spare and can work on syzbot reports, I am going to a web
page where I can see them and select the ones it makes sense to fix.
I hate having to set up email filters.

