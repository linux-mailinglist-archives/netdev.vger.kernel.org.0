Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B05AF0BFE
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfKFCWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:22:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42220 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730562AbfKFCWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:22:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B306C1510457E;
        Tue,  5 Nov 2019 18:22:01 -0800 (PST)
Date:   Tue, 05 Nov 2019 18:22:01 -0800 (PST)
Message-Id: <20191105.182201.1863952899580900567.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, lkp@intel.com, sfr@canb.auug.org.au
Subject: Re: [PATCH net-next] net: ethernet: emac: Fix phy mode type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191105175323.12560-1-andrew@lunn.ch>
References: <20191105175323.12560-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 18:22:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue,  5 Nov 2019 18:53:23 +0100

> Pass a phy_interface_t to of_get_phy_mode(), by changing the type of
> phy_mode in the device structure. This then requires that
> zmii_attach() is also changes, since it takes a pointer to phy_mode.
> 
> Fixes: 0c65b2b90d13 ("net: of_get_phy_mode: Change API to solve int/unit warnings")
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied.
