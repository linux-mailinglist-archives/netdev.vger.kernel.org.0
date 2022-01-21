Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE41D496082
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350663AbiAUOLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbiAUOLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:11:54 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2372C061574
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:11:53 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id j16so6205441qtr.5
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ilwpCcZSwvPRLq8JaXI/u2k5jSHETHd56B55UKnPGd8=;
        b=3NIdir9mI2TcCYm53aGuM5tIrvVwbQA/7j2tIyifGBRuL8ZN8TVKHa0DKiUTKxM9wX
         1knsaPFVu5u1KTi2gA01/j/MwaRPMs7H8/sW7UEmfjktFPmUYoGHw8ay2gS8HeeLLYlm
         IS8We2r4vQ+jBsIg7c5oKqSoFMTyFn47eSxGksC+q/b7PXLTKYCvBTtB/70TNlcus8PA
         kIQAAKMDI6KM8wJ7L8u2x1icnzS7V6ZX8w/XD6d+m7FGw6E26LGgKq5//1P+ta1buBaR
         qV/S++AUkmy6Hl6Md0vXry6OTKz5YGCj83bOnSak2RXPAGLxldRgAxq213y34MW0+yYH
         AkyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ilwpCcZSwvPRLq8JaXI/u2k5jSHETHd56B55UKnPGd8=;
        b=VfwjZdE6BiQQZW2Mc6cY1mRTcKTgASrj/mf5uglwH6Jmi4Gyv2Rkp8SoJLa+LbIcvx
         S0ZNj8FZf+1WE2Dm3jF3DHwep3i7RWkLORK6u2vCaRWFy6p5BTP7igG0wibXmUjubit2
         cvm/ufrByPsyX6NjNTaHejhaT4+bJVsoJ1EJTxmTcdVDudd9GcCDVYfH2lh+rNF9pGrS
         WRNGyPzwfuCHOd1MieV16Q5kbewOhrpGx6HIhUNNMojwbqkTer9nLCKZAoT5s+Su8CaL
         ZJFpiDHW8PdLL4UrwZycm5U/Y8RMhI6gvNlggeduhK5WBWwRoALaj36EnxYR3EHBGXTz
         AbUg==
X-Gm-Message-State: AOAM53268zxCrbYfHquloTa1/uFidTl3i6wKyJqJkVO0wyYnMHU70+fu
        7bW5m7PRcEZhmJea2eCv7n7WRg==
X-Google-Smtp-Source: ABdhPJz4mBOtGvlC+7V1bwu+9seyxD27fnqdIsX/SDT8ZAPy+CqysHmL+VUTLf2G38KYt/fJo/hORQ==
X-Received: by 2002:ac8:4755:: with SMTP id k21mr3353278qtp.166.1642774312837;
        Fri, 21 Jan 2022 06:11:52 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id q8sm3260893qkl.65.2022.01.21.06.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 06:11:52 -0800 (PST)
Message-ID: <a0051dc2-e626-915a-8925-416ff7effb94@mojatatu.com>
Date:   Fri, 21 Jan 2022 09:11:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: tdc errors
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>, shuah@kernel.org
References: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
 <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
 <CAKa-r6teP-fL63MWZzEWfG4XzugN-dY4ZabNfTBubfetwDS-Rg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <CAKa-r6teP-fL63MWZzEWfG4XzugN-dY4ZabNfTBubfetwDS-Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 04:36, Davide Caratti wrote:
> On Thu, Jan 20, 2022 at 8:34 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:

[..]>>
>> So... How is the robot not reporting this as a regression?
>> Davide? Basically kernel has the feature but code is missing
>> in both iproute2 and iproute2-next..
> 
> my guess (but it's only a guess) is that also the tc-testing code is
> less recent than the code of the kernel under test, so it does not not
> contain new items (like 7d64).

Which kernel(s) + iproute2 version does the bot test?
In this case, the tdc test is in the kernel already..
So in my opinion shouldve just ran and failed and a report
sent indicating failure. Where do the reports go?

+Cc Shuah.

> But even if we had the latest net-next test code and the latest
> net-next kernel under test, we would anyway see unstable test results,
> because of the gap with iproute2 code.  My suggestion is to push new
> tdc items (that require iproute2 bits, or some change to the kernel
> configuration in the build environment) using 'skip: yes' in the JSON
> (see [1]), and enable them only when we are sure that all the code
> propagated at least to stable trees.
> 
> wdyt?
> 

That's better than current status quo but: still has  human dependency
IMO. If we can remove human dependency the bot can do a better job.
Example:
One thing that is often a cause of failures in tdc is kernel config.
A lot of tests fail because the kernel doesnt have the config compiled
in.
Today, we work around that by providing a kernel config file in tdc.
Unfortunately we dont use that config file for anything
meaningful other than to tell the human what kernel options
to ensure are compiled in before running the tests (manually).
Infact the user has to inspect the config file first.

One idea that will help in automation is as follows:
Could we add a "environment dependency" check that will ensure
for a given test the right versions of things and configs exist?
Example check if CONFIG_NET_SCH_ETS is available in the running
kernel before executing "ets tests" or we have iproute2 version
 >= blah before running the policer test with skip_sw feature etc
I think some of this can be done via the pre-test-suite but we may
need granularity at per-test level.

cheers,
jamal
