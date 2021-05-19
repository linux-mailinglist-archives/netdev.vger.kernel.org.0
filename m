Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E90388BB6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 12:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348143AbhESKjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 06:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhESKjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 06:39:15 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0816AC06175F;
        Wed, 19 May 2021 03:37:55 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id s5-20020a7bc0c50000b0290147d0c21c51so3037817wmh.4;
        Wed, 19 May 2021 03:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xzuESJ+k+2y7Nhli/8VjnG+9Q7+whBxw6GBhacmD5FA=;
        b=qyZnyuji6WAA/FyI/zYJiASunjp824/6ZpSGR24DJkEr1W/446xOfaSzbTFSTQSigD
         XL0BBC5q0saLHLGZOhjXuCvXdJBKBlREXp71VHXntN0hyVVTqP0wp90VkkflUgqwzC3M
         aXEndXp9KYPgUMmvMQrDXl8U69ueoqNwJSsUhg3AvfMCVbmgJRE/8nyaSNk2QYuaMPsu
         nDy/5xSwAia7uHJqf55WYBAoRmEbI2H/gI7zlHZ07izNwrKj20r+DkmDwTTur5hC6bXJ
         MeiJE8DONPY9Zo4tkUV0MnlUrI4T5z3TAV7zfCzqPVIeDeSxeOjbvUHXONDNjBYZAp5R
         +o3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xzuESJ+k+2y7Nhli/8VjnG+9Q7+whBxw6GBhacmD5FA=;
        b=CCSiRVjvzFLHWunjc407FhAgEmfvzqba+mZWK67WnZqT6Lk4ez+UofxdehP6bWzrLk
         4VUdmrZ8RjwbJVE3bJgZGmt84MLmDncT88su+0m+jrCvy47wUiLThulXT5jdwt1qeaZ5
         a3dyqoojYrjhUDVvdVMoR/sA0wY2ucaf/BZck672Ta6/s+rIZ5bL5ECtXUtfxQ76wA9N
         8KvR50/yzfYu3w+k1DPY2SIedHa0SOh8i2ac7n5QLBAt9MfOADa5pzZsPeD+h6R+ZL0U
         y/FJHyosNaTrCavglhGNgFXEQr0nCVNOm0MqmQQGkZWF3UUC+lQMCx0iCHSgZOKCVTEB
         AcOQ==
X-Gm-Message-State: AOAM532h3gCcHUYkh7y8GdNQnXlFCmePZCY0VxdLdcWzGXy4Sf20zow9
        WrYW0JgVv8HdtBCbF//NwM0=
X-Google-Smtp-Source: ABdhPJxRhhLUGT9FkUiySw8DyA1imc0Ea6Q8ODsVyJcs+hJMMhvPHZZWIBH1wdZ+2qBZB2LL3p4YKA==
X-Received: by 2002:a05:600c:2256:: with SMTP id a22mr10117550wmm.138.1621420673557;
        Wed, 19 May 2021 03:37:53 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:e5dc:6577:6b94:e9e7? (p200300ea8f384600e5dc65776b94e9e7.dip0.t-ipconnect.de. [2003:ea:8f38:4600:e5dc:6577:6b94:e9e7])
        by smtp.googlemail.com with ESMTPSA id v18sm30207587wro.18.2021.05.19.03.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 May 2021 03:37:52 -0700 (PDT)
Subject: Re: [PATCH] net: phy: add driver for Motorcomm yt8511 phy
To:     Leon Romanovsky <leon@kernel.org>, Peter Geis <pgwipeout@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
References: <20210511214605.2937099-1-pgwipeout@gmail.com>
 <YKOB7y/9IptUvo4k@unreal>
 <CAMdYzYrV0T9H1soxSVpQv=jLCR9k9tuJddo1Kw-c3O5GJvg92A@mail.gmail.com>
 <YKTJwscaV1WaK98z@unreal>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cbfecaf2-2991-c79e-ba80-c805d119ac2f@gmail.com>
Date:   Wed, 19 May 2021 12:37:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YKTJwscaV1WaK98z@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.05.2021 10:18, Leon Romanovsky wrote:
> On Tue, May 18, 2021 at 08:20:03PM -0400, Peter Geis wrote:
>> On Tue, May 18, 2021 at 4:59 AM Leon Romanovsky <leon@kernel.org> wrote:
>>>
>>> On Tue, May 11, 2021 at 05:46:06PM -0400, Peter Geis wrote:
>>>> Add a driver for the Motorcomm yt8511 phy that will be used in the
>>>> production Pine64 rk3566-quartz64 development board.
>>>> It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
>>>>
>>>> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
>>>> ---
>>>>  MAINTAINERS                 |  6 +++
>>>>  drivers/net/phy/Kconfig     |  6 +++
>>>>  drivers/net/phy/Makefile    |  1 +
>>>>  drivers/net/phy/motorcomm.c | 85 +++++++++++++++++++++++++++++++++++++
>>>>  4 files changed, 98 insertions(+)
>>>>  create mode 100644 drivers/net/phy/motorcomm.c
>>>
>>> <...>
>>>
>>>> +static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
>>>> +     { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
>>>> +     { /* sentinal */ }
>>>> +}
>>>
>>> Why is this "__maybe_unused"? This *.c file doesn't have any compilation option
>>> to compile part of it.
>>>
>>> The "__maybe_unused" is not needed in this case.
>>
>> I was simply following convention, for example the realtek.c,
>> micrel.c, and smsc.c drivers all have this as well.
> 
> Maybe they have a reason, but this specific driver doesn't have such.
> 

It's used like this:
MODULE_DEVICE_TABLE(mdio, <mdio_device_id_tbl>);

And MODULE_DEVICE_TABLE is a no-op if MODULE isn't defined:

#ifdef MODULE
/* Creates an alias so file2alias.c can find device table. */
#define MODULE_DEVICE_TABLE(type, name)					\
extern typeof(name) __mod_##type##__##name##_device_table		\
  __attribute__ ((unused, alias(__stringify(name))))
#else  /* !MODULE */
#define MODULE_DEVICE_TABLE(type, name)
#endif

In this case the table is unused.

> Thanks
> 
>>
>>>
>>> Thanks


