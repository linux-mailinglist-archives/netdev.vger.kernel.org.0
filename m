Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C4E1457B9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 15:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAVOYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 09:24:46 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:48308 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgAVOYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 09:24:46 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00MEOP0r055902;
        Wed, 22 Jan 2020 08:24:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579703065;
        bh=Nyeylm0gjyF8o7Phqcn3fOc+DFddhIjGH+F7kSw4Lxg=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=jTtwl3ElWLdUdI1gTZc++aUq5A9xlOe5EM4OjtymNBKOa3QO7666qZx5evq/fIx2k
         58i4Geij6YHdXaYYBXpJVykvDwniOqsKy0ZsDUS62emfFuZ+9eci0/G2t7B4Ou9Qlo
         AXShmCpKqH/cNTyxaSvQy4DqzcSjFsmiXxyy/3Yw=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00MEOPV9065269
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Jan 2020 08:24:25 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 22
 Jan 2020 08:24:25 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 22 Jan 2020 08:24:25 -0600
Received: from [172.24.145.246] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00MEOIIo016493;
        Wed, 22 Jan 2020 08:24:19 -0600
Subject: Re: [PATCH 1/3] dt-bindings: net: can: m_can: Add Documentation for
 stb-gpios
To:     Dan Murphy <dmurphy@ti.com>, Faiz Abbas <faiz_abbas@ti.com>,
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
From:   Sekhar Nori <nsekhar@ti.com>
Message-ID: <8fc7c343-267d-c91c-0381-60990cfc35e8@ti.com>
Date:   Wed, 22 Jan 2020 19:54:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <c3b0eeb8-bd78-aa96-4783-62dc93f03bfe@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/01/20 7:05 PM, Dan Murphy wrote:
> Faiz
> 
> On 1/22/20 2:03 AM, Faiz Abbas wrote:
>> The CAN transceiver on some boards has an STB pin which is
>> used to control its standby mode. Add an optional property
>> stb-gpios to toggle the same.
>>
>> Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
>> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
>> ---
>>   Documentation/devicetree/bindings/net/can/m_can.txt | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/can/m_can.txt
>> b/Documentation/devicetree/bindings/net/can/m_can.txt
>> index ed614383af9c..cc8ba3f7a2aa 100644
>> --- a/Documentation/devicetree/bindings/net/can/m_can.txt
>> +++ b/Documentation/devicetree/bindings/net/can/m_can.txt
>> @@ -48,6 +48,8 @@ Optional Subnode:
>>                 that can be used for CAN/CAN-FD modes. See
>>                
>> Documentation/devicetree/bindings/net/can/can-transceiver.txt
>>                 for details.
>> +stb-gpios        : gpio node to toggle the STB (standby) signal on
>> the transceiver
>> +
> 
> The m_can.txt is for the m_can framework.  If this is specific to the
> platform then it really does not belong here.
> 
> If the platform has specific nodes then maybe we need a
> m_can_platform.txt binding for specific platform nodes.  But I leave
> that decision to Rob.

Since this is transceiver enable, should this not be in
Documentation/devicetree/bindings/net/can/can-transceiver.txt?

Thanks,
Sekhar
