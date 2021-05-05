Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6442437335B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 02:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhEEAzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 20:55:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhEEAzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 20:55:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1le5nh-002Z5f-CW; Wed, 05 May 2021 02:54:05 +0200
Date:   Wed, 5 May 2021 02:54:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 11/20] net: dsa: qca8k: add GLOBAL_FC
 settings needed for qca8327
Message-ID: <YJHsrQdl2bIAFYC2@lunn.ch>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-11-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504222915.17206-11-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  struct qca8k_priv {
> +	u8 switch_revision;
>  	struct regmap *regmap;
>  	struct mii_bus *bus;
>  	struct ar8xxx_port_status port_sts[QCA8K_NUM_PORTS];

This belongs in some other patch.

     Andrew
