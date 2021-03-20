Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7740342D42
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 15:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhCTOWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 10:22:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38530 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhCTOWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Mar 2021 10:22:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNcUw-00C3B8-OD; Sat, 20 Mar 2021 15:22:38 +0100
Date:   Sat, 20 Mar 2021 15:22:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Report switch name and ID
Message-ID: <YFYFLiwnXBeXhqgj@lunn.ch>
References: <20210320112715.8667-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210320112715.8667-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int hellcreek_devlink_info_get(struct dsa_switch *ds,
> +				      struct devlink_info_req *req,
> +				      struct netlink_ext_ack *extack)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +	int ret;
> +
> +	ret = devlink_info_driver_name_put(req, "hellcreek");
> +	if (ret)
> +		return ret;
> +
> +	return devlink_info_version_fixed_put(req,
> +					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
> +					      hellcreek->pdata->name);

>  static const struct hellcreek_platform_data de1soc_r1_pdata = {
> +	.name		 = "Hellcreek r4c30",

Hi Kurt

The two other DSA drivers which implement this keep the
DEVLINK_INFO_VERSION_GENERIC_ASIC_ID just the model name, mv88e6390,
SJA1105E for example. You have hellcreek in the driver name, so i
don't see a need to repeat it.

      Andrew
