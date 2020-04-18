Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CF1AF5AC
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgDRWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:51:06 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603DCC061A0C;
        Sat, 18 Apr 2020 15:51:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB81712783B1C;
        Sat, 18 Apr 2020 15:51:05 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:51:05 -0700 (PDT)
Message-Id: <20200418.155105.298011645985222996.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com,
        scott.branden@broadcom.com, murali.policharla@broadcom.com,
        taoren@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: broadcom: Add support for BCM53125
 internal PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417183805.8702-1-f.fainelli@gmail.com>
References: <20200417183805.8702-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:51:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 17 Apr 2020 11:38:02 -0700

> BCM53125 has internal Gigabit PHYs which support interrupts as well as
> statistics, make it possible to configure both of those features with a
> PHY driver entry.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
