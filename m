Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD38F459CFC
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 08:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhKWHrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 02:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbhKWHrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 02:47:43 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAF5C06173E
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 23:44:35 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id v15so9421879ljc.0
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 23:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OFni7OMG0YDoHf8+SVSQQtBeUkvcBzsEi+4TKKd7G1I=;
        b=OcZR1d2SpMTDbJaWfkBN1hJ40OYDUx2AaZKYuwiAyFTSaRbV8MbCtjAnXo7Rm2DTYP
         /z1B2Ahc+dRZVgCwpngyw3Hh/QkFn1DgzUNMqLXBd6C7hukq1/+6NPc+ixXw3o2sL7ao
         iUiut6q0OSiqNCG1mKb4AmQdw/8a0sVWsycs8BCthTPIHGef6Iukdl3OzF49Ln/ljoT0
         xxwhn+5VTMEBLLkilBV/AO8RcwkONyjFX4NNPvvYuVp/Tap85jXMC27W36rpJ/CiMudA
         OqrubRHDUHonEf/sCY+FS29pkbmciuNAY1VkcPgBssr5/EsTSAUwZvO/aTvbL+i7KVQP
         2Fpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OFni7OMG0YDoHf8+SVSQQtBeUkvcBzsEi+4TKKd7G1I=;
        b=BK0mTzeyX/oZ4LmAZyW0vmqDt6C/DxyAojBsNePknNjotd22ZSLRxdJozJms2cEPKi
         mJ37J5g4rqEpaXVL8tJSG8Y7YmspAAk0zJgQGMzuPH1o3S0qs7uDr+CO3dPwO3c6m3wB
         6UBPKPz1B+qkbDDgNCEvaFwN0UlGBhiTc/3DFDRqjwalg7F3RjUvZeSqyCFn6JN+Hziq
         t9abbAzsXNZzWx4oghE5O7vi4b+Z8gq/+iVN+XF1Mf7JDDA9yjOGTbxvjU6lktakaGRu
         q4WqGI7s3s0JKp9gsR79LcuG3hXSwC/x/VxAAEkT8Va8Wu741hc5G/axzLLoBvndDy5u
         69Qw==
X-Gm-Message-State: AOAM533R4rDeTRGNz0K8ZXLzZj/lXaAxriwOrXXbgj6sxkNlhXENUYW1
        xweuzIhikKg5rv6FSnfFbav+rWrOlzbms4xZ
X-Google-Smtp-Source: ABdhPJwd3aQlA4lgavu0f7MvLhBPfptaaXJOH6mA3nCT2ykbcFdj7Ilc01WLJCJIn8W7F1T0Et1F7w==
X-Received: by 2002:a2e:890d:: with SMTP id d13mr2881763lji.396.1637653473587;
        Mon, 22 Nov 2021 23:44:33 -0800 (PST)
