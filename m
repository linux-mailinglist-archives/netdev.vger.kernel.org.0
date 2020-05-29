Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A71E87A4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgE2TVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:21:04 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:38782 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgE2TVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:21:03 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04TJKqFb005913;
        Fri, 29 May 2020 14:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590780052;
        bh=b75WU4NLq7IvAuVuX+BGqp8jzFKIDOQ2RHAKq2oynGM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=o1xEJi5M+26Ei+rEYqwrnO9KWOjia3DvNdFZvrvV8kW11tk/LbGg6XbirtzdQh7SZ
         uW3FqUfgCa8C8ZaNGFZUgwm/owp9yNlWxdeagAsTHMkLjJQ8pBBgFTMvB+c/6a2qB1
         FInVZkH3ydXOIAqaFyJvJ8dETH7H2STxi9UN6UM4=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04TJKqsv086452;
        Fri, 29 May 2020 14:20:52 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 29
 May 2020 14:20:52 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 29 May 2020 14:20:52 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04TJKp7m028747;
        Fri, 29 May 2020 14:20:51 -0500
Subject: Re: [PATCH net-next v4 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Rob Herring <robh@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200527164934.28651-1-dmurphy@ti.com>
 <20200527164934.28651-4-dmurphy@ti.com> <20200529190356.GA2758033@bogus>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <62ee3f8b-2b44-5836-a365-7367d6ce3cd4@ti.com>
Date:   Fri, 29 May 2020 14:20:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200529190356.GA2758033@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rob

On 5/29/20 2:03 PM, Rob Herring wrote:
> On Wed, May 27, 2020 at 11:49:33AM -0500, Dan Murphy wrote:
>> Add the internal delay values into the header and update the binding
>> with the internal delay properties.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../devicetree/bindings/net/ti,dp83869.yaml      | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,dp83869.yaml b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>> index 5b69ef03bbf7..2971dd3fc039 100644
>> --- a/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,dp83869.yaml
>> @@ -64,6 +64,20 @@ properties:
>>          Operational mode for the PHY.  If this is not set then the operational
>>          mode is set by the straps. see dt-bindings/net/ti-dp83869.h for values
>>   
>> +  rx-internal-delay-ps:
>> +    $ref: "#/properties/rx-internal-delay-ps"
> This just creates a circular reference which probably blows up.

dt_binding_check did not have an issue with this.

But I will remove it

Dan

