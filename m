Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F093925DAE6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgIDOEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730599AbgIDOBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:01:06 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7451DC061247;
        Fri,  4 Sep 2020 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hEP46ZA6ePHrwQkWvRFQ6iFofIiyW4GUhLIggfpPhx0=; b=gKQwO9iyk/2sWho9Mvuf1cqDxn
        3181MQpZ7sI+rEyM734NAJw8e0Aw475FUeuRZBA6pbiWujl6HEDa6qiER9CTunZFAKVVgrJ2JKTFJ
        2YcgKz+Nh62HqyFyjvnaw+m02RFiROdeJV/8ytqFfogZCb42BmiNUj3i9Bm9iDuSqwN6iuH0SmNrV
        8pcvUs2hIb5IMGxQ+lF1TG2PzkHWxxvxYqXsOrlMRaUdLOM8ZTBFJTIGZyxnSbIsoQDchY7334DZR
        tfdai1NX8T6syGl1YEfbvrM2BsqzVVQJkf+6rqijWamyMgp6lwJK+ifqiij42wEoOCEThOk39RBtz
        sh1QbgjQ==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kECGr-000sWO-Ho; Fri, 04 Sep 2020 16:00:53 +0200
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
 <307b343b-2e8d-cb20-c22f-0e80acdf1dc9@arf.net.pl>
 <20200904134558.GL3112546@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <ed801431-2b46-5d6d-0cfd-a4b043702f9f@arf.net.pl>
Date:   Fri, 4 Sep 2020 16:00:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904134558.GL3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-09-04 o 15:45, Andrew Lunn pisze:
>> Just a bunch of questions.
>>
>> Actually, why is it necessary to have a full MDIO bus scan already during
>> probing peripherals?
> That is the Linux bus model. It does not matter what sort of bus it
> is, PCI, USB, MDIO, etc. When the bus driver is loaded, the bus is
> enumerated and drivers probe for each device found on the bus.

OK. But is it always expected to find all the devices on the bus in the 
first run? Does the bus model ever allow to just add any more devices? 
Kind of, "hotplug". :)

>> I'd say that it is not necessary to have a PHY getting found before it is
>> needed to setup the complete interface.
> It is like saying, we don't need to probe the keyboard until the first
> time the "Press Enter" prompt is given?

I'm not sure what you mean. It's like saying that we don't need to care 
if we even have the keyboard until we are interested in any interaction 
with it. (This might be reading a key, an autotest, ..., or not using, 
but avoiding a conflict - depends on application.)

Best regards,
Adam

