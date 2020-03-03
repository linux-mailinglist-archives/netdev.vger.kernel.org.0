Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A44D91775CF
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgCCMTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:19:09 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:44324 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbgCCMTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:19:09 -0500
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48WwzY09P2z1rh7v;
        Tue,  3 Mar 2020 13:18:58 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48WwzQ0tXSz1qyDf;
        Tue,  3 Mar 2020 13:18:58 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id N18NRUUMe8GX; Tue,  3 Mar 2020 13:18:56 +0100 (CET)
X-Auth-Info: 36mG5rV5unE/6I7rRTDnY+xJnd34FsjeHM1hXyvCHi4=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  3 Mar 2020 13:18:56 +0100 (CET)
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>
References: <20200303073715.32301-1-o.rempel@pengutronix.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <0c95d6ac-b345-4218-ebad-683fbf1f4d60@denx.de>
Date:   Tue, 3 Mar 2020 13:18:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200303073715.32301-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/20 8:37 AM, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> configured in device tree by setting compatible =
> "ethernet-phy-id0180.dc81".
> 
> PHY 1 has less suported registers and functionality. For current driver
> it will affect only the HWMON support.

Can't you do some magic with match_phy_device (like in
8b95599c55ed24b36cf44a4720067cfe67edbcb4) to discern the second half of
the PHY ?
