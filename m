Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA90C3DD207
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhHBIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 04:31:58 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:44940 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhHBIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 04:31:57 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1728VXJE010222;
        Mon, 2 Aug 2021 03:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1627893093;
        bh=pSAZGmb9+ZZIRIq5mLynkHawfEAYvLAK0jyf9EHdzDA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=bnwTqOM4baLr/jbQA2G3WkNOsl589ZmsX3fYPkA3r6dXSkAgdyq5p948ExrWHk+Wa
         kgY4d3KGh4uqTWUE8FVGEnMgih58mZRGWZcWVC3LWY0OOq8cAGFFP7+yRRZkqmEXnR
         KBa2Win/U3byICEerGMHJvJtEAXeV72p1cDY85bI=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1728VXb7024136
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 2 Aug 2021 03:31:33 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 2 Aug
 2021 03:31:33 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 2 Aug 2021 03:31:33 -0500
Received: from [10.250.232.46] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1728VR7D078697;
        Mon, 2 Aug 2021 03:31:28 -0500
Subject: Re: [PATCH] dt-bindings: net: can: Document power-domains property
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sriram Dash <sriram.dash@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210731045138.29912-1-a-govindraju@ti.com>
 <20210802071047.n6mxecdohahhzifr@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <a38447f6-c7c6-751f-b8ff-ae2b1077cccc@ti.com>
Date:   Mon, 2 Aug 2021 14:01:26 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802071047.n6mxecdohahhzifr@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 02/08/21 12:40 pm, Marc Kleine-Budde wrote:
> On 31.07.2021 10:21:38, Aswath Govindraju wrote:
>> Document power-domains property for adding the Power domain provider.
>>
>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>> ---
>>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> index a7b5807c5543..d633fe1da870 100644
>> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
>> @@ -104,6 +104,13 @@ properties:
>>            maximum: 32
>>      maxItems: 1
>>  
>> +  power-domains:
>> +    description:
>> +      Power domain provider node and an args specifier containing
>> +      the can device id value. Please see,
>> +      Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
> 
> Why are you referring to a TI specific file in a generic binding?
> 

I was trying to refer to an example. If it shouldn't be referred then I
will remove it an post a post a respin.

Thanks,
Aswath

> Marc
> 

