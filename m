Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CCF20A889
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407648AbgFYXB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407645AbgFYXB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:01:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22AF3C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:01:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9627B153562EE;
        Thu, 25 Jun 2020 16:01:56 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:01:56 -0700 (PDT)
Message-Id: <20200625.160156.967214748111553612.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com, kuba@kernel.org,
        o.rempel@pengutronix.de
Subject: Re: [PATCH net-next] net: dsa/ar9331: convert to mac_link_up()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jo2X6-0005yf-55@rmk-PC.armlinux.org.uk>
References: <E1jo2X6-0005yf-55@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:01:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Wed, 24 Jun 2020 11:21:32 +0100

> Convert the ar9331 DSA driver to use the finalised link parameters in
> mac_link_up() rather than the parameters in mac_config().
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied.
