Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC7A13B290
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgANTDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:03:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46612 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbgANTDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:03:49 -0500
Received: from localhost (unknown [63.64.162.234])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F93F1523E3C0;
        Tue, 14 Jan 2020 11:03:48 -0800 (PST)
Date:   Tue, 14 Jan 2020 11:03:48 -0800 (PST)
Message-Id: <20200114.110348.814176165638046449.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mdio_bus: Simplify reset handling and extend to non-DT
 systems
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200113130529.15372-1-geert+renesas@glider.be>
References: <20200113130529.15372-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 11:03:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Mon, 13 Jan 2020 14:05:29 +0100

> Convert mdiobus_register_reset() from open-coded DT-only optional reset
> handling to reset_control_get_optional_exclusive().  This not only
> simplifies the code, but also adds support for lookup-based resets on
> non-DT systems.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next, thanks.
