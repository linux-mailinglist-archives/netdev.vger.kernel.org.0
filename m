Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B32C1DB8C5
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgETP4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:56:10 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:41956 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgETP4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:56:10 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04KFu5kl121964;
        Wed, 20 May 2020 10:56:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589990165;
        bh=Z1FghLDYCt9S+tlhl6CoZ8M0XLa4JQ7N0CO0ouJegsA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=IYVriDqHuGv8dSt1qh2dSXk38T/6c0V3Mwck06kesJERAoxAQozitXmGF0uFSZvF4
         V3GxqQ328t33wRZMkDUYZdINBQWTFdwUW3bIXU8BU1gyWxm227aK3rJVBwz2UIvAq0
         jrMCnIZg4RT/LfbknaoB7GZhIPTqtHwZeosfHCTY=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04KFu4FD125889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 20 May 2020 10:56:05 -0500
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 20
 May 2020 10:56:04 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 20 May 2020 10:56:05 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04KFu4TV130035;
        Wed, 20 May 2020 10:56:04 -0500
Subject: Re: [PATCH net-next v2 3/4] dt-bindings: net: Add RGMII internal
 delay for DP83869
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200520121835.31190-1-dmurphy@ti.com>
 <20200520121835.31190-4-dmurphy@ti.com> <20200520135624.GC652285@lunn.ch>
 <770e42bb-a5d7-fb3e-3fc1-b6f97a9aeb83@ti.com>
 <20200520153631.GH652285@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <95ab99bf-2fb5-c092-ad14-1b0a47c782a4@ti.com>
Date:   Wed, 20 May 2020 10:56:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520153631.GH652285@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 5/20/20 10:36 AM, Andrew Lunn wrote:
>>> Hi Dan
>>>
>>> Having it required with PHY_INTERFACE_MODE_RGMII_ID or
>>> PHY_INTERFACE_MODE_RGMII_RXID is pretty unusual. Normally these
>>> properties are used to fine tune the delay, if the default of 2ns does
>>> not work.
>> Also if the MAC phy-mode is configured with RGMII-ID and no internal delay
>> values defined wouldn't that be counter intuitive?
> Most PHYs don't allow the delay to be fine tuned. You just pass for
> example PHY_INTERFACE_MODE_RGMII_ID to the PHY driver and it enables a
> 2ns delay. That is what people expect, and is documented.

> Being able to tune the delay is an optional extra, which some PHYs
> support, but that is always above and beyond
> PHY_INTERFACE_MODE_RGMII_ID.

I am interested in knowing where that is documented.  I want to RTM I 
grepped for a few different words but came up empty

Since this is a tuneable phy we need to program the ID.  2ns is the 
default value

Maybe I can change it from Required to Configurable or Used.

Dan


>       Andrew
