Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244BB2B7039
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgKQUgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:36:50 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55294 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726805AbgKQUgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:36:49 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKaihr072887;
        Tue, 17 Nov 2020 14:36:44 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605645404;
        bh=7g8+febBysogqn0CrrzambHHvshikLPusWzANaG4ARM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=WzvjfoShrXMk2Oaw229UmzxJt/tpCFx90MecnbO11SqjKHmyE0Qbw2Nq7VTS1YkMO
         vZ8Zp74GzEvy1fjyG94uj7+GFN1h0gc/GhhsWGDBKnkUKiAzxFqkoDRf9BaXJqCH5E
         2mQNOExw1W4B6ACKTeGe6pENbOmXikxsoLakBHlk=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHKaiFg048577
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 14:36:44 -0600
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 14:36:43 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 14:36:43 -0600
Received: from [10.250.40.192] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHKahRp018100;
        Tue, 17 Nov 2020 14:36:43 -0600
Subject: Re: [PATCH net-next v4 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <ciorneiioana@gmail.com>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-3-dmurphy@ti.com> <20201117203150.GA1800835@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <553087de-e6e4-23b9-e8c0-d77b430703f3@ti.com>
Date:   Tue, 17 Nov 2020 14:36:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201117203150.GA1800835@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 11/17/20 2:31 PM, Andrew Lunn wrote:
> On Tue, Nov 17, 2020 at 02:15:53PM -0600, Dan Murphy wrote:
>> Per the 802.3cg spec the 10base T1L can operate at 2 different
>> differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
> ability
Ack
>
>> drive that output is dependent on the PHY's on board power supply.
>> This common feature is applicable to all 10base T1L PHYs so this binding
>> property belongs in a top level ethernet document.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> index 6dd72faebd89..bda1ce51836b 100644
>> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> @@ -174,6 +174,12 @@ properties:
>>         PHY's that have configurable TX internal delays. If this property is
>>         present then the PHY applies the TX delay.
>>   
>> +  max-tx-rx-p2p-microvolt:
>> +    description: |
>> +      Configures the Tx/Rx p2p differential output voltage for 10base-T1L PHYs.
> Does it configure, or does it limit? I _think_ this is a negotiation
> parameter, so the PHY might decide to do 1100mV if the link peer is
> near by even when max-tx-rx-p2p-microvolt has the higher value.

For this device we can configure or force it to only work at 1.1v p2p 
otherwise 2.4 is the default.

But each LP's have to be configured for the same voltage. unless auto 
negotiation is on then it negotiates the voltage.

Dan

>
>       Andrew
