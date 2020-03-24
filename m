Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE9E19165A
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgCXQ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:27:15 -0400
Received: from foss.arm.com ([217.140.110.172]:37914 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728796AbgCXQ0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 12:26:53 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 637081FB;
        Tue, 24 Mar 2020 09:26:48 -0700 (PDT)
Received: from [192.168.3.111] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BCEC3F52E;
        Tue, 24 Mar 2020 09:26:47 -0700 (PDT)
Subject: Re: [PATCH] net: PHY: bcm-unimac: Fix clock handling
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
References: <20200324161010.81107-1-andre.przywara@arm.com>
 <20200324161739.GE14512@lunn.ch>
From:   =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
Message-ID: <5852f0e7-aea8-7af8-3a88-5e4fcdc6e5d4@arm.com>
Date:   Tue, 24 Mar 2020 16:26:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324161739.GE14512@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2020 16:17, Andrew Lunn wrote:

Hi,

> On Tue, Mar 24, 2020 at 04:10:10PM +0000, Andre Przywara wrote:
>> The DT binding for this PHY describes an *optional* clock property.
>> Due to a bug in the error handling logic, we are actually ignoring this
>> clock *all* of the time so far.
>>
>> Fix this by using devm_clk_get_optional() to handle this clock properly.
>>
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> 
> Hi Andre
> 
> Do you have a fixes: tag for this?

Should be:
Fixes: b78ac6ecd1b6b ("net: phy: mdio-bcm-unimac: Allow configuring MDIO
clock divider")

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks for that!

Cheers,
Andre
