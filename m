Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1888D1866D1
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 09:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgCPIoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 04:44:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730069AbgCPIoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 04:44:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A37F143243A6;
        Mon, 16 Mar 2020 01:44:33 -0700 (PDT)
Date:   Mon, 16 Mar 2020 01:44:32 -0700 (PDT)
Message-Id: <20200316.014432.1845198613759724217.davem@davemloft.net>
To:     o.rempel@pengutronix.de
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mark.rutland@arm.com, robh+dt@kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marex@denx.de, david@protonic.nl, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 0/4] add TJA1102 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313052252.25389-1-o.rempel@pengutronix.de>
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Mar 2020 01:44:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>
Date: Fri, 13 Mar 2020 06:22:48 +0100

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

Florian, please properly follow up in the discussion of patch #1 so that they
can implement support properly.

Thank you.
