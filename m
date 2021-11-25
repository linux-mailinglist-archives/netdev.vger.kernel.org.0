Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA645DBD8
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 15:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhKYOG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 09:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbhKYOE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 09:04:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3130D6108F;
        Thu, 25 Nov 2021 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637848877;
        bh=OW8SXgLeaFycymHewB1JWt75n32rZJK31X0fmu6z5Ys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EEpjapNxyk9ig82xMriYB3IysGHM6ibS7TD0YKfuG0vydo2BKY9Kl2zgeK0gSoZvk
         4iwvQ2R3u+gtdUSi1wd/aZS+nCjr71sPzLX0KStwQ1usqLt81irRuMGgPsLUlrD0aJ
         sKSJyupd6obwbBE2AQ4OxGQ2DUdRbRTV/ShNWDgjZXgXTakVROvK5zgmqkbw96F43g
         hbQcLorlLgsfdPQg9D0V0aqc6ztOqRXatHdtytglI3OxqldrqQPHqZyuNQVHCyDViR
         H9blW643oFj6GXlUnRJohniC0sgR5Un1DKmBIURy6RxAGEQ9pHEa3DkVLNywP6ygAZ
         4y4N10WXWqN1A==
Date:   Thu, 25 Nov 2021 16:01:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hao Chen <chenhao288@hisilicon.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [net-next v2] net: ethtool: set a default driver name
Message-ID: <YZ+XJ0Z54qxcO4KO@unreal>
References: <20211125072544.32578-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125072544.32578-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:25:44PM +0800, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The netdev (e.g. ifb, bareudp), which not support ethtool ops
> (e.g. .get_drvinfo), we can use the rtnl kind as a default name.
> 
> ifb netdev may be created by others prefix, not ifbX.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Hao Chen <chenhao288@hisilicon.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Danielle Ratson <danieller@nvidia.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v1: https://lore.kernel.org/all/20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/ 
> ---
>  net/ethtool/ioctl.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
