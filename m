Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7961457F9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 15:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAVOho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 09:37:44 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49630 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgAVOho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 09:37:44 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00MEbSg1059865;
        Wed, 22 Jan 2020 08:37:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579703848;
        bh=ExCKsULHAY09wbOO5eobOUvQLsBWiXPX0ybK/2ZK/to=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=sVFv0qguYaSgtrDDtyh7c9sU7oqMHY6VpoQRS9BBgR9GtXBXuL/XeHnit+SO3Ycg+
         afvW7NgWnlgEmwyh4przgqq7u86VzyKhRq3HC/Y6nEdHyDzw8ejhWTIcOLqDr0k/uJ
         gxq1gqFfsF9vyxFKx1LUotUt/t26JBT3BlteIDXg=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00MEbSLs087066
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 08:37:28 -0600
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 08:37:28 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 08:37:28 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00MEbRQ4083641;
        Wed, 22 Jan 2020 08:37:27 -0600
Subject: Re: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for
 stb-gpios
To:     Sekhar Nori <nsekhar@ti.com>, Faiz Abbas <faiz_abbas@ti.com>,
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
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f834087b-da1c-88a0-93fe-bc72c8ac71ff@ti.com>
Date:   Wed, 22 Jan 2020 08:34:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8fc7c343-267d-c91c-0381-60990cfc35e8@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sekhar

On 1/22/20 8:24 AM, Sekhar Nori wrote:
> On 22/01/20 7:05 PM, Dan Murphy wrote:
>> Faiz
>>
>> On 1/22/20 2:03 AM, Faiz Abbas wrote:
>>> The CAN transceiver on some boards has an STB pin which is
>>> used to control its standby mode. Add an optional property
>>> stb-gpios to toggle the same.
>>>
>>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>>> ---
>>>    Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt
>>> b/Documentation/devicetree/bindings/net/can/m_can.txt
>>> index ed614383af9c..cc8ba3f7a2aa 100644
>>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>>> @@ -48,6 +48,8 @@ Optional Subnode:
>>>                  that can be used for CAN/CAN-FD modes. See
>>>                 
>>> Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>>                  for details.
>>> +stb-gpios        : gpio node to toggle the STB (standby) signal on
>>> the transceiver
>>> +
>> The m_can.txt is for the m_can framework.  If this is specific to the
>> platform then it really does not belong here.
>>
>> If the platform has specific nodes then maybe we need a
>> m_can_platform.txt binding for specific platform nodes.  But I leave
>> that decision to Rob.
> Since this is transceiver enable, should this not be in
> Documentation/devicetree/bindings/net/can/can-transceiver.txt?

+1

Dan

