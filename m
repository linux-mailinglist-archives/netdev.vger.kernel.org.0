Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C823030B849
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhBBHEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 02:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232371AbhBBHC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 02:02:57 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00027C061756;
        Mon,  1 Feb 2021 23:02:16 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id k25so21716550oik.13;
        Mon, 01 Feb 2021 23:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6C9jt/6KxKNI0ezRD+MueHVWKLwHrnHbGoKiSrDh4Uk=;
        b=J1oKhx9CaBvCt8hzUuwHMNy4gPNUhBKMfkJAlClJm/qYeIQR7frtxcFn1etLDY0miO
         MDJ7kGgIm5gslAgt5gRnEFhSakFZBN46qI5t+mzfTQfVGoTHnx7FH1nqiPo3EWrGoMw6
         qJDHHNi/nENgmdm6/J03xppqFtgroKpkk8cKJXzlZfCBf1Lz5AydLwfMKntj1Ti8wm9v
         qhG0qqO8r0AbTNxSZ1ZJEPRzUpGBYZ9ZzJ2/yaX16tOazwhAP/zYLkfn37GdcjM96OTh
         +ThndwLKA+D7Y1gh9e+AxNYw1xY8+JDHeqwCjrq8W3jDmRzBbEqvygs7slEBOlPZM8qc
         hCMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6C9jt/6KxKNI0ezRD+MueHVWKLwHrnHbGoKiSrDh4Uk=;
        b=HoNd7tF6cZ19fTAduye0BKz35zL8zVKipNvDKIigKLU0W02UIO/9HV5scv2AlVD5Fg
         hmGGwazpIWXYrWogS3YGizgW8CKAEB0foI4w1FYvZN9B+QWuM2KORT/VCX2dSnjmHClp
         5xpDTrzmMMtEPt2ssE20TGnWjJ9hr/9P/syJxHCwEaZ4h1RKOXDWYxXeYnJaWlMmVguY
         DykS3KurdnOxllBPbgz4UldGvcLc2Rd+RRIEJPjPzE4yUqkzdmTKfVHnaY5Jgi2iqx17
         cmSQZeZawbuxRuqWuA3Ce/2mOKOzQsDYsHknaGj4a96fDTfxgjGQFFuLEfnUwIoz1yaB
         41Hw==
X-Gm-Message-State: AOAM531PZY29x6ykHC0zP4wTkfKe6GYf2CpYhhbFccBaUNHhLtDwzTJH
        J4WMynO3fRBGjCO5lOYONDQ=
X-Google-Smtp-Source: ABdhPJxO0De8BobalEGebOu3MbJMAXe1SmvJcxPZxpNPkOOjh03HzC49YZoqLDLyJujzxy2AcZSg7w==
X-Received: by 2002:aca:5988:: with SMTP id n130mr1870437oib.60.1612249336466;
        Mon, 01 Feb 2021 23:02:16 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id d3sm4705650ooi.42.2021.02.01.23.02.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 23:02:15 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Subject: Re: [PATCH] rtw88: 8821c: Add RFE 2 support
To:     Kalle Valo <kvalo@codeaurora.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andy Huang <tehuang@realtek.com>
References: <20200805084559.30092-1-kai.heng.feng@canonical.com>
 <c0c336d806584361992d4b52665fbb82@realtek.com>
 <9330BBA5-158B-49F1-8B7C-C2733F358AC1@canonical.com>
 <CAAd53p6SA5gG8V27eD1Kh1ik932Kt8KzmYjLy33pOkw=QPKgpA@mail.gmail.com>
 <871rdz7zjf.fsf@codeaurora.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <e4f2fe2b-52a2-7b39-6758-decf22d82eb6@lwfinger.net>
Date:   Tue, 2 Feb 2021 01:02:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <871rdz7zjf.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 12:29 AM, Kalle Valo wrote:
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>> On Wed, Aug 5, 2020 at 7:24 PM Kai-Heng Feng
>> <kai.heng.feng@canonical.com> wrote:
>>>
>>> Hi Tony,
>>>
>>>> On Aug 5, 2020, at 19:18, Tony Chuang <yhchuang@realtek.com> wrote:
>>>>
>>>>> 8821CE with RFE 2 isn't supported:
>>>>> [   12.404834] rtw_8821ce 0000:02:00.0: rfe 2 isn't supported
>>>>> [   12.404937] rtw_8821ce 0000:02:00.0: failed to setup chip efuse info
>>>>> [   12.404939] rtw_8821ce 0000:02:00.0: failed to setup chip information
>>>>>
>>>>
>>>> NACK
>>>>
>>>> The RFE type 2 should be working with some additional fixes.
>>>> Did you tested connecting to AP with BT paired?
>>>
>>> No, I only tested WiFi.
>>>
>>>> The antenna configuration is different with RFE type 0.
>>>> I will ask someone else to fix them.
>>>> Then the RFE type 2 modules can be supported.
>>>
>>> Good to know that, I'll be patient and wait for a real fix.
>>
>> It's been quite some time, is support for RFE type 2 ready now?
> 
> It looks like this patch should add it:
> 
> https://patchwork.kernel.org/project/linux-wireless/patch/20210202055012.8296-4-pkshih@realtek.com/
> 
New firmware (rtw8821c_fw.bin) is also needed. That is available at 
https://github.com/lwfinger/rtw88.git.

Larry

