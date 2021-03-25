Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF5634962E
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhCYPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhCYPzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:55:32 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C377EC06174A;
        Thu, 25 Mar 2021 08:55:31 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id g20so1454837wmk.3;
        Thu, 25 Mar 2021 08:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oboscLOCxZgPatgZxost0Nu0mBSRwFVV2R3LjLZrcUo=;
        b=MJ9xUA5EilIcr5GB/BcGAmx4oL83UDWRk1LXyLn7TjliW/MyjxjxkyZ7U0laK9x5Ru
         HuHAO70jfbxj0pTbYyCn95GZxw0myGI1UeXILEMUBrkEMCPGS0iemJ6GCCQ1pKxFODo3
         II4jWHzYGQ5SPukhN8La7hVtkwS3HaYGObWczFN+0wPe5zQU4eVGg2LrVJNqpCfZ+dI4
         09iOIEUMK/LEx+D4xkc1g1WpnW7iyIsQckJ7KKJkfweJRGmTZ6YyeBKU+e/y+in8TygG
         n5BM4wHc4hspipi7/hWtIR9yJM7fy+6r3KeiYDoLuAPfhwQDE2QTv4l/Dy9u5d79ftXA
         +k9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oboscLOCxZgPatgZxost0Nu0mBSRwFVV2R3LjLZrcUo=;
        b=CLpsqP0L9/Zul9y9xuxpBac50ZUunWqty4zgmO0o+xeHko9gqvhzsFAeoJNIsE9gW1
         0BgZZkQn7hcFnYC6CkOzeOjXopWCykiWhxzD7a60XwDqi3wyQLOjDmqHymns/qLwB+jF
         rD1/PUXQNmqSRSuUg+SZIw2nvW1Y9m1LfcfWGkH+e2OE5aH5hV8EVax5l8/Ar3rrHUzV
         xiIa704EkGY9teNKWKyRdpLrQVLDS+OlRb54Ykj//IS7QMsKZ2gep1naSF4AOHsyk3cS
         /ScBCpe8PcpQ4KLXnyQreo0LG7qElGeas/aBhegG4nptxRjQ+yNP8/IytV3SgBklbIa9
         YPEA==
X-Gm-Message-State: AOAM532CJ+GoLPX+zOXSdQ4bGNNyN9RX8CX7RkbKyLXdfdUNG2gpTRFz
        awgA2fviyXrKFJn+oZJau2Q=
X-Google-Smtp-Source: ABdhPJyI2RAE5TJGA+zvTRGXh4WOYNmeTrWDqnM0X56nJCd5sepJrkCHc4KilK3GF6yhQKpaOOVugA==
X-Received: by 2002:a05:600c:198d:: with SMTP id t13mr8883725wmq.73.1616687730446;
        Thu, 25 Mar 2021 08:55:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:835:ce1a:dbdf:db93? (p200300ea8f1fbb000835ce1adbdfdb93.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:835:ce1a:dbdf:db93])
        by smtp.googlemail.com with ESMTPSA id x13sm210835wmp.39.2021.03.25.08.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 08:55:30 -0700 (PDT)
Subject: Re: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible
 string
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org
References: <20210325124225.2760-1-linux.amoon@gmail.com>
 <4ce8997b-9f20-2c77-2d75-93e038eec6d8@gmail.com>
 <CANAwSgS4SLdYwY9n6uNci+rgE1Q4UAzCy29gX+CL4patDgH15A@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <41c4af19-cceb-c25c-2e11-cc9319cc42c1@gmail.com>
Date:   Thu, 25 Mar 2021 16:55:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANAwSgS4SLdYwY9n6uNci+rgE1Q4UAzCy29gX+CL4patDgH15A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.03.2021 16:40, Anand Moon wrote:
> Hi Heiner
> 
> 
> On Thu, 25 Mar 2021 at 18:49, Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 25.03.2021 13:42, Anand Moon wrote:
>>> On most of the Amlogic SoC I observed that Ethernet would not get
>>> initialize when try to deploy the mainline kernel, earlier I tried to
>>> fix this issue with by setting ethernet reset but it did not resolve
>>> the issue see below.
>>>       resets = <&reset RESET_ETHERNET>;
>>>       reset-names = "stmmaceth";
>>>
>>> After checking what was the missing with Rockchip SoC dts
>>> I tried to add this missing compatible string and then it
>>> started to working on my setup.
>>>
>>> Also I tried to fix the device tree binding to validate the changes.
>>>
>>> Tested this on my Odroid-N2 and Odroid-C2 (64 bit) setup.
>>> I do not have ready Odroid C1 (32 bit) setup so please somebody test.
>>>
>>
>> When working on the Odroid-C2 I did not have such a problem.
>> And if you look at of_mdiobus_child_is_phy() and
>> of_mdiobus_register_phy() you'll see that your change shouldn't be
>> needed.
> I will check this out, thanks for your inputs.
>>
>> Could you please elaborate on:
>> - What is the exact problem you're facing? Best add a dmesg log.
>    1> I am aware all the distro kernel I have tested ethernet will work file
>    2> My issue is when I compile the mainline kernel with the default setting,
>        Ethernet interface will not receive any DHCP IP address from the router
>        Although the Ethernet interface comes up properly.
>       This does not happen frequently but I observed this at my end.

If the PHY wouldn't be detected, then your network would never work.
So there must be a different reason. You can manually assign a static IP
and then check what's going wrong: checking for missed / error packets,
running iperf, etc.


>   3> I tried to collect logs but I did not observe any kernel issue
> like panic or warning.
> 
>> - Which kernel version are you using?
>      I am using the mainline kernel with default settings.
> 
> -Anand
> 

