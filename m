Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E40423122
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhJEUAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbhJEUAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 16:00:07 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72506C061749;
        Tue,  5 Oct 2021 12:58:16 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m3so770672lfu.2;
        Tue, 05 Oct 2021 12:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hgFhj/BkQI7X1cffQ0EVk2bBOpilxAjwgAYdfhmxDBA=;
        b=h/UmKSAsadZNKK7tRc0lVsnctgsJzYQuDv6vocfyyLB6EScvHPBCa8uaFsxi1y+YHk
         8pYqPbMFQhtzVZgVsJp6OCNFk5VsoOdHntI5UbDYoLDzpL2sLPHnsJ2JcG7UL2rnf20L
         CuqnU0y+QIxl5iHuXs8TjFNAwb1S+Q3YiEhk42NxBtA9XWvswrMkBlO/7RRxJFs/5BiM
         NpxjFzEL83eT0OFfAg2ofe/8Xpae+9q/6Dnzyl5H+qX8MmWBo6k5GaXaVGJ12o2EJZQY
         +sHwhtbB1+1aLQYj0E2Qm6WAU4cXLRLsZBikiWalMQk4mI98q06VFSTIo3PWL673RX9R
         50yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgFhj/BkQI7X1cffQ0EVk2bBOpilxAjwgAYdfhmxDBA=;
        b=JXrlJijNtsJHrTe7bfhNLuhNaPKO8kTebNNGpvaryu+/EzqNiz9ySpd5c+izJjCAvy
         h6WlNQ0iwZGugwn3QKRfmjxAaijlGOcQ60YUdU6Ya05DHoA03ZMoXJRlOFRlleF5zZMm
         nvo9QYQ8FE752kzGO5B/I2UHN+J/QrQWYH4K3zFWzgxeXIN89e+7LMJ4eRmYd7O7ahnq
         lhA6JG//gIkMw7UI2R1SX7xSbVNo9sarSxsV+fYR/WbPXt6Tuw8bDPxs3rw+rlMTd6My
         ZDkLdgkJ3xduz6bBXeUnuouTOXb2h6huf3/HPc1QHPllAOkOnPxh0kR9UCI5Ot7LxEfc
         Qdeg==
X-Gm-Message-State: AOAM532grxz6izibuNJSCVYtdsmj2jqtJIiFZn6lAngWSGoLvF0V8QZn
        LEl6bXmxLpA3D2gmL7ef6HP8AS+X6cgtoQ==
X-Google-Smtp-Source: ABdhPJwbP+6YFFxvDLyLVT88rWS9woqIcvh8rSXK2rz7dCObjl7q+fYO3MgMTM+pZ2PEcX0UfDXnRQ==
X-Received: by 2002:a05:6512:1042:: with SMTP id c2mr5374251lfb.59.1633463894437;
        Tue, 05 Oct 2021 12:58:14 -0700 (PDT)
Received: from [192.168.0.131] ([194.183.54.57])
        by smtp.gmail.com with ESMTPSA id a21sm2237530lji.135.2021.10.05.12.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Oct 2021 12:58:14 -0700 (PDT)
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20211001143601.5f57eb1a@thinkpad> <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad> <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
Date:   Tue, 5 Oct 2021 21:58:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211004170847.3f92ef48@thinkpad>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On 10/4/21 5:08 PM, Marek Behún wrote:
> On Mon, 4 Oct 2021 16:50:09 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> 
>>> Hello Andrew,
>>>
>>> I am aware of this, and in fact am working on a proposal for an
>>> extension of netdev LED extension, to support the different link
>>> modes. (And also to support for multi-color LEDs.)
>>>
>>> But I am not entirely sure whether these different link modes should be
>>> also definable via device-tree. Are there devices with ethernet LEDs
>>> dedicated for a specific speed? (i.e. the manufacturer says in the
>>> documentation of the device, or perhaps on the device's case, that this
>>> LED shows 100M/1000M link, and that other LED is shows 10M link?)
>>> If so, that this should be specified in the devicetree, IMO. But are
>>> such devices common?
>>
>> I have a dumb 5 port switch next to me. One port is running at 1G. Its
>> left green LED is on and blinks with traffic. Another port of the
>> switch is running at 100Mbps and its right orange LED is on, blinks
>> for traffic. And there is text on the case saying 10/100 orange, 1G
>> green.
>>
>> I think this is pretty common. You generally do want to know if 10/100
>> is being used, it can indicate problems. Same for a 10G port running
>> at 1G, etc.
> 
> OK then. I will work no a proposal for device tree bindings for this.
> 
>>> And what about multi-color LEDs? There are ethernet ports where one LED
>>> is red-green, and so can generate red, green, and yellow color. Should
>>> device tree also define which color indicates which mode?
>>
>> There are two different ways this can be implemented. There can be two
>> independent LEDs within the same package. So you can generate three
>> colours. Or there can be two cross connected LEDs within the
>> package. Apply +ve you get one colour, apply -ve you get a different
>> colour. Since you cannot apply both -ve and +ve at the same time, you
>> cannot get both colours at once.
>>
>> If you have two independent LEDs, I would define two LEDs in DT.
> 
> No, we have multicolor LED API which is meant for exactly this
> situation: a multicolor LED.

Multicolor LED framework is especially useful for the arrangements
where we want to have a possibility of controlling mixed LED color
in a wide range.
In the discussed case it seems that having two separate LED class
devices will be sufficient. Unless the LEDs have 255 or so possible
brightness levels each and they can produce meaningful mixed color
per some device state.

> (I am talking about something like the KJ2518D-262 from
>   http://www.rego.com.tw/product_detail.php?prdt_id=258
>   which has Green/Orange on left and Yellow on right side.
>   The left Green/Orange LED has 3 pins, and so it can mix the colors into
>   yellow.)
> 
>> Things get tricky for the two dependency LEDs. Does the LED core have
>> support for such LEDs?
> 
> Unfortunately not yet. The multicolor API supports LEDs where the
> sub-leds are independent.

What do you mean by dependency here? You can write LED multicolor class
driver that will aggregate whatever LEDs you want, provided that it will
know how to control them. However, the target use case was RGB LED
controllers.

>> This is where we need to strike a balance between too simple and too
>> complex. Implement most of the common features, but don't support
>> exotic stuff, like two dependency LEDs?
> 
> I think the best solution here would be a subclass "enumcolor" (or
> different name), where you can choose between several pre-defined colors.
> In sysfs you could then do
>    echo 1 >brightness
>    echo green >color
>    echo yellow >color
> 
> There already are other people who need to register such LEDs.
> 
> Marek
> 

-- 
Best regards,
Jacek Anaszewski
