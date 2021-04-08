Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0212358543
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhDHNuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:50:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231892AbhDHNuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:50:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUV2e-00FWgV-WB; Thu, 08 Apr 2021 15:49:52 +0200
Date:   Thu, 8 Apr 2021 15:49:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        alobakin@pm.me, meirl@mellanox.com, dmurphy@ti.com,
        mkubecek@suse.cz, f.fainelli@gmail.com, irusskikh@marvell.com,
        alexanderduyck@fb.com, magnus.karlsson@intel.com,
        ecree@solarflare.com, idosch@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next] ethtool: Move __ethtool_get_link_ksettings() to
 common file
Message-ID: <YG8KAOtjkpNuEPkN@lunn.ch>
References: <20210408105813.2555878-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408105813.2555878-1-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 01:58:13PM +0300, Danielle Ratson wrote:
> __ethtool_get_link_ksettings() function is shared by both ioctl and
> netlink ethtool interfaces.
> 
> Move it to net/ethtool/common.c file, which is the suitable place for
> a shared code.
> 
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Seems sensible.

Did you look to see what else is shared and should move? Rather than
doing it one function at a time, can we do it all at once?

    Andrew
