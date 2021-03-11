Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE41033811D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhCKXMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:12:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52998 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCKXM3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 18:12:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lKUTh-00AQuB-EI; Fri, 12 Mar 2021 00:12:25 +0100
Date:   Fri, 12 Mar 2021 00:12:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] net: dsa: hellcreek: Add devlink FDB region
Message-ID: <YEqj2TU0h/6LahS9@lunn.ch>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
 <20210311175344.3084-7-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311175344.3084-7-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int hellcreek_setup_devlink_regions(struct dsa_switch *ds)
>  {
>  	struct hellcreek *hellcreek = ds->priv;
>  	struct devlink_region_ops *ops;
>  	struct devlink_region *region;
>  	u64 size;
> +	int ret;
>  
> +	/* VLAN table */
>  	size = VLAN_N_VID * sizeof(struct hellcreek_devlink_vlan_entry);
>  	ops  = &hellcreek_region_vlan_ops;

I think this comment belongs in the previous patch adding the VLAN
region.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
