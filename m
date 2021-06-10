Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC17C3A219B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFJAtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:49:20 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:47604 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJAtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 20:49:20 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15A0lIQ2035269;
        Wed, 9 Jun 2021 19:47:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1623286039;
        bh=/V9t/npogsGFkO8y3koHA2bVOzUPrE5rQACqM8GfjIk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=ipXoOqzLPmiLUIgFSAryX9nRW7FjVFxPfftIOAJYYgD3E1W6a8uq2AypHMNbjWnNk
         wnA4UlkLQxeZtapDtHUssqB49cHpNkzu/vyQTTQkDxEiIN+CeR7ecAqf7FqcDVu1Q5
         dQTaolKhgOy7z8edllpRB9CC8EGllKyJYyYk2mZA=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15A0lIA6117845
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 9 Jun 2021 19:47:18 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 19:47:18 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Wed, 9 Jun 2021 19:47:18 -0500
Received: from [10.247.25.23] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15A0lILe012301;
        Wed, 9 Jun 2021 19:47:18 -0500
Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
 soft reset and retain established link
To:     Andrew Lunn <andrew@lunn.ch>, "Modi, Geet" <geet.modi@ti.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210324010006.32576-1-praneeth@ti.com>
 <YFsxaBj/AvPpo13W@lunn.ch> <404285EC-BBF0-4482-8454-3289C7AF3084@ti.com>
 <YGSk4W4mW8JQPyPl@lunn.ch> <3494dcf6-14ca-be2b-dbf8-dda2e208b70b@ti.com>
 <YLEf128OEADi0Kb1@lunn.ch> <5480BEB5-B540-4BB6-AC32-65CB27439270@ti.com>
 <EC713CBF-D669-4A0E-ADF2-093902C03C49@ti.com> <YLaICrmU8ND+66mU@lunn.ch>
From:   "Bajjuri, Praneeth" <praneeth@ti.com>
Message-ID: <e2972a60-25e0-c444-8397-facda4a75b3c@ti.com>
Date:   Wed, 9 Jun 2021 19:47:18 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLaICrmU8ND+66mU@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On 6/1/2021 2:18 PM, Andrew Lunn wrote:
> On Tue, Jun 01, 2021 at 07:01:04PM +0000, Modi, Geet wrote:
>> Hello Andrew,
>>
>>   
>>
>> Please let me know if you have additional questions/clarifications to approve
>> below change request.
>>
>>   
>>
>> Regards,
>> Geet
>>
>>   
>>
>>   
>>
>> From: Geet Modi <geet.modi@ti.com>
>> Date: Friday, May 28, 2021 at 10:10 AM
>> To: Andrew Lunn <andrew@lunn.ch>, "Bajjuri, Praneeth" <praneeth@ti.com>
>> Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
>> "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
>> "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
>> Subject: Re: [EXTERNAL] Re: [EXTERNAL] Re: [PATCH] net: phy: dp83867: perform
>> soft reset and retain established link
> 
> So this all seems to boil down to, it does not matter if it is
> acceptable or not, you are going to do it. So please just remove that
> part of the comment. It has no value.

Sent v2 addressing comment as per your suggestion.
Ref: https://lore.kernel.org/patchwork/patch/1444281/

Thanks
Praneeth

> 
> 	 Andrew
> 
