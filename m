Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB90F141D98
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgASLbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47420 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgASLbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:21 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2995D14C850B4;
        Sun, 19 Jan 2020 03:31:20 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:23:53 -0800 (PST)
Message-Id: <20200117.042353.544899187026083387.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH v2 net-next] net: dsa: felix: Don't error out on
 disabled ports with no phy-mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116184153.12301-1-olteanv@gmail.com>
References: <20200116184153.12301-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 16 Jan 2020 20:41:53 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The felix_parse_ports_node function was tested only on device trees
> where all ports were enabled. Fix this check so that the driver
> continues to probe only with the ports where status is not "disabled",
> as expected.
> 
> Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> - Use for_each_available_child_of_node instead of open-coding the
>   of_device_is_available check.

Applied.
