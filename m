Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7594A9D61
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376751AbiBDRG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiBDRG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 12:06:59 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40051C061714;
        Fri,  4 Feb 2022 09:06:59 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so13665030pju.2;
        Fri, 04 Feb 2022 09:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FCJqphnrhYpXz/JFE4AkQNtVQmZZt8NjKZRV3W24Djg=;
        b=Gd2i++FD63/D2XyQ30o5iAnrXBBh6iaFgJbsDQFwRT6Jwul6zaUqKEY6xXUIIho/qy
         ujalZi/4IXnzr6Umn3jGvktxmgu9sKWD7bU4ffIH4ASAhIzozqnQlwEeABDAcwRCK2Si
         p6rTY0Rj7nFylg/FqnPLrGbYwKTvrJIdcCLokxQuYQ2XtXwzOcvXsM1blPRhsLD6N8ql
         NhbIp6Ku7JOCFiFwLOTi9hdH8uCOJrEQmIvV+DUeQaR4TBDa880x1y7iTpqFOREyXn5U
         RNj6ANdN8cGZsEB4laW4LKaUbpiW716wnEZmccOagqCZ+N4W1SGBShcQ2gTrcTJYYXuj
         6Msw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FCJqphnrhYpXz/JFE4AkQNtVQmZZt8NjKZRV3W24Djg=;
        b=OBA3A8sfMjGSDfPD/3NyTffRKCln8JOvXvAxwAadp9/UiUfSD3Gy/3aJT5xgyA9Nmz
         qS8u+CIc1dXhgiYAneru39920XCOriaszRS37kDYGlyuo8NfyUC7/q+/oaYVPmrTGjQ/
         hiG9NN56QgbUEsnTdL+YwPDLGYfIRNZH5Ny3Llr0Bz5ObU3g8cEetHs7i2n+7oI3Tq/p
         uOf/5ACb01wlisBpDNU9xp5HIrE/hkI5VjvabwfI5x6+s8VNgcWe65DIiu3ZkvzsR22d
         KAbjn44wDe+l7o1xVNHIky/oxECCtblkUwoowH4hX0kmIvHdC7Jkg+xBjgopX+vewc+x
         5htg==
X-Gm-Message-State: AOAM531T/a2eIifwSER4+reGzO7iNOeVDSqVK7LsFxM2/ZkhC2wDHjRg
        ZfHjMdtdESfXvIuvwVNx4AA=
X-Google-Smtp-Source: ABdhPJw9lMPygL/ISdGM/aCPLsFC/wIwxRfiafUpyHNrsqk/Tjfew/WLnrXNfRLFURUGYBdNFnF9LQ==
X-Received: by 2002:a17:902:8641:: with SMTP id y1mr4146731plt.115.1643994418657;
        Fri, 04 Feb 2022 09:06:58 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ca12sm2700502pjb.11.2022.02.04.09.06.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:06:57 -0800 (PST)
Message-ID: <5bd30f31-6303-0b1c-b378-6d7b1e4a0928@gmail.com>
Date:   Fri, 4 Feb 2022 09:06:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Martin Schiller <ms@dev.tdt.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch> <c732e1ce-8c9c-b947-8d4b-78903920a5b2@gmail.com>
 <CAJ+vNU1Urkd4A8BdvP7H9W_H2DDOH2_khXesh49KzWoVqjk_iw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CAJ+vNU1Urkd4A8BdvP7H9W_H2DDOH2_khXesh49KzWoVqjk_iw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/2022 8:02 AM, Tim Harvey wrote:
> On Wed, Feb 2, 2022 at 7:12 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 2/2/2022 5:01 PM, Andrew Lunn wrote:
>>>> As a person responsible for boot firmware through kernel for a set of
>>>> boards I continue to do the following to keep Linux from mucking with
>>>> various PHY configurations:
>>>> - remove PHY reset pins from Linux DT's to keep Linux from hard resetting PHY's
>>>> - disabling PHY drivers
>>>>
>>>> What are your thoughts about this?
>>>
>>> Hi Tim
>>>
>>> I don't like the idea that the bootloader is controlling the hardware,
>>> not linux.
>>
>> This is really trying to take advantage of the boot loader setting
>> things up in a way that Linux can play dumb by using the Generic PHY
>> driver and being done with it. This works... until it stops, which
>> happens very very quickly in general. The perfect counter argument to
>> using the Generic PHY driver is when your system implements a low power
>> mode where the PHY loses its power/settings, comes up from suspend and
>> the strap configuration is insufficient and the boot loader is not part
>> of the resume path *prior* to Linux. In that case Linux needs to restore
>> the settings, but it needs a PHY driver for that.
> 
> Florian,
> 
> That makes sense - I'm always trying to figure out what the advantage
> of using some of these PHY drivers really is vs disabling them.
> 
>>
>> If your concern Tim is with minimizing the amount of time the link gets
>> dropped and re-established, then there is not really much that can be
>> done that is compatible with Linux setting things up, short of
>> minimizing the amount of register writes that do need the "commit phase"
>> via BMCR.RESET.
> 
> No, my reasoning has nothing to do with link time - I have just run
> into several cases where some new change in a PHY driver blatantly
> either resets the PHY reverting to pin-strapping config which is wrong
> (happend to me with DP83867 but replacing the 'reset' to a 'restart'
> solved that) or imposes some settings without dt bindings to guide it
> (this case with the LEDs) or imposes some settings based on 'new'
> dt-bindings which I was simply not aware of (a lesser issue as dt
> bindings can be added to resolve it).
> 
>>
>> I do agree that blindly imposing LED settings that are different than
>> those you want is not great, and should be remedied. Maybe you can
>> comment this part out in your downstream tree for a while until the LED
>> binding shows up (we have never been so close I am told).
> 
> or disable the driver in defconfig, or blacklist the module if I want
> to do it via rootfs.
> 
> Can you point me to something I can look at for these new LED bindings
> that are being worked on?
> 

This is the latest attempt AFAICT:

https://lore.kernel.org/netdev/20211112153557.26941-1-ansuelsmth@gmail.com/
-- 
Florian
