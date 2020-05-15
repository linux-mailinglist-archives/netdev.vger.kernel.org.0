Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF7D1D5B1A
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOU7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:59:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:35662 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgEOU7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 16:59:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 483C2ACAE;
        Fri, 15 May 2020 20:59:12 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 29B3E602F2; Fri, 15 May 2020 22:59:09 +0200 (CEST)
Date:   Fri, 15 May 2020 22:59:09 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        simon.horman@netronome.com, kernel-team@fb.com
Subject: Re: [PATCH net-next 2/3] nfp: don't check lack of RX/TX channels
Message-ID: <20200515205909.GG21714@lion.mk-sys.cz>
References: <20200515194902.3103469-1-kuba@kernel.org>
 <20200515194902.3103469-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515194902.3103469-3-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:49:01PM -0700, Jakub Kicinski wrote:
> Core will now perform this check.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index a5aa3219d112..6eb9fb9a1814 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -1438,8 +1438,7 @@ static int nfp_net_set_channels(struct net_device *netdev,
>  	unsigned int total_rx, total_tx;
>  
>  	/* Reject unsupported */
> -	if (!channel->combined_count ||
> -	    channel->other_count != NFP_NET_NON_Q_VECTORS ||
> +	if (channel->other_count != NFP_NET_NON_Q_VECTORS ||
>  	    (channel->rx_count && channel->tx_count))
>  		return -EINVAL;
>  
> -- 
> 2.25.4
> 
