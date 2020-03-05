Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A42B17A37E
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 11:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCEKze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 05:55:34 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49278 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgCEKze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 05:55:34 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 025AtT2Z010220;
        Thu, 5 Mar 2020 04:55:29 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583405729;
        bh=UMh1opH6tmYxUIx/AyWNlJuD6bLG+NyY4/gGWFJ85Nk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=FsxuKIay7I+ZBVLkyPl3LpD5Y6p6SDnF7fgG7qfZn9e/Qs3/UODQ+ema+spkam3Dm
         oC4R744c+dIqSRHYZnxu5jf01hUAn0nfY6BHAbjA6S5zx166YKmyg2ooK905vnVZDD
         j0PrP1WJl3Du/jaaMLEghlYQ0SpRkTBwFXWdVH04=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 025AtTDL030404
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Mar 2020 04:55:29 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 5 Mar
 2020 04:55:29 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 5 Mar 2020 04:55:29 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 025AtQuu006736;
        Thu, 5 Mar 2020 04:55:27 -0600
Subject: Re: [for-next PATCH v2 0/5] phy: ti: gmii-sel: add support for
 am654x/j721e soc
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        David Miller <davem@davemloft.net>
CC:     <m-karicheri2@ti.com>, <t-kristo@ti.com>, <nsekhar@ti.com>,
        <robh+dt@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
 <20200304.143951.1102411401290807167.davem@davemloft.net>
 <71a6fea9-65c1-3a3c-a35b-9432208b3ee5@ti.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <7c5395a6-56cb-1d2a-0243-99a6b0fed2a7@ti.com>
Date:   Thu, 5 Mar 2020 12:55:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <71a6fea9-65c1-3a3c-a35b-9432208b3ee5@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/03/2020 07:17, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On 05/03/20 4:09 am, David Miller wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>> Date: Tue, 3 Mar 2020 18:00:24 +0200
>>
>>> Hi Kishon,
>>>
>>> This series adds support for TI K3 AM654x/J721E SoCs in TI phy-gmii-sel PHY
>>> driver, which is required for future adding networking support.
>>>
>>> depends on:
>>>   [PATCH 0/2] phy: ti: gmii-sel: two fixes
>>>   https://lkml.org/lkml/2020/2/14/2510
>>>
>>> Changes in v2:
>>>   - fixed comments
>>>
>>> v1: https://lkml.org/lkml/2020/2/22/100
>>
>> This is mostly DT updates and not much networking code changes, will some other
>> tree take this?
> 
> I can take the phy related changes. Grygorii, can you split the dt
> patches into a separate series?

sure. Could pls, pick up 1-3 and I'll resend 4-5.
Or you want me re-send once again?

-- 
Best regards,
grygorii
