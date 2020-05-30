Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79901E8C8E
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgE3Aar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgE3Aar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:30:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B1C03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 17:30:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A88B1287B52E;
        Fri, 29 May 2020 17:30:46 -0700 (PDT)
Date:   Fri, 29 May 2020 17:30:45 -0700 (PDT)
Message-Id: <20200529.173045.1832051198504656316.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH] net: ethtool: cabletest: Make
 ethnl_act_cable_test_tdr_cfg static
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528214324.853699-1-andrew@lunn.ch>
References: <20200528214324.853699-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 17:30:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Thu, 28 May 2020 23:43:24 +0200

> kbuild test robot is reporting:
> net/ethtool/cabletest.c:230:5: warning: no previous prototype for
> 
> Mark the function as static.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks Andrew.  Please put "net-next" or similar next time.

Also, a Fixes: tag would have been nice but I won't require it for
something like this.

Hmmm, I also just noticed how onerous that PHYLINK=y/n requirement
is for the ethtool netlink stuff :-/
