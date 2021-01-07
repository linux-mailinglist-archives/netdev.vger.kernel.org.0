Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE20F2ED5EE
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbhAGRp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:45:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728843AbhAGRp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:45:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxZLX-00Gikc-VT; Thu, 07 Jan 2021 18:45:15 +0100
Date:   Thu, 7 Jan 2021 18:45:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Subject: Re: [PATCH 1/3] usbnet: specify naming of
 usbnet_set/get_link_ksettings
Message-ID: <X/dIq16CQ6xe+dLh@lunn.ch>
References: <20210107113518.21322-1-oneukum@suse.com>
 <20210107113518.21322-2-oneukum@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107113518.21322-2-oneukum@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -int usbnet_get_link_ksettings(struct net_device *net,
> +/* These methods are written on the assumption that the device
> + * uses MII
> + */
> +int usbnet_get_link_ksettings_mdio(struct net_device *net,
>  			      struct ethtool_link_ksettings *cmd)

Hi Oliver

I would prefer this was called usbnet_get_link_ksettings_mii, since
this is using the old mii framework, not phylib and mdio drivers.  I
believe there are some USB drivers which do use mdio drivers and
phylib, and we should try to avoid getting things confused.

	Andrew
