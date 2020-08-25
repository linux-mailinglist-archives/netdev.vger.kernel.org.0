Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7112625215E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 21:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgHYT5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 15:57:52 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:34026 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgHYT5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 15:57:51 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07PJvfOj060116;
        Tue, 25 Aug 2020 14:57:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598385461;
        bh=ajbZ9rVhCYnFjI5Ed3ufZapctmtfgBJlQbs+33Lcn1w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=TxyZsn5QqlaGwRd/resxsNiAIl6hy0Txxd6DAogOT/6uBsSNVvSFdX3pytmcA0Jdv
         +mUefimNqE4yVAc92vnjRyzAUHmiCeaDQesPOVj+DnnPFqwoiXh+Y4eualLeyh9Stl
         KNr/fqgWmY1Pixoz+/1vk//1w9Savzt9p9Ei8NPs=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07PJvfXS055772
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 14:57:41 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 25
 Aug 2020 14:57:40 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 25 Aug 2020 14:57:40 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07PJveAu093612;
        Tue, 25 Aug 2020 14:57:40 -0500
Subject: Re: [PATCH] net: dp83869: Fix RGMII internal delay configuration
To:     Andrew Lunn <andrew@lunn.ch>,
        Daniel Gorsulowski <daniel.gorsulowski@esd.eu>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>
References: <20200825120721.32746-1-daniel.gorsulowski@esd.eu>
 <20200825133750.GQ2588906@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <b2c665e7-9566-6767-6ee3-39219a1bd4a3@ti.com>
Date:   Tue, 25 Aug 2020 14:57:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200825133750.GQ2588906@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 8/25/20 8:37 AM, Andrew Lunn wrote:
> On Tue, Aug 25, 2020 at 02:07:21PM +0200, Daniel Gorsulowski wrote:
>> The RGMII control register at 0x32 indicates the states for the bits
>> RGMII_TX_CLK_DELAY and RGMII_RX_CLK_DELAY as follows:
>>
>>    RGMII Transmit/Receive Clock Delay
>>      0x0 = RGMII transmit clock is shifted with respect to transmit/receive data.
>>      0x1 = RGMII transmit clock is aligned with respect to transmit/receive data.
>>
>> This commit fixes the inversed behavior of these bits
>>
>> Fixes: 736b25afe284 ("net: dp83869: Add RGMII internal delay configuration")
> I Daniel
>
> I would like to see some sort of response from Dan Murphy about this.

Daniel had sent this privately to me and I encouraged him to send it in 
for review.

Unfortunately he did not cc me on the patch he sent to the list.

But reviewing it off the list it looks fine to me

Dan

