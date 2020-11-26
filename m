Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2C32C553E
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389966AbgKZN0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389957AbgKZN0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:26:41 -0500
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE19EC0613D4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:26:39 -0800 (PST)
Received: by mail-qv1-xf42.google.com with SMTP id y11so888440qvu.10
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kjFeqmxhjwefG2mpnqAX2DW+iAVpV00FSbi8nM3+hnI=;
        b=qOd/rdrMv2uDRkzHhtropNJkC8kXeunMzZxeHVxCV8FSL1cBCWWFQyLMAqiw+UcLDQ
         +nI/0bPcLG1tqPNQtXOQyn3lBMSfyWkdlpXus38Ntc6LRys6HTeHAXj1/xWvpDAt11Jd
         soxSUfQH+jBoTiPsaRxWQ2qn14q0p6gB2S+HuT0T+lgv+/GWCM+67DtGrqargFjRXbyh
         NjBCgv3iQJRbIIX2BuNKoViPHtwge28Oe8cCT8biG1cDE0LxFogi4kXaGruUuM4lXK5i
         rbFePlqX9eCvPdC+1meJN83HCrQX2uiT0qgQT3NTrp8tGoEYoKRjfhasD+FRfZZFRidn
         tcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kjFeqmxhjwefG2mpnqAX2DW+iAVpV00FSbi8nM3+hnI=;
        b=KA0t3HoqVUEWx1pZedOAJbaMAxx4ccP4eS+GSulJgAgVCbhVq6TfcbnQDNaUttrecE
         QLKJEMp8F9ezsHOYURRn2JB8iVJSaW+lc3VcUTmP7qjmiV2RwktWUVo9UqMXRwr4omd5
         DzVhyfaOPjAWaHv3RgbpvE4LF4JMHhh0PAKcec11cZ1NuYTKZMv3tJudONk4kgg3Ljbp
         K5GKME7S9dKNjFv972CHf2lIuSXEJGs7sX0uafPeVUv1GzucMoSeCzMqGoiQseRvfszt
         v1uN5vtp6JF0uIQln4jLd8Ub2wOUhTAMJzZHdfF8CT7aI60ALoKr7DDjKzGjhNT5Ze/5
         j3Eg==
X-Gm-Message-State: AOAM532wRP1syMxEKvsmbl/U8t83hpuHLyZJ0r5vVoHZX1Gbug/DcvKM
        BXTWEul5c3xMsHmpxBC8A4py2Q==
X-Google-Smtp-Source: ABdhPJy08wHFd5qwOBufuR5pWiVKOWhJsWDm0Zav312OrcPiFFDjmxszhKZcHscwBq2RG9ARIL/uFg==
X-Received: by 2002:a0c:9bac:: with SMTP id o44mr3020517qve.43.1606397199223;
        Thu, 26 Nov 2020 05:26:39 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id p48sm2845400qtp.67.2020.11.26.05.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 05:26:38 -0800 (PST)
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     wenxu <wenxu@ucloud.cn>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
 <1606276883-6825-4-git-send-email-wenxu@ucloud.cn>
 <20201125111109.547c6426@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpWO=vvw_iK9KaQAzEULXzUmmQWxs8xzNsXhTj3i4WcnbQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <efda6acc-0e9c-7686-40ca-4d906e585e0b@mojatatu.com>
Date:   Thu, 26 Nov 2020 08:26:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWO=vvw_iK9KaQAzEULXzUmmQWxs8xzNsXhTj3i4WcnbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-26 12:03 a.m., Cong Wang wrote:
> On Wed, Nov 25, 2020 at 11:11 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 25 Nov 2020 12:01:23 +0800 wenxu@ucloud.cn wrote:
>>> From: wenxu <wenxu@ucloud.cn>
>>>
>>> Currently kernel tc subsystem can do conntrack in cat_ct. But when several
>>> fragment packets go through the act_ct, function tcf_ct_handle_fragments
>>> will defrag the packets to a big one. But the last action will redirect
>>> mirred to a device which maybe lead the reassembly big packet over the mtu
>>> of target device.
>>>
>>> This patch add support for a xmit hook to mirred, that gets executed before
>>> xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
>>> The frag xmit hook maybe reused by other modules.
>>>
>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>
>> LGMT. Cong, Jamal still fine by you guys?
> 
> Yes, I do not look much into detail, but overall it definitely looks good.
> This is targeting net-next, so it is fine to fix anything we miss later.
> 
> Acked-by: Cong Wang <cong.wang@bytedance.com>

Same here.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
