Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797B21462BA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgAWHif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:38:35 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:54658 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbgAWHif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 02:38:35 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00N7cG5V040330;
        Thu, 23 Jan 2020 01:38:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579765096;
        bh=+3fXqcctM4dNh7tgCXPjwPubIvB6hs8YxTRU7AzutRk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=mbeg9XgepZonrW1hQIw7gajr0qSxQQboBeue0IYJbJMm1keAa72SugKcqLG9zVXS0
         +/wucmukAmdUWSXS1TUMevXdKQy89omXtpS4/MIuyVbaBfFn8sn/syzbcnurcxLyek
         TeWKXuxjudNzQyqYiE0Xyc66WPOYqNlKZBeYzwww=
Received: from DFLE100.ent.ti.com (dfle100.ent.ti.com [10.64.6.21])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00N7cGqC059359
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Jan 2020 01:38:16 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 23
 Jan 2020 01:38:16 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 23 Jan 2020 01:38:15 -0600
Received: from [172.24.190.4] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00N7cAwc040274;
        Thu, 23 Jan 2020 01:38:11 -0600
Subject: Re: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for
 stb-gpios
To:     Dan Murphy <dmurphy@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
CC:     <catalin.marinas@arm.com>, <mark.rutland@arm.com>,
        <robh+dt@kernel.org>, <davem@davemloft.net>, <mkl@pengutronix.de>,
        <wg@grandegger.com>, <sriram.dash@samsung.com>, <nm@ti.com>,
        <t-kristo@ti.com>
References: <20200122080310.24653-1-faiz_abbas@ti.com>
 <20200122080310.24653-2-faiz_abbas@ti.com>
 <c3b0eeb8-bd78-aa96-4783-62dc93f03bfe@ti.com>
 <8fc7c343-267d-c91c-0381-60990cfc35e8@ti.com>
 <f834087b-da1c-88a0-93fe-bc72c8ac71ff@ti.com>
From:   Faiz Abbas <faiz_abbas@ti.com>
Message-ID: <57baeedc-9f51-7b92-f190-c0bbd8525a16@ti.com>
Date:   Thu, 23 Jan 2020 13:09:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f834087b-da1c-88a0-93fe-bc72c8ac71ff@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 22/01/20 8:04 pm, Dan Murphy wrote:
> Sekhar
> 
> On 1/22/20 8:24 AM, Sekhar Nori wrote:
>> On 22/01/20 7:05 PM, Dan Murphy wrote:
>>> Faiz
>>>
>>> On 1/22/20 2:03 AM, Faiz Abbas wrote:
>>>> The CAN transceiver on some boards has an STB pin which is
>>>> used to control its standby mode. Add an optional property
>>>> stb-gpios to toggle the same.
>>>>
>>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>>>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>>>> ---
>>>>    Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt
>>>> b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>> index ed614383af9c..cc8ba3f7a2aa 100644
>>>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>>>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>>>> @@ -48,6 +48,8 @@ Optional Subnode:
>>>>                  that can be used for CAN/CAN-FD modes. See
>>>>                
>>>> Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>>>                  for details.
>>>> +stb-gpios        : gpio node to toggle the STB (standby) signal on
>>>> the transceiver
>>>> +
>>> The m_can.txt is for the m_can framework.  If this is specific to the
>>> platform then it really does not belong here.
>>>
>>> If the platform has specific nodes then maybe we need a
>>> m_can_platform.txt binding for specific platform nodes.  But I leave
>>> that decision to Rob.
>> Since this is transceiver enable, should this not be in
>> Documentation/devicetree/bindings/net/can/can-transceiver.txt?
> 

The transceiver node is just a node without an associated device. I had
tried to convert it to a phy implementation but that idea got shot down
here:

https://lore.kernel.org/patchwork/patch/1006238/

Thanks,
Faiz
