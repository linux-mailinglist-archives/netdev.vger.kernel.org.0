Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D5D46D514
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 15:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhLHOLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 09:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhLHOLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 09:11:01 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE24C061746;
        Wed,  8 Dec 2021 06:07:29 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id o13so4224689wrs.12;
        Wed, 08 Dec 2021 06:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=flO2O8RvdMi4zDyJ0phVtOeQZBpULAZ1IhqXyVEqyzA=;
        b=Egk86bCKE8ZJa9Cxbm7c7hc3MxfwwPpQfeTlLF1zqfn9EQxmPANDyOI9rBxigF1gBy
         z0FE1yf7TsZp7sXnDofJIAaW3rKF5aWJTc2kZHUF/+hZGbcz89t52kGQ+4inbIqHUxA9
         clPpkb7qZ3s+Try2LP26Z+XTyvMinh/mBP8uXl4PW56FpmeQJsCaW6UMLdXT2YjiNy7F
         kWjZJyTJ9lLjPyC6KqoZyjfNEZnCLMSfz+diNnPIKVPeSN0AxW7wOc/ca8xCQQZTLAVT
         Sthi0dRPwE9h0DAZ6lxO+R/qjVfz3vrj7Uv77+3ZPG6bRQFgGSjejt76DkRKR0EIjOEL
         MTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=flO2O8RvdMi4zDyJ0phVtOeQZBpULAZ1IhqXyVEqyzA=;
        b=mkxLxsp4EnOeUbH2BJdUYh8VqHpVK+xHu1s7mDrU5KkBtwOZrOpjG6QTKMHC3l2/xB
         EtVv9mHjXmHug0v1f62N+oHTpCizrI2k6GK0IVJMS5PELmOcGWHFoE0R9ndJBbC0ZB+c
         /TTlqCixXlU3GX7Y3Gen4/BPKey5Jj/ebTwPdGhB6DcLlMDllp2Pmjc3vxCZ/qAQ2Kre
         2u8OxHKhqagOHtyn2BcObKlJe1C6X74Ot8hsIWVaXsEU4p7wAG1YlN63+l5OB8Nr5nlT
         LWrJsL6/N+Ttci/M1W7OH52SvbNrTzhIeTlPLYD0kYkinoe6p+WIp/P9AIdi3o1s4Xes
         02SQ==
X-Gm-Message-State: AOAM530h6FMvPU7O9zIRLKx6Di87w+eH0RgtCAjVJ/NcBhsfr3QJuMEn
        eQ9NpimbxhAVuqtx6fxsHyc=
X-Google-Smtp-Source: ABdhPJxwrd+qCdOIbLO5MeObmUldpC0bKJPA1DSjSX0ZaTkODCFhRslJ7yErIE3qwCprCkUf/wLWgw==
X-Received: by 2002:a05:6000:181:: with SMTP id p1mr60216470wrx.292.1638972448449;
        Wed, 08 Dec 2021 06:07:28 -0800 (PST)
Received: from debian64.daheim (p5b0d797a.dip0.t-ipconnect.de. [91.13.121.122])
        by smtp.gmail.com with ESMTPSA id c10sm3101318wrb.81.2021.12.08.06.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 06:07:27 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1muwdv-0008Oc-Ou;
        Wed, 08 Dec 2021 15:07:24 +0100
Message-ID: <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com>
Date:   Wed, 8 Dec 2021 15:07:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF
 selection
Content-Language: de-DE
To:     Robert Marko <robimarko@gmail.com>, Kalle Valo <kvalo@kernel.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
References: <20211009221711.2315352-1-robimarko@gmail.com>
 <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2021 13:21, Robert Marko wrote:
> On Tue, 7 Dec 2021 at 19:06, Kalle Valo <kvalo@kernel.org> wrote:
>>
>> Robert Marko <robimarko@gmail.com> wrote:
>>
>>> Some ath10k IPQ40xx devices like the MikroTik hAP ac2 and ac3 require the
>>> BDF-s to be extracted from the device storage instead of shipping packaged
>>> API 2 BDF-s.
>>>
>>> This is required as MikroTik has started shipping boards that require BDF-s
>>> to be updated, as otherwise their WLAN performance really suffers.
>>> This is however impossible as the devices that require this are release
>>> under the same revision and its not possible to differentiate them from
>>> devices using the older BDF-s.
>>>
>>> In OpenWrt we are extracting the calibration data during runtime and we are
>>> able to extract the BDF-s in the same manner, however we cannot package the
>>> BDF-s to API 2 format on the fly and can only use API 1 to provide BDF-s on
>>> the fly.
>>> This is an issue as the ath10k driver explicitly looks only for the
>>> board.bin file and not for something like board-bus-device.bin like it does
>>> for pre-cal data.
>>> Due to this we have no way of providing correct BDF-s on the fly, so lets
>>> extend the ath10k driver to first look for BDF-s in the
>>> board-bus-device.bin format, for example: board-ahb-a800000.wifi.bin
>>> If that fails, look for the default board file name as defined previously.
>>>
>>> Signed-off-by: Robert Marko <robimarko@gmail.com>
>>
>> Can someone review this, please? I understand the need for this, but the board
>> handling is getting quite complex in ath10k so I'm hesitant.
>>
>> What about QCA6390 and other devices. Will they still work?
> Hi Kalle,
> everything else should just continue working as before unless the
> board-bus-device.bin file
> exists it will just use the current method to fetch the BDF.
> 
> Also, this only applies to API1 BDF-s.
> 
> We are really needing this as currently there are devices with the
> wrong BDF being loaded as
> we have no way of knowing where MikroTik changed it and dynamic
> loading would resolve
> all of that since they are one of the rare vendors that embed the
> BDF-s next to calibration data.

Isn't the only user of this the non-upstreamable rb_hardconfig
mikrotik platform driver? So, in your case the devices in question
needs to setup a detour through the userspace firmware (helper+scripts)
to pull on the sysfs of that mikrotik platform driver? Wouldn't it
be possible to do this more directly?

Cheers,
Christian
