Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB29E23AFE9
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgHCWBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgHCWBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:01:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20C0C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:01:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 732181276E716;
        Mon,  3 Aug 2020 14:44:59 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:01:43 -0700 (PDT)
Message-Id: <20200803.150143.1814094529162821629.davem@davemloft.net>
To:     bruno.thomsen@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, festevam@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        laa@kamstrup.com, bth@kamstrup.com
Subject: Re: [PATCH v2 0/4 net-next] Improve MDIO Ethernet PHY reset
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200730195749.4922-1-bruno.thomsen@gmail.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 14:44:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruno Thomsen <bruno.thomsen@gmail.com>
Date: Thu, 30 Jul 2020 21:57:45 +0200

> This patch series is a result of trying to upstream a new device
> tree for a TQMa7D based board[1][2]. Initial this DTS used some
> deprecated PHY reset properties on the FEC device; NXP Ethernet
> MAC also known as Freescale Fast Ethernet Controller.
> 
> When switching from FEC properties[3]:
> "phy-reset-gpios"
> "phy-reset-duration"
> "phy-reset-post-delay"
> 
> To MDIO PHY properties[4]:
> "reset-gpios"
> "reset-assert-us"
> "reset-deassert-us"
> 
> The result was that no Ethernet PHY device was detected on boot.
> 
> This issue could be worked around by disabling PHY type ID auto-
> detection by using "ethernet-phy-id0022.1560" as compatible
> string and not "ethernet-phy-ieee802.3-c22".
> 
> Upstreaming a DTS with this workaround was not accepted, so I
> digged into the MDIO reset flow and found that it had a few
> missing parts compared to the deprecated FEC reset function.
> After some more testing and logic analyzer traces it was
> revealed that the failed PHY communication was due to missing
> initial device reset.
 ...

Series applied, thank you.
