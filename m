Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA7138252F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 09:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbhEQHTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 03:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235178AbhEQHTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 03:19:53 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3227FC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 00:18:36 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i17so5181563wrq.11
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 00:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q+TJlZFz8otf51w9GU3maD2PbVMWGQyaIA9+/3eixVI=;
        b=cEUp8t3ZTuV/SVt7DNM6nK9qr3VjMngO4X/8Uj+NGO6FcElHS4pdde8Pq4VDAiMTX5
         rC2sImAQpchQkXZbVH5ie88qf5dF25bDblmDt/tW5pwPWZ4XdhEkKhLBVFbV2N2lfwU0
         u/Mnkq3/3Od4fJwXIXappF1LEFq9YEQVDuFtG40d+JPyOMhefTCyX3yl8FioZJ4aaAzb
         46ymACr4+2UvMW9DK/QGf/CfyIwNcpvyFjj9NdPsSLEsZxwM1lLOiBJLxVwUIxIIzZI4
         UJQdTSgTw70sQAKrwREPJWWh1dmOoZVtQnIKcla8lH+vmX68ySxAzRSOYrbvc0/lH4hB
         63hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Q+TJlZFz8otf51w9GU3maD2PbVMWGQyaIA9+/3eixVI=;
        b=TICSqMcUuVl3R/25YXYfsIvtYcml1vJCu9lwpzyhC0iwUNKuYu9U8SmgXDRJw+Eila
         Ow9jzr+3XnnYOYlWAKS8CIev+mO3DfRYcpAprt5PaIxBvQxSXGoGo0+yP9vKZ4GnZBjJ
         ZP4NTeysLCi3WR2RomX5ZI416jpvH5lPl9Lc60Y/pLWRyMOJ6YJNvObK+YPMxx+GEGGj
         6qkpAi0UwMZZKR7SX4Q+MsCWwoS4N2Hg2bsMa1FcJh7/VBttIHnIDRnRQJw4y5H3l0Sg
         rm9r8RgvDBK+bobbyEBd4NRWigm7vj2ywJe7fuBPi1BMuitHYkdvmZy52STz1Byy2Z6D
         1ICg==
X-Gm-Message-State: AOAM531Idx9j8JIDeChTdhUEgU0A3Aik2PoFeqkUrrfMZeBSXizDXEDC
        AZ0uOVEyS4L45Es1OX2KR6vtkWy1LqCekw==
X-Google-Smtp-Source: ABdhPJxfcILGUX75djiQmrgjj2lwJ4cVIePJ0RjgswNvVzeNAXCuqBHU/Y2v2wJV/vczQiHSIqCb9g==
X-Received: by 2002:adf:9d48:: with SMTP id o8mr72267431wre.183.1621235914412;
        Mon, 17 May 2021 00:18:34 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:b163:7fac:6e1c:1606? ([2a01:e0a:410:bb00:b163:7fac:6e1c:1606])
        by smtp.gmail.com with ESMTPSA id s6sm23133484wms.0.2021.05.17.00.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 00:18:33 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] netns: export get_net_ns_by_id()
To:     Leon Romanovsky <leon@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "list@hauke-m.de:NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20210512212956.4727-1-ryazanov.s.a@gmail.com>
 <20210514121433.2d5082b3@kicinski-fedora-PC1C0HJN>
 <CAHNKnsSM6dcMDnOOEo5zs6wdzdA1S43pMpB+rkKpuuBrBxj3pg@mail.gmail.com>
 <YKD8f7wP2EzUU7PX@unreal>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6b92c63f-d5eb-7af8-29a7-d8f632654c14@6wind.com>
Date:   Mon, 17 May 2021 09:18:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YKD8f7wP2EzUU7PX@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 16/05/2021 à 13:05, Leon Romanovsky a écrit :
> On Fri, May 14, 2021 at 11:52:51PM +0300, Sergey Ryazanov wrote:
>> On Fri, May 14, 2021 at 10:14 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Thu, 13 May 2021 00:29:56 +0300 Sergey Ryazanov wrote:
>>>> No one loadable module is able to obtain netns by id since the
>>>> corresponding function has not been exported. Export it to be able to
>>>> use netns id API in loadable modules too as already done for
>>>> peernet2id_alloc().
>>>
>>> peernet2id_alloc() is used by OvS, what's the user for get_net_ns_by_id()?
>>
>> There are currently no active users of get_net_ns_by_id(), that is why
>> I did not add a "Fix" tag. Missed function export does not break
>> existing code in any way.
> 
> It is against kernel rule to do not expose APIs, even internal to the kernel,
Yep, there was no internal user, it's why I didn't add this EXPORT_*() at the
beginning.


Regards,
Nicolas
