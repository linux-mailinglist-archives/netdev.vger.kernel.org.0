Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF6764ABE
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 18:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbfGJQ2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 12:28:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42600 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfGJQ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 12:28:52 -0400
Received: by mail-wr1-f67.google.com with SMTP id a10so3134968wrp.9;
        Wed, 10 Jul 2019 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n3bVyRuBKYxMwLKy4aeR+FP9w4ZvEseyvW7OI9IZnbM=;
        b=XHKiWE4N0U/xyNtRKn7HagPuAN+2NqE5j+nVNgD/Qk/l3+b6vC0CH9J85QMXPnMpbt
         7SUy/hpPniQDOsCc2dIqFPx0+l7kUiIok6WWjM5vZ5/4cD/Mzyyp+4fExUV83A8EJe39
         0CfeBMapQD8h7y/Xyug01C+eClFLI3sb6jachQdUYQGpC5zM8Y1UwxgmBtnpvs5L375f
         JKf6ehyA5cdRPk23ND9WPGpFaHIRwHSXxH2R3tmTD5g1NoNz2RmnWqpkVNweyuVMNAex
         xv1Vv6hSZ9XjjMi1rDooAM1Jj9XTjv72hvTcobevL8peFZi/qGm/PNdPDmiSp2TfoLoV
         waPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=n3bVyRuBKYxMwLKy4aeR+FP9w4ZvEseyvW7OI9IZnbM=;
        b=pwYOecls6+Uv9df5O2Yj4X9zMsD+qdQ9Bxi0TZNR0F5Bgs5NLccY3WRAofHo1cVpCG
         V/W+f1Dl10F5rn3y8j7gUMQfAJ85faq6IQJ9WKUjGK3/uxGyQOp+AkrpzltGSxHfh3AO
         OpcSSXAAdctODjafp4g5Dig/u3GyWADVVAz0z/PVOBVQA6mx9ca8cEU6bAqMrSmIF8ei
         coaR6z+Yv/ANkjlJi0SxjsjdTDyodIrcQoBk3kTYbFXLJGL4AojswyLMnMIQOQ/fwS5g
         N00MpAKH7+CjHQ/iJGO1tbgUKb7jnISC8rNNhbk8+6o/hnlIVH0YnMNHx4Kq3zBalM53
         3tGw==
X-Gm-Message-State: APjAAAWG938rn33YosXjVYNlYf3M/uBvYePYANhwyA7jb6b0Atlxf9oh
        mHnYhOoq7IVT675YXyvmodI=
X-Google-Smtp-Source: APXvYqxH3ffobwnT4mYcjr2r81f/nuiw1WUDlOiaEIjOFxFpknbtgS7MDQTIrkmI2WQIKPgdAWvpZg==
X-Received: by 2002:adf:d081:: with SMTP id y1mr33907589wrh.34.1562776128779;
        Wed, 10 Jul 2019 09:28:48 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o6sm4169040wra.27.2019.07.10.09.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 09:28:48 -0700 (PDT)
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
To:     Rob Herring <robh+dt@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
 <20190703232331.GL250418@google.com>
 <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <7d102d81-750d-32d9-a554-95f018e69f2f@gmail.com>
Date:   Wed, 10 Jul 2019 09:28:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/19 8:55 AM, Rob Herring wrote:
> On Wed, Jul 3, 2019 at 5:23 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>>
>> Hi Florian,
>>
>> On Wed, Jul 03, 2019 at 02:37:47PM -0700, Florian Fainelli wrote:
>>> On 7/3/19 12:37 PM, Matthias Kaehlcke wrote:
>>>> The LED behavior of some Realtek PHYs is configurable. Add the
>>>> property 'realtek,led-modes' to specify the configuration of the
>>>> LEDs.
>>>>
>>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>>>> ---
>>>> Changes in v2:
>>>> - patch added to the series
>>>> ---
>>>>  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
>>>>  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
>>>>  2 files changed, 26 insertions(+)
>>>>  create mode 100644 include/dt-bindings/net/realtek.h
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
>>>> index 71d386c78269..40b0d6f9ee21 100644
>>>> --- a/Documentation/devicetree/bindings/net/realtek.txt
>>>> +++ b/Documentation/devicetree/bindings/net/realtek.txt
>>>> @@ -9,6 +9,12 @@ Optional properties:
>>>>
>>>>     SSC is only available on some Realtek PHYs (e.g. RTL8211E).
>>>>
>>>> +- realtek,led-modes: LED mode configuration.
>>>> +
>>>> +   A 0..3 element vector, with each element configuring the operating
>>>> +   mode of an LED. Omitted LEDs are turned off. Allowed values are
>>>> +   defined in "include/dt-bindings/net/realtek.h".
>>>
>>> This should probably be made more general and we should define LED modes
>>> that makes sense regardless of the PHY device, introduce a set of
>>> generic functions for validating and then add new function pointer for
>>> setting the LED configuration to the PHY driver. This would allow to be
>>> more future proof where each PHY driver could expose standard LEDs class
>>> devices to user-space, and it would also allow facilities like: ethtool
>>> -p to plug into that.
>>>
>>> Right now, each driver invents its own way of configuring LEDs, that
>>> does not scale, and there is not really a good reason for that other
>>> than reviewing drivers in isolation and therefore making it harder to
>>> extract the commonality. Yes, I realize that since you are the latest
>>> person submitting something in that area, you are being selected :)
> 
> I agree.
> 
>> I see the merit of your proposal to come up with a generic mechanism
>> to configure Ethernet LEDs, however I can't justify spending much of
>> my work time on this. If it is deemed useful I'm happy to send another
>> version of the current patchset that addresses the reviewer's comments,
>> but if the implementation of a generic LED configuration interface is
>> a requirement I will have to abandon at least the LED configuration
>> part of this series.
> 
> Can you at least define a common binding for this. Maybe that's just
> removing 'realtek'. While the kernel side can evolve to a common
> infrastructure, the DT bindings can't.

That would be a great start, and that is actually what I had in mind
(should have been more specific), I was not going to have you Matthias
do the grand slam and convert all this LED configuration into the LEDs
class etc. that would not be fair.

It seems to be that we can fairly easily agree on a common binding for
LED configuration, I would define something along those lines to be
flexible:

phy-led-configuration = <LED_NUM_MASK LED_CFG_MASK>;

where LED_NUM_MASK is one of:

0 -> link
1 -> activity
2 -> speed

that way you can define single/dual/triple LED configurations by
updating the bitmask.

LED_CFG_MASK is one of:

0 -> LED_CFG_10
1 -> LED_CFG_100
2 -> LED_CFG_1000

(let's assume 1Gbps or less for now)

or this can be combined in a single cell with a left shift.

Andrew, Heiner, do you see that approach working correctly and scaling
appropriately?
-- 
Florian
