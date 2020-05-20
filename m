Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7335C1DC0A2
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 22:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgETUzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 16:55:24 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35262 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgETUzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 16:55:24 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KKtFwp073115;
        Wed, 20 May 2020 15:55:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1590008115;
        bh=BmoSOnBCrUW4xWm9dGNe0tiNDhi185y+fKxf8IEICwc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=PdzXTFniGDCKX9FwR6EU3H0fF+l+s4SZgO1uM37Qy2jCiiKmGEWSrRCfuqP5sdQ25
         QVlwa/KnHuXNrGJHw2frEMzH2g+w22sJGTyOAGJr6UaYs0U1NHoOL1TVL2z+6TfQb8
         eQWW7hGuwLzXBwuPuSSX15KDhonnck5mUhXD4T5A=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KKtFte031224
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 15:55:15 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 15:55:15 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 15:55:15 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KKtENm084063;
        Wed, 20 May 2020 15:55:14 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
 <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
 <20200520164313.GI652285@lunn.ch>
 <d5d46c21-0afa-0c51-9baf-4f99de94bbd5@ti.com>
 <41101897-5b29-4a9d-0c14-9b8080089850@gmail.com>
 <7e117c01-fa6e-45f3-05b7-4efe7a3c1943@ti.com>
 <20200520192719.GK652285@lunn.ch>
 <0bba1378-0847-491f-8f21-ac939ac48820@ti.com>
 <20200520204423.GA677363@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <ecee51d5-a69e-4f7e-2a33-ae7aae63fec8@ti.com>
Date:   Wed, 20 May 2020 15:55:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520204423.GA677363@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/20/20 3:44 PM, Andrew Lunn wrote:
>> I think adding it in the core would be a bit of a challenge.  I think each
>> PHY driver needs to handle parsing and validating this property on its own
>> (like fifo-depth).  It is a PHY specific setting.
> fifo-depth yes. But some delays follow a common pattern.
>
> e.g.
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
>
> Device Tree Value     Delay   Pad Skew Register Value
>    -----------------------------------------------------
>          0               -840ps          0000
>          200             -720ps          0001
>          400             -600ps          0010
>          600             -480ps          0011
>          800             -360ps          0100
>          1000            -240ps          0101
>          1200            -120ps          0110
>          1400               0ps          0111
>          1600             120ps          1000
>          1800             240ps          1001
>          2000             360ps          1010
>          2200             480ps          1011
>          2400             600ps          1100
>          2600             720ps          1101
>          2800             840ps          1110
>          3000             960ps          1111
>
> Documentation/devicetree/bindings/net/adi,adin.yaml
>
>   adi,rx-internal-delay-ps:
>      description: |
>        RGMII RX Clock Delay used only when PHY operates in RGMII mode with
>        internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
>      enum: [ 1600, 1800, 2000, 2200, 2400 ]
>      default: 2000
>
>    adi,tx-internal-delay-ps:
>      description: |
>        RGMII TX Clock Delay used only when PHY operates in RGMII mode with
>        internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
>      enum: [ 1600, 1800, 2000, 2200, 2400 ]
>      default: 2000
>
> Documentation/devicetree/bindings/net/apm-xgene-enet.txt
>
> - tx-delay: Delay value for RGMII bridge TX clock.
>              Valid values are between 0 to 7, that maps to
>              417, 717, 1020, 1321, 1611, 1913, 2215, 2514 ps
>              Default value is 4, which corresponds to 1611 ps
> - rx-delay: Delay value for RGMII bridge RX clock.
>              Valid values are between 0 to 7, that maps to
>              273, 589, 899, 1222, 1480, 1806, 2147, 2464 ps
>              Default value is 2, which corresponds to 899 ps
>
> You could implement checking against a table of valid values, which is
> something you need for your PHY. You could even consider making it a
> 2D table, and return the register value, not the delay?

So provide a helper function that will just basically parse an array and 
return the indexed value.

The outlier here is the AD device since the index to value is not 1-1 
mapping.  Not sure we need a 2D table like the AD driver.

I actually implemented this in the dp83869 a bit ago and have done this 
in a few other non-PHY drivers.

I guess I can look at making it a utility function in the networking space.

Dan

>
> 	  Andrew
