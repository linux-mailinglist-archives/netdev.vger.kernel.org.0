Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9961F00D4
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgFEUPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:15:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAD0C08C5C2;
        Fri,  5 Jun 2020 13:15:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DDD0E127B0475;
        Fri,  5 Jun 2020 13:15:40 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:15:40 -0700 (PDT)
Message-Id: <20200605.131540.378563618447105158.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        kuba@kernel.org, linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael@walle.cc
Subject: Re: [PATCH net 0/4] Fixes for OF_MDIO flag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605140107.31275-1-dmurphy@ti.com>
References: <20200605140107.31275-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:15:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Fri, 5 Jun 2020 09:01:03 -0500

> There are some residual drivers that check the CONFIG_OF_MDIO flag using the
> if defs. Using this check does not work when the OF_MDIO is configured as a
> module. Using the IS_ENABLED macro checks if the flag is declared as built-in
> or as a module.

Series applied, thank you.
