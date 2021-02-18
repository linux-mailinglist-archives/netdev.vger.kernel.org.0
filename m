Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2533A31EDA1
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbhBRRsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbhBRRLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:11:22 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC475C0613D6
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:10:41 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id q10so5281243edt.7
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MfpAGWNr+JjuLKBAFMfKoelww8BJYjLy5AHrwTlW5To=;
        b=q6snTKrhJsOeTWIp3w3HTPVaMroNCKuhKIJzsY625JTv9RtaONmIYUoHPvSI+ffMV3
         h9e9yrpYp5jWs6Sw1aQ+THXSVqS7xZON2/aAMicEH3QyTv4GWGAi/Wswfz45yo4jSLrt
         SHLu/MIuVgXj2Rqa+03iHY114vjHYQizHBf1LQf/9WWOVmhjwaUqbEpvhTdk6pSP/5Dq
         jN++SBXC8x7VwIZhrg3iORafpXCmxdwbA922RJuW3chVyute/udjyA4FX4ermRE0ERSC
         73IpMElce6A0YC7QPVPRhxAazknbf6LzZBZSKmI0Q/GGZ6lP6/G7F1nandq3q1IE/PQ/
         K8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MfpAGWNr+JjuLKBAFMfKoelww8BJYjLy5AHrwTlW5To=;
        b=UtGf356AW1EqEBJI4gciLrhpSL4WIa48psDLG1bR8L4WwC/pEPGENJI3tek9WU1qi8
         w1IWVM+apz4QX1zRZEe2U0PZ/wNWeXKI6wheHFFhhuFJI4ZfB5YoMKiozFvyZb9Na1AF
         4dGLVPZcBcJW5A+d6iv41YLEp98fDwvGszKwe5DzFhF4sNYDnz4BQ7xgPd/Y5gRCQVE0
         s14o6xd5H6NRB9wnpm6MfJvwGZs2vgGEtqlv04/8oxbu06Cpc0f4TF2Wd44qqWjfIQuI
         sv+TxXOobPKxdlJj0o6ZQlHq46qs++WZCmKBMyiSB7GEHMXbmp0ZhnAbQgmUfipHXDur
         5m/A==
X-Gm-Message-State: AOAM530qFgEvcV1wvGXlbPRSe28/oQ9DqfKdF1KX+dE4H+JmU4ayYUb5
        ZYuyY+TB0bIRyfcPBrGhiBY=
X-Google-Smtp-Source: ABdhPJzQTlKe4YeqkwTcSyeWd31XyMQ3vD9CTsazjr43PAffyFwGydmYpDqCIF24Y3H8jZiIguTIfA==
X-Received: by 2002:a50:d714:: with SMTP id t20mr5026604edi.65.1613668240365;
        Thu, 18 Feb 2021 09:10:40 -0800 (PST)
Received: from [192.168.0.104] ([77.124.112.241])
        by smtp.gmail.com with ESMTPSA id da12sm506852edb.52.2021.02.18.09.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 09:10:40 -0800 (PST)
Subject: Re: bug report: WARNING in bonding
To:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Moshe Shemesh <moshe@nvidia.com>,
        Itay Aveksis <itayav@nvidia.com>,
        Ran Rozenstein <ranro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <fb299ee2-4cf0-31d8-70f4-874da43e0021@gmail.com>
 <20201112154627.GA2138135@shredder>
 <e864f9a3-cda7-e498-91f4-894921527eaf@gmail.com>
 <20201112163307.GA2140537@shredder>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <67b689d8-419b-78ec-0286-0983337ca3c1@gmail.com>
Date:   Thu, 18 Feb 2021 19:10:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201112163307.GA2140537@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/12/2020 6:33 PM, Ido Schimmel wrote:
> On Thu, Nov 12, 2020 at 05:54:30PM +0200, Tariq Toukan wrote:
>>
>>
>> On 11/12/2020 5:46 PM, Ido Schimmel wrote:
>>> On Thu, Nov 12, 2020 at 05:38:44PM +0200, Tariq Toukan wrote:
>>>> Hi all,
>>>>
>>>> In the past ~2-3 weeks, we started seeing the following WARNING and traces
>>>> in our regression testing systems, almost every day.
>>>>
>>>> Reproduction is not stable, and not isolated to a specific test, so it's
>>>> hard to bisect.
>>>>
>>>> Any idea what could this be?
>>>> Or what is the suspected offending patch?
>>>
>>> Do you have commit f8e48a3dca06 ("lockdep: Fix preemption WARN for spurious
>>> IRQ-enable")? I think it fixed the issue for me
>>>
>>
>> We do have it. Yet issue still exists.
> 
> I checked my mail and apparently we stopped seeing this warning after I
> fixed a lockdep issue (spin_lock() vs spin_lock_bh()) in a yet to be
> submitted patch. Do you see any other lockdep warnings in the log
> besides this one? Maybe something in mlx4/5 which is why syzbot didn't
> hit it?
> 

Hi,

Issue still reproduces. Even in GA kernel.
It is always preceded by some other lockdep warning.

So to get the reproduction:
- First, have any lockdep issue.
- Then, open bond interface.

Any idea what could it be?

We'll share any new info as soon as we have it.

Regards,
Tariq
