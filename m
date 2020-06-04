Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A001F1EEBF7
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 22:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgFDU1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 16:27:48 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:49544 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgFDU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 16:27:48 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 054KRead089425;
        Thu, 4 Jun 2020 15:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591302460;
        bh=N+QJzUFxIrA5/MuRXT6M2TS2TtMFDYT1CkUkUKyL2nU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=wKDoW0axSiLqJ/3p1Y1FMpNfJBXHSmXvlTIXVBMhohSyAZ0nwUFtYWXkSp921FGmW
         X12njTBRLnsnK1ZZQnfcQR1rw08Gv8JUz8a+PFJ4eX4SQW3R6eqjNmjSbfA4lHVJxU
         t8p36EM92491GlrWIaIWvGOicyeLBb7VDz2FkjSo=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 054KReI6123953
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 4 Jun 2020 15:27:40 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 4 Jun
 2020 15:27:40 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 4 Jun 2020 15:27:40 -0500
Received: from [10.250.52.63] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 054KReJw121027;
        Thu, 4 Jun 2020 15:27:40 -0500
Subject: Re: [PATCH net-next v6 4/4] net: dp83869: Add RGMII internal delay
 configuration
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <robh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
References: <20200604111410.17918-1-dmurphy@ti.com>
 <20200604111410.17918-5-dmurphy@ti.com>
 <20200604092545.40c85fce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <63a53dad-4f0a-31ca-ad1a-361b633c28bf@ti.com>
 <20200604094829.0d7d5df7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <8a844e26-3a5a-ac61-1c4a-e60fbebf6341@ti.com>
Date:   Thu, 4 Jun 2020 15:27:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200604094829.0d7d5df7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 6/4/20 11:48 AM, Jakub Kicinski wrote:
> On Thu, 4 Jun 2020 11:38:14 -0500 Dan Murphy wrote:
>> Jakub
>>
>> On 6/4/20 11:25 AM, Jakub Kicinski wrote:
>>> On Thu, 4 Jun 2020 06:14:10 -0500 Dan Murphy wrote:
>>>> Add RGMII internal delay configuration for Rx and Tx.
>>>>
>>>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>>> Hi Dan, please make sure W=1 C=1 build is clean:
>>>
>>> drivers/net/phy/dp83869.c:103:18: warning: â€˜dp83869_internal_delayâ€™ defined but not used [-Wunused-const-variable=]
>>>     103 | static const int dp83869_internal_delay[] = {250, 500, 750, 1000, 1250, 1500,
>>>         |                  ^~~~~~~~~~~~~~~~~~~~~~
>> I built with W=1 and C=1 and did not see this warning.
>>
>> What defconfig are you using?
> allmodconfig with gcc-10
>
>> Can you check if CONFIG_OF_MDIO is set or not?  That would be the only
>> way that warning would come up.
> Hm. I don't have the config from this particular build but just running
> allmodconfig makes it CONFIG_OF_MDIO=m

OK that makes sense then.  That is an existing bug that shows up because 
of this.

#ifdef CONFIG_OF_MDIO

So the addition of the array exposed an existing issue.

That bug fix can go to net then.
>>> Also net-next is closed right now, you can post RFCs but normal patches
>>> should be deferred until after net-next reopens.
>> I know net-next is closed.
>>
>> I pinged David M when it was open about what is meant by "new" patches
>> in the net-dev FAQ.  So I figured I would send the patches to see what
>> the response was.
>>
>> To me these are not new they are in process patches.  My understand is
>> New is v1 patchesets.
>>
>> But now I have the answer.
> Oh sorry, I may be wrong in this case, I haven't tracked this series.
>
It says v6 in $subject.

But still you may be correct I don't know

Dan

