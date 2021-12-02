Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BD3466993
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 19:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376514AbhLBSGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 13:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376552AbhLBSGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 13:06:49 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D79C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 10:03:26 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id j17so608461qtx.2
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 10:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qmoIB/vQ7dx+ZL4hnVmzrtnHGIgx+ch6N5esWiBSYDs=;
        b=AOAGUEjb5hU9Kvx0GZA0Qy0Ar4Yj7E+nzf9+3P1+MjIaseDKQdax/ZvyWLmelcI6K8
         tuZPcOSxVxLcN/+jYJ3vRo4kMfH6fytp+/F4gGXAhcChaXHfQwOot0WmPqN/nVmrI9ZG
         1Xw0hgj0rYT+2Kt9fejePHzNpBGDGRsWwGiMhMMP3aYaljcV2D9kQGPXsAYnzz3cXiqI
         lpEGkJV3n5Dtv+KzF/V7Xc9y4KeuA5ryj7CLLQEy/fIaazywNhAvtwi5bBUXt9dAn4mf
         1kAAXRvK/lVI6b69jlx/5sa2vuJF4phPHGfXZjErfh+9+uxjIIvqDklQ7Sa1djU8igUc
         DQTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qmoIB/vQ7dx+ZL4hnVmzrtnHGIgx+ch6N5esWiBSYDs=;
        b=r3vu9Ffc5pX0f02ZXoW86Yf3g2zBh449MGz7FXeUIUnaDilrec2P1Cw2xrkxk/rajE
         2icQF2L3iAIJI3jf5Wgmh2OtHLUCSu3EKyQuTPAigjY8WCqEpxbRuUcbKwkpJvjlLZRM
         YVIwZ6Z2yL909w6DGwJFSmgBidQ5uQ31rsWffsRcx1yv8A+u2lLBzl6BRJs4Nib1JYkn
         2rf6+vRB5MoeS1uMZCB9BF1WXjp4fK8yrthKBN0a5avgZ3fUCwNX3/fu2VaXLNWhqS5r
         yYgZw0k9Nb4MQDcq0ZdcIwP2mLMsZB6T5qIF3Lsc/ZuSFvioc2QWCVkM2aq7BhFfjwb5
         Rg0w==
X-Gm-Message-State: AOAM531V8BXA7IrUZM9QYj32by8QfkGMRtkHx7WhoFu5g9NWqAUyri2M
        7CEqTivrp8YasBsBwj25ed7z1w==
X-Google-Smtp-Source: ABdhPJwTVH0Fg4NOTUEAB2C5SQuhYWc144pstV4EktapLHy7e6schsD7Rn0sPUUVcGqJwFNiB5sOqw==
X-Received: by 2002:a05:622a:1828:: with SMTP id t40mr15691343qtc.0.1638468205569;
        Thu, 02 Dec 2021 10:03:25 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id x13sm434042qkp.102.2021.12.02.10.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 10:03:24 -0800 (PST)
Message-ID: <c8379f78-01da-cd2f-f4e2-99874a01f995@mojatatu.com>
Date:   Thu, 2 Dec 2021 13:03:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: prestera: flower template support
Content-Language: en-US
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <1e86c2c7-eb84-4170-00f2-007bed67f93a@mojatatu.com>
 <VI1P190MB0734C11D7BCDA57437264E698F699@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <VI1P190MB0734C11D7BCDA57437264E698F699@VI1P190MB0734.EURP190.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-02 12:39, Volodymyr Mytnyk wrote:
> Hi Jamal,
> 
>>
>>> From: Volodymyr Mytnyk<vmytnyk@marvell.com>
>>>
>>> Add user template explicit support. At this moment, max TCAM rule size
>>> is utilized for all rules, doesn't matter which and how much flower
>>> matches are provided by user. It means that some of TCAM space is
>>> wasted, which impacts the number of filters that can be offloaded.
>>>
>>> Introducing the template, allows to have more HW offloaded filters.
>>>
>>> Example:
>>>     tc qd add dev PORT clsact
>>>     tc chain add dev PORT ingress protocol ip \
>>>       flower dst_ip 0.0.0.0/16
>>
>> "chain" or "filter"?
> 
> tc chain add ... flower [tempalte] is the command to add explicitly chain with a given template
> 

I guess you are enforcing the template on chain 0. My brain
was  expecting chain id to be called out.


> tc filter ... is the command to add a filter itself in that chain
> 

Got it.


>> You are not using tc priority? Above will result in two priorities (the 0.0.0.0 entry will be more important) and in classical flower approach two  different tables.
>> I am wondering how you map the table to the TCAM.
>> Is the priority sorting entirely based on masks in hardware?
> 
> Kernel tc filter priority is used as a priority for HW rule (see flower implementation).

The TCAM however should be able to accept many masks - is the idea
here to enforce some mask per chain and then have priority being the
priorities handle conflict? What happens when you explicitly specify
priority. If you dont specify it the kernel provides it and essentially
resolution is based on the order in which the rules are entered..

cheers,
jamal



