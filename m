Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDFCD8060
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 21:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbfJOTgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 15:36:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43541 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfJOTgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 15:36:13 -0400
Received: by mail-lj1-f194.google.com with SMTP id n14so21456979ljj.10
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 12:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dY9dTqORsmcdIYURqmKO8ynoME5yJtIxXo238v92LWw=;
        b=gC6OEG0u6XAww10PjR0blIHmsTp97uQavxaY7hExrc6u6Lb47wXtOWEenDGZ25k8Qf
         tKfZW36wuHhc3d0Rs/ddb/A5JxiIgeSonUbDybIUVrQs5fyBDJWvvaYiXJwTQzE6eJvS
         qbHmuIbRQNKjUdZL/2bPP7W9BavFaBQpgNWA979w0W6tmAPd5KhX+b6W4cidcoglqVqh
         YVbKwOJI31ljMvHJLxy1wvPVmyX6LQIAy2TrXGLidfY5hXVr7hktdOomT7+3zTtBzZHN
         PdusN5gM6mDYOku9R34QTxYzhwaAdwLILOLpnLEQQfenquTDkNVe9ZdaXYMrAyoWSPyk
         TxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dY9dTqORsmcdIYURqmKO8ynoME5yJtIxXo238v92LWw=;
        b=nnzr5kHwR1IAdSp7utNC96r4wM6twSFKPy3m4yTOd/2G9Sh8rRz5l/uz2PdaPHQkU9
         /1sAFQoa+/2QpTiTxKcG8qJyqHlpwtaErfejSi0unSC45VPX0EonNFJlluFaolxVVmJ2
         DHi/kPOADJmbwWstVP7L/Nyuwc9+P1giG42T3Agg5Q0iP+uR5TnWvOIYIiHjLkh8Z0Vu
         L5KZ8yJttUy7cBht8dxlH4L6IFYspF7lav1Ap2D1ZPBO0PtsSAAJXn0q/G7KOuDuPJjw
         xEz1PZh9V+wClUASl1WJSXcyFeAunS+jzhLjGWnSg6vFv1fxMHBsTbg+EWdEzEO5W6aQ
         RIyQ==
X-Gm-Message-State: APjAAAVjMg8JLHnqJtq/IHcrH57/D2aqFY1uxmDQCEu7iczocHC432Q1
        p43b7GT8kiyu53qC5EYEfILYwQ==
X-Google-Smtp-Source: APXvYqxoddFQcCgGM/JK7yqlZUcVJFdzMcf+DbMTc0KmvvsOestnfjUnpwM/gdNohvH9IPf5CIOX6Q==
X-Received: by 2002:a2e:970b:: with SMTP id r11mr22617492lji.56.1571168171488;
        Tue, 15 Oct 2019 12:36:11 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm5577691lfh.97.2019.10.15.12.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2019 12:36:11 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:36:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH v2 net 2/2] dpaa2-eth: Fix TX FQID values
Message-ID: <20191015123603.153a5322@cakuba.netronome.com>
In-Reply-To: <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
References: <1571045117-26329-1-git-send-email-ioana.ciornei@nxp.com>
        <1571045117-26329-3-git-send-email-ioana.ciornei@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Oct 2019 12:25:17 +0300, Ioana Ciornei wrote:
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> 
> Depending on when MC connects the DPNI to a MAC, Tx FQIDs may
> not be available during probe time.
> 
> Read the FQIDs each time the link goes up to avoid using invalid
> values. In case an error occurs or an invalid value is retrieved,
> fall back to QDID-based enqueueing.
> 
> Fixes: 1fa0f68c9255 ("dpaa2-eth: Use FQ-based DPIO enqueue API")
> Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - used reverse christmas tree ordering in update_tx_fqids
> 
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 42 ++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 5acd734a216b..c3c2c06195ae 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -1235,6 +1235,8 @@ static void dpaa2_eth_set_rx_taildrop(struct dpaa2_eth_priv *priv, bool enable)
>  	priv->rx_td_enabled = enable;
>  }
>  
> +static void update_tx_fqids(struct dpaa2_eth_priv *priv);
> 
>  static int link_state_update(struct dpaa2_eth_priv *priv)
>  {
>  	struct dpni_link_state state = {0};
> @@ -1261,6 +1263,7 @@ static int link_state_update(struct dpaa2_eth_priv *priv)
>  		goto out;
>  
>  	if (state.up) {
> +		update_tx_fqids(priv);
>  		netif_carrier_on(priv->net_dev);
>  		netif_tx_start_all_queues(priv->net_dev);
>  	} else {
> @@ -2533,6 +2536,45 @@ static int set_pause(struct dpaa2_eth_priv *priv)
>  	return 0;
>  }
>  
> +static void update_tx_fqids(struct dpaa2_eth_priv *priv)
> +{
> +	struct dpni_queue_id qid = {0};
> +	struct dpaa2_eth_fq *fq;
> +	struct dpni_queue queue;
> +	int i, j, err;
> +
> +	/* We only use Tx FQIDs for FQID-based enqueue, so check
> +	 * if DPNI version supports it before updating FQIDs
> +	 */
> +	if (dpaa2_eth_cmp_dpni_ver(priv, DPNI_ENQUEUE_FQID_VER_MAJOR,
> +				   DPNI_ENQUEUE_FQID_VER_MINOR) < 0)
> +		return;
> +
> +	for (i = 0; i < priv->num_fqs; i++) {
> +		fq = &priv->fq[i];
> +		if (fq->type != DPAA2_TX_CONF_FQ)
> +			continue;
> +		for (j = 0; j < dpaa2_eth_tc_count(priv); j++) {
> +			err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
> +					     DPNI_QUEUE_TX, j, fq->flowid,
> +					     &queue, &qid);
> +			if (err)
> +				goto out_err;
> +
> +			fq->tx_fqid[j] = qid.fqid;
> +			if (fq->tx_fqid[j] == 0)
> +				goto out_err;
> +		}
> +	}
> +
> +	return;
> +
> +out_err:
> +	netdev_info(priv->net_dev,
> +		    "Error reading Tx FQID, fallback to QDID-based enqueue");

Missing new line at the end of this message, I think.

> +	priv->enqueue = dpaa2_eth_enqueue_qd;

Should the enqueue be set to dpaa2_eth_enqueue_fq config was successful?
IOW if there is a transient error we should go back to the preferred
method?

> +}

