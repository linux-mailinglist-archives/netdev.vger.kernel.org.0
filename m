Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755642B9F7F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 02:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKTBAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 20:00:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40210 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgKTBAB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 20:00:01 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfumF-0082QI-Im; Fri, 20 Nov 2020 01:59:51 +0100
Date:   Fri, 20 Nov 2020 01:59:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     lkp@intel.com, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v10 3/4] net: dsa: mv88e6xxx: Change serdes lane
 parameter from  u8 type to int
Message-ID: <20201120005951.GZ1804098@lunn.ch>
References: <cover.1605830552.git.pavana.sharma@digi.com>
 <eff598a6313c0d2ad2a58227063adf86d0c10e90.1605830552.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eff598a6313c0d2ad2a58227063adf86d0c10e90.1605830552.git.pavana.sharma@digi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -459,7 +459,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
>  		chip->ports[port].cmode = cmode;
>  
>  		lane = mv88e6xxx_serdes_get_lane(chip, port);
> -		if (!lane)
> +		if (lane < 0)
>  			return -ENODEV;

return lane

since lane is an errno.

Other than that:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
