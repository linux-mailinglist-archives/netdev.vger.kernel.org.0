Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F7E2A30
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437642AbfJXGAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 02:00:38 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:49004 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406817AbfJXGAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 02:00:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9O60bhj097600;
        Thu, 24 Oct 2019 01:00:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571896837;
        bh=RSBHvKel6saIbyxRXHhRaUv2sydn3RPTCOZHYjazgFQ=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=l8Xj9bBJbdRCA35zAB4u/Y3euLki9I7/es6usWgrbbLE4HBHHnaWPTe8mA7EAhVb4
         rNHKzP0af3Hnh+8oEJWtAaK5s5kyYE25JFq5IAFU+YoHstpTMG08+2Xdf3Rk5HSwy/
         d/lszw4fsvuwz9MgW3xQmmoKejy3JuIDLSPvB3Nw=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9O60bmw092518
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Oct 2019 01:00:37 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 24
 Oct 2019 01:00:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 24 Oct 2019 01:00:36 -0500
Received: from [172.24.190.233] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9O60XeU056478;
        Thu, 24 Oct 2019 01:00:34 -0500
Subject: Re: [PATCH] phy: ti: gmii-sel: fix mac tx internal delay for
 rgmii-rxid
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>
References: <20191023144744.1246-1-grygorii.strashko@ti.com>
 <45a6ffd4-c0bd-1845-cb71-9adbafde2dd8@gmail.com>
 <98235ce5-a86b-46be-c390-18bbbfd1df03@ti.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <319c6be7-922b-2b88-4aac-399e1828cb9e@ti.com>
Date:   Thu, 24 Oct 2019 11:30:04 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <98235ce5-a86b-46be-c390-18bbbfd1df03@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/10/19 11:12 AM, Grygorii Strashko wrote:
> 
> 
> On 24/10/2019 05:41, Florian Fainelli wrote:
>>
>>
>> On 10/23/2019 7:47 AM, Grygorii Strashko wrote:
>>> Now phy-gmii-sel will disable MAC TX internal delay for PHY interface mode
>>> "rgmii-rxid" which is incorrect.
>>> Hence, fix it by enabling MAC TX internal delay in the case of "rgmii-rxid"
>>> mode.
>>>
>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> Should this have a:
>>
>> Fixes: 92b58b34741f ("phy: ti: introduce phy-gmii-sel driver")
>>
> 
> Yes. it should.
> Kishon, would you like me to re-submit or can you fix while applying?

I'll fix it while applying.

Thanks
Kishon
