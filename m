Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8164E1FF36E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgFRNoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:44:23 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:51642 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbgFRNoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 09:44:18 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05IDiDs2103690;
        Thu, 18 Jun 2020 08:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592487853;
        bh=jrhWybePBkLjKFFokXcERsTDgrYSw3CTsM7TNQNBCNM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=A2FxWZ/gV0Nix5vu1sBykSBIFsjc68WFsGdSy75rH/s33GaTqRlKsVrAj334UxncZ
         goMEGiZAWPGI+NxwoSvucy8SuRftdeAnXF+oOdrNsSrzo1y7bZijjD3ktdC7KZ1+Zj
         ZbPvM8p4IewZDcaTm9CH0ll3BOFEJpiLhkd6slRU=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05IDiDuf015024
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 18 Jun 2020 08:44:13 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 18
 Jun 2020 08:44:12 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 18 Jun 2020 08:44:12 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05IDiCem029547;
        Thu, 18 Jun 2020 08:44:12 -0500
Subject: Re: [PATCH net-next v7 1/6] dt-bindings: net: Add tx and rx internal
 delays
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-2-dmurphy@ti.com> <20200618020101.GJ249144@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <71943ef1-3e64-47a9-2027-ad801795bdf5@ti.com>
Date:   Thu, 18 Jun 2020 08:44:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200618020101.GJ249144@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 6/17/20 9:01 PM, Andrew Lunn wrote:
> On Wed, Jun 17, 2020 at 01:20:14PM -0500, Dan Murphy wrote:
>> tx-internal-delays and rx-internal-delays are a common setting for RGMII
>> capable devices.
>>
>> These properties are used when the phy-mode or phy-controller is set to
>> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
>> controller that the PHY will add the internal delay for the connection.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../devicetree/bindings/net/ethernet-phy.yaml         | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> index 9b1f1147ca36..b2887476fe6a 100644
>> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
>> @@ -162,6 +162,17 @@ properties:
>>       description:
>>         Specifies a reference to a node representing a SFP cage.
>>   
>> +
>> +  rx-internal-delay-ps:
>> +    description: |
>> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
>> +      PHY's that have configurable RX internal delays.
>> +
>> +  tx-internal-delay-ps:
>> +    description: |
>> +      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
>> +      PHY's that have configurable TX internal delays.
>> +
> So in a later patch you have:
>
> default: 2000
>
> That seems to apply that these values only apply when the phy mode
> indicates a delay is needed. It would be good to document that here,
> when each of these properties will be used. Also, that they default to
> 2000 when not present.

The default of 2000ps is for the DP83869 only.  The DP83822 fixed delay 
is 3500ps.

So indicating that the default here is 2000ps for all devices is not 
correct.

But I can add a note that if these properties are present then the delay 
is added by the PHY.

Dan


>       Andrew
