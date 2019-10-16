Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC13D98DA
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436509AbfJPSGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:06:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:47519 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390200AbfJPSGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 14:06:32 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46tgGZ1KmQz1qrKJ;
        Wed, 16 Oct 2019 20:06:27 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46tgGW2PD2z1qqkD;
        Wed, 16 Oct 2019 20:06:27 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id GjXzJZHRRr4W; Wed, 16 Oct 2019 20:06:26 +0200 (CEST)
X-Auth-Info: q8KrUYbe6deieexfjmrIGlak95NYtiqZqmMc9DoiVf4=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 16 Oct 2019 20:06:26 +0200 (CEST)
Subject: Re: [PATCH net V4 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795
 PHYs
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        sean.nyekjaer@prevas.dk, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
References: <20191013212404.31708-1-marex@denx.de>
 <20191015.174209.218969750454729705.davem@davemloft.net>
 <c7ff59cb-0ee7-b746-c54b-6e718ab62c28@denx.de>
 <20191016.134626.2020955495176386867.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <2d59ae1a-fe6e-8bf5-36a4-db8c2fa48617@denx.de>
Date:   Wed, 16 Oct 2019 20:06:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016.134626.2020955495176386867.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/16/19 7:46 PM, David Miller wrote:
> From: Marek Vasut
> Date: Wed, 16 Oct 2019 15:39:18 +0200
> 
>> Maybe next time we can do these exercises on patches which are not
>> bugfixes for real issues?
> 
> No, we should put changes into the tree which are correctly formed.
> 
> If you're not interested in learning how to submit changes properly,
> we am not interested in accepting your work.
> 
> It's as simple as that.

If I wasn't interested, I wouldn't have sent V5 before replying to the
previous email. I hope the V5 is fine.
