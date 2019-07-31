Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A6C7C01F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfGaLgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:36:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39047 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfGaLgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 07:36:39 -0400
Received: from cpe-2606-a000-111b-6140-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:6140::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hsmuG-0001kn-7d; Wed, 31 Jul 2019 07:36:34 -0400
Date:   Wed, 31 Jul 2019 07:36:04 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net] drop_monitor: Add missing uAPI file to MAINTAINERS
 file
Message-ID: <20190731113604.GC9823@hmswarspite.think-freely.org>
References: <20190731063819.10001-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731063819.10001-1-idosch@idosch.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:38:19AM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Fixes: 6e43650cee64 ("add maintainer for network drop monitor kernel service")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9f5b8bd4faf9..b540794cbd91 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11137,6 +11137,7 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  W:	https://fedorahosted.org/dropwatch/
>  F:	net/core/drop_monitor.c
> +F:	include/uapi/linux/net_dropmon.h
>  
>  NETWORKING DRIVERS
>  M:	"David S. Miller" <davem@davemloft.net>
> -- 
> 2.21.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

