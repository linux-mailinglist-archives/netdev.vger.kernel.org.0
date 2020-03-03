Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F30541786A7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgCCXrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:47:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37196 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbgCCXrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:47:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A6A015AA817B;
        Tue,  3 Mar 2020 15:47:04 -0800 (PST)
Date:   Tue, 03 Mar 2020 15:47:04 -0800 (PST)
Message-Id: <20200303.154704.121901783577255281.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, olteanv@gmail.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] net: dsa: fix phylink_start()/phylink_stop()
 calls
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1j993K-0005kp-87@rmk-PC.armlinux.org.uk>
References: <E1j993K-0005kp-87@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 15:47:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 03 Mar 2020 15:01:46 +0000

> Place phylink_start()/phylink_stop() inside dsa_port_enable() and
> dsa_port_disable(), which ensures that we call phylink_stop() before
> tearing down phylink - which is a documented requirement.  Failure
> to do so can cause use-after-free bugs.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
> v2: reorder phylink_start() / phylink_stop() as per Andrew's comment.

Applied and queued up for -stable, thanks Russell.

The patch applied with some fuzz but still is correct, so I wonder
if you generated this against net-next or a tree with other local
changes?

Thanks again.
