Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459B01B52A3
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 04:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgDWClo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 22:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgDWClo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 22:41:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53573C03C1AB;
        Wed, 22 Apr 2020 19:41:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D91B127AE207;
        Wed, 22 Apr 2020 19:41:43 -0700 (PDT)
Date:   Wed, 22 Apr 2020 19:41:42 -0700 (PDT)
Message-Id: <20200422.194142.1298980987273597716.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marex@denx.de, david@protonic.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/4] add TJA1102 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422092456.24281-1-o.rempel@pengutronix.de>
References: <20200422092456.24281-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 19:41:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Wed, 22 Apr 2020 11:24:52 +0200

> changes v5:
> - rename __of_mdiobus_register_phy() to of_mdiobus_phy_device_register()
> 
> changes v4:
> - remove unused phy_id variable
> 
> changes v3:
> - export part of of_mdiobus_register_phy() and reuse it in tja11xx
>   driver
> - coding style fixes
> 
> changes v2:
> - use .match_phy_device
> - add irq support
> - add add delayed registration for PHY1

Series applied, thanks.
