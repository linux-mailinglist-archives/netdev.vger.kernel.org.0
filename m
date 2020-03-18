Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F321189489
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 04:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCRDi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 23:38:59 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:34446 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726478AbgCRDi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 23:38:59 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id EAA20121A;
        Wed, 18 Mar 2020 03:38:57 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:1:41:69:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2393:2559:2562:2639:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3871:3872:4250:4321:4605:5007:7576:10004:10848:11026:11232:11473:11657:11658:11914:12043:12048:12297:12438:12555:12663:12740:12760:12895:12986:13439:14659:21080:21451:21611:21627:21740:21966:21990:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: can70_6b2be4ea10100
X-Filterd-Recvd-Size: 14602
Received: from XPS-9350.home (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Wed, 18 Mar 2020 03:38:56 +0000 (UTC)
Message-ID: <8d9544fe6d413cdd600504e48f301e023b99e17b.camel@perches.com>
Subject: Re: [PATCH] bnx2x: fix spelling mistake "pauseable" -> "pausable"
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 17 Mar 2020 20:37:06 -0700
In-Reply-To: <20200317182921.482606-1-colin.king@canonical.com>
References: <20200317182921.482606-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-03-17 at 18:29 +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Bulk rename of variables and literal strings. No functional
> changes.

I'm not sure either spelling is a "real" word and
pauseable seems more intelligible and less likely
to be intended to be a typo of "possible" to me.

> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  .../net/ethernet/broadcom/bnx2x/bnx2x_dcb.c   | 84 +++++++++----------
>  .../net/ethernet/broadcom/bnx2x/bnx2x_dcb.h   |  6 +-
>  2 files changed, 45 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
> index 2c6ba046d2a8..fc15a4864077 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.c
> @@ -44,7 +44,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>  				       struct pg_help_data *help_data,
>  				       struct dcbx_ets_feature *ets,
>  				       u32 *pg_pri_orginal_spread);
> -static void bnx2x_dcbx_separate_pauseable_from_non(struct bnx2x *bp,
> +static void bnx2x_dcbx_separate_pausable_from_non(struct bnx2x *bp,
>  				struct cos_help_data *cos_data,
>  				u32 *pg_pri_orginal_spread,
>  				struct dcbx_ets_feature *ets);
> @@ -80,7 +80,7 @@ static void bnx2x_pfc_set(struct bnx2x *bp)
>  	/* Tx COS configuration */
>  	for (i = 0; i < bp->dcbx_port_params.ets.num_of_cos; i++)
>  		/*
> -		 * We configure only the pauseable bits (non pauseable aren't
> +		 * We configure only the pausable bits (non pausable aren't
>  		 * configured at all) it's done to avoid false pauses from
>  		 * network
>  		 */
> @@ -290,7 +290,7 @@ static void bnx2x_dcbx_get_ets_feature(struct bnx2x *bp,
>  
>  	/* Clean up old settings of ets on COS */
>  	for (i = 0; i < ARRAY_SIZE(bp->dcbx_port_params.ets.cos_params) ; i++) {
> -		cos_params[i].pauseable = false;
> +		cos_params[i].pausable = false;
>  		cos_params[i].strict = BNX2X_DCBX_STRICT_INVALID;
>  		cos_params[i].bw_tbl = DCBX_INVALID_COS_BW;
>  		cos_params[i].pri_bitmask = 0;
> @@ -335,12 +335,12 @@ static void  bnx2x_dcbx_get_pfc_feature(struct bnx2x *bp,
>  	   !GET_FLAGS(error, DCBX_LOCAL_PFC_ERROR | DCBX_LOCAL_PFC_MISMATCH |
>  			     DCBX_REMOTE_PFC_TLV_NOT_FOUND)) {
>  		bp->dcbx_port_params.pfc.enabled = true;
> -		bp->dcbx_port_params.pfc.priority_non_pauseable_mask =
> +		bp->dcbx_port_params.pfc.priority_non_pausable_mask =
>  			~(pfc->pri_en_bitmap);
>  	} else {
>  		DP(BNX2X_MSG_DCB, "DCBX_LOCAL_PFC_DISABLED\n");
>  		bp->dcbx_port_params.pfc.enabled = false;
> -		bp->dcbx_port_params.pfc.priority_non_pauseable_mask = 0;
> +		bp->dcbx_port_params.pfc.priority_non_pausable_mask = 0;
>  	}
>  }
>  
> @@ -1080,8 +1080,8 @@ bnx2x_dcbx_print_cos_params(struct bnx2x *bp,
>  	DP(BNX2X_MSG_DCB,
>  	   "pfc_fw_cfg->dcb_version %x\n", pfc_fw_cfg->dcb_version);
>  	DP(BNX2X_MSG_DCB,
> -	   "pdev->params.dcbx_port_params.pfc.priority_non_pauseable_mask %x\n",
> -	   bp->dcbx_port_params.pfc.priority_non_pauseable_mask);
> +	   "pdev->params.dcbx_port_params.pfc.priority_non_pausable_mask %x\n",
> +	   bp->dcbx_port_params.pfc.priority_non_pausable_mask);
>  
>  	for (cos = 0 ; cos < bp->dcbx_port_params.ets.num_of_cos ; cos++) {
>  		DP(BNX2X_MSG_DCB,
> @@ -1097,8 +1097,8 @@ bnx2x_dcbx_print_cos_params(struct bnx2x *bp,
>  		   cos, bp->dcbx_port_params.ets.cos_params[cos].strict);
>  
>  		DP(BNX2X_MSG_DCB,
> -		   "pdev->params.dcbx_port_params.ets.cos_params[%d].pauseable %x\n",
> -		   cos, bp->dcbx_port_params.ets.cos_params[cos].pauseable);
> +		   "pdev->params.dcbx_port_params.ets.cos_params[%d].pausable %x\n",
> +		   cos, bp->dcbx_port_params.ets.cos_params[cos].pausable);
>  	}
>  
>  	for (pri = 0; pri < LLFC_DRIVER_TRAFFIC_TYPE_MAX; pri++) {
> @@ -1182,7 +1182,7 @@ static inline void bnx2x_dcbx_add_to_cos_bw(struct bnx2x *bp,
>  		data->cos_bw += pg_bw;
>  }
>  
> -static void bnx2x_dcbx_separate_pauseable_from_non(struct bnx2x *bp,
> +static void bnx2x_dcbx_separate_pausable_from_non(struct bnx2x *bp,
>  			struct cos_help_data *cos_data,
>  			u32 *pg_pri_orginal_spread,
>  			struct dcbx_ets_feature *ets)
> @@ -1247,14 +1247,14 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>  	}
>  	/* single priority group */
>  	if (pg_help_data->data[0].pg < DCBX_MAX_NUM_PG_BW_ENTRIES) {
> -		/* If there are both pauseable and non-pauseable priorities,
> -		 * the pauseable priorities go to the first queue and
> -		 * the non-pauseable priorities go to the second queue.
> +		/* If there are both pausable and non-pausable priorities,
> +		 * the pausable priorities go to the first queue and
> +		 * the non-pausable priorities go to the second queue.
>  		 */
>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
>  			/* Pauseable */
>  			cos_data->data[0].pausable = true;
> -			/* Non pauseable.*/
> +			/* Non pausable.*/
>  			cos_data->data[1].pausable = false;
>  
>  			if (2 == num_of_dif_pri) {
> @@ -1274,7 +1274,7 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>  			}
>  
>  		} else if (IS_DCBX_PFC_PRI_ONLY_PAUSE(bp, pri_join_mask)) {
> -			/* If there are only pauseable priorities,
> +			/* If there are only pausable priorities,
>  			 * then one/two priorities go to the first queue
>  			 * and one priority goes to the second queue.
>  			 */
> @@ -1294,7 +1294,7 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>  			cos_data->data[1].pri_join_mask =
>  				(1 << ttp[LLFC_TRAFFIC_TYPE_FCOE]);
>  		} else
> -			/* If there are only non-pauseable priorities,
> +			/* If there are only non-pausable priorities,
>  			 * they will all go to the same queue.
>  			 */
>  			bnx2x_dcbx_ets_disabled_entry_data(bp,
> @@ -1302,9 +1302,9 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>  	} else {
>  		/* priority group which is not BW limited (PG#15):*/
>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
> -			/* If there are both pauseable and non-pauseable
> -			 * priorities, the pauseable priorities go to the first
> -			 * queue and the non-pauseable priorities
> +			/* If there are both pausable and non-pausable
> +			 * priorities, the pausable priorities go to the first
> +			 * queue and the non-pausable priorities
>  			 * go to the second queue.
>  			 */
>  			if (DCBX_PFC_PRI_GET_PAUSE(bp, pri_join_mask) >
> @@ -1326,8 +1326,8 @@ static void bnx2x_dcbx_2cos_limit_cee_single_pg_to_cos_params(struct bnx2x *bp,
>  			/* Non pause-able.*/
>  			cos_data->data[1].pausable = false;
>  		} else {
> -			/* If there are only pauseable priorities or
> -			 * only non-pauseable,* the lower priorities go
> +			/* If there are only pausable priorities or
> +			 * only non-pausable,* the lower priorities go
>  			 * to the first queue and the higher priorities go
>  			 * to the second queue.
>  			 */
> @@ -1375,19 +1375,19 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>  	u8 i = 0;
>  	u8 pg[DCBX_COS_MAX_NUM_E2] = { 0 };
>  
> -	/* If there are both pauseable and non-pauseable priorities,
> -	 * the pauseable priorities go to the first queue and
> -	 * the non-pauseable priorities go to the second queue.
> +	/* If there are both pausable and non-pausable priorities,
> +	 * the pausable priorities go to the first queue and
> +	 * the non-pausable priorities go to the second queue.
>  	 */
>  	if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask)) {
>  		if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp,
>  					 pg_help_data->data[0].pg_priority) ||
>  		    IS_DCBX_PFC_PRI_MIX_PAUSE(bp,
>  					 pg_help_data->data[1].pg_priority)) {
> -			/* If one PG contains both pauseable and
> -			 * non-pauseable priorities then ETS is disabled.
> +			/* If one PG contains both pausable and
> +			 * non-pausable priorities then ETS is disabled.
>  			 */
> -			bnx2x_dcbx_separate_pauseable_from_non(bp, cos_data,
> +			bnx2x_dcbx_separate_pausable_from_non(bp, cos_data,
>  					pg_pri_orginal_spread, ets);
>  			bp->dcbx_port_params.ets.enabled = false;
>  			return;
> @@ -1395,18 +1395,18 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>  
>  		/* Pauseable */
>  		cos_data->data[0].pausable = true;
> -		/* Non pauseable. */
> +		/* Non pausable. */
>  		cos_data->data[1].pausable = false;
>  		if (IS_DCBX_PFC_PRI_ONLY_PAUSE(bp,
>  				pg_help_data->data[0].pg_priority)) {
> -			/* 0 is pauseable */
> +			/* 0 is pausable */
>  			cos_data->data[0].pri_join_mask =
>  				pg_help_data->data[0].pg_priority;
>  			pg[0] = pg_help_data->data[0].pg;
>  			cos_data->data[1].pri_join_mask =
>  				pg_help_data->data[1].pg_priority;
>  			pg[1] = pg_help_data->data[1].pg;
> -		} else {/* 1 is pauseable */
> +		} else {/* 1 is pausable */
>  			cos_data->data[0].pri_join_mask =
>  				pg_help_data->data[1].pg_priority;
>  			pg[0] = pg_help_data->data[1].pg;
> @@ -1415,8 +1415,8 @@ static void bnx2x_dcbx_2cos_limit_cee_two_pg_to_cos_params(
>  			pg[1] = pg_help_data->data[0].pg;
>  		}
>  	} else {
> -		/* If there are only pauseable priorities or
> -		 * only non-pauseable, each PG goes to a queue.
> +		/* If there are only pausable priorities or
> +		 * only non-pausable, each PG goes to a queue.
>  		 */
>  		cos_data->data[0].pausable = cos_data->data[1].pausable =
>  			IS_DCBX_PFC_PRI_ONLY_PAUSE(bp, pri_join_mask);
> @@ -1507,23 +1507,23 @@ static void bnx2x_dcbx_2cos_limit_cee_three_pg_to_cos_params(
>  	u8 num_of_pri = LLFC_DRIVER_TRAFFIC_TYPE_MAX;
>  
>  	cos_data->data[0].pri_join_mask = cos_data->data[1].pri_join_mask = 0;
> -	/* If there are both pauseable and non-pauseable priorities,
> -	 * the pauseable priorities go to the first queue and the
> -	 * non-pauseable priorities go to the second queue.
> +	/* If there are both pausable and non-pausable priorities,
> +	 * the pausable priorities go to the first queue and the
> +	 * non-pausable priorities go to the second queue.
>  	 */
>  	if (IS_DCBX_PFC_PRI_MIX_PAUSE(bp, pri_join_mask))
> -		bnx2x_dcbx_separate_pauseable_from_non(bp,
> +		bnx2x_dcbx_separate_pausable_from_non(bp,
>  				cos_data, pg_pri_orginal_spread, ets);
>  	else {
>  		/* If two BW-limited PG-s were combined to one queue,
>  		 * the BW is their sum.
>  		 *
> -		 * If there are only pauseable priorities or only non-pauseable,
> +		 * If there are only pausable priorities or only non-pausable,
>  		 * and there are both BW-limited and non-BW-limited PG-s,
>  		 * the BW-limited PG/s go to one queue and the non-BW-limited
>  		 * PG/s go to the second queue.
>  		 *
> -		 * If there are only pauseable priorities or only non-pauseable
> +		 * If there are only pausable priorities or only non-pausable
>  		 * and all are BW limited, then	two priorities go to the first
>  		 * queue and one priority goes to the second queue.
>  		 *
> @@ -1796,7 +1796,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>  		p->strict = cos_data.data[i].strict;
>  		p->bw_tbl = cos_data.data[i].cos_bw;
>  		p->pri_bitmask = cos_data.data[i].pri_join_mask;
> -		p->pauseable = cos_data.data[i].pausable;
> +		p->pausable = cos_data.data[i].pausable;
>  
>  		/* sanity */
>  		if (p->bw_tbl != DCBX_INVALID_COS_BW ||
> @@ -1806,13 +1806,13 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>  
>  			if (CHIP_IS_E2(bp) || CHIP_IS_E3A0(bp)) {
>  
> -				if (p->pauseable &&
> +				if (p->pausable &&
>  				    DCBX_PFC_PRI_GET_NON_PAUSE(bp,
>  						p->pri_bitmask) != 0)
>  					BNX2X_ERR("Inconsistent config for pausable COS %d\n",
>  						  i);
>  
> -				if (!p->pauseable &&
> +				if (!p->pausable &&
>  				    DCBX_PFC_PRI_GET_PAUSE(bp,
>  						p->pri_bitmask) != 0)
>  					BNX2X_ERR("Inconsistent config for nonpausable COS %d\n",
> @@ -1820,7 +1820,7 @@ static void bnx2x_dcbx_fill_cos_params(struct bnx2x *bp,
>  			}
>  		}
>  
> -		if (p->pauseable)
> +		if (p->pausable)
>  			DP(BNX2X_MSG_DCB, "COS %d PAUSABLE prijoinmask 0x%x\n",
>  				  i, cos_data.data[i].pri_join_mask);
>  		else
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
> index 9a9517c0f703..6cfe0d50bcd0 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_dcb.h
> @@ -46,7 +46,7 @@ struct bnx2x_dcbx_cos_params {
>  #define BNX2X_DCBX_STRICT_INVALID			DCBX_COS_MAX_NUM
>  #define BNX2X_DCBX_STRICT_COS_HIGHEST			0
>  #define BNX2X_DCBX_STRICT_COS_NEXT_LOWER_PRI(sp)	((sp) + 1)
> -	u8	pauseable;
> +	u8	pausable;
>  };
>  
>  struct bnx2x_dcbx_pg_params {
> @@ -57,7 +57,7 @@ struct bnx2x_dcbx_pg_params {
>  
>  struct bnx2x_dcbx_pfc_params {
>  	u32 enabled;
> -	u32 priority_non_pauseable_mask;
> +	u32 priority_non_pausable_mask;
>  };
>  
>  struct bnx2x_dcbx_port_params {
> @@ -153,7 +153,7 @@ struct cos_help_data {
>  #define DCBX_STRICT_PRIORITY			(15)
>  #define DCBX_INVALID_COS_BW			(0xFFFFFFFF)
>  #define DCBX_PFC_PRI_NON_PAUSE_MASK(bp)		\
> -			((bp)->dcbx_port_params.pfc.priority_non_pauseable_mask)
> +			((bp)->dcbx_port_params.pfc.priority_non_pausable_mask)
>  #define DCBX_PFC_PRI_PAUSE_MASK(bp)		\
>  					((u8)~DCBX_PFC_PRI_NON_PAUSE_MASK(bp))
>  #define DCBX_PFC_PRI_GET_PAUSE(bp, pg_pri)	\

