Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65648F1EF
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 22:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiANVMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 16:12:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiANVMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 16:12:45 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CA05C06161C
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 13:12:44 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id w7so8728473ioj.5
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 13:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tWtDNg5+Bhfmwr+j+Ylz4be/vWrJULlzFqrP8LZGXZE=;
        b=MI5gS8rVm4F/rluiWHsEJAL5LozTs5mhjBH4RJ53ylQdhI7p7TdKQZiCFo0U3wjb47
         Mkxg1v/FTuSpOhFy7tFH3lgKLPzkNE3IpD/elMer9blvvUCyPBDTZCOUa+U0yLTIVk6k
         1qYZlKvF1+2bBA02JxDLTp5FC7m/JrWH/T70oYuMSAoWrmqF5lPVkvu5Ks4+QmYk3g9G
         PB+feivIXF1T11/WBqrFtrngg0akG/LMsN/CXTRKryVJhFzhP+qtoOxvGajlnj/iHsN/
         AgvpaOVzWH0ovSmMiAorRAtsLEGIQgKOsz9xGdhCrg91cGLI2I6Gz71jOtln+jhlyNYy
         z5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tWtDNg5+Bhfmwr+j+Ylz4be/vWrJULlzFqrP8LZGXZE=;
        b=q+m1WOsDoXFNsin/L0nBz98rhIjkmSXLhnNnGk3SuuQdYXW+aVHCF5zIatP+RU+w1n
         9eCFeqRXY4lOtWlYysxzo2dIza4AtxQh4il6CoiHdPqQKB4GiApHZBheNRlK09Nl6O0X
         bAXz23XKnTspNTiBmYrWTq1eZs7YRtMALioLfucQR2LMJzlCQGan/EUMBKtDfktSoqYC
         P7ZmnPMQFsvlpIlgtkP/I4Rr9mMEnbWc2TzaneSNLLLpN8BNmv2nAgQYRK1GAmAeh8sE
         3QTg+fb+sr69WfviykZ2nmq+uENpMzgQRtX9us41/iBD2rzp3JDsCfWFnvilU/i+PIdo
         x0QQ==
X-Gm-Message-State: AOAM532BEFp/D7oQP5kOLH+6CjmyUmpSrHZbOJwvakR7Qt8vMJt0mXs0
        /EschMK1prrp4Xa5zFOHy3uZ2Lj4pLFwsw==
X-Google-Smtp-Source: ABdhPJwLfXGnz7mNSdOAYNKgTpuloQJPTbM0wM69mBS8YTtCinOD6FdvwU4CQ/zY9V1MSrDXibMWzA==
X-Received: by 2002:a05:6602:587:: with SMTP id v7mr5186126iox.105.1642194763338;
        Fri, 14 Jan 2022 13:12:43 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id t6sm5604000iov.39.2022.01.14.13.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 13:12:42 -0800 (PST)
Message-ID: <6d25d602-399e-0a25-1410-0e958237db11@linaro.org>
Date:   Fri, 14 Jan 2022 15:12:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring, v2 (RFC)
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeHhKDUNy8rU+xcG@lunn.ch>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <YeHhKDUNy8rU+xcG@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/14/22 2:46 PM, Andrew Lunn wrote:
> On Fri, Jan 14, 2022 at 11:03:26AM -0600, Alex Elder wrote:
>> Yikes!  I don't know why that turned out double-spaced.  I hope
>> this one turns out better.
>>
>> 					-Alex
>>
>> This is a second RFC for a design to implement new functionality
>> in the Qualcomm IPA driver.  Since last time I've looked into some
>> options based on feedback.  This time I'll provide some more detail
>> about the hardware, and what the feature is doing.  And I'll end
>> with two possible implementations, and some questions.
>>
>> My objective is to get a general sense that what I plan to do
>> is reasonable, so the patches that implement it will be acceptable.
>>
>>
>> The feature provides the AP access to information about the packets
>> that the IPA hardware processes as it carries them between its
>> "ports".  It is intended as a debug/informational interface only.
>> Before going further I'll briefly explain what the IPA hardware
>> does.
>>
>> The upstream driver currently uses the hardware only as the path
>> that provides access to a 5G/LTE cellular network via a modem
>> embedded in a Qualcomm SoC.
>>
>>         \|/
>>          |
>>    ------+-----   ------
>>    | 5G Modem |   | AP |
>>    ------------   ------
>>               \\    || <-- IPA channels, or "ports"
>>              -----------
>>              |   IPA   |
>>              -----------
> 
> Hi Alex
> 
> I think i need to take a step back here. With my background, an AP is
> an 802.11 Access Point.

Again, terminology problems!  Sorry about that.

Yes, when I say "AP" I mean "Application Processor".  Some people
might call it "APSS" for "Application Processor Subsystem."

> But here you mean Application Processor?
> What does IPA standard for ?

"IPA" stands for IP Accelerator, or Internet Protocol Accelerator.

> MHI ?

Modem-Host Interface (which is really a separate topic that I
don't want to get too distracted by at this point).  It is
basically a layer built over PCIe, that abstracts things to
carry multiple logical channels of data over a PCIe bus.
I'm working with others now to support MHI, but it's not
at all present in the IPA driver at the moment.

> I can probably figure these all out from context, but half the problem
> here is making sure we are talking the same language when we are
> considering using concepts from another part of the network stack.

Yes!  It's one reason I asked for input on naming this
feature.  Qualcomm has its own name (which could be fine),
but I'd like to try to use something that avoids confusion
as much as possible.

I really appreciate your considering this Andrew.

					-Alex

> 
> 	    Andrew
> 

