Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1685832DF62
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhCEB6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:58:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41168 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhCEB6e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 20:58:34 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHzjZ-009MhE-3Z; Fri, 05 Mar 2021 02:58:29 +0100
Date:   Fri, 5 Mar 2021 02:58:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V2 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YEGQRW9cYK7pHOC7@lunn.ch>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1614884228-8542-2-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/* MODULE EEPROM DATA */
> +
> +enum {
> +	ETHTOOL_A_EEPROM_DATA_UNSPEC,
> +	ETHTOOL_A_EEPROM_DATA_HEADER,
> +
> +	ETHTOOL_A_EEPROM_DATA_OFFSET,
> +	ETHTOOL_A_EEPROM_DATA_LENGTH,
> +	ETHTOOL_A_EEPROM_DATA_PAGE,
> +	ETHTOOL_A_EEPROM_DATA_BANK,
> +	ETHTOOL_A_EEPROM_DATA_I2C_ADDRESS,
> +	ETHTOOL_A_EEPROM_DATA,

If you look at all the other such enums in ethtool_netlink, you will
see a comment indicating the type. Please add them here as well.

Please also update Documentation/networking/ethtool-netlink.rst.

       Andrew
