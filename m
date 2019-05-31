Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF23119F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfEaPx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:53:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:49036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726601AbfEaPx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 11:53:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59C79B020;
        Fri, 31 May 2019 15:53:56 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 089D5E00E3; Fri, 31 May 2019 17:53:56 +0200 (CEST)
Date:   Fri, 31 May 2019 17:53:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, linville@redhat.com
Subject: Re: [PATCH v2 1/2] ethtool: sync ethtool-copy.h with linux-next from
 30/05/2019
Message-ID: <20190531155355.GG15954@unicorn.suse.cz>
References: <20190531135748.23740-1-andrew@lunn.ch>
 <20190531135748.23740-2-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531135748.23740-2-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 03:57:47PM +0200, Andrew Lunn wrote:
> Sync ethtool-copy.h with linux-next from 22/05/2019. This provides
> access to the new link modes for 100BaseT1 and 1000BaseT1.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

BtW, this differs from the file "make headers_install" produces in
net-next but only in white space so that it doesn't really matter and it
gets sorted in a future sync.

>  ethtool-copy.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/ethtool-copy.h b/ethtool-copy.h
> index 92ab10d65fc9..ad16e8f9c290 100644
> --- a/ethtool-copy.h
> +++ b/ethtool-copy.h
> @@ -1481,6 +1481,8 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_200000baseLR4_ER4_FR4_Full_BIT = 64,
>  	ETHTOOL_LINK_MODE_200000baseDR4_Full_BIT	 = 65,
>  	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
> +	ETHTOOL_LINK_MODE_100baseT1_Full_BIT             = 67,
> +	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT            = 68,
>  
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
> @@ -1597,7 +1599,7 @@ enum ethtool_link_mode_bit_indices {
>  
>  static __inline__ int ethtool_validate_speed(__u32 speed)
>  {
> -	return speed <= INT_MAX || speed == SPEED_UNKNOWN;
> +	return speed <= INT_MAX || speed == (__u32)SPEED_UNKNOWN;
>  }
>  
>  /* Duplex, half or full. */
> @@ -1710,6 +1712,9 @@ static __inline__ int ethtool_validate_duplex(__u8 duplex)
>  #define ETH_MODULE_SFF_8436		0x4
>  #define ETH_MODULE_SFF_8436_LEN		256
>  
> +#define ETH_MODULE_SFF_8636_MAX_LEN	640
> +#define ETH_MODULE_SFF_8436_MAX_LEN	640
> +
>  /* Reset flags */
>  /* The reset() operation must clear the flags for the components which
>   * were actually reset.  On successful return, the flags indicate the
> -- 
> 2.20.1
> 
