Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6F3234B48
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbgGaSlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:41:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387676AbgGaSlG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:41:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Zxp-007jEH-50; Fri, 31 Jul 2020 20:41:05 +0200
Date:   Fri, 31 Jul 2020 20:41:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Thompson <dthompson@mellanox.com>, f@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Asmaa Mnebhi <asmaa@mellanox.com>
Subject: Re: [PATCH net-next] Add Mellanox BlueField Gigabit Ethernet driver
Message-ID: <20200731184105.GH1748118@lunn.ch>
References: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596047355-28777-1-git-send-email-dthompson@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mlxbf_gige_mdio_read(struct mii_bus *bus, int phy_add, int phy_reg)
> +{
> +	struct mlxbf_gige *priv = bus->priv;
> +	u32 cmd;
> +	u32 ret;

Here and in write, please check if it is a C45 transaction request and
return -EOPNOTSUPP.

       Andrew
