Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22A9D84C3
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390017AbfJPAW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:22:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42232 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387839AbfJPAW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:22:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1C6C1203B44B;
        Tue, 15 Oct 2019 17:22:27 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:22:27 -0700 (PDT)
Message-Id: <20191015.172227.1754483638007790724.davem@davemloft.net>
To:     alexandre.belloni@bootlin.com
Cc:     vz@mleia.com, slemieux.tyco@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] net: lpc_eth: parse phy nodes from device tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191010204530.15150-2-alexandre.belloni@bootlin.com>
References: <20191010204530.15150-1-alexandre.belloni@bootlin.com>
        <20191010204530.15150-2-alexandre.belloni@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:22:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>
Date: Thu, 10 Oct 2019 22:45:30 +0200

> When connected to a micrel phy, phy_find_first doesn't work properly
> because the first phy found is on address 0, the broadcast address but, the
> first thing the phy driver is doing is disabling this broadcast address.
> The phy is then available only on address 1 but the mdio driver doesn't
> know about it.
> 
> Instead, register the mdio bus using of_mdiobus_register and try to find
> the phy description in device tree before falling back to phy_find_first.
> 
> This ultimately also allows to describe the interrupt the phy is connected
> to.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Please respond to Andrew's feedback.
