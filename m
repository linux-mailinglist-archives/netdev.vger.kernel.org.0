Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07D421426A2
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgATJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:08:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54982 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgATJIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:08:48 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D227153D1F5D;
        Mon, 20 Jan 2020 01:08:46 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:08:44 +0100 (CET)
Message-Id: <20200120.100844.376820797624094847.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com
Subject: Re: [PATCH net-next] net: phy: don't crash in phy_read/_write_mmd
 without a PHY driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116174628.16821-1-olteanv@gmail.com>
References: <20200116174628.16821-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:08:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 16 Jan 2020 19:46:28 +0200

> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> The APIs can be used by Ethernet drivers without actually loading a PHY
> driver. This may become more widespread in the future with 802.3z
> compatible MAC PCS devices being locally driven by the MAC driver when
> configuring for a PHY mode with in-band negotiation.
> 
> Check that drv is not NULL before reading from it.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>

Applied, thank you.
