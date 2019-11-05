Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DE2F06C7
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfKEUUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:20:39 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52020 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbfKEUUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 15:20:39 -0500
Received: by mail-wm1-f68.google.com with SMTP id q70so817851wme.1;
        Tue, 05 Nov 2019 12:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DJ/Rzer6W3I0Dr0ryA3Ftmba0w7zthSuSKlMtsEH54E=;
        b=MB9QGhKPy9nfaeBeKb3LecMRQJ6UHjvm90x370vDoluYyIO5QJb+Yc18SfvBCLEqgZ
         FeS/zznvJX09sMr5q3gXVqRmosboazpxQxnXHpLFwY09KOIV5R84gG1I/n9aV/wLonx5
         41e8+9myNG35zXsAc+jLinqOZg9PXxuf0RqB2B89EJA1pnf/UB7XiCUSklMl0tGUbdKd
         2Rx7T26IWr+baBhWJtddGrmWxlrQocy9Y7tLVYWF5lPJ8wmuVZsGZXFCyuepHLvuBgBo
         PSorKlsWl7nxZfsIu3w6r5GqmikPV8TIHCPpz0chz2GPibSLmEZgRbk1zU5NYlMMZx2z
         dKmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DJ/Rzer6W3I0Dr0ryA3Ftmba0w7zthSuSKlMtsEH54E=;
        b=RyBW6U8uEeaB/AiXVvZ/87haTC9m57VFJjTs6iZys6+eT4YLA/sa4x5PaQ4ctxC2ma
         2jSNwlNK48FkBMzDJHBxftb3hZOCbPRGCPpYsM73uZMII95HWY6fF8doiDgGMgmE0U45
         5MI2vh37Y+aE6ChcyjELVPFuvGqj5N8BhEp19+rU/CYqnK0fgyitrJS1kOM50JUmD+bA
         BxMNMjjvJhHh7DbL3xqOARp1G2ymjxPhwaTaxjrEquoCjQz0Auss8NP2NBaUNFg54uWz
         k0A6d5UU32RWRlIZ87zQbyMZ9R8+otvqTOktWhlxygcI1lfUDJ5+YQwFKhtbx7/bRhdT
         I71w==
X-Gm-Message-State: APjAAAW28BssX19UnF/CPFe+FuC3cu+hby0SosyIjBPa7MaHP/4JYVJ5
        Mflhie3YHc1/B5UNRh4qVTcVEH1X
X-Google-Smtp-Source: APXvYqzoOTj6ukyAvLKVtrPhUU0akXk/A43iub2Lt3iaWVQbynakEf8nEiW51FCbD1Zb0yVOCAMZAw==
X-Received: by 2002:a1c:67d7:: with SMTP id b206mr715005wmc.68.1572985236966;
        Tue, 05 Nov 2019 12:20:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f17:6e00:e905:33d7:3b10:e04b? (p200300EA8F176E00E90533D73B10E04B.dip0.t-ipconnect.de. [2003:ea:8f17:6e00:e905:33d7:3b10:e04b])
        by smtp.googlemail.com with ESMTPSA id g184sm724742wma.8.2019.11.05.12.20.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 12:20:36 -0800 (PST)
Subject: Re: [PATCH 2/2] net: phy: dp83869: Add TI dp83869 phy
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191105181826.25114-1-dmurphy@ti.com>
 <20191105181826.25114-2-dmurphy@ti.com>
 <68b9c003-4fb3-b854-695a-fa1c6e08f518@gmail.com>
 <4ffebfad-87d2-0e19-5b54-7e550c540d03@ti.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1f64ae30-bbf3-525a-4fab-556924b18122@gmail.com>
Date:   Tue, 5 Nov 2019 21:20:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ffebfad-87d2-0e19-5b54-7e550c540d03@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2019 21:02, Dan Murphy wrote:
> Heiner
> 
> On 11/5/19 1:55 PM, Heiner Kallweit wrote:
>> On 05.11.2019 19:18, Dan Murphy wrote:
>>> Add support for the TI DP83869 Gigabit ethernet phy
>>> device.
>>>
>>> The DP83869 is a robust, low power, fully featured
>>> Physical Layer transceiver with integrated PMD
>>> sublayers to support 10BASE-T, 100BASE-TX and
>>> 1000BASE-T Ethernet protocols.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>>>   drivers/net/phy/Kconfig              |   6 +
>>>   drivers/net/phy/Makefile             |   1 +
>>>   drivers/net/phy/dp83869.c            | 439 +++++++++++++++++++++++++++
>>>   include/dt-bindings/net/ti-dp83869.h |  43 +++
>>>   4 files changed, 489 insertions(+)
>>>   create mode 100644 drivers/net/phy/dp83869.c
>>>   create mode 100644 include/dt-bindings/net/ti-dp83869.h

[...]

>>> +static int op_mode;
>>> +
>>> +module_param(op_mode, int, 0644);
>>> +MODULE_PARM_DESC(op_mode, "The operational mode of the PHY");
>>> +
>> A module parameter isn't the preferred option here.
>> You could have more than one such PHY in different configurations.
>> Other drivers like the Marvell one use the interface mode to
>> check for the desired mode. Or you could read it from DT.
>>
> We do read the initial mode from the DT but there was a request to be able to change the mode during runtime.

Maybe we need to understand the use case better to be able to advise.
Will this be needed in production? Or was it requested as debug feature?
There's the option to set PHY registers from userspace, e.g. with phytool.
This could be used for reconfiguring the PHY.

Heiner



[...]
