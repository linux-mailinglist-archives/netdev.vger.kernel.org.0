Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D78E142738
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 10:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgATJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 04:27:30 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55096 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgATJ1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 04:27:30 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4DE1153D4BFE;
        Mon, 20 Jan 2020 01:27:27 -0800 (PST)
Date:   Mon, 20 Jan 2020 10:27:26 +0100 (CET)
Message-Id: <20200120.102726.1895329023642901606.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        alexandru.marginean@nxp.com
Subject: Re: [PATCH v2 net-next] net: phylink: allow in-band AN for USXGMII
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200118121915.7762-1-olteanv@gmail.com>
References: <20200118121915.7762-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jan 2020 01:27:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 18 Jan 2020 14:19:15 +0200

> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> USXGMII supports passing link information in-band between PHY and MAC PCS,
> add it to the list of protocols that support in-band AN mode.
> 
> Being a MAC-PHY protocol that can auto-negotiate link speeds up to 10
> Gbps, we populate the initial supported mask with the entire spectrum of
> link modes up to 10G that PHYLINK supports, and we let the driver reduce
> that mask in its .phylink_validate method.
> 
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> - copied netdev list
> - Reordered USXGMII with 10GKR

Applied, thanks.
