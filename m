Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C8326B493
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbgIOX0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:26:54 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42500 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgIOX0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:26:51 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08FNQepT001080;
        Tue, 15 Sep 2020 18:26:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600212400;
        bh=nR6reMnzuShhnQAUVf9pjPzWzCB1Ke7a/UlmPVYyG4I=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=E4eoJo4Gub8aHeh+fYxpUs6RRFZhFz7e97KAQNVo+srqYCvdnYGuXBIeXVCqEtpVJ
         0jlA+DlnTk+jGb0R7BW43MniNxq48Ti1tCiheds+EiPxrRKEGs8xA8hdSyxF4Qoe6a
         zUGctxY0FVWOri/c2yMIVzieBum+CdPeOh0Mw5ec=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08FNQe21050737
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 18:26:40 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 15
 Sep 2020 18:26:39 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 15 Sep 2020 18:26:39 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08FNQdNG081051;
        Tue, 15 Sep 2020 18:26:39 -0500
Subject: Re: [PATCH net-next 1/3] ethtool: Add 100base-FX link mode entries
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200915181708.25842-1-dmurphy@ti.com>
 <20200915181708.25842-2-dmurphy@ti.com> <20200915201014.GC3526428@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <bfe1a5fa-2092-7aa8-db24-86306042d3fc@ti.com>
Date:   Tue, 15 Sep 2020 18:26:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200915201014.GC3526428@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/15/20 3:10 PM, Andrew Lunn wrote:
> On Tue, Sep 15, 2020 at 01:17:06PM -0500, Dan Murphy wrote:
>> @@ -160,6 +160,8 @@ static const struct phy_setting settings[] = {
>>   	PHY_SETTING(    100, FULL,    100baseT_Full		),
>>   	PHY_SETTING(    100, FULL,    100baseT1_Full		),
>>   	PHY_SETTING(    100, HALF,    100baseT_Half		),
>> +	PHY_SETTING(    100, HALF,    100baseFX_Half		),
>> +	PHY_SETTING(    100, FULL,    100baseFX_Full		),
> Hi Dan
>
> Does 100baseFX_Half make an sense? My understanding of 802.3 section
> 26 is that it is always a pair, not a single fibre where you might
> need CSMA/CD?

I actually questioned that too and looked it up

I found these and thought they could be viable

http://www.certiology.com/tech-terms/network/100base-fx.html

"The 100Base-FX can be used in a maximum length of 412 meters if being 
used in

half-duplex connections or as 2 kilometer lengths in the case of 
full-duplex transmissions over optical fiber."

https://www.cnet.com/products/half-duplex-100basefx-interface-pb7/

Of course I never have seen one myself

Dan


>     Andrew
