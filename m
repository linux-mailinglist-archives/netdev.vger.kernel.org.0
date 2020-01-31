Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13FE414F12E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgAaRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:17:31 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40950 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgAaRRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:17:31 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00VHHORw044420;
        Fri, 31 Jan 2020 11:17:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1580491044;
        bh=+Lek5+g/nyO29sHE2v79UKO/32OeJVnF+qZpmQhxI2o=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=VcPMttHsm08yVTRRIyC1A0qEFeHYBfuHpVc2p2N/ldSx4Udz87FbYIX+rWcaKJFE6
         6XYxkbUa8hLIFXXJVjnTxxSSM32h65PTj/DaN2QS0l9oSR5YbXoWLTUT6+B+vISNF/
         CZJUX9DiG1kkk8JY2Dg0mH9GX/PF9lMm9uZ898ck=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00VHHO4m002841
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 31 Jan 2020 11:17:24 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 31
 Jan 2020 11:17:24 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 31 Jan 2020 11:17:23 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00VHHNpR076978;
        Fri, 31 Jan 2020 11:17:23 -0600
Subject: Re: [PATCH net-master 1/1] net: phy: dp83867: Add speed optimization
 feature
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
References: <20200131151110.31642-1-dmurphy@ti.com>
 <20200131151110.31642-2-dmurphy@ti.com>
 <20200131091004.18d54183@cakuba.hsd1.ca.comcast.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <6b4bb017-de97-0688-47c5-723ec4c3a339@ti.com>
Date:   Fri, 31 Jan 2020 11:14:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200131091004.18d54183@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 1/31/20 11:10 AM, Jakub Kicinski wrote:
> On Fri, 31 Jan 2020 09:11:10 -0600, Dan Murphy wrote:
>> Set the speed optimization bit on the DP83867 PHY.
>> This feature can also be strapped on the 64 pin PHY devices
>> but the 48 pin devices do not have the strap pin available to enable
>> this feature in the hardware.  PHY team suggests to have this bit set.
>>
>> With this bit set the PHY will auto negotiate and report the link
>> parameters in the PHYSTS register and not in the BMCR.  So we need to
>> over ride the genphy_read_status with a DP83867 specific read status.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> While we wait for the PHY folk to take a look, could you please
> provide a Fixes tag?

Hmm. This is not a bug fix though this is a new feature being added.

Not sure what it would be fixing.

Dan

