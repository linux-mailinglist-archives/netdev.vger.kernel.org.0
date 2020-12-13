Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F37C2D8D22
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 13:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406731AbgLMM4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 07:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgLMM4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 07:56:23 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71E7C0613CF;
        Sun, 13 Dec 2020 04:55:42 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id q20so3310072oos.12;
        Sun, 13 Dec 2020 04:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7hjE0eiFvPerzKGNP58EBfWNvonykp96rfUMfWh51Wk=;
        b=lHAPLktk8CPNJMgrz4pKIMnN2Y+fE7ksYs3p+CT4Vwgx1IUUe3h8T7y8zsfwn0RFB/
         dewv+8gKzJTsZgeVEO4qmcoDqUrBSvVVe4ekpibhSMxUF79qHFvlz8Xrh8N9n4925mrg
         l0etATtDRQUYbrE4l03EVZFbg0DsNG0C4CT+zW9rXEN4cMVqrdZMXYF4nnrrr/82xAfZ
         fmnN6Khxe10+DkYAa3bDQ5Tz6nj555/mRV4vveGbCRTNYwGaM7qFWBX9U8LqPrZIuijM
         u/iMYA/Q9jcMjuOT7kMihGcKeAFOQijD1oCO6QLJUP8ypk6VwUw2iWBlLnON3SUVqZK3
         pHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7hjE0eiFvPerzKGNP58EBfWNvonykp96rfUMfWh51Wk=;
        b=pv9wtcud/oH61smxPVQjchaWmekvDxC+FLyI1H4ZK9OXYOXz/cEzzkqfxRd7mlcnYu
         /R4Bo2ak83+X1StQPRyJd2Uz7yTPB/Ffmevte55X8VBVs+R+aHHZgU5Hr5ymxOLUyASy
         K6M9l5r/pRkvVA1I92JZgVLnM3InpM5rGOP12ifAwLM8Yuhwdoq99fTqH5Ki9/hMfryd
         1Y0j6FYb+qci0icFyUkipBXoGuse0/aexUY5mvCVP9ycmVNWbW4nhROe7tqVq36WJzHu
         UWOMzS0fyeyAiqpxXIC9kNQfsYjqvUJitaCs++/aRovVpZxTsH50V5WiXmA6dWbkWBaW
         Pqdw==
X-Gm-Message-State: AOAM530CVQwILJei3KjEl7oeIb4qA8c49r8TphUq+GPmLsMi1gyrpcQR
        7dpTk4ZCBIjVg6Y2C8nQx3o7ao8EqSQ=
X-Google-Smtp-Source: ABdhPJwK+nvfO6OpMojQu0KbNPWdxfwoUGIzmjc8Kh15k6e/6rKI0GEuFnT/E46g6qBdvS+8BRkYLg==
X-Received: by 2002:a4a:6154:: with SMTP id u20mr11295517ooe.12.1607864142162;
        Sun, 13 Dec 2020 04:55:42 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i16sm3458482otc.61.2020.12.13.04.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Dec 2020 04:55:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
References: <20201128193335.219395-1-masahiroy@kernel.org>
 <20201212161831.GA28098@roeck-us.net>
 <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <8f645b94-80e5-529c-7b6a-d9b8d8c9685e@roeck-us.net>
Date:   Sun, 13 Dec 2020 04:55:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CANiq72=e9Csgpcu3MdLGB77dL_QBn6PpqoG215YUHZLNCUGP0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/20 9:04 PM, Miguel Ojeda wrote:
> On Sat, Dec 12, 2020 at 5:18 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> This patch results in:
>>
>> arch/sh/kernel/cpu/sh4a/smp-shx3.c: In function 'shx3_prepare_cpus':
>> arch/sh/kernel/cpu/sh4a/smp-shx3.c:76:3: error: ignoring return value of 'request_irq' declared with attribute 'warn_unused_result'
>>
>> when building sh:defconfig. Checking for calls to request_irq()
>> suggests that there will be other similar errors in various builds.
>> Reverting the patch fixes the problem.
> 
> Which ones? From a quick grep and some filtering I could only find one
> file with wrong usage apart from this one:
> 
>     drivers/net/ethernet/lantiq_etop.c:
> request_irq(irq, ltq_etop_dma_irq, 0, "etop_tx", priv);
>     drivers/net/ethernet/lantiq_etop.c:
> request_irq(irq, ltq_etop_dma_irq, 0, "etop_rx", priv);
> 
> Of course, this does not cover other functions, but it means there
> aren't many issues and/or people building the code if nobody complains
> within a few weeks. So I think we can fix them as they come.
> 

Witz komm raus, Du bist umzingelt.

The key here is "if nobody complains". I would argue that it is _your_
responsibility to do those builds, and not the reponsibility of others
to do it for you.

But, sure, your call. Please feel free to ignore my report.

Guenter
