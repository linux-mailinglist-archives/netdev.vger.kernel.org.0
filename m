Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE8034D90F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhC2UbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhC2UbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 16:31:13 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D80C061574;
        Mon, 29 Mar 2021 13:31:13 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id j7so14149632wrd.1;
        Mon, 29 Mar 2021 13:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6txOJ7qOb/CCnuU8RJH/xS5l0FL0VtX/BfP8joMK7bU=;
        b=OJ3tgPvRaG4ckLFZk/g8lQyrzsOKnsY980ciYLFVucwbSmuAqZQF/68e7bLIP4b0sr
         9gxy0E5ndRoXhnePBjbZp2CT7n2tfV+WwKNrvktjWeC0LOvnuja4DQqxyptxko4jSU59
         j82ptWAyRQmWjs1UCIg712DxXA9xzQFAwLBsq47Rr6GMAaPDosQB4MOGOeV0WiYB6+O+
         bkHspiDF2A8CwsuGcdrgD4y2SGktkfDiWlTC4wbknXNosbeh+nFBBaG6spA92P/LeMgA
         O25aepCPo7JOHpdtUjAqhlsQV9T4AkCdOb6dpoTe6uiQDuYv5KRoCZUgZx97G+9gPE8q
         oT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6txOJ7qOb/CCnuU8RJH/xS5l0FL0VtX/BfP8joMK7bU=;
        b=n/6gBFLEwZk+qDruoCw6iGl/FGQqjbtFFd5j8xw9ZeFCD5L5IuwYtAPj+Ff+a0vzVU
         RWWwFg1AItcOV9Rh2IeBvtwHkSt6/R8DXc+p3xu5b0K1D/y+d6Nun2AWZEBsEMzb5uWL
         Ochnuzc1GHwDmtIOSCrnbE8wrAOBllPIricqMK/Y4B1lavmU2rPD0aJ89BMChph6bA5D
         8OUojTsWe/L6aCR4743jKE8U32Q7qe9LHbb1aFgtqjcbCCxmDfC1NbG9B0g55vgp1S5N
         bMpkxPOKBFIkcQ1vOXXkqRWd5Q1reK7nVKgdNkU7e+6jdeTr9q5Qm0JP5ueQu+CAdmxp
         ptQg==
X-Gm-Message-State: AOAM5335Wdcw1RhD2vCsTaS2x1AlgR2n5H1t6Zgt5qLkpnH5wYMaUd7r
        iRNBrf1zJOUpwgZnns6bOgA=
X-Google-Smtp-Source: ABdhPJw1pXpwEwqzt3DGLb1K0VQrxrbwxcP3RoWlJc/HKSOyyLY6ym4XHtsoe4SRuX3OJsv/kQUB4w==
X-Received: by 2002:adf:f711:: with SMTP id r17mr30093723wrp.358.1617049871867;
        Mon, 29 Mar 2021 13:31:11 -0700 (PDT)
Received: from [192.168.1.101] ([37.173.175.207])
        by smtp.gmail.com with ESMTPSA id h10sm32432410wrp.22.2021.03.29.13.31.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 13:31:11 -0700 (PDT)
Subject: Re: [syzbot] WARNING in xfrm_alloc_compat (2)
To:     Dmitry Safonov <dima@arista.com>,
        syzbot <syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <000000000000ceb65005beb18c8f@google.com>
 <06c56a34-b7c6-f397-568d-3cdf6b044858@arista.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a4f2d6c8-b4cf-c993-d0b4-952c16b2317d@gmail.com>
Date:   Mon, 29 Mar 2021 22:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <06c56a34-b7c6-f397-568d-3cdf6b044858@arista.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/21 9:57 PM, Dmitry Safonov wrote:
> Hi,
> 
> On 3/29/21 8:04 PM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    6c996e19 net: change netdev_unregister_timeout_secs min va..
>> git tree:       net-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=102e5926d00000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0ac79756537274e
>> dashboard link: https://syzkaller.appspot.com/bug?extid=834ffd1afc7212eb8147
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a7b1aad00000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ae6b7cd00000
>>
>> The issue was bisected to:
>>
>> commit 5f3eea6b7e8f58cf5c8a9d4b9679dc19e9e67ba3
>> Author: Dmitry Safonov <dima@arista.com>
>> Date:   Mon Sep 21 14:36:53 2020 +0000
>>
>>     xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10694b3ad00000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12694b3ad00000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14694b3ad00000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
>> Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
>>
>> netlink: 208 bytes leftover after parsing attributes in process `syz-executor193'.
>> ------------[ cut here ]------------
>> unsupported nla_type 356
> 
> This doesn't seem to be an issue.
> Userspace sent message with nla_type 356, which is > __XFRM_MSG_MAX, so
> this warning is expected. I've added it so when a new XFRM_MSG_* will be
> added, to make sure that there will be translations to such messages in
> xfrm_compat.ko (if the translation needed).
> This is WARN_ON_ONCE(), so it can't be used as DOS.
> 
> Ping me if you'd expect something else than once-a-boot warning for
> this. Not sure how-to close syzkaller bug, docs have only `invalid' tag,
> which isn't `not-a-bug'/`expected' tag:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
> 

You should not use WARN_ON_ONCE() for this case (if user space can trigger it)

https://lwn.net/Articles/769365/

<quote>
Greg Kroah-Hartman raised the problem of core kernel API code that will use WARN_ON_ONCE() to complain about bad usage; that will not generate the desired result if WARN_ON_ONCE() is configured to crash the machine. He was told that the code should just call pr_warn() instead, and that the called function should return an error in such situations. It was generally agreed that any WARN_ON() or WARN_ON_ONCE() calls that can be triggered from user space need to be fixed. 
</quote>


