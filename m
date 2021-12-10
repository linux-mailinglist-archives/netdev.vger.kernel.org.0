Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A2346FD37
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238933AbhLJJEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:04:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbhLJJEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:04:08 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB014C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:00:33 -0800 (PST)
Received: from ip4d173d4a.dynamic.kabel-deutschland.de ([77.23.61.74] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mvblV-0006nW-L4; Fri, 10 Dec 2021 10:00:30 +0100
Message-ID: <cb51a8cc-7c43-745e-e075-398eee47b071@leemhuis.info>
Date:   Fri, 10 Dec 2021 10:00:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: Fw: [Bug 215129] New: Linux kernel hangs during power down
 #forregzbot
Content-Language: en-BS
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        netdev <netdev@vger.kernel.org>
References: <20211124144505.31e15716@hermes.local>
 <bca0a700-65ba-1b8d-c265-b1051423a7e2@leemhuis.info>
 <93f23a8b-518d-d573-4b46-5883477eedfc@leemhuis.info>
In-Reply-To: <93f23a8b-518d-d573-4b46-5883477eedfc@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1639126833;05e2f11d;
X-HE-SMSGID: 1mvblV-0006nW-L4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 04.12.21 09:55, Thorsten Leemhuis wrote:
> Top-posting for once, to make this easy accessible to everyone.

Once again. The fix sadly didn't link to the mail with the report on the
list, as it should (see https://git.kernel.org/linus/1f57bd42b77c ),
otherwise this message wouldn't be needed. But whatever, for the record
& regzbot:

A fix was committed here:

https://kernel.googlesource.com/pub/scm/linux/kernel/git/tnguy/net-queue/+/de98e3651464acb08a5bba6df9ad323c7e9cdc33

Not yet in next and the commit-id is likely to different later, but I
ignore that for now and tell regzbot about it nevertheless:

#regzbot fixed-by: de98e3651464acb08a5bba6df9ad323c7e9cdc33

Ciao, Thorsten


> A fix is discussed here:
> 
> #regzbot link https://bugzilla.kernel.org/show_bug.cgi?id=215129
> #regzbot monitor
> https://lore.kernel.org/all/6bb28d2f-4884-7696-0582-c26c35534bae@gmail.com/
> 
> Ciao, Thorsten, your Linux kernel regression tracker.
> 
> TWIMC: this mail is primarily send for documentation purposes and for
> regzbot, my Linux kernel regression tracking bot. These mails usually
> contain '#forregzbot' in the subject, to make them easy to spot and filter.
> 
> P.S.: I guess I'll modify regzbot to automatically catch related
> discussions if they links to the same bugzilla ticket (which I forgot to
> tell regzbot about when I told it about the regression), then messages
> like this wouldn't be needed.
> 
> 
> On 25.11.21 12:17, Thorsten Leemhuis wrote:
>> Hi, this is your Linux kernel regression tracker speaking.
>>
>> On 24.11.21 23:45, Stephen Hemminger wrote:
>>>
>>>
>>> Begin forwarded message:
>>>
>>> Date: Wed, 24 Nov 2021 21:14:53 +0000
>>> From: bugzilla-daemon@bugzilla.kernel.org
>>> To: stephen@networkplumber.org
>>> Subject: [Bug 215129] New: Linux kernel hangs during power down
>>>
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>>
>>>             Bug ID: 215129
>>>            Summary: Linux kernel hangs during power down
>>>            Product: Networking
>>>            Version: 2.5
>>>     Kernel Version: 5.15
>>>           Hardware: All
>>>                 OS: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: Other
>>>           Assignee: stephen@networkplumber.org
>>>           Reporter: martin.stolpe@gmail.com
>>>         Regression: No
>>>
>>> Created attachment 299703
>>>   --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit  
>>> Kernel log after timeout occured
>>>
>>> On my system the kernel is waiting for a task during shutdown which doesn't
>>> complete.
>>>
>>> The commit which causes this behavior is:
>>> [f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
>>> parent before ethtool ioctl ops
>>>
>>> This bug causes also that the system gets unresponsive after starting Steam:
>>> https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/
>>
>> TWIMC: To be sure this issue doesn't fall through the cracks unnoticed,
>> I'm adding it to regzbot, my Linux kernel regression tracking bot:
>>
>> #regzbot ^introduced f32a213765739f2a1db319346799f130a3d08820
>> #regzbot title net: kernel hangs during power down
>> #regzbot ignore-activity
>>
>> Ciao, Thorsten, your Linux kernel regression tracker.
>>
>> P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
>> on my table. I can only look briefly into most of them. Unfortunately
>> therefore I sometimes will get things wrong or miss something important.
>> I hope that's not the case here; if you think it is, don't hesitate to
>> tell me about it in a public reply. That's in everyone's interest, as
>> what I wrote above might be misleading to everyone reading this; any
>> suggestion I gave they thus might sent someone reading this down the
>> wrong rabbit hole, which none of us wants.
>>
>> BTW, I have no personal interest in this issue, which is tracked using
>> regzbot, my Linux kernel regression tracking bot
>> (https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
>> this mail to get things rolling again and hence don't need to be CC on
>> all further activities wrt to this regression.
>>
>> P.S.: If you want to know more about regzbot, check out its
>> web-interface, the getting start guide, and/or the references documentation:
>>
>> https://linux-regtracking.leemhuis.info/regzbot/
>> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
>> https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
>>
>> The last two documents will explain how you can interact with regzbot
>> yourself if your want to.
>>
>> Hint for the reporter: when reporting a regression it's in your interest
>> to tell #regzbot about it in the report, as that will ensure the
>> regression gets on the radar of regzbot and the regression tracker.
>> That's in your interest, as they will make sure the report won't fall
>> through the cracks unnoticed.
>>
>> Hint for developers: you normally don't need to care about regzbot, just
>> fix the issue as you normally would. Just remember to include a 'Link:'
>> tag to the report in the commit message, as explained in
>> Documentation/process/submitting-patches.rst
>> That aspect was recently was made more explicit in commit 1f57bd42b77c:
>> https://git.kernel.org/linus/1f57bd42b77c
>>
