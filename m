Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8727C4A4778
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378045AbiAaMqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377935AbiAaMqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:46:46 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F178C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:46:46 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id k25so6276777qtp.4
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 04:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ha8RQLsU/O+VZwRh4lQFBRJE2m9AraEHmiwYGuGwr9s=;
        b=5LwwU/MfDFoYY87dbmlQ2NeHobu+ZJIdlRqZJ35r6roQhUYUCT4fyjZSo9dl43Zw98
         nxL8qR/GMMG/FOa1K/dne6OPXYxDHk/FkVdLmFZLiiD/I7T0rEMpyWVbV0islA4vSoF0
         WUyJKBin27DL9oe6wlz1jMIVutwwuDVsLvYnOaYylQxL9yrResDc3+0t0QI+Th+Yr4MD
         fODRpucE9NYsXvMgJC70b8H3ny1/r3rbiTukZvubd9nOL+C/IaF0v/15ahMqp9DzLGic
         bGX6WDlgjwAp/vdsGli35G9V9K4x6RM8NgUfDWBc+VTzotx5xdUynHPMf2orhGamLcRK
         5pgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ha8RQLsU/O+VZwRh4lQFBRJE2m9AraEHmiwYGuGwr9s=;
        b=vnogAUhhuXhLeiXpxVhSd79UVmMrt64JLAVEX4v+Jm6/tuaTngkkDR1TZQx9PuciBv
         JLhUyauDOSyyVjA6R98sbEuJDpPlVx9gTaVyoFv+VNjjZXap6WiW+7WFdtWdF3MXwIWN
         Mfsoi5IAziYJf2IPmxsJSmQHDvXZHWNjflM1angZ6ZpTzi8FAqhX9W7rp0nqTuykyHu4
         Ju0znPP07vzoyecrQRpjz0uHFk4nJSNqiUHjUyQGKoKL5iFVcGXr3mbWOrymPJH0JB2A
         vwAukZ8AXxLgqpUXTp4oOhDV906yJzmIZJi/zfuQmuu2TQw5VtdRDn9jc+BoSJIJz+xO
         +YVQ==
X-Gm-Message-State: AOAM532EWLKyeiNb+DLM+jDCQIopXv4eWZCMRJ5O8EVB3p2jJQWigM4H
        WtUvzguef1NnBpNElSol3SbrUw==
X-Google-Smtp-Source: ABdhPJzCb8z6Ar4lM3gzy0tgSjVv6RfG3XmK9cXnj4O14Bt2fgss8PoRyqqVSPxxFuJo5QHQx88jYw==
X-Received: by 2002:ac8:5b89:: with SMTP id a9mr14237214qta.681.1643633205508;
        Mon, 31 Jan 2022 04:46:45 -0800 (PST)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-74.dsl.bell.ca. [184.148.47.74])
        by smtp.googlemail.com with ESMTPSA id c127sm8260123qkf.36.2022.01.31.04.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 04:46:44 -0800 (PST)
Message-ID: <53506df1-feed-57e4-48f2-7444922e9bc2@mojatatu.com>
Date:   Mon, 31 Jan 2022 07:46:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: tdc errors
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Davide Caratti <dcaratti@redhat.com>
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
 <a0051dc2-e626-915a-8925-416ff7effb94@mojatatu.com>
 <69c4581e-09bd-4218-4d5f-d39564bce9bc@linuxfoundation.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <69c4581e-09bd-4218-4d5f-d39564bce9bc@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 11:27, Shuah Khan wrote:
> On 1/21/22 7:11 AM, Jamal Hadi Salim wrote:
>> On 2022-01-21 04:36, Davide Caratti wrote:
>>> On Thu, Jan 20, 2022 at 8:34 PM Jamal Hadi Salim <jhs@mojatatu.com> 
>>> wrote:

[..]


> 
> Several tests check for config support for their dependencies in their
> test code - I don't see any of those in tc-testing. Individual tests
> are supposed to check for not just the config dependencies, but also
> any feature dependency e.g syscall/ioctl.
> 
> Couple of way to fix this problem for tc-testing - enhance the test to
> check for dependencies and skip with a clear message on why test is
> skipped.
> 
> A second option is enhancing the tools/testing/selftests/kselftest_deps.sh
> script that checks for build depedencies. This tool can be enhanced easily
> to check for run-time dependencies and use this in your automation.
> 
> Usage: ./kselftest_deps.sh -[p] <compiler> [test_name]
> 
>      kselftest_deps.sh [-p] gcc
>      kselftest_deps.sh [-p] gcc vm
>      kselftest_deps.sh [-p] aarch64-linux-gnu-gcc
>      kselftest_deps.sh [-p] aarch64-linux-gnu-gcc vm
> 
> - Should be run in selftests directory in the kernel repo.
> - Checks if Kselftests can be built/cross-built on a system.
> - Parses all test/sub-test Makefile to find library dependencies.
> - Runs compile test on a trivial C file with LDLIBS specified
>    in the test Makefiles to identify missing library dependencies.
> - Prints suggested target list for a system filtering out tests
>    failed the build dependency check from the TARGETS in Selftests
>    main Makefile when optional -p is specified.
> - Prints pass/fail dependency check for each tests/sub-test.
> - Prints pass/fail targets and libraries.
> - Default: runs dependency checks on all tests.
> - Optional test name can be specified to check dependencies for it.
> 

Thanks Shuah. We'll look at this approach.
Question: How do we get reports when the bot finds a regression?


cheers,
jamal
