Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6BE141D97
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgASLbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:31:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgASLbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:31:20 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 697F214C823DF;
        Sun, 19 Jan 2020 03:31:18 -0800 (PST)
Date:   Fri, 17 Jan 2020 04:18:15 -0800 (PST)
Message-Id: <20200117.041815.1098432693191653265.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next] net: dsa: felix: Don't restart PCS SGMII AN
 if not needed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200116180959.29844-1-olteanv@gmail.com>
References: <20200116180959.29844-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 03:31:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 16 Jan 2020 20:09:59 +0200

> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> Some PHYs like VSC8234 don't like it when AN restarts on their system side
> and they restart line side AN too, going into an endless link up/down loop.
> Don't restart PCS AN if link is up already.
> 
> Although in theory this feedback loop should be possible with the other
> in-band AN modes too, for some reason it was not seen with the VSC8514
> QSGMII and AQR412 USXGMII PHYs. So keep this logic only for SGMII where
> the problem was found.
> 
> Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
> Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied.