Received: from [10.0.6.3] (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id u3sm1201270lfs.256.2021.11.22.23.44.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 23:44:33 -0800 (PST)
Subject: Re: [PATCH] can: bittiming: replace CAN units with the SI metric
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211119161850.202094-1-mailhol.vincent@wanadoo.fr>
 <38544770-9e5f-1b1b-1f0a-a7ff1719327d@hartkopp.net>
 <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
From:   Jimmy Assarsson <extja@kvaser.com>
Message-ID: <9fabde2b-b0ec-bc7c-30fa-d7556ed3c89d@kvaser.com>
Date:   Tue, 23 Nov 2021 08:44:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAMZ6RqJobmUnAMUjnaqYh0jsOPw7-PwiF+bF79hy6h+8SCuuDg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-22 03:22, Vincent MAILHOL wrote:
> Le lun. 22 nov. 2021 à 03:27, Oliver Hartkopp <socketcan@hartkopp.net> a écrit :
>> On 19.11.21 17:18, Vincent Mailhol wrote:
>>> In [1], we introduced a set of units in linux/can/bittiming.h. Since
>>> then, generic SI prefix were added to linux/units.h in [2]. Those new
>>> prefix can perfectly replace the CAN specific units.
>>>
>>> This patch replaces all occurrences of the CAN units with their
>>> corresponding prefix according to below table.
>>>
>>>    CAN units   SI metric prefix
>>>    -------------------------------
>>>    CAN_KBPS    KILO
>>>    CAN_MBPS    MEGA
>>>    CAM_MHZ     MEGA
>>>
>>> The macro declarations are then removed from linux/can/bittiming.h
>>>
>>> [1] commit 1d7750760b70 ("can: bittiming: add CAN_KBPS, CAN_MBPS and
>>> CAN_MHZ macros")
>>>
>>> [2] commit 26471d4a6cf8 ("units: Add SI metric prefix definitions")
>>>
>>> Suggested-by: Jimmy Assarsson <extja@kvaser.com>
>>> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
>>> ---
>>>    drivers/net/can/dev/bittiming.c           | 5 +++--
>>>    drivers/net/can/usb/etas_es58x/es581_4.c  | 5 +++--
>>>    drivers/net/can/usb/etas_es58x/es58x_fd.c | 5 +++--
>>>    include/linux/can/bittiming.h             | 7 -------
>>>    4 files changed, 9 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
>>> index 0509625c3082..a5c9f973802a 100644
>>> --- a/drivers/net/can/dev/bittiming.c
>>> +++ b/drivers/net/can/dev/bittiming.c
>>> @@ -4,6 +4,7 @@
>>>     * Copyright (C) 2008-2009 Wolfgang Grandegger <wg@grandegger.com>
>>>     */
>>>
>>> +#include <linux/units.h>
>>>    #include <linux/can/dev.h>
>>>
>>>    #ifdef CONFIG_CAN_CALC_BITTIMING
>>> @@ -81,9 +82,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
>>>        if (bt->sample_point) {
>>>                sample_point_nominal = bt->sample_point;
>>>        } else {
>>> -             if (bt->bitrate > 800 * CAN_KBPS)
>>> +             if (bt->bitrate > 800 * KILO)
>>>                        sample_point_nominal = 750;
>>> -             else if (bt->bitrate > 500 * CAN_KBPS)
>>> +             else if (bt->bitrate > 500 * KILO)
>>>                        sample_point_nominal = 800;
>>>                else
>>>                        sample_point_nominal = 875;
>>> diff --git a/drivers/net/can/usb/etas_es58x/es581_4.c b/drivers/net/can/usb/etas_es58x/es581_4.c
>>> index 14e360c9f2c9..ed340141c712 100644
>>> --- a/drivers/net/can/usb/etas_es58x/es581_4.c
>>> +++ b/drivers/net/can/usb/etas_es58x/es581_4.c
>>> @@ -10,6 +10,7 @@
>>>     */
>>>
>>>    #include <linux/kernel.h>
>>> +#include <linux/units.h>
>>>    #include <asm/unaligned.h>
>>>
>>>    #include "es58x_core.h"
>>> @@ -469,8 +470,8 @@ const struct es58x_parameters es581_4_param = {
>>>        .bittiming_const = &es581_4_bittiming_const,
>>>        .data_bittiming_const = NULL,
>>>        .tdc_const = NULL,
>>> -     .bitrate_max = 1 * CAN_MBPS,
>>> -     .clock = {.freq = 50 * CAN_MHZ},
>>> +     .bitrate_max = 1 * MEGA,
>>> +     .clock = {.freq = 50 * MEGA},
>>
>> IMO we are losing information here.
>>
>> It feels you suggest to replace MHz with M.
> 
> When I introduced the CAN_{K,M}BPS and CAN_MHZ macros, my primary
> intent was to avoid having to write more than five zeros in a
> row (because the human brain is bad at counting those). And the
> KILO/MEGA prefixes perfectly cover that intent.
> 
> You are correct to say that the information of the unit is
> lost. But I assume this information to be implicit (frequencies
> are in Hz, baudrate are in bits/second). So yes, I suggest
> replacing MHz with M.
> 
> Do you really think that people will be confused by this change?
> 
> I am not strongly opposed to keeping it either (hey, I was the
> one who introduced it in the first place). I just think that
> using linux/units.h is sufficient.

Came across linux/units.h when looking at a different driver, and thought
that it was also possible to utilize them in the CAN drivers.

I've no strong opinion about any of the suggested solutions.
I'm fine with keeping it as it is, just wanted to raise the question :)

Best regards,
jimmy

>> So where is the Hz information then?
> 
> It is in the comment of can_clock:freq :)
> 
> https://elixir.bootlin.com/linux/v5.15/source/include/uapi/linux/can/netlink.h#L63
> 
>>>        .ctrlmode_supported = CAN_CTRLMODE_CC_LEN8_DLC,
>>>        .tx_start_of_frame = 0xAFAF,
>>>        .rx_start_of_frame = 0xFAFA,
>>> diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
>>> index 4f0cae29f4d8..aec299bed6dc 100644
>>> --- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
>>> +++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
>>> @@ -12,6 +12,7 @@
>>>     */
>>>
>>>    #include <linux/kernel.h>
>>> +#include <linux/units.h>
>>>    #include <asm/unaligned.h>
>>>
>>>    #include "es58x_core.h"
>>> @@ -522,8 +523,8 @@ const struct es58x_parameters es58x_fd_param = {
>>>         * Mbps work in an optimal environment but are not recommended
>>>         * for production environment.
>>>         */
>>> -     .bitrate_max = 8 * CAN_MBPS,
>>> -     .clock = {.freq = 80 * CAN_MHZ},
>>> +     .bitrate_max = 8 * MEGA,
>>> +     .clock = {.freq = 80 * MEGA},
>>>        .ctrlmode_supported = CAN_CTRLMODE_LOOPBACK | CAN_CTRLMODE_LISTENONLY |
>>>            CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_FD | CAN_CTRLMODE_FD_NON_ISO |
>>>            CAN_CTRLMODE_CC_LEN8_DLC | CAN_CTRLMODE_TDC_AUTO,
>>> diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
>>> index 20b50baf3a02..a81652d1c6f3 100644
>>> --- a/include/linux/can/bittiming.h
>>> +++ b/include/linux/can/bittiming.h
>>> @@ -12,13 +12,6 @@
>>>    #define CAN_SYNC_SEG 1
>>>
>>>
>>> -/* Kilobits and Megabits per second */
>>> -#define CAN_KBPS 1000UL
>>> -#define CAN_MBPS 1000000UL
>>> -
>>> -/* Megahertz */
>>> -#define CAN_MHZ 1000000UL
>>
>> So what about
>>
>> #define CAN_KBPS KILO /* kilo bits per second */
>> #define CAN_MBPS MEGA /* mega bits per second */
>>
>> #define CAN_MHZ MEGA /* mega hertz */
>>
>>
>> ??
>>
>> Regards,
>> Oliver
