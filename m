Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C783D65F6
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhGZRBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 13:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZRBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 13:01:39 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01202C061757;
        Mon, 26 Jul 2021 10:42:08 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id m13so16878741lfg.13;
        Mon, 26 Jul 2021 10:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CB/Zfc1t7P/NpdwsSeGT1bKh/GhRunvdvj+F1dDVEFY=;
        b=Fa8nmn6olMrVEgthgmB6WZBqqeoGhcGAMhSETZOVyLvYgeosON1iDJD89jEmywcbHK
         bzQQ8Iak1AQjubLB3so4rvmH3gDfbItJIQfZTjs7PTKOH0olyX4lO4DNj9AvVIFBsg4U
         3LbxmPxgfTZ7wZVK/05VoanNdjXIYF5lYvRDpCKx+y5/MKJFWhka8MYgrPlrVVA5m7L2
         aM3fS3lBSW93RjAGPZeUVEO50SdA0noKzmoz3h4pGbR3oW3S3O5ghSEz91YRdT0xTjq4
         mwY/yceYfIK0OP5BTZqyReozexrgGqfxyedpi0UsOP/tYIaWlHT4wxCf+bh6Y2vtaakV
         FwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CB/Zfc1t7P/NpdwsSeGT1bKh/GhRunvdvj+F1dDVEFY=;
        b=Hr4Vj9GQTFaUga2f2Nr9JwPi8dba7JObEHbHa8afkNz1Q1OsONFc53v9GbGuGrsfkC
         25U+UWPjXNueE2QaFph5OK2eE81x5VWw2fCE+257mqxZiFi7phsN4ywBlF9E+R2XOO4E
         2Nyc6A5Pkx9TOgFmENWqXftY38g9QY5p4/ZlMK2RD2obOSr7EpQ3XCgjPpnpTFYF1srt
         TmrhA58+SONDZhVDcva4hWXblrglqUk/74al96fuwKWwFxo8kx4wN8fd7JeEKrSFXo1P
         p2O+vMm2o7sl8O0G9fNlGU2fXYUJtasharluuppfp6tEaYZWs+a8LpyeX0dVLEIeGYsU
         15Mw==
X-Gm-Message-State: AOAM532vrSv+h4G247f4gI9Qcm2ok4+/wY/N1+65GlCprsRG0gvnMJUH
        BLLZhFJSVLMUrokqmD1h9luFAappefo=
X-Google-Smtp-Source: ABdhPJyJi3tgaWUvzfSlcfmyhMK8pe139JiW0qM7HQpQOyei/dQcAGuZuSVi76YmDLKvQSas1MSOyA==
X-Received: by 2002:a19:a403:: with SMTP id q3mr14012039lfc.287.1627321326164;
        Mon, 26 Jul 2021 10:42:06 -0700 (PDT)
Received: from [192.168.0.131] ([194.183.54.57])
        by smtp.gmail.com with ESMTPSA id q7sm60272lfb.124.2021.07.26.10.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 10:42:05 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com> <YPTKB0HGEtsydf9/@lunn.ch>
 <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com> <YPbu8xOFDRZWMTBe@lunn.ch>
 <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
 <20210721204543.08e79fac@thinkpad> <YPh6b+dTZqQNX+Zk@lunn.ch>
 <20210721220716.539f780e@thinkpad>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
Date:   Mon, 26 Jul 2021 19:42:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210721220716.539f780e@thinkpad>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On 7/21/21 10:07 PM, Marek Behún wrote:
> On Wed, 21 Jul 2021 21:50:07 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>>> Hi Heiner,
>>>
>>> in sysfs, all devices registered under LED class will have symlinks in
>>> /sys/class/leds. This is how device classes work in Linux.
>>>
>>> There is a standardized format for LED device names, please look at
>>> Documentation/leds/leds-class.rst.
>>>
>>> Basically the LED name is of the format
>>>    devicename:color:function
>>
>> The interesting part here is, what does devicename mean, in this
>> context?
>>
>> We cannot use the interface name, because it is not unique, and user
>> space can change it whenever it wants. So we probably need to build
>> something around the bus ID, e.g. pci_id. Which is not very friendly
>> :-(
> 
> Unfortunately there isn't consensus about what the devicename should
> mean. There are two "schools of thought":
> 
> 1. device name of the trigger source for the LED, i.e. if the LED
>     blinks on activity on mmc0, the devicename should be mmc0. We have
>     talked about this in the discussions about ethernet PHYs.
>     In the case of the igc driver if the LEDs are controlled by the MAC,
>     I guess some PCI identifier would be OK. Or maybe ethernet-mac
>     identifier, if we have something like that? (Since we can't use
>     interface names due to the possibility of renaming.)
> 
>     Pavel and I are supporters of this scheme.
> 
> 2. device name of the LED controller. For example LEDs controlled by
>     the maxim,max77650-led controller (leds-max77650.c) define device
>     name as "max77650"
> 
>     Jacek supports this scheme.

I believe you must have misinterpreted some my of my statements.
The whole effort behind LED naming unification was getting rid of
hardware device names in favour of Linux provided device names.
See e.g. the excerpt from Documentation/leds/leds-class.rst:

- devicename:
         it should refer to a unique identifier created by the kernel,
         like e.g. phyN for network devices or inputN for input devices, 
rather
         than to the hardware; the information related to the product 
and the bus
         to which given device is hooked is available in sysfs and can be
         retrieved using get_led_device_info.sh script from tools/leds; 
generally
         this section is expected mostly for LEDs that are somehow 
associated with
         other devices.


-- 
Best regards,
Jacek Anaszewski
