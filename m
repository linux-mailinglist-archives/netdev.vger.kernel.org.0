Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E88A219254E
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 11:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCYKVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 06:21:18 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33664 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgCYKVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 06:21:18 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48nPKQ3GY0z1qy4M;
        Wed, 25 Mar 2020 11:21:14 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48nPKQ1HrGz1qqkK;
        Wed, 25 Mar 2020 11:21:14 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id c9fCxwBNxHKC; Wed, 25 Mar 2020 11:21:10 +0100 (CET)
X-Auth-Info: Jk8AWD3vuXK/N+e+qyBjxYOdVRAvzUbptF9rayGrzfo=
Received: from [127.0.0.1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Wed, 25 Mar 2020 11:21:10 +0100 (CET)
Subject: Re: user space interface for configuring T1 PHY management mode
 (master/slave)
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        David Miller <davem@davemloft.net>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        david@protonic.nl, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, olteanv@gmail.com
References: <20200325083449.GA8404@pengutronix.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <e2a1877c-1cb2-e047-38e0-e3b41d941b33@denx.de>
Date:   Wed, 25 Mar 2020 11:21:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325083449.GA8404@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/25/20 9:34 AM, Oleksij Rempel wrote:
> Hi all,

Hi,

> I'm working on mainlining of NXP1102 PHY (BroadR Reach/802.3bw) support.
> 
> Basic functionality is working and support with mainline kernel. Now it is time
> to extend it. According to the specification, each PHY can be master or slave.
> 
> The HW can be pre configured via bootstrap pins or fuses to have a default
> configuration. But in some cases we still need to be able to configure the PHY
> in a different mode: 
> --------------------------------------------------------------------------------
> http://www.ieee802.org/3/1TPCESG/public/BroadR_Reach_Automotive_Spec_V3.0.pdf
> 
> 6.1 MASTER-SLAVE configuration resolution
> 
> All BroadR-Reach PHYs will default to configure as SLAVE upon power up or reset
> until a management system (for example, processor/microcontroller) configures
> it to be MASTER. MASTER-SLAVE assignment for each link configuration is
> necessary for establishing the timing control of each PHY.

Thanks for reminding me of this. I sent out
https://patchwork.ozlabs.org/project/netdev/list/?series=166575
maybe it helps.
