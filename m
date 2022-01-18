Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD98D492D0D
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 19:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347845AbiARSO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 13:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347841AbiARSOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 13:14:24 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24161C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:14:24 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id r15so1367816ilj.7
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 10:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fWA2LtBSkb7OtA3OLZlu2a/9bVjouMvqp9LwVh5aZE0=;
        b=bs1C8bfnfHCgv4K232+bbq2k6LL5/cChyWs2DiuyKo0dyEjpc6yqp8pX2tDSGFKFji
         kZE+lsnJQ9ads0PDlg1mMlsnc+vrtzD9KryVnkyUIS7EnPN2ruxoGGYj62bXsfunq6W9
         TKDeA6oIDRgDoHZPy8Fsg6Bma2N1e8fviewozVtR4F/BWRpVKCrTfsFdXKv7xWLzrEA/
         FNi9+AC7aBpngIFWNA7cKSXgIUNuWJGzg9Ax74F8Us/0Rq4RTX8+6M2EU49LW3weCH5/
         WocIK/bCwrg99KB4KnYOhSuWE6jovn4iflsiXlz4m5YAEdia9yFRJeMoNVGBYt5FQZ4o
         Ztpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fWA2LtBSkb7OtA3OLZlu2a/9bVjouMvqp9LwVh5aZE0=;
        b=RVTD0PVe3bIOcSfGryyVONQkhL7xI9nGJHmbc6EoLKIitgE4oHHUesUwUKLyAssThO
         yn//rKOS8mSanLSejHUnjWN/aXxcMzWkMiYOp5vOGz/w7U29piOCZE57iyOA1xfjfnVc
         Pm82/u/0LH2F1G7eiSKC21JZjuQf0PKsMQzR8//SpzP8XOE70lBdR9u8/YQUPFuoeuWY
         Jc+r0mZtILK5zrlVTkYdt/yZNadklIVRicm1Lzz/cxOeT+bWtpiJlj60Iwzv9RpKn7sb
         BF0nVadqo5DUEr3iFWB7ehIX8UWmRBxxquCxODFNYUrYWrWc+0XjiEWjh0E9AMwE1uaB
         LZwQ==
X-Gm-Message-State: AOAM532SA3l2bojOovMdMV2EZNBmHItFbsRFViovspFR+/ZWEIMq8xdh
        pfryP0c/M9pQqGS6lQIgiab71Q==
X-Google-Smtp-Source: ABdhPJxxJYXTv0gffQIIH21VkyrbZka0D2cY72L0ntzD0F0v7zZ5KIHWlWW8iPfRy2PdK0LhxSfWCQ==
X-Received: by 2002:a05:6e02:180e:: with SMTP id a14mr13947041ilv.300.1642529663495;
        Tue, 18 Jan 2022 10:14:23 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i20sm12699549iov.43.2022.01.18.10.14.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 10:14:22 -0800 (PST)
Message-ID: <9175f51f-2db4-84fd-01ba-0047ce8ebdcc@linaro.org>
Date:   Tue, 18 Jan 2022 12:14:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: Port mirroring, v2 (RFC)
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org> <YeHhKDUNy8rU+xcG@lunn.ch>
 <6d25d602-399e-0a25-1410-0e958237db11@linaro.org>
 <20220118100751.542e0ad0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20220118100751.542e0ad0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 12:07 PM, Jakub Kicinski wrote:
> On Fri, 14 Jan 2022 15:12:41 -0600 Alex Elder wrote:
>>> I think i need to take a step back here. With my background, an AP is
>>> an 802.11 Access Point.
>>
>> Again, terminology problems!  Sorry about that.
>>
>> Yes, when I say "AP" I mean "Application Processor".  Some people
>> might call it "APSS" for "Application Processor Subsystem."
> 
> And AP is where Linux runs, correct? Because there are also APs on NICs
> (see ETH_RESET_AP) which are not the host...

Correct.  It is the term I have used consistently in the
IPA code, to refer to "the processor (complex) running
Linux, which (basically) owns the IPA device."

					-Alex

