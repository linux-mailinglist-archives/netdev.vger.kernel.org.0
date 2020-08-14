Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4952D244CB3
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgHNQaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:30:30 -0400
Received: from hostingweb31-40.netsons.net ([89.40.174.40]:58597 "EHLO
        hostingweb31-40.netsons.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728099AbgHNQa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:30:27 -0400
Received: from [37.160.38.175] (port=40734 helo=[192.168.42.162])
        by hostingweb31.netsons.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <luca@lucaceresoli.net>)
        id 1k6cay-0001mB-F9; Fri, 14 Aug 2020 18:30:20 +0200
Subject: Re: [PATCH] dt-bindings: Whitespace clean-ups in schema files
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux HWMON List <linux-hwmon@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "open list:IIO SUBSYSTEM AND DRIVERS" <linux-iio@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-ALSA <alsa-devel@alsa-project.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        MTD Maling List <linux-mtd@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:REAL TIME CLOCK (RTC) SUBSYSTEM" 
        <linux-rtc@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>
References: <20200812203618.2656699-1-robh@kernel.org>
 <d5808e9c-07fe-1c28-b9a6-a16abe9df458@lucaceresoli.net>
 <CAL_JsqKekx0VO4NROwLrgrU8+L584HaLHM9i3kCZvU+g5myeGw@mail.gmail.com>
From:   Luca Ceresoli <luca@lucaceresoli.net>
Message-ID: <f1963eb9-283f-e903-2a3a-4f324d71d418@lucaceresoli.net>
Date:   Fri, 14 Aug 2020 18:30:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKekx0VO4NROwLrgrU8+L584HaLHM9i3kCZvU+g5myeGw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 14/08/20 16:51, Rob Herring wrote:
> On Thu, Aug 13, 2020 at 4:31 AM Luca Ceresoli <luca@lucaceresoli.net> wrote:
>>
>> Hi Rob,
>>
>> On 12/08/20 22:36, Rob Herring wrote:
>>> Clean-up incorrect indentation, extra spaces, long lines, and missing
>>> EOF newline in schema files. Most of the clean-ups are for list
>>> indentation which should always be 2 spaces more than the preceding
>>> keyword.
>>>
>>> Found with yamllint (which I plan to integrate into the checks).
>>
>> [...]
>>
>>> diff --git a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
>>> index 3d4e1685cc55..28c6461b9a9a 100644
>>> --- a/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
>>> +++ b/Documentation/devicetree/bindings/clock/idt,versaclock5.yaml
>>> @@ -95,10 +95,10 @@ allOf:
>>>        # Devices without builtin crystal
>>>        properties:
>>>          clock-names:
>>> -            minItems: 1
>>> -            maxItems: 2
>>> -            items:
>>> -              enum: [ xin, clkin ]
>>> +          minItems: 1
>>> +          maxItems: 2
>>> +          items:
>>> +            enum: [ xin, clkin ]
>>>          clocks:
>>>            minItems: 1
>>>            maxItems: 2
>>
>> Thanks for noticing, LGTM.
>>
>> [...]
>>
>>> diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
>>> index d7dac16a3960..36dc7b56a453 100644
>>> --- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
>>> +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
>>> @@ -33,8 +33,8 @@ properties:
>>>      $ref: /schemas/types.yaml#/definitions/uint32
>>>
>>>    touchscreen-min-pressure:
>>> -    description: minimum pressure on the touchscreen to be achieved in order for the
>>> -                 touchscreen driver to report a touch event.
>>> +    description: minimum pressure on the touchscreen to be achieved in order
>>> +      for the touchscreen driver to report a touch event.
>>
>> Out of personal taste, I find the original layout more pleasant and
>> readable. This third option is also good, especially for long descriptions:
>>
>>   description:
>>     minimum pressure on the touchscreen to be achieved in order for the
>>     touchscreen driver to report a touch event.
>>
>> At first glance yamllint seems to support exactly these two by default:
>>
>>> With indentation: {spaces: 4, check-multi-line-strings: true}
> 
> Turning on check-multi-line-strings results in 10K+ warnings, so no.
> 
> The other issue is the style ruamel.yaml wants to write out is as the
> patch does above. This matters when doing some scripted
> transformations where we read in the files and write them back out. I
> can somewhat work around that by first doing a pass with no changes
> and then another pass with the actual changes, but that's completely
> scriptable. Hopefully, ruamel learns to preserve the style better.

Kind of sad, but I understand the reason as far as my understanding of
the yaml world allows. Thanks for the explanation.

[For idt,versaclock5.yaml, plus an overview of whole patch]
Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>

-- 
Luca
