Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D804C802B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiCABNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiCABNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:13:18 -0500
Received: from relay.hostedemail.com (relay.a.hostedemail.com [64.99.140.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16866FD8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:12:37 -0800 (PST)
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id EB8C16D7;
        Tue,  1 Mar 2022 01:12:35 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf06.hostedemail.com (Postfix) with ESMTPA id 77B9F20015;
        Tue,  1 Mar 2022 01:12:29 +0000 (UTC)
Message-ID: <fe3c21a9c0178a2f0fcea698b8e6405a99747dea.camel@perches.com>
Subject: Re: [PATCH 03/10] staging: wfx: format comments on 100 columns
From:   Joe Perches <joe@perches.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Mon, 28 Feb 2022 17:12:28 -0800
In-Reply-To: <20220225112405.355599-4-Jerome.Pouiller@silabs.com>
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
         <20220225112405.355599-4-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 77muhtja19n3dsratymaanib3ctsb9fr
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 77B9F20015
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18rc9SVD0a5kXusMoMzjYsxOtCG3ORwyWA=
X-HE-Tag: 1646097149-871435
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-02-25 at 12:23 +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> A few comments were not yet formatted on 100 columns.

IMO, none of these changes are necessary or good changes.

80 columns is preferred.

Really comments should most always use 80 columns, and
only occasionally should code be more than 80 columns
and almost never should code be more than 100 columns.

> diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
[]
> @@ -117,9 +117,7 @@ static int wfx_tx_policy_get(struct wfx_vif *wvif, struct ieee80211_tx_rate *rat
>  	if (idx >= 0) {
>  		*renew = false;
>  	} else {
> -		/* If policy is not found create a new one using the oldest
> -		 * entry in "free" list
> -		 */
> +		/* If policy is not found create a new one using the oldest entry in "free" list */
>  		*renew = true;
>  		entry = list_entry(cache->free.prev, struct wfx_tx_policy, link);
>  		memcpy(entry->rates, wanted.rates, sizeof(entry->rates));
> @@ -494,9 +492,7 @@ void wfx_tx_confirm_cb(struct wfx_dev *wdev, const struct wfx_hif_cnf_tx *arg)
>  	wfx_tx_fill_rates(wdev, tx_info, arg);
>  	skb_trim(skb, skb->len - tx_priv->icv_size);
>  
> -	/* From now, you can touch to tx_info->status, but do not touch to
> -	 * tx_priv anymore
> -	 */
> +	/* From now, you can touch to tx_info->status, but do not touch to tx_priv anymore */
>  	/* FIXME: use ieee80211_tx_info_clear_status() */
>  	memset(tx_info->rate_driver_data, 0, sizeof(tx_info->rate_driver_data));
>  	memset(tx_info->pad, 0, sizeof(tx_info->pad));
> diff --git a/drivers/staging/wfx/queue.c b/drivers/staging/wfx/queue.c
[]
> @@ -210,8 +210,8 @@ bool wfx_tx_queues_has_cab(struct wfx_vif *wvif)
>  	if (wvif->vif->type != NL80211_IFTYPE_AP)
>  		return false;
>  	for (i = 0; i < IEEE80211_NUM_ACS; ++i)
> -		/* Note: since only AP can have mcast frames in queue and only
> -		 * one vif can be AP, all queued frames has same interface id
> +		/* Note: since only AP can have mcast frames in queue and only one vif can be AP,
> +		 * all queued frames has same interface id
>  		 */
>  		if (!skb_queue_empty_lockless(&wvif->tx_queue[i].cab))
>  			return true;
> @@ -253,9 +253,8 @@ static struct sk_buff *wfx_tx_queues_get_skb(struct wfx_dev *wdev)
>  			skb = skb_dequeue(&queues[i]->cab);
>  			if (!skb)
>  				continue;
> -			/* Note: since only AP can have mcast frames in queue
> -			 * and only one vif can be AP, all queued frames has
> -			 * same interface id
> +			/* Note: since only AP can have mcast frames in queue and only one vif can
> +			 * be AP, all queued frames has same interface id
>  			 */
>  			hif = (struct wfx_hif_msg *)skb->data;
>  			WARN_ON(hif->interface != wvif->id);


