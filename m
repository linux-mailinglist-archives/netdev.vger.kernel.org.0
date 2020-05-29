Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EBB1E882F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgE2TtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgE2TtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 15:49:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F4C03E969;
        Fri, 29 May 2020 12:49:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 66E2E1282FE36;
        Fri, 29 May 2020 12:48:59 -0700 (PDT)
Date:   Fri, 29 May 2020 12:48:58 -0700 (PDT)
Message-Id: <20200529.124858.1944254056553169947.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: marvell: unlock after
 phy_select_page() failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529100207.GB1304852@mwanda>
References: <20200529100207.GB1304852@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 12:48:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 29 May 2020 13:02:07 +0300

> We need to call phy_restore_page() even if phy_select_page() fails.
> Otherwise we are holding the phy_lock_mdio_bus() lock.  This requirement
> is documented at the start of the phy_select_page() function.
> 
> Fixes: a618e86da91d ("net : phy: marvell: Speedup TDR data retrieval by only changing page once")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
