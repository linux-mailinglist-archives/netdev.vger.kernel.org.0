Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9122241AD
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgGQRXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 13:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgGQRXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 13:23:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A50C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 10:23:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87145135A71AB;
        Fri, 17 Jul 2020 10:23:41 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:23:40 -0700 (PDT)
Message-Id: <20200717.102340.604950331268601832.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        ioana.ciornei@nxp.com, michael@walle.cc
Subject: Re: [PATCH net-next] net: phy: continue searching for C45 MMDs
 even if first returned ffff:ffff
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200712164815.1763532-1-olteanv@gmail.com>
References: <20200712164815.1763532-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 10:23:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 12 Jul 2020 19:48:15 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> At the time of introduction, in commit bdeced75b13f ("net: dsa: felix:
> Add PCS operations for PHYLINK"), support for the Lynx PCS inside Felix
> was relying, for USXGMII support, on the fact that get_phy_device() is
> able to parse the Lynx PCS "device-in-package" registers for this C45
> MDIO device and identify it correctly.
 ...
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied to net-next, thanks.
