Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97400409BF3
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 20:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346995AbhIMSOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 14:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbhIMSOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 14:14:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D42CC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 11:13:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so436764pjb.1
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 11:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZIGcaECPJUrYG5m6nqHzFS7/pkBWggIEkrORkkKcXoE=;
        b=QgJoeDfkeUNADEkBougj6gOLWK2JCCSZ4BMjlkbsRW1Nx6OQrIdeFvmeUJlnyEKe7M
         ZgFW7d3cNiHeplVbHq1Foawz2aufqWngXY0zn3mhHaeixBkTDihMNWJQjS/d1ZzOPa/g
         nkhCtpGEfC8KgTVdL9oM2aefuhUJcS6KODK27NOStilz8oH3g00xgqG3U22HZDTZaxvA
         a2muWlOuegIs83MCI3SJgc0I1PUDHDgkAUlpYaFR+2AiNsyFe9N9666OOZZrSpeYyqx1
         GC+6zj5NWtSvpPnLcVXiS0U/ZpAe3n+5o97EMvdfOw0jKEVt1IEZZHiXGm2eoMKKoigS
         H8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZIGcaECPJUrYG5m6nqHzFS7/pkBWggIEkrORkkKcXoE=;
        b=CEnfTkb5QC7tvPylsulqSvFW0Qy3Ra6L/5YV3LxOnYAhtTYOqyih1WkWJfjUvCVjYi
         cN+SeRsh/hSi5EkbL99I5Z5aIBHuiLqBVP9V7XLkGOQFEtPFiXjJqEpuZtago1eHXYzJ
         cU392iD5m3//DSxj0pMw6ma1YTElCn8R0F/AWqZYPtK7jdhqz4LKn79B2fPh/MVd/M6g
         CXAeJ/akCV50jKsxHjxtzQ1KAcw0aju9iM/iddcsl8eMLeDqIcS4qfhAcWN7u/7+skLT
         oVwZxcqNs+oikBO10FnDdVfENfY5ilIPUbZPhp3uUqIc2ifZ8PvMQ9oeyV1om0VLQQUP
         lkEw==
X-Gm-Message-State: AOAM533sKQeVk+77Dal7jtGvXXkrWwGB5mGInmOvgYEqk/FOD8SnRO+7
        hpdw7hLsnWXMmaf+/t2zshE=
X-Google-Smtp-Source: ABdhPJxH/AVyvvrA/bdIHwFAc9Cw39fLiw6wqLt55umLaZGRpJwtIpAgxfiPYmpVwW0gGBcOE2z6/g==
X-Received: by 2002:a17:90a:4605:: with SMTP id w5mr871431pjg.219.1631556800530;
        Mon, 13 Sep 2021 11:13:20 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id b7sm8840434pgs.64.2021.09.13.11.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 11:13:20 -0700 (PDT)
Message-ID: <89a84601-7103-d77d-23a6-2ec8d2f4dfc2@gmail.com>
Date:   Mon, 13 Sep 2021 11:13:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next 8/8] net: dsa: rtl8366: Drop and depromote
 pointless prints
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mauri Sandberg <sandberg@mailfence.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        DENG Qingfang <dqfext@gmail.com>
References: <20210913144300.1265143-1-linus.walleij@linaro.org>
 <20210913144300.1265143-9-linus.walleij@linaro.org>
 <7e029178-c46a-9dbb-2ee4-58d062f6e001@gmail.com>
 <20210913173810.lrzuzan5vp7l7b4u@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210913173810.lrzuzan5vp7l7b4u@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/2021 10:38 AM, Vladimir Oltean wrote:
> On Mon, Sep 13, 2021 at 10:35:53AM -0700, Florian Fainelli wrote:
>> On 9/13/2021 7:43 AM, Linus Walleij wrote:
>>> We don't need a message for every VLAN association, dbg
>>> is fine. The message about adding the DSA or CPU
>>> port to a VLAN is directly misleading, this is perfectly
>>> fine.
>>>
>>> Cc: Vladimir Oltean <olteanv@gmail.com>
>>> Cc: Mauri Sandberg <sandberg@mailfence.com>
>>> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
>>> Cc: Florian Fainelli <f.fainelli@gmail.com>
>>> Cc: DENG Qingfang <dqfext@gmail.com>
>>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> Maybe at some point we should think about moving that kind of debugging
>> messages towards the DSA core, and just leave drivers with debug prints that
>> track an internal state not visible to the DSA framework.
> 
> I have some trace points on the bridge driver and in DSA for FDB
> entries, maybe something along those lines?

Yes trace points would work really well, thanks!
-- 
Florian
