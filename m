Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA5CD92B0
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391854AbfJPNjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:39:22 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60992 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730396AbfJPNjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 09:39:21 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46tYLJ1fP3z1rTYZ;
        Wed, 16 Oct 2019 15:39:20 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46tYLJ14Zwz1qqkD;
        Wed, 16 Oct 2019 15:39:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id H16J7DUxOhX5; Wed, 16 Oct 2019 15:39:19 +0200 (CEST)
X-Auth-Info: M1Hx/YvkOMREkYSdFmVtLa9xCmuFceUYsCgw6kvNvMk=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 16 Oct 2019 15:39:18 +0200 (CEST)
Subject: Re: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795
 PHYs
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
References: <20191013212404.31708-1-marex@denx.de>
 <20191015.174209.218969750454729705.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <c7ff59cb-0ee7-b746-c54b-6e718ab62c28@denx.de>
Date:   Wed, 16 Oct 2019 15:39:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191015.174209.218969750454729705.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/19 2:42 AM, David Miller wrote:
> From: Marek Vasut <marex@denx.de>
> Date: Sun, 13 Oct 2019 23:24:03 +0200
> 
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Fixes: 9d162ed69f51 ("net: phy: micrel: add support for KSZ8795")
> 
> I'm sorry to be strict, but as Heiner said the Fixes: tag needs to be
> the first tag.
> 
> I'm pushing this back to you so that you can learn how to submit patches
> properly in the future, nothing more.

Maybe next time we can do these exercises on patches which are not
bugfixes for real issues?
