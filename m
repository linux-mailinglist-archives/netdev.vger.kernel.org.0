Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83B94925FC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 13:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239134AbiARMrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 07:47:41 -0500
Received: from mxout04.lancloud.ru ([45.84.86.114]:39352 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237683AbiARMrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 07:47:41 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 1F4DA21122DB
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH RFC] phy: make phy_set_max_speed() *void*
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        <linux-renesas-soc@vger.kernel.org>
References: <a2296c4e-884b-334a-570f-901831bfea3c@omp.ru>
 <YeXo+G/roPb2G2rU@lunn.ch>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <0e9a9558-e54f-9650-b4e2-fca4a4c2347b@omp.ru>
Date:   Tue, 18 Jan 2022 15:47:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YeXo+G/roPb2G2rU@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 1:08 AM, Andrew Lunn wrote:

>> After following the call tree of phy_set_max_speed(), it became clear
>> that this function never returns anything but 0, so we can change its
>> result type to *void* and drop the result checks from the three drivers
>> that actually bothered to do it...
>>
>> Found by Linux Verification Center (linuxtesting.org) with the SVACE static
>> analysis tool.
>>
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> Seems reasonable.

   No need to seprate into severla patches? :-)

> net-next is closed at the moment, so please repost

   That's why RFC is mainly here. :-)

> once it opens.

   Sure.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

   T!

>     Andrew

MBR, Sergey
