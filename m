Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7643474226
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhLNMNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhLNMNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:13:05 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A20BC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:13:05 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id n15so18189259qta.0
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 04:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5Gu1k3HLDn8zxxqSWo1wPzr0Z8uwn932g/M9N2i2LB8=;
        b=09z+hDjkHbL2jMgxjAyg1pOcLXDVe/idWpJFChBLK0ZqqdsUjUZi5xG+ftdTpGVR/m
         cNhUVLdbHpwQwYm8ubteLyrekdG4nNlrpIxKHqJbOEL9GBM9OyG/ql8/LlrOtoxAfQ4X
         x4bboDTc0BpD1+EOqCu7IXZxP+CfioiK4iWDp2uCs2lm80Nv0Mx0MuC/dG97ubroSe/P
         A2fZj/ZiLMX2Dpaq4gvth7z2HIdC+SNctZR/L/beUmmIpvHf50zma7x6lHij4i7P21Vk
         4yTW38H0IOMp7S8q2NpPfZP39BKZ8jEda399EdVUw1FqNII0Qwa0eK6x6OhyhDLdzi+L
         Kf8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5Gu1k3HLDn8zxxqSWo1wPzr0Z8uwn932g/M9N2i2LB8=;
        b=hovf/iTz1G3lLuj1Swdfj4A0GNzjvFQXLMSPAum2cH7+JSjAwIk2Ee2nDAEvflkPs9
         GsytTaH2BmFz+xPhq62in5nPwN2+AoGkWIaCnoBQg2lHh2b1rIPRbZ2EBDioEJtmcCAI
         yxPTj7gca9bdLeRclTIxEeWd5accTu3yRT8xsnRKe+v1/8NFAhnc4p7gVdug2vyMOpSn
         84s0kGzQl5ucrwijVZS/ClYg5meqx7eHp6Ai7Li4Lh1Avc6ccxsBeKcUWzD6LXzMfQwL
         7cioGKQIcvHdveQIOthtQo8oyxHDnZy3bu/t9szvUOe5emtkosUTYx55d/rmG04C0AHv
         1MFw==
X-Gm-Message-State: AOAM533MiiifRProZ4LyG2Y8d2yq18df8m6kT4ZKFDThsb/I8thAg1wx
        w3pVz2BDHSD9k5KA3aDY1D6XTg==
X-Google-Smtp-Source: ABdhPJzs29jO6m7jR9wZKnov8/wdnlWjkOfA0BBtUooADZt6IWTMts1PNImOJqM89U298WDAI8mz+g==
X-Received: by 2002:a05:622a:54d:: with SMTP id m13mr5370977qtx.33.1639483984593;
        Tue, 14 Dec 2021 04:13:04 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id s6sm7691601qko.43.2021.12.14.04.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 04:13:04 -0800 (PST)
Message-ID: <a21b793f-48e6-a944-8869-676fb3cd448c@mojatatu.com>
Date:   Tue, 14 Dec 2021 07:13:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com>
 <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
 <CAM_iQpVOuQ4C3xAo1F0pasPB5M+zUfviyYO1VkanvfYkq2CqNg@mail.gmail.com>
 <CAMDZJNUos+sb+Q1QTpDTfVDj7-RcsajcT=P6PABuzGuHCXZqHw@mail.gmail.com>
 <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAM_iQpU+JMtrObsGUwUwC8eoZ1G39Lvp7ihV2iERF5dg0FySXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-13 17:53, Cong Wang wrote:
> On Sat, Dec 11, 2021 at 6:34 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:

>> We support this in skbedit firstly in production. act_bpf can do more
>> things than this. Anyway we
>> can support this in both act_skbedit/acc_bpf. 1/2 is changed from
>> skip_tx_queue in skb to per-cpu var suggested-by Eric. We need another
>> patch which can change the
>> per-cpu var in bpf. I will post this patch later.
> 
> The point is if act_bpf can do it, you don't need to bother skbedit at
> all. 

Just a comment on this general statement:
I know of at least one large data centre that wont allow anything
"compiled" to be installed unless it goes through a very long vetting
process(we are talking months).
"Compiled" includes bpf. This is common practise in a few other places
some extreme more than others - the reasons are typically driven by
either some overzelous program manager or security people. Regardless
of the reasoning, this is a real issue.
Note: None of these data centres have a long process if what is
installed is a bash script expressing policy.
In such a case an upstream of a feature such as this is more useful.


cheers,
jamal

