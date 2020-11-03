Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388272A4C01
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 17:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgKCQxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 11:53:12 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40310 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgKCQxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 11:53:11 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A3Gr4oZ061462;
        Tue, 3 Nov 2020 10:53:04 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604422384;
        bh=0Tkp6HLRVCB/7ivjFJeStRM6yrcVsh9/LqVVSNK0ysQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Anuz5tKbBGuCx0poQrMYXF/O5541STenRpOVtBf9We3N7ok2idb0GrDCk/Mxsox29
         McVsSzhmdTxAUg7ONgpcec2G+4FFLg30BDwBWUtwepx3vU5hg+ZusFLMGS9z8Tj8Qg
         4Z7NnvX8E2K2zUIuE/lg2VxytxpmMUxSrlEedoJw=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A3Gr4Iu015522
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Nov 2020 10:53:04 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 3 Nov
 2020 10:53:03 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 3 Nov 2020 10:53:04 -0600
Received: from [10.250.36.55] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A3Gr3ej016284;
        Tue, 3 Nov 2020 10:53:03 -0600
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <robh@kernel.org>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-3-dmurphy@ti.com> <20201030195655.GD1042051@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <a50fe8f3-2ca1-8969-08ac-013704a5a617@ti.com>
Date:   Tue, 3 Nov 2020 10:52:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201030195655.GD1042051@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 10/30/20 2:56 PM, Andrew Lunn wrote:
> On Fri, Oct 30, 2020 at 12:29:48PM -0500, Dan Murphy wrote:
>> Per the 802.3cg spec the 10base T1L can operate at 2 different
>> differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
>> drive that output is dependent on the PHY's on board power supply.
> Hi Dan
>
> So this property is about the board being able to support the needed
> voltages? The PHY is not forced into 2.4v p2p, it just says the PHY
> can operate at 2.4v and the board will not melt, blow a fuse, etc?
>
> I actually think it is normal to specify the reverse. List the maximum
> that device can do because of board restrictions. e.g.
>
> - maximum-power-milliwatt : Maximum module power consumption
>    Specifies the maximum power consumption allowable by a module in the
>    slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.
>
> - max-link-speed:
>     If present this property specifies PCI gen for link capability.  Host
>     drivers could add this as a strategy to avoid unnecessary operation for
>     unsupported link speed, for instance, trying to do training for
>     unsupported link speed, etc.  Must be '4' for gen4, '3' for gen3, '2'
>     for gen2, and '1' for gen1. Any other values are invalid.
>
>   - max-microvolt : The maximum voltage value supplied to the haptic motor.
>                  [The unit of the voltage is a micro]
>
> So i think this property should be
>
>     max-tx-rx-p2p = <1000>;

When I was re-writing the code I couldn't come up with a better property 
name but I like this one.

I will implement it.

Do you have any issue with the property being in the ethernet-phy.yaml?

Dan


