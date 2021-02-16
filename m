Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5631C8BB
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBPKZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:25:48 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:52852 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhBPKZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:25:41 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 11GAOeRs127257;
        Tue, 16 Feb 2021 04:24:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1613471080;
        bh=jXP/A7m1+bRyusmpL52wb3C/gRf4Bo6Hw3U3UA3/J00=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=GedDc0/SqmIZkDbq5PAfBWDTHHn4XOOKFbSDL9C+GnB+tFeuMKrjlaYUapRHsiZiQ
         hYzFmU6ZeNuEBK3OjHPJ0Hjxz68Im473WdNpa7PKmX289A6NnLKtMcI6b3u7wA4aXy
         CH52r8WUMom0okKamv0eH+FZAvzGKF+34GfLecAY=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 11GAOeDY090324
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Feb 2021 04:24:40 -0600
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 16
 Feb 2021 04:24:40 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 16 Feb 2021 04:24:40 -0600
Received: from [10.250.234.229] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 11GAOZ58004811;
        Tue, 16 Feb 2021 04:24:36 -0600
Subject: Re: [PATCH v14 2/4] phy: Add media type and speed serdes
 configuration interfaces
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Vinod Koul <vkoul@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210210085255.2006824-1-steen.hegelund@microchip.com>
 <20210210085255.2006824-3-steen.hegelund@microchip.com>
 <04d91f6b-775a-8389-b813-31f7b4a778cb@ti.com>
 <ffa00a2bf83ffa21ffdc61b380ab800c31f8cf28.camel@microchip.com>
 <704b850f-9345-2e36-e84b-b332fed22270@ti.com> <YCqAMUfinMsnZnrq@lunn.ch>
 <d5b3ccf9df1968671baadcd3c7a5e068d48867c5.camel@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <d5351524-d02d-0bdb-53ba-b5b9a72673f2@ti.com>
Date:   Tue, 16 Feb 2021 15:54:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d5b3ccf9df1968671baadcd3c7a5e068d48867c5.camel@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/02/21 2:07 pm, Steen Hegelund wrote:
> Hi Andrew and Kishon,
> 
> On Mon, 2021-02-15 at 15:07 +0100, Andrew Lunn wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>> know the content is safe
>>
>> On Mon, Feb 15, 2021 at 05:25:10PM +0530, Kishon Vijay Abraham I
>> wrote:
>>> Okay. Is it going to be some sort of manual negotiation where the
>>> Ethernet controller invokes set_speed with different speeds? Or the
>>> Ethernet controller will get the speed using some out of band
>>> mechanism
>>> and invokes set_speed once with the actual speed?
>>
>> Hi Kishon
>>
>> There are a few different mechanism possible.
>>
>> The SFP has an EEPROM which contains lots of parameters. One is the
>> maximum baud rate the module supports. PHYLINK will combine this
>> information with the MAC capabilities to determine the default speed.
>>
>> The users can select the mode the MAC works in, e.g. 1000BaseX vs
>> 2500BaseX, via ethtool -s. Different modes needs different speeds.
>>
>> Some copper PHYs will change there host side interface baud rate when
>> the media side interface changes mode. 10GBASE-X for 10G copper,
>> 5GBase-X for 5G COPPER, 2500Base-X for 2.5G copper, and SGMII for
>> old school 10/100/1G Ethernet.
>>
>> Mainline Linux has no support for it, but some 'vendor crap' will do
>> a
>> manual negotiation, simply trying different speeds and see if the
>> SERDES establishes link. There is nothing standardised for this, as
>> far as i know.
>>
>>     Andrew
> 
> Yes, in case I mention the only way to ensure communication is human
> intervention to set the speed to the highest common denominator.

Okay.. is it the same case for set_media as well?

Thanks
Kishon
