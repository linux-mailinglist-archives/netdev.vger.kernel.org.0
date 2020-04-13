Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86291A65B9
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 13:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgDMLqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729124AbgDMLqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 07:46:48 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F2C03BC91
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 04:46:48 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id u15so3868986ljd.3
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 04:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w5G8BiV+fr1up1+uzYFTdVFdnpeu0NQAhm8rmu5LMOs=;
        b=WAbySBJkhxBEdCY3bylurzwpdimdEzMWK4D1yZJzK1zHC65aVMYci5TlfqsYZMxbcq
         p7Do/I4NbX+/vUN4YI1tvDui78s/AXBlYxkhFE7VviXY75Kq5a7t/OFNzci7yeU98gDh
         FVscaosBXDJpZedJPV+Oj8rWxJOEDLJIyd4Qq0+sWO9GuY38w5g3XvDOYk73NnDiWxj1
         SxIF8RFjyq57pT8S9EVtWH+pLieebGr/Kmon9qgvQn6UBgrTbFo5iKlq+DPSxRn6pb9K
         kKMWSWsbj8+8Y4bgQCXKlEuzxpidVCha//CK81C+HnsWXclk6IV2hg1SRGIa091/07Zx
         5lYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w5G8BiV+fr1up1+uzYFTdVFdnpeu0NQAhm8rmu5LMOs=;
        b=RWOOh3UXx0SYEm672JeJBX7xPQqhjUY2s0EnISM0NWJUHRdArBHt8zWAaGJC0Kcu19
         trdWTSlWc98Rz23AJuO2ptgPbKT5YGg4Mrmq4CeGCAMFpFHl8pSDo+7YqfLAB2Pjp4jL
         /JoJ1JQ/+qJ3oU3AebWAt3EmD56k/hdGhxLzNbyyNbcBo4w2FWQEvSht4pYr6lsrRcKl
         Q4IwqPLrDwJAoKuuguTBVjf68+wvbC0TIgsSkunXj5ypC81022D6s1yLlRA0Sc6telhi
         sDunublkP6Wq7QQQCZIXz2HwBD1LbcyLkoopk78KOsn3I6dt4kqIb2RvaMAg8nXIgi/P
         L5mw==
X-Gm-Message-State: AGi0PuZ+xjiypAOAqKsSb7VqK7z6Zj4sAu9Jtl2ni/LNxYpXiEdRmev9
        wdrRDtKA2zI0kG3FanYEqnY=
X-Google-Smtp-Source: APiQypKIs3UpdUa4aoGL6+AICm56xszmFgoseR3rTPm9AKOdjWLBBstQDFvTJFiwwq+7RjNYBbvr+Q==
X-Received: by 2002:a2e:95c4:: with SMTP id y4mr10264823ljh.94.1586778406747;
        Mon, 13 Apr 2020 04:46:46 -0700 (PDT)
Received: from [192.168.1.134] (dsl-olubng11-54f81e-195.dhcp.inet.fi. [84.248.30.195])
        by smtp.gmail.com with ESMTPSA id w72sm7828360lff.56.2020.04.13.04.46.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 04:46:45 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
From:   Lauri Jakku <ljakku77@gmail.com>
Message-ID: <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
Date:   Mon, 13 Apr 2020 14:46:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200413113430.GM334007@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Fair enough, i'll strip them.

-lja

On 2020-04-13 14:34, Leon Romanovsky wrote:
> On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote:
>> Hi,
>>
>> Comments inline.
>>
>> On 2020-04-13 13:58, Leon Romanovsky wrote:
>>> On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote:
>>>> From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001
>>>> From: Lauri Jakku <lja@iki.fi>
>>>> Date: Mon, 13 Apr 2020 13:18:35 +0300
>>>> Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>
>>>> The driver installation determination made properly by
>>>> checking PHY vs DRIVER id's.
>>>> ---
>>>>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>>>>  drivers/net/phy/mdio_bus.c                | 11 +++-
>>>>  2 files changed, 72 insertions(+), 9 deletions(-)
>>>
>>> I would say that most of the code is debug prints.
>>>
>>
>> I tought that they are helpful to keep, they are using the debug calls, so
>> they are not visible if user does not like those.
> 
> You are missing the point of who are your users.
> 
> Users want to have working device and the code. They don't need or like
> to debug their kernel.
> 
> Thanks
> 
