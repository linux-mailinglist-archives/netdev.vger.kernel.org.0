Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD99C4720E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfFOUaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 16:30:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39304 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFOUaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 16:30:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C4F8F14EB7D5C;
        Sat, 15 Jun 2019 13:30:21 -0700 (PDT)
Date:   Sat, 15 Jun 2019 13:30:21 -0700 (PDT)
Message-Id: <20190615.133021.572699563162351841.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phylink: set the autoneg state in
 phylink_phy_change
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
References: <1560407871-5642-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 15 Jun 2019 13:30:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Thu, 13 Jun 2019 09:37:51 +0300

> The phy_state field of phylink should carry only valid information
> especially when this can be passed to the .mac_config callback.
> Update the an_enabled field with the autoneg state in the
> phylink_phy_change function.
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied and queued up for -stable, thanks.
