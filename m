Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343FA369763
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhDWQtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:49:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWQtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 12:49:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZyzF-000hG0-7F; Fri, 23 Apr 2021 18:49:01 +0200
Date:   Fri, 23 Apr 2021 18:49:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH net-next 1/3] net: marvell: prestera: bump supported
 firmware version to 3.0
Message-ID: <YIL6feaar8Y/yOaZ@lunn.ch>
References: <20210423155933.29787-1-vadym.kochan@plvision.eu>
 <20210423155933.29787-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423155933.29787-2-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 06:59:31PM +0300, Vadym Kochan wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> New firmware version has some ABI and feature changes like:
> 
>     - LAG support
>     - initial L3 support
>     - changed events handling logic
> 
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> index 298110119272..80fb5daf1da8 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -13,7 +13,7 @@
>  
>  #define PRESTERA_MSG_MAX_SIZE 1500
>  
> -#define PRESTERA_SUPP_FW_MAJ_VER	2
> +#define PRESTERA_SUPP_FW_MAJ_VER	3
>  #define PRESTERA_SUPP_FW_MIN_VER	0

I could be reading the code wrong, but it looks like anybody with
firmware version 2 on their machine and this new driver version
results in the switch not probing? And if the switch does not probe,
do they have any networking to go get the new firmware version?

I think you need to provide some degree of backwards compatibly to
older firmware. Support version 2 and 3. When version 4 comes out,
drop support for version 2 in the driver etc.

     Andrew
