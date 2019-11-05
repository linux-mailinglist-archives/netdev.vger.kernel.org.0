Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7234CF06DB
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbfKEU1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:27:09 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38624 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEU1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 15:27:08 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA5KR3PS044132;
        Tue, 5 Nov 2019 14:27:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572985623;
        bh=rH++WuDv1lCZdrYpSV5zZgXdIrmKRKCOWMSQ05fJaa0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mfb7v3irh0V2NdkRfzSTMotUrRzDnyf1PFuqYYcfWwhKBWlv3azHECg345t3tjeSw
         K+83V5aP8HldxiAqv66x7CWLD79S2DSgQ8JtMIr3a9vxRO+PBxNJV9TnUR03rT5WCH
         u451rFB9MZOvSCpQiDT11pC5zt3tiOadEq4/OQxs=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA5KR3sY128666;
        Tue, 5 Nov 2019 14:27:03 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 5 Nov
 2019 14:26:47 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 5 Nov 2019 14:26:47 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA5KR1xJ066971;
        Tue, 5 Nov 2019 14:27:02 -0600
Subject: Re: [PATCH 2/2] net: phy: dp83869: Add TI dp83869 phy
To:     Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191105181826.25114-1-dmurphy@ti.com>
 <20191105181826.25114-2-dmurphy@ti.com>
 <68b9c003-4fb3-b854-695a-fa1c6e08f518@gmail.com>
 <4ffebfad-87d2-0e19-5b54-7e550c540d03@ti.com>
 <1f64ae30-bbf3-525a-4fab-556924b18122@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <3c4696b4-32ac-8529-ef97-1a2ae6bbfa32@ti.com>
Date:   Tue, 5 Nov 2019 14:26:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1f64ae30-bbf3-525a-4fab-556924b18122@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner

On 11/5/19 2:20 PM, Heiner Kallweit wrote:
> On 05.11.2019 21:02, Dan Murphy wrote:
>> Heiner
>>
>> On 11/5/19 1:55 PM, Heiner Kallweit wrote:
>>> On 05.11.2019 19:18, Dan Murphy wrote:
>>>> Add support for the TI DP83869 Gigabit ethernet phy
>>>> device.
>>>>
>>>> The DP83869 is a robust, low power, fully featured
>>>> Physical Layer transceiver with integrated PMD
>>>> sublayers to support 10BASE-T, 100BASE-TX and
>>>> 1000BASE-T Ethernet protocols.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>>> ---
>>>>    drivers/net/phy/Kconfig              |   6 +
>>>>    drivers/net/phy/Makefile             |   1 +
>>>>    drivers/net/phy/dp83869.c            | 439 +++++++++++++++++++++++++++
>>>>    include/dt-bindings/net/ti-dp83869.h |  43 +++
>>>>    4 files changed, 489 insertions(+)
>>>>    create mode 100644 drivers/net/phy/dp83869.c
>>>>    create mode 100644 include/dt-bindings/net/ti-dp83869.h
> [...]
>
>>>> +static int op_mode;
>>>> +
>>>> +module_param(op_mode, int, 0644);
>>>> +MODULE_PARM_DESC(op_mode, "The operational mode of the PHY");
>>>> +
>>> A module parameter isn't the preferred option here.
>>> You could have more than one such PHY in different configurations.
>>> Other drivers like the Marvell one use the interface mode to
>>> check for the desired mode. Or you could read it from DT.
>>>
>> We do read the initial mode from the DT but there was a request to be able to change the mode during runtime.
> Maybe we need to understand the use case better to be able to advise.
> Will this be needed in production? Or was it requested as debug feature?
> There's the option to set PHY registers from userspace, e.g. with phytool.
> This could be used for reconfiguring the PHY.

This was a customer request that they be able to modify the op_mode from 
user space.

This was all I was given for a requirement.  The customers use case was 
proprietary.

Dan


> Heiner
>
>
>
> [...]
