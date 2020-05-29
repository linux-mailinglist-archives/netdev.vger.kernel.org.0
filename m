Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0FB1E87B2
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgE2TZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:25:02 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57916 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbgE2TZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:25:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04TJOrLQ115731;
        Fri, 29 May 2020 14:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590780293;
        bh=e18OPFFxMK0w4LxsBnOJXJYjvGft3xX9i3/iKCwz9oQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=jnpfiDkkW9fLsC3es7GNc3rYpdCBqLo7Ep5VmrI0Ve2uCXFREa3Y43L/w1r0zhWPk
         OvpP6bts38CfpFLAsZYp5d/DAhutF2HjjZsTTnpVHMorooJ4WEyjX1VIusq+DvphGN
         AoDZCmBiH4AJrk2ZFoaCD3Y+5hIq5inKujYqMPJI=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04TJOrTr103207
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 14:24:53 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 29
 May 2020 14:24:53 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 29 May 2020 14:24:53 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04TJOqLf031009;
        Fri, 29 May 2020 14:24:52 -0500
Subject: Re: [PATCH net-next v4 1/4] dt-bindings: net: Add tx and rx internal
 delays
To:     Rob Herring <robh@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200527164934.28651-1-dmurphy@ti.com>
 <20200527164934.28651-2-dmurphy@ti.com> <20200529182544.GA2691697@bogus>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <b8a0b1e8-c7fb-d38b-5c43-c6c4116a3349@ti.com>
Date:   Fri, 29 May 2020 14:24:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200529182544.GA2691697@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob

On 5/29/20 1:25 PM, Rob Herring wrote:
> On Wed, May 27, 2020 at 11:49:31AM -0500, Dan Murphy wrote:
>> tx-internal-delays and rx-internal-delays are a common setting for RGMII
>> capable devices.
>>
>> These properties are used when the phy-mode or phy-controller is set to
>> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
>> controller that the PHY will add the internal delay for the connection.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> index ac471b60ed6a..70702a4ef5e8 100644
>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>> @@ -143,6 +143,20 @@ properties:
>>         Specifies the PHY management type. If auto is set and fixed-link
>>         is not specified, it uses MDIO for management.
>>   
>> +  rx-internal-delay-ps:
>> +    $ref: /schemas/types.yaml#definitions/uint32
>> +    description: |
>> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
>> +      PHY's that have configurable RX internal delays.  This property is only
>> +      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-rxid.
> Isn't this a property of the phy (this is the controller schema)? Looks
> like we have similar properties already and they go in phy nodes. Would
> be good to have a standard property, but let's be clear where it goes.
>
> We need to add '-ps' as a standard unit suffix (in dt-schema) and then a
> type is not needed here.

This is a PHY specific property.

I will move them.

Dumb question but you can just point me to the manual about how and 
where to add the '-ps' to the dt-schema

Dan


> Rob
