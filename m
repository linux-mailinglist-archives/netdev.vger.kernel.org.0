Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCBD4217E9
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbhJDTvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbhJDTvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 15:51:36 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D44C061753
        for <netdev@vger.kernel.org>; Mon,  4 Oct 2021 12:49:47 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id y201so23123103oie.3
        for <netdev@vger.kernel.org>; Mon, 04 Oct 2021 12:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0xg0klEEXfQWyRwdVFTk0XM1yzW4hChkS4NjvWNx8aU=;
        b=CDtCkikeyO++8Dw6DTVaX/AIePG7DTSGjbDcCsuSjPJluh4XvMAw/uY3Gh6CQoNJ0d
         J2AInkZI4kOnjTBw6lZwwnvLTFcgp7+wj51CxMTZEatOUOwvheo3uMup5Pdfh6snsBkl
         H09KTg2kwKdyEUYMgyDcsOoBVrmED+gyJUrt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0xg0klEEXfQWyRwdVFTk0XM1yzW4hChkS4NjvWNx8aU=;
        b=quKoXfLZdRvpxghaSfDVD6v+s1x9bmDipZRvmwGs7W/SHEgjNuJhn9FctWoR1OL4xB
         Ga7zkF8R4Na3SPpEIbhdx1mdD0FAPbAxTIZSxo1EC3cJIivzODnQN/DKnnBXtUrFjkf2
         lz+9lXXenGx5/BvvbWTlSeJmDbQ2REAGEz8dndX6dFvR3SlWP2Z+JYE+fMT2e1LIMWHz
         8Alkiv0I9KjBKCPs1Q1LV8yqURVmoDNWHeLp+LE/PmMpTPUf1rYH+KUfKKW8X2jeFKOQ
         gIpC17JpRIwQMaXmif5hdKVeA7RXRMJiiV/60z+GN/TL40ZOkEzrbl59r0cInr1yp0eN
         wY7Q==
X-Gm-Message-State: AOAM531PGo9cx8OP1XiQoDb37Q79PMz9xkx2sF/l3643TwxcoC29C5X9
        bRNjYYnT+gQGQ4Ku9yHh3REvdw==
X-Google-Smtp-Source: ABdhPJzsnMH+2UsoMkwY1hiP5DrE0TfnSByx0Y6C/tVxAI6vzAv0kmaVE4C2B8tHNk/IbWCLjH+j1g==
X-Received: by 2002:a05:6808:1910:: with SMTP id bf16mr15014619oib.43.1633376986355;
        Mon, 04 Oct 2021 12:49:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s66sm2808181oie.32.2021.10.04.12.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 12:49:45 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/95] 4.19.209-rc1 review
To:     Eric Dumazet <edumazet@google.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Netdev <netdev@vger.kernel.org>, Jann Horn <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211004125033.572932188@linuxfoundation.org>
 <CA+G9fYtyzfpSnapCFEVgeWGD8ZwS2_Lv5KPwjX4hUwDAv52kFg@mail.gmail.com>
 <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <576d46b9-644f-ece0-2cf0-8abbe8b85f4a@linuxfoundation.org>
Date:   Mon, 4 Oct 2021 13:49:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANn89iKPvyS1FB2z9XFr4Y1i8XXc34CTdbSAakjMC=NVYvwzXw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/4/21 11:44 AM, Eric Dumazet wrote:
> On Mon, Oct 4, 2021 at 10:40 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>>
>> On Mon, 4 Oct 2021 at 18:32, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 4.19.209 release.
>>> There are 95 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.209-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Regression found on arm, arm64, i386 and x86.
>> following kernel crash reported on stable-rc linux-4.19.y.
>>
> 
> Stable teams should backport cred: allow get_cred() and put_cred() to
> be given NULL.
> 
> f06bc03339ad4c1baa964a5f0606247ac1c3c50b
> 
> Or they should have tweaked my patch before backporting it.
> 
Seeing the same problem on my test system as well.

Patch applied with fuzz. Didn't need any tweaks. Compiling now.
Will let you know soon.

thanks,
-- Shuah

