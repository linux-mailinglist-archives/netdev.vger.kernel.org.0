Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BFC26E4BB
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgIQSzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:55:05 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:36320 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgIQQU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:20:29 -0400
X-Greylist: delayed 4574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 12:20:29 EDT
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08HF3nrx093974;
        Thu, 17 Sep 2020 10:03:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600355029;
        bh=68MpQKTxCsWGwGbzyWvdukkDiJlxjWj2z9bwK07+mIc=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=lOpXGXAPhmGYsk2hY2bA9ZJ7mS1TXFA0SFETEkwJEZE7azGrHllU51Kd3btXbG0xa
         YIcmSI1PTtcPhj8IxkcxOr+6DcPoBhTygSCnH3m8nYxnmtOKCaRKWGKw8slQnv4ijx
         wGTd2sGIc2GC+/qho4wa8fm4Yi1TAEe0efWoRlik=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08HF3niL092139
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 10:03:49 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 17
 Sep 2020 10:03:49 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 17 Sep 2020 10:03:49 -0500
Received: from [10.250.32.129] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08HF3mer076110;
        Thu, 17 Sep 2020 10:03:48 -0500
Subject: Re: [PATCH net-next 1/3] ethtool: Add 100base-FX link mode entries
From:   Dan Murphy <dmurphy@ti.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-2-dmurphy@ti.com> <20200915202113.GE3526428@lunn.ch>
 <f2a38c01-8726-a7fe-f645-2c83fe30b932@ti.com>
Message-ID: <24c84585-2a42-31c7-2493-1a9891b3a21e@ti.com>
Date:   Thu, 17 Sep 2020 10:03:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f2a38c01-8726-a7fe-f645-2c83fe30b932@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/15/20 6:29 PM, Dan Murphy wrote:
> Andrew
>
> On 9/15/20 3:21 PM, Andrew Lunn wrote:
>> On Tue, Sep 15, 2020 at 01:17:06PM -0500, Dan Murphy wrote:
>>> Add entries for the 100base-FX full and half duplex supported modes.
>>>
>>> $ ethtool eth0
>>>          Supported ports: [ TP    MII     FIBRE ]
>>>          Supported link modes:   10baseT/Half 10baseT/Full
>>>                                  100baseT/Half 100baseT/Full
>>>                                  100baseFX/Half 100baseFX/Full
>>>          Supported pause frame use: Symmetric Receive-only
>>>          Supports auto-negotiation: No
>>>          Supported FEC modes: Not reported
>>>          Advertised link modes:  10baseT/Half 10baseT/Full
>>>                                  100baseT/Half 100baseT/Full
>>>                                  100baseFX/Half 100baseFX/Full
>> I thought this PHY could not switch between TP and Fibre. It has a
>> strap which decides? So i would expect the supported modes to be
>> either BaseT or BaseFX. Not both. Same for Advertised?
>>
>>         Andrew
>
> I found that the phy-device was setting all these bits in phy_init in 
> features_init.
>
> My first pass was to clear all these bits as well because the PHY was 
> still advertising these modes.
>
> But you are right this PHY cannot switch without strapping.
>
> I can clear these bits.

I re-read your reply and this is just an example.  This patch really has 
nothing to do with any PHY as it is just adding in the new link modes.

Unless you comment wanted me to remove the TP and advertised modes from 
the example in the commit message?

Dan


>
> Dan
>
