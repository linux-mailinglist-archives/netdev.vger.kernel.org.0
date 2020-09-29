Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C1927C18B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgI2JqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:46:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36616 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgI2JqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:46:03 -0400
X-Greylist: delayed 405 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 05:46:02 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 3E215AB553;
        Tue, 29 Sep 2020 09:39:17 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E57CC60068;
        Tue, 29 Sep 2020 09:39:16 +0000 (UTC)
Received: from us4-mdac16-23.ut7.mdlocal (unknown [10.7.65.247])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E477E2009A;
        Tue, 29 Sep 2020 09:39:16 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.34])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 641B91C0052;
        Tue, 29 Sep 2020 09:39:16 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D977F600061;
        Tue, 29 Sep 2020 09:39:15 +0000 (UTC)
Received: from mh-desktop (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 10:39:09 +0100
Date:   Tue, 29 Sep 2020 10:39:00 +0100
From:   Martin Habets <mhabets@solarflare.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     <linux-net-drivers@solarflare.com>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH net-next] sfc: replace in_interrupt() usage
Message-ID: <20200929093900.GA744783@mh-desktop>
Mail-Followup-To: Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <168a1f9e-cba4-69a8-9b29-5c121295e960@solarflare.com>
 <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e45d9556-2759-6f33-01a0-d1739ce5760d@solarflare.com>
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25674.003
X-TM-AS-Result: No-14.224600-8.000000-10
X-TMASE-MatchedRID: qsaWi0FWcYvoSitJVour/fX6vk0haZdNSeIjeghh/zPk1kyQDpEj8AVM
        9kPsaYx4cjMLlL2TSB93mhqEAvvV9KqKVUC4ufIxuwdUMMznEA8CPiT971fk7I5JUK9UdYkn7+h
        Y9l7Y+Owds0DxnQOL5QErJz3OIdKMGnqsZ8sRr2KElYPZNnLuEff6ZSoNZQrIwUqLhUY4dAIVAs
        f1+cZFJ5MfkJBtMpYZhcH4/RV0ZAxITqtSH9SWSfFCD/XOqpSbQ2+afbhb/SpwkdIrVt8X1Y3Ea
        5VcsfoBkUx/UvKOwM2dwbgSqOKjW+kfPO9/GUD1O/898KGmvbT2X2nyY2WSCV7puwv8+Drqxxj3
        91JlVj+5aogRwgmmutOC2PAZNoPtCFTjJ6qDvW5LIfps09VJ28tEPnVvPlFkROqr1drjnLnTflT
        vFEeDIcn+FFIj5hS6ijbjfDGXdUQh4UgUH4JX7APZZctd3P4BZwLLfALfnN1jyv+d0Z0OxQg9EZ
        sHcUj6L/mM2TkILPXl0ByOo0JQffEmjlQBhGaCU8KO1ajdBDySiza26cvwNJQSL3wNKmMrFfQL8
        ZvDsiNn6D/2y5V6NQY2O3Al38VGBBja7g4HU80BnSWdyp4eoeBefETzWLKxeUMkPpZu/kCjxYyR
        Ba/qJaTygpcqFEs8jaPj0W1qn0Q7AFczfjr/7NGHt67MA4ofXaRDO31+d1RLpkEBIh9UMhuvcGu
        VSi8Cg5WhyM2znYk=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.224600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25674.003
