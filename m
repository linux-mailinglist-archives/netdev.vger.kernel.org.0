Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B59D3FE511
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 23:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242412AbhIAVtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 17:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhIAVto (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 17:49:44 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AEFC061575;
        Wed,  1 Sep 2021 14:48:47 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id x10-20020a056830408a00b004f26cead745so1543999ott.10;
        Wed, 01 Sep 2021 14:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bM/DObiZ9PUO+ooQ6bmBOKRWIQZ3cIe0ybO6KHu8cTQ=;
        b=foUJrSLb8NoGrGAcbGQtZOC9HiFzsYHciEyZlDitunIZtfznW49Y4/U7lkVY3yVm/G
         hQDvlegv0nC9pmpowUW/4wuCHT0IOSa+XVE6gF4Rw4id6djAc/CUPSYJgmUC0EQl1AVy
         EoPn0TZ0TBC1bKZEn/dl7SFqaGAE41K8uc/W+jNQ0agzUmrWSO9DNbyd4pUmX9KRAab1
         0tm2HCcxN486zLS/3y4JV6lLn0nGu0/Z9pkFBxKbmXuLGAWRHWoPkS9Tz2CDHGvaWHSz
         BgYhvFKyKR5aAMG1g/h5F79levteWJPKMZ+iDwLyLvKHwiqPx5kjrRodUwXSujTlRBKB
         lmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bM/DObiZ9PUO+ooQ6bmBOKRWIQZ3cIe0ybO6KHu8cTQ=;
        b=qoIfYRfuxE4tSI/xRn9Gd+fM3dG7Mvs7zCrWAnuvRoabzs+LoEerXxi0UwYcT43j2k
         O+EH4HiEwfwRpFdlZTVCv6bPXKMoNGXGjEpg44pxTxd+U5QiYIvfX8xXFxsNgeNA0AvH
         7U0BqAVo7StK64b7vWCleu5f7/iY4ErGI387RAF229SS1q8SRwLTwKe09otpPUbTBDWB
         j6CZORFwd47aKplE+8s+w39dg5oSDMbh+wiVwr2n0ZMYwxN+80/mlKG6E3493fnTlCnQ
         bRZSPjCKP4ERObUTxSEhQw3RoKhT5XyYi4b+c15NgsUHrhgglWwD1iRoosR2C/z4y4/c
         YmpA==
X-Gm-Message-State: AOAM533O7PV6Q88ilwQ+xiTJSMtbQlaktQVNvrMeCVhfOffwuwS+IOaq
        0fcN2zjgZmsXMEvXaBFVBhk=
X-Google-Smtp-Source: ABdhPJxSxIeSetO6ZBqwHPOtR8ynpEZFfmXOoDs2IWjEExxm6adHf6GyW0d7soNrcwmU3QMUWszA9w==
X-Received: by 2002:a05:6830:2443:: with SMTP id x3mr1375906otr.12.1630532926987;
        Wed, 01 Sep 2021 14:48:46 -0700 (PDT)
Received: from ?IPV6:2603:8090:2005:39b3::1023? (2603-8090-2005-39b3-0000-0000-0000-1023.res6.spectrum.com. [2603:8090:2005:39b3::1023])
        by smtp.gmail.com with UTF8SMTPSA id bg38sm5348oib.26.2021.09.01.14.48.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 14:48:46 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <3e1db007-1ffa-6e84-a0f7-a36fa0820768@lwfinger.net>
Date:   Wed, 1 Sep 2021 16:48:44 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [GIT PULL] Networking for v5.15
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>
References: <20210831203727.3852294-1-kuba@kernel.org>
 <CAHk-=wjB_zBwZ+WR9LOpvgjvaQn=cqryoKigod8QnZs=iYGEhA@mail.gmail.com>
 <20210901124131.0bc62578@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <4dfae09cd2ea3f5fe4b8fa5097d1e0cc8a34e848.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/21 14:49, Johannes Berg wrote:
> On Wed, 2021-09-01 at 12:41 -0700, Jakub Kicinski wrote:
>>
>>>
>>> They all seem to have that same issue, and it looks like the fix would
>>> be to get the RTN lock in iwl_mvm_init_mcc(), but I didn't really look
>>> into it very much.
>>>
>>> This is on my desktop, and I actually don't _use_ the wireless on this
>>> machine. I assume it still works despite the warnings, but they should
>>> get fixed.
>>>
>>> I *don't* see these warnings on my laptop where I actually use
>>> wireless, but that one uses ath10k_pci, so it seems this is purely a
>>> iwlwifi issue.
>>>
>>> I can't be the only one that sees this. Hmm?
>>
>> Mm. Looking thru the recent commits there is a suspicious rtnl_unlock()
>> in commit eb09ae93dabf ("iwlwifi: mvm: load regdomain at INIT stage").
> 
> Huh! That's not the version of the commit I remember - it had an
> rtnl_lock() in there too (just before the mutex_lock)?! Looks like that
> should really be there, not sure how/where it got lost along the way.
> 
> That unbalanced rtnl_unlock() makes no sense anyway. Wonder why it
> doesn't cause more assertions/problems at that point, clearly it's
> unbalanced. Pretty sure it's missing the rtnl_lock() earlier in the
> function for some reason.
> 
> Luca and I will look at it tomorrow, getting late here, sorry.
> 
> johannes
> 
I am seeing the same problem, and it does happen in lots of places. For example

finger@2603-8090-2005-39b3-0000-0000-0000-1023:~/rtl8812au>dmesg | grep 
assertion\ failed
[    6.465589] RTNL: assertion failed at net/core/rtnetlink.c (1702)
[    6.465948] RTNL: assertion failed at net/core/devlink.c (11496)
[    6.466263] RTNL: assertion failed at net/core/rtnetlink.c (1412)
[    6.466500] RTNL: assertion failed at net/core/dev.c (1987)
[    6.466708] RTNL: assertion failed at net/core/fib_rules.c (1227)
[    6.466902] RTNL: assertion failed at net/ipv4/devinet.c (1526)
[    6.467097] RTNL: assertion failed at net/ipv4/igmp.c (1779)
[    6.467291] RTNL: assertion failed at net/ipv4/igmp.c (1432)

I am in the process of bisecting the problem, just in case it happens some other 
place than your suspicion leads you.

Larry

