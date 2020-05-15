Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EE71D5898
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 20:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEOSD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 14:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgEOSD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 14:03:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629AFC061A0C;
        Fri, 15 May 2020 11:03:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE43F14EF40A9;
        Fri, 15 May 2020 11:03:27 -0700 (PDT)
Date:   Fri, 15 May 2020 11:03:27 -0700 (PDT)
Message-Id: <20200515.110327.618691695451535144.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, marex@denx.de, david@protonic.nl
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: execute cable test on
 link up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514194218.22011-1-o.rempel@pengutronix.de>
References: <20200514194218.22011-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 May 2020 11:03:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Thu, 14 May 2020 21:42:18 +0200

> A typical 100Base-T1 link should be always connected. If the link is in
> a shot or open state, it is a failure. In most cases, we won't be able
> to automatically handle this issue, but we need to log it or notify user
> (if possible).
> 
> With this patch, the cable will be tested on "ip l s dev .. up" attempt
> and send ethnl notification to the user space.
> 
> This patch was tested with TJA1102 PHY and "ethtool --monitor" command.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied, thanks.
