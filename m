Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B38C0F0736
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbfKEUtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:49:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39578 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727401AbfKEUtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 15:49:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id a11so23097747wra.6;
        Tue, 05 Nov 2019 12:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hYSd/3njTuRQYW+MbQwSCa/QBWDUOU5HAkx5FhnJaxQ=;
        b=SJi0bd5eZKeDma6tKVX5tx5Y4/nqRMP5L8Pk0IqeZD7fyFmlOqlfgeSYs3HwmL1reG
         ZhMAD1lxKulx24PY9hoMnqSpJinCmLPs+vf2UbGiA0/R4Izkti5z9CobAeZJO8VSKp1B
         xAgDUwXzMhbchGqsLPQKhq28CUrriSyDGMdFJB7Qz21qAMMxuPbxug5sJPhPKceXcoaR
         JJUVqQXTs5PdQ+i5H4TrTFpWfqtwIMNKc9GFmM3qdm+FdLS+d4AnT+zuZT1F61wyx+j0
         WHR31XpUKVdUTG5PdPs0lsVZm0oykFjZvXr/NuT1eniwuNVVPkz85R3lD8g5IYFzuYYn
         Ob0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hYSd/3njTuRQYW+MbQwSCa/QBWDUOU5HAkx5FhnJaxQ=;
        b=hx1/OR3njjJNjnTotqwLHN/g6lVEWyXHWjg3P12WZ7twp7aUw8FATdIALpAUIshsOS
         UOAJPvC5RykRmpmN7hlKpQLajq5FJx4aqv61cZsNmPvIVJDtXNV0KhfE5zCpjB/rj08U
         9YUx46Ev9tL8Yra1VXcGwrds+v33UKEXEsA1rHD0IqS9pH4CIAIUyfPyIg15RArl4c7X
         mBDc9KPnijiHnhIEaSALV0Uq0ntMAknmK4HdUOOp7+7Iz5jrca3jE8t044yEXvsZiKz3
         YuIhLPfwiTZ8WXTSHOkDZsQfZ+DZXfMih4o9rqXTkQXTZnd1Uz7hjJBqEKg25ldhSv4l
         88/g==
X-Gm-Message-State: APjAAAWLGbG0jrvwyFyxm+GUoXWFS6BFI0dfdRTtKafHmHn7tYs02In6
        dDjW0CbiGkiJlXKdWlXbgOt0l3LW
X-Google-Smtp-Source: APXvYqySnnEKyJwbTzo0v50ES/1OR5Mrp2AyU38W23B8j9lg6q78wc1WUJZ4o4jz43cdC6i2YAyHRQ==
X-Received: by 2002:adf:e387:: with SMTP id e7mr13795359wrm.180.1572986937915;
        Tue, 05 Nov 2019 12:48:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f17:6e00:e905:33d7:3b10:e04b? (p200300EA8F176E00E90533D73B10E04B.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:e905:33d7:3b10:e04b])
        by smtp.googlemail.com with ESMTPSA id a8sm549480wme.11.2019.11.05.12.48.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 12:48:57 -0800 (PST)
Subject: Re: [PATCH 2/2] net: phy: dp83869: Add TI dp83869 phy
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191105181826.25114-1-dmurphy@ti.com>
 <20191105181826.25114-2-dmurphy@ti.com>
 <68b9c003-4fb3-b854-695a-fa1c6e08f518@gmail.com>
 <4ffebfad-87d2-0e19-5b54-7e550c540d03@ti.com>
 <1f64ae30-bbf3-525a-4fab-556924b18122@gmail.com>
 <3c4696b4-32ac-8529-ef97-1a2ae6bbfa32@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <b0727f9f-2837-51bb-a8b7-d11bdc9af110@gmail.com>
Date:   Tue, 5 Nov 2019 21:48:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3c4696b4-32ac-8529-ef97-1a2ae6bbfa32@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2019 21:26, Dan Murphy wrote:
> Heiner
> 
> On 11/5/19 2:20 PM, Heiner Kallweit wrote:
>> On 05.11.2019 21:02, Dan Murphy wrote:
>>> Heiner
>>>
>>> On 11/5/19 1:55 PM, Heiner Kallweit wrote:
>>>> On 05.11.2019 19:18, Dan Murphy wrote:
>>>>> Add support for the TI DP83869 Gigabit ethernet phy
>>>>> device.
>>>>>
>>>>> The DP83869 is a robust, low power, fully featured
>>>>> Physical Layer transceiver with integrated PMD
>>>>> sublayers to support 10BASE-T, 100BASE-TX and
>>>>> 1000BASE-T Ethernet protocols.
>>>>>
>>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>>> ---
>>>>>    drivers/net/phy/Kconfig              |   6 +
>>>>>    drivers/net/phy/Makefile             |   1 +
>>>>>    drivers/net/phy/dp83869.c            | 439 +++++++++++++++++++++++++++
>>>>>    include/dt-bindings/net/ti-dp83869.h |  43 +++
>>>>>    4 files changed, 489 insertions(+)
>>>>>    create mode 100644 drivers/net/phy/dp83869.c
>>>>>    create mode 100644 include/dt-bindings/net/ti-dp83869.h
>> [...]
>>
>>>>> +static int op_mode;
>>>>> +
>>>>> +module_param(op_mode, int, 0644);
>>>>> +MODULE_PARM_DESC(op_mode, "The operational mode of the PHY");
>>>>> +
>>>> A module parameter isn't the preferred option here.
>>>> You could have more than one such PHY in different configurations.
>>>> Other drivers like the Marvell one use the interface mode to
>>>> check for the desired mode. Or you could read it from DT.
>>>>
>>> We do read the initial mode from the DT but there was a request to be able to change the mode during runtime.
>> Maybe we need to understand the use case better to be able to advise.
>> Will this be needed in production? Or was it requested as debug feature?
>> There's the option to set PHY registers from userspace, e.g. with phytool.
>> This could be used for reconfiguring the PHY.
> 
> This was a customer request that they be able to modify the op_mode from user space.
> 
> This was all I was given for a requirement.  The customers use case was proprietary.
> 
If the module parameter serves just a (unknown) proprietary use case,
then it should not be in mainline. You could provide a patch with this
parameter separately to the client.

> Dan
> 
> 
>> Heiner
>>
>>
>>
>> [...]
> 

