Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C6C3379C8
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhCKQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCKQn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:43:58 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E284CC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:43:57 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id z25so2985490lja.3
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=hWnPCJLlHc2RukGUfWN6xbxveygo+DMUJclF8Xo4tnk=;
        b=r0T+N2j4itSugNZbVd6Qiv5qIHe1ugPAfELvZ3kO6Zk8+6/UC79x64JqqzGDmD0Drh
         fQe/x1UOHC1xMgxUN5mWL2yJrEiRrZ+lIlTBI/T2nSXxR6lW200AMC6BNsdQva8wn2QK
         deguX+sDJ0NTFpsIHTOG0r/he1+GR2S5sPhgJC1H6efU+ZZc5hurjCkDCcJaqn8cmMZ1
         Myy9MM1YIo+N970sytSUmbs25P206nKHv3ZGu8LIYnqOqo/N7ivr3hPk2LmW3yNcMYZA
         LEoDqPS02aqI7C+ttz5Pwfw6KXnDBkbkfKMcusaKJWz3BrZqdIF63nscJBR7km12DEe0
         jDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding;
        bh=hWnPCJLlHc2RukGUfWN6xbxveygo+DMUJclF8Xo4tnk=;
        b=bQhX7BN0DM5m+8kZ1nu+iaJh6vzoKcRB2RDkfMt5vaidzvkO8a/iIXmqFEzKFRl6Hv
         ce+o+UVT2cYql93b5jLEW9zTfuwvKrYspQP4KEr+GZ0CyUrNQPElmNln8F0F4eD4JpKV
         +eMu9VARIVq/ZZFLiUxZUJTvYP6lr4mV8eRqJYxtBDeji1C9eSCNLiaUzh1xisuGfC6C
         mqr0AY3AGSaOuTO4RD3npF6CSx6ihfwpWvHBZ4fS6DgKiPDBGh3QZCZObXHqyPhCBP63
         OT0P+X1DOM6DHy+atxZwAEnCdnaGwM0CLCFOoWel1QhKAJPy8zNi3fwdDmsJ9uJrYKtk
         OxiQ==
X-Gm-Message-State: AOAM532QKrSx1McXFBtAZiPY+I+NYieNgBRjhj6mY9RyRGZxddSTIRTL
        v1zU8jGqYxJ0KfTr8lxJtvU=
X-Google-Smtp-Source: ABdhPJy4EhbzMZv39zI1ofob9/TDR4MNXhK4tTM03KwJqcLRymtAtW0ogjmdwUluTrk9MscPlF/SZg==
X-Received: by 2002:a2e:b806:: with SMTP id u6mr5229086ljo.99.1615481036388;
        Thu, 11 Mar 2021 08:43:56 -0800 (PST)
Received: from ?IPv6:2001:14ba:14fd:ee00:f103:26cf:9a94:68c4? (dcx008yjvypxp-hzzqdcy-3.rev.dnainternet.fi. [2001:14ba:14fd:ee00:f103:26cf:9a94:68c4])
        by smtp.gmail.com with ESMTPSA id x31sm975549lfu.10.2021.03.11.08.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:43:55 -0800 (PST)
Reply-To: ljakku77@gmail.com
Subject: Re: NET: r8168/r8169 identifying fix
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
 <3e3b4402-3b6f-7d26-10f3-8e2b18eb65c4@gmail.com>
From:   gmail <ljakku77@gmail.com>
Message-ID: <eb4b6c25-539a-9a94-27a4-398031725709@gmail.com>
Date:   Thu, 11 Mar 2021 18:43:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <3e3b4402-3b6f-7d26-10f3-8e2b18eb65c4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Heiner Kallweit kirjoitti 11.3.2021 klo 18.23:
> On 11.03.2021 17:00, gmail wrote:
>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>
>>     On 15.04.2020 16:39, Lauri Jakku wrote:
>>
>>         Hi, There seems to he Something odd problem, maybe timing
>>         related. Stripped version not workingas expected. I get back to
>>         you, when  i have it working.
>>
>>     There's no point in working on your patch. W/o proper justification it
>>     isn't acceptable anyway. And so far we still don't know which problem
>>     you actually have.
>>     FIRST please provide the requested logs and explain the actual problem
>>     (incl. the commit that caused the regression).
>>
>>
>>      
>>         13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
>>         <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
>>         strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
>>         Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
>>         Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
>>         Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
>>         2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
>>         2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
>>         13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
>>         The driver installation determination made properly by checking
>>         PHY vs DRIVER id's. ---
>>         drivers/net/ethernet/realtek/r8169_main.c | 70
>>         ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
>>         files changed, 72 insertions(+), 9 deletions(-) I would say that
>>         most of the code is debug prints. I tought that they are helpful
>>         to keep, they are using the debug calls, so they are not visible
>>         if user does not like those. You are missing the point of who
>>         are your users. Users want to have working device and the code.
>>         They don't need or like to debug their kernel. Thanks
>>
>>     Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.
>>
>>     Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
>>     is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
>>     would be much nicer and user friendly way.
>>
>>
>>     When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
>>     not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.
>>
>>     The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
>>     thing what other patches do not?
>>
>>     Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
>>     task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
>>     for the module to work.
>>
>>         --Lauri J.
>>
>>
> I have no clue what you're trying to say. The last patch wasn't acceptable at all.
> If you want to submit a patch:
>
> - Follow kernel code style
> - Explain what the exact problem is, what the root cause is, and how your patch fixes it
> - Explain why you're sure that it doesn't break processing on other chip versions
>    and systems.
>
Ok, i'll make nice patch that has in comment what is the problem and how 
does the patch help the case at hand.

I don't know the rootcause, but something in subsystem that possibly is 
initializing bit slowly, cause the reloading

of the module provides working network connection, when done via insmod 
cycle. I'm not sure is it just a timing

issue or what. I'd like to check where is the driver pointer populated, 
and put some debugs to see if the issue is just

timing, let's see.


The problem is that (1st load) fails, but there is valid HW found (the 
ID is known), when the hacky patch of mine

is applied, the second time of loading module works ok, and network is 
connected ok etc.


I make the change so that when the current HEAD code is going to return 
failure, i do check that if the HW id is read ok

from the HW, then pass -EAGAIN ja try to load 5 times, sleeping 250ms in 
between.


--Lauri J.




