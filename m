Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED4D44B2AA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 19:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242343AbhKISXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 13:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242389AbhKISXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 13:23:13 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88017C061764;
        Tue,  9 Nov 2021 10:20:27 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v20so32865plo.7;
        Tue, 09 Nov 2021 10:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I5wTdLmlJ6yAtNAX1aGNMQtVcCvB6wAMhoGw1PgjShw=;
        b=jDZSHOQwo+2hNDQD2WfbPe4ou0IAujUoXUBQoTO5mynEfV0iZS5IA8uH3Jwtu0rj43
         i/K8bG8I98oj2qYPYpHHhlSgtuPzeONXIbDQQuBIvsI5BNZZkC8WSrp0/tVIaVeltrZy
         VnWc59XbHrzOSv1FZKYgZCXQvenHj7fDp8PnZDIg5V6UyatUwhb3VWxz6hRCmrBor3j+
         8xTVlumwnmvst7bRZN7iRUmOEtpSkXeMtEB568sZvL1dt5GB5yEJG8pdzGBTTIRB+EpA
         2ct28FrY17iiudsMs4QEQYsSI9ZueO203f7lev4ISHpkhs3omSCOW3Wulkj/J6uO/are
         /Bvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I5wTdLmlJ6yAtNAX1aGNMQtVcCvB6wAMhoGw1PgjShw=;
        b=xDQBlf5kl+jmp6NwmdZr57TH4OWZsKeZNm3O4LArIPg32Apvt6cf0DCpBbZb1UjchX
         fna3Y0AJP10YDyxh63/kSxVICvbB9R7MX4CnmsKM/WRCM1oYuoCKeILGT37Tei9KbLLn
         v23GwZ7I+390UZhSBVDC8ZC/UOAMpvBlXoP/N6S+7QinDQKHxutHLv4w68XEdYVAMjNc
         nWkFT1FZF480W+KvwNVhRZvJCo78k2DD4jVissojaQhrdwzOe+ak/44Lj7Qed2TOdW76
         a/o7xTtnp24IFte51KjZ5iXtmdacnqCKwK+yJkhBD4ESJMpWGZutfzmiEaD7k8xQoMNa
         78oQ==
X-Gm-Message-State: AOAM533fkgFRhqAHjTG1np6tm+AkYQLXBKpZ0RPrZ9WzJdypUDuNOFzA
        6okCBF+iuuLD72k1xL2eBXb8gCulGFI=
X-Google-Smtp-Source: ABdhPJzUMsFFMKjCDJF4+X2TN6M5dpgngkI7pPnNOdNbZWgVxq6UfRXQBcgVomS2x2fPe67sZ9s6bw==
X-Received: by 2002:a17:90a:9d89:: with SMTP id k9mr9585117pjp.74.1636482026724;
        Tue, 09 Nov 2021 10:20:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f130sm20142967pfa.81.2021.11.09.10.20.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:20:26 -0800 (PST)
Subject: Re: [PATCH v2 2/7] net: dsa: b53: Move struct b53_device to
 include/linux/dsa/b53.h
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Martin Kaistra <martin.kaistra@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211109095013.27829-1-martin.kaistra@linutronix.de>
 <20211109095013.27829-3-martin.kaistra@linutronix.de>
 <f71396fc-29a3-4022-3f7a-3a37abb9079c@gmail.com>
 <caec2d40-6093-ff06-ab8e-379e7939a85c@gmail.com>
 <CA+h21hp+UKRgCE0UTZr7keyU380W22ZEXdbfORhSTNfzb1S_iw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b04b344e-2a17-eac2-bbcb-746091f9175a@gmail.com>
Date:   Tue, 9 Nov 2021 10:20:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hp+UKRgCE0UTZr7keyU380W22ZEXdbfORhSTNfzb1S_iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/21 10:15 AM, Vladimir Oltean wrote:
> On Tue, 9 Nov 2021 at 20:11, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 11/9/21 10:05 AM, Florian Fainelli wrote:
>>> On 11/9/21 1:50 AM, Martin Kaistra wrote:
>>>> In order to access the b53 structs from net/dsa/tag_brcm.c move the
>>>> definitions from drivers/net/dsa/b53/b53_priv.h to the new file
>>>> include/linux/dsa/b53.h.
>>>>
>>>> Signed-off-by: Martin Kaistra <martin.kaistra@linutronix.de>
>>>> ---
>>>>  drivers/net/dsa/b53/b53_priv.h |  90 +----------------------------
>>>>  include/linux/dsa/b53.h        | 100 +++++++++++++++++++++++++++++++++
>>>>  2 files changed, 101 insertions(+), 89 deletions(-)
>>>>  create mode 100644 include/linux/dsa/b53.h
>>>
>>> All you really access is the b53_port_hwtstamp structure within the
>>> tagger, so please make it the only structure exposed to net/dsa/tag_brcm.c.
>>
>> You do access b53_dev in the TX part, still, I would like to find a more
>> elegant solution to exposing everything here, can you create a
>> b53_timecounter_cyc2time() function that is exported to modules but does
>> not require exposing the b53_device to net/dsa/tag_brcm.c?
>> --
>> Florian
> 
> Switch drivers can't export symbols to tagging protocol drivers, remember?
> https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/

I do now :) How about a function pointer in dsa_switch_ops that driver
can hook onto?
-- 
Florian