X-MDID: 1601372356-85VnqPVuZNgV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 09:05:52PM +0100, Edward Cree wrote:
> efx_ef10_try_update_nic_stats_vf() used in_interrupt() to figure out
>  whether it is safe to sleep (for MCDI) or not.
> The only caller from which it was not is efx_net_stats(), which can be
>  invoked under dev_base_lock from net-sysfs::netstat_show().
> So add a new update_stats_atomic() method to struct efx_nic_type, and
>  call it from efx_net_stats(), removing the need for
>  efx_ef10_try_update_nic_stats_vf() to behave differently for this case
>  (which it wasn't doing correctly anyway).
> For all nic_types other than EF10 VF, this method is NULL and so we
>  call the regular update_stats() methods, which are happy with being
>  called from atomic contexts.
> 
> Fixes: f00bf2305cab ("sfc: don't update stats on VF when called in atomic context")
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Reviewed-by: Martin Habets <mhabets@solarflare.com>

> ---
> Only compile-tested so far, because I'm waiting for my kernel to
>  finish rebuilding with CONFIG_DEBUG_ATOMIC_SLEEP which I'm hoping
>  is the right thing to detect the bug in the existing code.
> I also wasn't quite sure how to give credit to the thorough analysis
>  in the commit message of Sebastian's patch.  I don't think we have
>  a Whatever-by: tag to cover that, do we?
> And this doesn't include your GFP_KERNEL change, which should
>  probably go in separately if you take this.
> 
>  drivers/net/ethernet/sfc/ef10.c       | 22 +++++++++++++---------
>  drivers/net/ethernet/sfc/efx_common.c |  2 +-
>  drivers/net/ethernet/sfc/net_driver.h |  5 +++++
>  drivers/net/ethernet/sfc/nic_common.h |  7 +++++++
>  4 files changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index c9df2e96ebe4..b702ba5986dc 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -1871,15 +1871,6 @@ static int efx_ef10_try_update_nic_stats_vf(struct efx_nic *efx)
>  
>  	spin_unlock_bh(&efx->stats_lock);
>  
> -	if (in_interrupt()) {
> -		/* If in atomic context, cannot update stats.  Just update the
> -		 * software stats and return so the caller can continue.
> -		 */
> -		spin_lock_bh(&efx->stats_lock);
> -		efx_update_sw_stats(efx, stats);
> -		return 0;
> -	}
> -
>  	efx_ef10_get_stat_mask(efx, mask);
>  
>  	rc = efx_nic_alloc_buffer(efx, &stats_buf, dma_len, GFP_ATOMIC);
> @@ -1938,6 +1929,18 @@ static size_t efx_ef10_update_stats_vf(struct efx_nic *efx, u64 *full_stats,
>  	return efx_ef10_update_stats_common(efx, full_stats, core_stats);
>  }
>  
> +static size_t efx_ef10_update_stats_atomic_vf(struct efx_nic *efx, u64 *full_stats,
> +					      struct rtnl_link_stats64 *core_stats)
> +{
> +	struct efx_ef10_nic_data *nic_data = efx->nic_data;
> +
> +	/* In atomic context, cannot update HW stats.  Just update the
> +	 * software stats and return so the caller can continue.
> +	 */
> +	efx_update_sw_stats(efx, nic_data->stats);
> +	return efx_ef10_update_stats_common(efx, full_stats, core_stats);
> +}
> +
>  static void efx_ef10_push_irq_moderation(struct efx_channel *channel)
>  {
>  	struct efx_nic *efx = channel->efx;
> @@ -3998,6 +4001,7 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
>  	.finish_flr = efx_port_dummy_op_void,
>  	.describe_stats = efx_ef10_describe_stats,
>  	.update_stats = efx_ef10_update_stats_vf,
> +	.update_stats_atomic = efx_ef10_update_stats_atomic_vf,
>  	.start_stats = efx_port_dummy_op_void,
>  	.pull_stats = efx_port_dummy_op_void,
>  	.stop_stats = efx_port_dummy_op_void,
> diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
> index c256db241570..72a3f0e09f52 100644
> --- a/drivers/net/ethernet/sfc/efx_common.c
> +++ b/drivers/net/ethernet/sfc/efx_common.c
> @@ -602,7 +602,7 @@ void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
>  	struct efx_nic *efx = netdev_priv(net_dev);
>  
>  	spin_lock_bh(&efx->stats_lock);
> -	efx->type->update_stats(efx, NULL, stats);
> +	efx_nic_update_stats_atomic(efx, NULL, stats);
>  	spin_unlock_bh(&efx->stats_lock);
>  }
>  
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 47aa753e64bd..9f7dfdf708cf 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -1172,6 +1172,9 @@ struct efx_udp_tunnel {
>   * @describe_stats: Describe statistics for ethtool
>   * @update_stats: Update statistics not provided by event handling.
>   *	Either argument may be %NULL.
> + * @update_stats_atomic: Update statistics while in atomic context, if that
> + *	is more limiting than @update_stats.  Otherwise, leave %NULL and
> + *	driver core will call @update_stats.
>   * @start_stats: Start the regular fetching of statistics
>   * @pull_stats: Pull stats from the NIC and wait until they arrive.
>   * @stop_stats: Stop the regular fetching of statistics
> @@ -1316,6 +1319,8 @@ struct efx_nic_type {
>  	size_t (*describe_stats)(struct efx_nic *efx, u8 *names);
>  	size_t (*update_stats)(struct efx_nic *efx, u64 *full_stats,
>  			       struct rtnl_link_stats64 *core_stats);
> +	size_t (*update_stats_atomic)(struct efx_nic *efx, u64 *full_stats,
> +				      struct rtnl_link_stats64 *core_stats);
>  	void (*start_stats)(struct efx_nic *efx);
>  	void (*pull_stats)(struct efx_nic *efx);
>  	void (*stop_stats)(struct efx_nic *efx);
> diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
> index 82271f0b8627..b9cafe9cd568 100644
> --- a/drivers/net/ethernet/sfc/nic_common.h
> +++ b/drivers/net/ethernet/sfc/nic_common.h
> @@ -244,6 +244,13 @@ void efx_nic_update_stats(const struct efx_hw_stat_desc *desc, size_t count,
>  			  const unsigned long *mask, u64 *stats,
>  			  const void *dma_buf, bool accumulate);
>  void efx_nic_fix_nodesc_drop_stat(struct efx_nic *efx, u64 *stat);
> +static inline size_t efx_nic_update_stats_atomic(struct efx_nic *efx, u64 *full_stats,
> +						 struct rtnl_link_stats64 *core_stats)
> +{
> +	if (efx->type->update_stats_atomic)
> +		return efx->type->update_stats_atomic(efx, full_stats, core_stats);
> +	return efx->type->update_stats(efx, full_stats, core_stats);
> +}
>  
>  #define EFX_MAX_FLUSH_TIME 5000
>  

-- 
Martin Habets <mhabets@solarflare.com>
