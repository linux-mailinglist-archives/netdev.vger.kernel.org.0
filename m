Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F969FF5AE
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 22:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfKPVCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 16:02:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfKPVCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 16:02:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D0121518AA65;
        Sat, 16 Nov 2019 13:02:07 -0800 (PST)
Date:   Sat, 16 Nov 2019 13:02:07 -0800 (PST)
Message-Id: <20191116.130207.18833339549640555.davem@davemloft.net>
To:     horatiu.vultur@microchip.com
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: mscc: ocelot: omit error check from
 of_get_phy_mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115101115.31392-1-horatiu.vultur@microchip.com>
References: <20191115101115.31392-1-horatiu.vultur@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 13:02:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Fri, 15 Nov 2019 11:11:15 +0100

> The commit 0c65b2b90d13c ("net: of_get_phy_mode: Change API to solve
> int/unit warnings") updated the function of_get_phy_mode declaration.
> Now it returns an error code and in case the node doesn't contain the
> property 'phy-mode' or 'phy-connection-type' it returns -EINVAL and would
> set the phy_interface_t to PHY_INTERFACE_MODE_NA.
> 
> Ocelot VSC7514 has 4 internal phys which have the phy interface
> PHY_INTERFACE_MODE_NA. So because of_get_phy_mode would assign
> PHY_INTERFACE_MODE_NA to phy_mode when there is an error, there is no need
> to add the error check.
> 
> Updates for v2:
>  - drop error check because of_get_phy_mode already assigns phy_interface
>    to PHY_INTERFACE_MODE in case of error.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Applied, thank you.
