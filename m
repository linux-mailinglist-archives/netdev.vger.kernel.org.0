Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346B31613F9
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgBQNwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:52:34 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60064 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbgBQNwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:52:34 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01HDqCYC046134;
        Mon, 17 Feb 2020 07:52:12 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581947532;
        bh=+byLAupfUW+GTMI0YH08CXSZf3dS/A6iBoU8mYL7Bjs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=HURDfCsN2H10t7joYw6Uc17TbFSzb3Bapj1w2k5EsFytBbtFsNE9Ny8ytRK5p2oF+
         nktDfWEC01tDiWJfk602k506HngSFs22HRsrfGjm16bvB3ZbUYwepME7vLxUSYHmzQ
         16vYOXQYxGv0LZT4rKidGd0bxJb6KgY4O1fDvNi8=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01HDqCNK060998
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 17 Feb 2020 07:52:12 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 17
 Feb 2020 07:52:11 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 17 Feb 2020 07:52:11 -0600
Received: from [172.24.190.4] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01HDq6xY041711;
        Mon, 17 Feb 2020 07:52:07 -0600
Subject: Re: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for
 stb-gpios
To:     Rob Herring <robh@kernel.org>
CC:     Dan Murphy <dmurphy@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <davem@davemloft.net>, <mkl@pengutronix.de>, <wg@grandegger.com>,
        <sriram.dash@samsung.com>, <nm@ti.com>, <t-kristo@ti.com>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
 <20200122080310.24653-2-faiz_abbas@ti.com>
 <c3b0eeb8-bd78-aa96-4783-62dc93f03bfe@ti.com>
 <8fc7c343-267d-c91c-0381-60990cfc35e8@ti.com>
 <f834087b-da1c-88a0-93fe-bc72c8ac71ff@ti.com>
 <57baeedc-9f51-7b92-f190-c0bbd8525a16@ti.com> <20200203120610.GA9303@bogus>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <15ae4d0e-10cf-7b4b-6487-8b64f885f184@ti.com>
Date:   Mon, 17 Feb 2020 19:23:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203120610.GA9303@bogus>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob,

On 03/02/20 5:36 pm, Rob Herring wrote:
> On Thu, Jan 23, 2020 at 01:09:41PM +0530, Faiz Abbas wrote:
>> Hi,
>>
>> On 22/01/20 8:04 pm, Dan Murphy wrote:
>>> Sekhar
>>>
>>> On 1/22/20 8:24 AM, Sekhar Nori wrote:
>>>> On 22/01/20 7:05 PM, Dan Murphy wrote:
>>>>> Faiz
>>>>>
>>>>> On 1/22/20 2:03 AM, Faiz Abbas wrote:
>>>>>> The CAN transceiver on some boards has an STB pin which is
>>>>>> used to control its standby mode. Add an optional property
>>>>>> stb-gpios to toggle the same.
>>>>>>
>>>>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>>>>>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>>>>>> ---
>>>>>>    Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
>>>>>>    1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>>> b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>>> index ed614383af9c..cc8ba3f7a2aa 100644
>>>>>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>>>> @@ -48,6 +48,8 @@ Optional Subnode:
>>>>>>                  that can be used for CAN/CAN-FD modes. See
>>>>>>                
>>>>>> Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>>>>>                  for details.
>>>>>> +stb-gpios        : gpio node to toggle the STB (standby) signal on
>>>>>> the transceiver
>>>>>> +
>>>>> The m_can.txt is for the m_can framework.  If this is specific to the
>>>>> platform then it really does not belong here.
>>>>>
>>>>> If the platform has specific nodes then maybe we need a
>>>>> m_can_platform.txt binding for specific platform nodes.  But I leave
>>>>> that decision to Rob.
>>>> Since this is transceiver enable, should this not be in
>>>> Documentation/devicetree/bindings/net/can/can-transceiver.txt?
>>>
>>
>> The transceiver node is just a node without an associated device. I had
>> tried to convert it to a phy implementation but that idea got shot down
>> here:
>>
>> https://lore.kernel.org/patchwork/patch/1006238/
> 
> Nodes and drivers are not a 1-1 thing. Is the transceiver a separate h/w 
> device? If so, then it should be a separate node and properties of that 
> device go in its node. 

The transceiver is indeed a separate device.

Also, nothing is stopping you from using the PHY
> binding without using the kernel's PHY framework.

The phy framework seemed like the best code reuse to implement it.

> 
> As to whether it should be a separate phy driver, I think probably the 
> wrong decision was made. We always seem to start out with no PHY on 
> these things and the complexity just grows until we need one. 
> 

We should be able to handle two properties (one max-datarate and the
other regulator node) for now. If we have to add more complex parts then
maybe we can think about the driver. I am just adding a xceiver
regulator for now.

Thanks,
Faiz
