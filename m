Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB82EF740
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbhAHSU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:20:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57608 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728505AbhAHSUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 13:20:55 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxwMu-00GwoL-3K; Fri, 08 Jan 2021 19:20:12 +0100
Date:   Fri, 8 Jan 2021 19:20:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 03/10] net: dsa: add ops for devlink-sb
Message-ID: <X/iiXIfDD9KdEGoI@lunn.ch>
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108175950.484854-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 08, 2021 at 07:59:43PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Switches that care about QoS might have hardware support for reserving
> buffer pools for individual ports or traffic classes, and configuring
> their sizes and thresholds. Through devlink-sb (shared buffers), this is
> all configurable, as well as their occupancy being viewable.
> 
> Add the plumbing in DSA for these operations.
> 
> Individual drivers still need to call devlink_sb_register() with the
> shared buffers they want to expose. A helper was not created in DSA for
> this purpose (unlike, say, dsa_devlink_params_register), since in my
> opinion it does not bring any benefit over plainly calling
> devlink_sb_register() directly.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
