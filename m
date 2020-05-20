Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0261DB831
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgETPa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:30:29 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52476 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETPa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:30:28 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KFUKTx029995;
        Wed, 20 May 2020 10:30:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589988620;
        bh=XzCtvPyJvSlocA8zsIHdT06ejX0cTIGWDBJYfgcXTsg=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=XyIybHPdd6zGT20ydVQ5/PMdgfM3EGmkcNaNp8CHat6avwLu5Hs2GFE+Ap2o8RKu0
         Nafj6GJSmBdUlyzStlf0WuC8/EIDGG6lQDrGA1ZUbO2MOjpq0DPAq6XRrr3nxT46X0
         4tG+pFWSwplVI/Arx1DaBQ3WGVZcLZv9XO+KFh/g=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KFUK1a115828
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 10:30:20 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 10:30:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 10:30:20 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KFUJqo082033;
        Wed, 20 May 2020 10:30:19 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
From:   Dan Murphy <dmurphy@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
Message-ID: <aa31d316-c948-b6c0-9ef4-350566bb019c@ti.com>
Date:   Wed, 20 May 2020 10:30:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/20/20 10:28 AM, Dan Murphy wrote:
> Andrew
>
> On 5/20/20 8:56 AM, Andrew Lunn wrote:
>> On Wed, May 20, 2020 at 07:18:34AM -0500, Dan Murphy wrote:
>>> Add the internal delay values into the header and update the binding
>>> with the internal delay properties.
>>>
>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> ---
>>>   .../devicetree/bindings/net/ti,dp83869.yaml    | 16 ++++++++++++++++
>>>   include/dt-bindings/net/ti-dp83869.h           | 18 
>>> ++++++++++++++++++
>>>   2 files changed, 34 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml 
>>> b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>>> index 5b69ef03bbf7..344015ab9081 100644
>>> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>>> @@ -64,6 +64,20 @@ properties:
>>>          Operational mode for the PHY.  If this is not set then the 
>>> operational
>>>          mode is set by the straps. see dt-bindings/net/ti-dp83869.h 
>>> for values
>>>   +  ti,rx-internal-delay:
>>> +    $ref: /schemas/types.yaml#definitions/uint32
>>> +    description: |
>>> +      RGMII Receive Clock Delay - see dt-bindings/net/ti-dp83869.h
>>> +      for applicable values. Required only if interface type is
>>> +      PHY_INTERFACE_MODE_RGMII_ID or PHY_INTERFACE_MODE_RGMII_RXID.
>> Hi Dan
>>
>> Having it required with PHY_INTERFACE_MODE_RGMII_ID or
>> PHY_INTERFACE_MODE_RGMII_RXID is pretty unusual. Normally these
>> properties are used to fine tune the delay, if the default of 2ns does
>> not work.
>
> Also if the MAC phy-mode is configured with RGMII-ID and no internal 
> delay values defined wouldn't that be counter intuitive?
>
> The driver will error out if the RGMII-ID is used and there was no 
> internal delay defined for either rx or tx making either one required.
>
> The MAC node needs to indicate to use the internal delay for RGMII 
> other wise the driver should ignore the internal delay programming as 
> these internal delays are not applicable to SGMII or MII modes.  The 
> RGMII mode can be used if the default 2ns delay is acceptable.
>
> Thus why we are documenting in the binding when the internal delay is 
> required as putting these under "required" is not correct.
>
> Dan
>
This is also the same for the DP83867 PHY as that PHY and the 83869 have 
a few identical features like internal delay, WoL and downshifting.

Dan


>>
>>      Andrew
