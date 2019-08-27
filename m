Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABBA9F225
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfH0SOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:14:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37860 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730376AbfH0SOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:14:17 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so19775820wrt.4
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W0rEXQ6LQDiVENfoKHlABbY/I3JBAZ51Vx6J+Gxo+gg=;
        b=MaWtnB6rSRVpXcy37wGCme5mGJXB+/itodcnKT6ZM8hR/YuzHOUv/6Bdo8X4YqdfmT
         iSgrJSSnAq6nSbb2inhxvQ4RTmPPmCliYqIvbZq7Rmw66W5e3Ys1Ur820N5hgYUR912U
         scfB42nMoxfH7q0l/ocd8PMe7dlqJONba7Q3dwb2YQ68RLz6YwHLjuhKv23rYpZ4W5r1
         7MaXaX3rqjQVScKV/Mxr5t6gfrHuy6QzB4dqppLESiSLia6oRlVXZx/OwHv2H/8spjOR
         +EDf/0c4ay47AEY6aUptXNk1ejlmtWCfuQNh71QCYu2OyJWSltrwxro7wFZkL6K9arc7
         7z6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W0rEXQ6LQDiVENfoKHlABbY/I3JBAZ51Vx6J+Gxo+gg=;
        b=DF8JHV+XRmqvRQyXZkIHghaKydAhXwbNTOxSGVysQYMD25oxlqpzwA6agA0yO+TVMU
         LT+ISuK5pw5PA/CdzBigMLzZ3+j5UvfydXVQqhBaSNbTfDR5AFRNW2SftuNoUfHHkvGc
         YWbmRKcSNPMEjb00JzDVIz1ST8Kah9df7QpC+bUSD1i4IpK/pthGKxle3kqDLy1Ingub
         y2y/U9UKKzhG3KefWVVKrKIu7KWSVjKZGuF29/KN7Kq0FAtz10WtSTWKnbyS1VHhzPUR
         TuNzq+HHpUPHKixHbEJsRYLNgGfpoJRJBLRiOipCPD3gIzID5h5NUIwSCkrlcrgum0xN
         f3BA==
X-Gm-Message-State: APjAAAUrHFMbjyiilYsDkczI5y0Z8LirnHfjFBmHjLBsiHz7gOWwb957
        OUmzkei1+zuWMFXkr80YjOFllkw3
X-Google-Smtp-Source: APXvYqzG3Cv39oikPpglZjLG+bTtMiYocP/RDcuZFgA33zUafowyzM4+aCmg/Sb1UYgSvYRWFXISsA==
X-Received: by 2002:a5d:6b52:: with SMTP id x18mr31574118wrw.66.1566929654053;
        Tue, 27 Aug 2019 11:14:14 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0? (p200300EA8F047C0004DC3C3331AAF4C0.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:4dc:3c33:31aa:f4c0])
        by smtp.googlemail.com with ESMTPSA id i93sm33085282wri.57.2019.08.27.11.14.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 11:14:12 -0700 (PDT)
Subject: Re: [PATCH] rtl_nic: add firmware rtl8125a-3
To:     Chun-Hao Lin <hau@realtek.com>
Cc:     Josh Boyer <jwboyer@kernel.org>,
        Linux Firmware <linux-firmware@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
References: <dd3220fb-7ed3-c5d1-d501-5e94f270a6b4@gmail.com>
 <CA+5PVA54CyX1od+drTF+R0cp-Kf5L51CxHf473R-FJd1HZA2-g@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b4faccd6-10ff-c6ab-523d-39a1734e1b72@gmail.com>
Date:   Tue, 27 Aug 2019 20:14:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+5PVA54CyX1od+drTF+R0cp-Kf5L51CxHf473R-FJd1HZA2-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.08.2019 14:08, Josh Boyer wrote:
> On Mon, Aug 26, 2019 at 6:23 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> This adds firmware rtl8125a-3 for Realtek's 2.5Gbps chip RTL8125.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> Firmware file was provided by Realtek and they asked me to submit it.
> 
> Can we get a Signed-off-by from someone at Realtek then?
> 
Hi Hau,

can you reply and add your Signed-off-by?
I saw that all the RTL8168 firmware was submitted by Hayes Wang.

> josh
> 
Heiner

>> The related extension to r8169 driver will be submitted in the next days.
>> ---
>>  WHENCE                |   3 +++
>>  rtl_nic/rtl8125a-3.fw | Bin 0 -> 3456 bytes
>>  2 files changed, 3 insertions(+)
>>  create mode 100644 rtl_nic/rtl8125a-3.fw
>>
>> diff --git a/WHENCE b/WHENCE
>> index fb12924..dbec18a 100644
>> --- a/WHENCE
>> +++ b/WHENCE
>> @@ -2906,6 +2906,9 @@ Version: 0.0.2
>>  File: rtl_nic/rtl8107e-2.fw
>>  Version: 0.0.2
>>
>> +File: rtl_nic/rtl8125a-3.fw
>> +Version: 0.0.1
>> +
>>  Licence:
>>   * Copyright © 2011-2013, Realtek Semiconductor Corporation
>>   *
>> diff --git a/rtl_nic/rtl8125a-3.fw b/rtl_nic/rtl8125a-3.fw
>> new file mode 100644
>> index 0000000000000000000000000000000000000000..fac635263f92e8d9734456b75932b2088edd5ef9
>> GIT binary patch
>> literal 3456
>> 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
>> DeEY6F
>>
>> literal 0
>> HcmV?d00001
>>
>> --
>> 2.23.0
>>
> 

