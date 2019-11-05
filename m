Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AE1F06AC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 21:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfKEUJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 15:09:32 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:38796 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEUJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 15:09:32 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA5K9SeQ070186;
        Tue, 5 Nov 2019 14:09:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572984568;
        bh=nE6BU9hEnA6eDsPcHYOOk7C7taGSXSjOx88R6DhNv5o=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QW9wn9q+x7sWeLsVYR+FWx4xEpBhpuae3KAKg2WkoNVs/MKWJnlZOSAAziZCFcouX
         6jeymzoO9VCfh9m1XBiIyZqYog30zD35peP1p10PiBcgv/ym/P6LEhYh8XV+3YJlkS
         6YZIyj35gFt0pkDpbuThxHC2U5/Q7L89XJlBurgk=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA5K9Sxu059145
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 5 Nov 2019 14:09:28 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 5 Nov
 2019 14:09:13 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 5 Nov 2019 14:09:28 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA5K9RTd119057;
        Tue, 5 Nov 2019 14:09:28 -0600
Subject: Re: [PATCH 2/2] net: phy: dp83869: Add TI dp83869 phy
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191105181826.25114-1-dmurphy@ti.com>
 <20191105181826.25114-2-dmurphy@ti.com>
 <68b9c003-4fb3-b854-695a-fa1c6e08f518@gmail.com>
 <4ffebfad-87d2-0e19-5b54-7e550c540d03@ti.com>
 <5d5cb879-b3a2-545f-7f74-0f1f1e6380bb@gmail.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <efe93d94-c877-779d-5df5-2c5e90dd2e8a@ti.com>
Date:   Tue, 5 Nov 2019 14:08:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5d5cb879-b3a2-545f-7f74-0f1f1e6380bb@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian

On 11/5/19 2:05 PM, Florian Fainelli wrote:
> On 11/5/19 12:02 PM, Dan Murphy wrote:
> int ret, val;
>>>> +
>>>> +    if (!phydev->priv) {
>>>> +        dp83869 = devm_kzalloc(&phydev->mdio.dev, sizeof(*dp83869),
>>>> +                       GFP_KERNEL);
>>> This belongs into the probe callback.
>> probe callback?  Why do I need a probe function?
> To allocate your driver private memory and do that just once,
> config_init() can be called multiple times through the lifetime of your
> PHY device driver, including but not limited to: phy_connect(),
> phy_init_hw(), phy_resume() etc. etc.

Ah OK.  Makes sense will fix it.

Dan

