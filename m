Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7ECE3C2181
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhGIJ12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 05:27:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37598 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhGIJ11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 05:27:27 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1m1mkV-0008Em-Cl
        for netdev@vger.kernel.org; Fri, 09 Jul 2021 09:24:43 +0000
Received: by mail-wr1-f69.google.com with SMTP id d9-20020adffbc90000b029011a3b249b10so2629833wrs.3
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 02:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7WNvZLwCMJPhU0LBKsV7xjBc2Y3AeokJ7ARXwaxrCLg=;
        b=FpdgA5idRmsMb9sfuCjiQvy1wi9/s5KBR7BKWD6FtYeeeKtsZK1bgjL7ZdX5QcC+q5
         fIix7r4m8gVK5IMhbGRHNmUl891rl1mGVogBo0TCHu0iP/zfipNfyfcPFbhU4vNMAAgL
         1D1x2Of9MjE/SYGMB/nYJD+REuwdCL9s4UwL61h4832B69WYlpKt9MrDJrHZFDzO2vVh
         8avNAyjRANW+QjfO+IRSqGYL8YK/mYhhePIxEgFDzW30U+kMMolOvx2tQ5BDKMx28FgG
         l0WFlIh5yuGsWB9F7SLOL8wHAUQmClNIg+ygpPZk8VNTV0BIwjmEjN5JsV2eRL2qW/yu
         NB1A==
X-Gm-Message-State: AOAM532ESWu/Z9KGjEONoul2Y0sXD1QcDcoCZkc1fQ05DjXOhCcGl4m9
        H3twhu38D4Vmq+zJ0vqr/RNhe7KoLH/8RFeNZMzHcs7GFZB+nzV1lFFGcxQWRcL0WZWaMn+5ryM
        zpJ38okm/F20Do6vECvteaQUuoy3xWlHsEA==
X-Received: by 2002:a05:600c:3644:: with SMTP id y4mr10822198wmq.85.1625822683084;
        Fri, 09 Jul 2021 02:24:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDDs/3crxV8R4sxhCWt0V09XDArwN4UwXG2P9xer0we+T7bW0lP7ZWheySa024sJYcbNmN9Q==
X-Received: by 2002:a05:600c:3644:: with SMTP id y4mr10822184wmq.85.1625822682905;
        Fri, 09 Jul 2021 02:24:42 -0700 (PDT)
Received: from [192.168.3.211] (xdsl-188-155-177-222.adslplus.ch. [188.155.177.222])
        by smtp.gmail.com with ESMTPSA id t22sm4497799wmi.22.2021.07.09.02.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jul 2021 02:24:42 -0700 (PDT)
To:     Mark Greer <mgreer@animalcreek.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <961dc9c5-0eb0-586c-5e70-b21ca2f8e6f3@linaro.org>
 <d498c949-3b1e-edaa-81ed-60573cfb6ee9@canonical.com>
 <20210512164952.GA222094@animalcreek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Subject: Re: [linux-nfc] Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof
 Kozlowski as maintainer
Message-ID: <df2ec154-79fa-af7b-d337-913ed4a0692e@canonical.com>
Date:   Fri, 9 Jul 2021 11:24:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210512164952.GA222094@animalcreek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/05/2021 18:49, Mark Greer wrote:
> On Wed, May 12, 2021 at 11:43:13AM -0400, Krzysztof Kozlowski wrote:
>> On 12/05/2021 11:11, Daniel Lezcano wrote:
>>> On 12/05/2021 16:43, Krzysztof Kozlowski wrote:
>>>> The NFC subsystem is orphaned.  I am happy to spend some cycles to
>>>> review the patches, send pull requests and in general keep the NFC
>>>> subsystem running.
>>>>
>>>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>>>
>>>> ---
>>>>
>>>> I admit I don't have big experience in NFC part but this will be nice
>>>> opportunity to learn something new. 
>>>
>>> NFC has been lost in the limbos since a while. Good to see someone
>>> volunteering to take care of it.
>>>
>>> May I suggest to create a simple nfc reading program in the 'tools'
>>> directory (could be a training exercise ;)
>>>
>>
>> Noted, thanks. I also need to get a simple hardware dongle for this....
> 
> Krzysztof, the NFC portion of the kernel has a counterpart in userspace
> called neard.  I'm supposed to be maintaining it but I have next to no
> time to do so.  If you have spare cycles, any help would be appreciated.
> 
> Anyway, in neard, there are some simple test scripts (python2 - I/we need
> to update to python3).  The current home of neard is:
> 
> git://git.kernel.org/pub/scm/network/nfc/neard.git

I guess none of us have problem of too much spare time :), so it took me
a while before I looked at neard.

With newer Gcc, neard did not even compile (which I am fixing now). I
set up a fork:
https://github.com/krzk/neard
However I can give early disclaimer - playing with GLib userspace code
is not something I am in long term interested. If this was written in
Rust, would be different story. :)

I also configured basic CI (or rather continuous building):
https://github.com/krzk/neard/actions/runs/1014641944

However I still do not have proper testing setup. No hardware. Would be
nice if Samsung. ST, NXP or Intel could spare some development board
with the NFC chip supported by kernel. Till then, I will try the NFC
simulator and virtual NCI drivers.

My next plan for neard is to extend the CI. There is no way I (or anyone
else I believe) can keep good quality of releases without automated
checks. I'll add some more distros, clang and later many some linters or
cppcheck.


Best regards,
Krzysztof
