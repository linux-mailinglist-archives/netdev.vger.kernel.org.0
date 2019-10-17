Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 439C8DA2E7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405773AbfJQBBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:01:47 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43713 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbfJQBBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:01:47 -0400
Received: by mail-lj1-f195.google.com with SMTP id n14so624922ljj.10
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=daN3obtjENRpw5pJpmfFu2gPN5OuhsMgOeM8JAF4Mtc=;
        b=IybOYx2p2o8NsZhXgMSv16Pyebz8VxTp5bNtDT9z6VBtzUvMQp1B8BGTWz0obGe3oO
         kmvdDR/326rTEvDfBeEgGB7KOGoAiytVkFN1Ov72CF6KSefEGgi03XWbAaNBhS9Fo8L7
         JUT9dRAqDjzeHrkF+/I2QhAvG+W9EvLBA7QL99gZp1QQUSVvkR0YYvTUbkuFkM7+E0PR
         AAPjqml0NRne9eRyR5Lgns3L7gAUj9AyOTiRDw2xrvtvCtVQr4rtyOwsRAGut15CEmhK
         JJYkPomw49k2/7BmUDvpsCz88iK528h83BZoes98Z2a+aOZiMWFTIO6OAT04Yc0A9cC8
         rWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=daN3obtjENRpw5pJpmfFu2gPN5OuhsMgOeM8JAF4Mtc=;
        b=nDaxpK3CBS1g3v3Oa2zjIKGrBE5CS8jUEYwJuFRvcF4WnnLEzVSm60Y9K3hPa69qDM
         xxNDaGggV/P0P6AEoYfEEGqYEc0By/Npw9/ljaFxHsGtbxCPSbPngGRQXcEo+1JsFH50
         UT49OYnlhF3l0WNPxMl8hEj52NfgxUycAazEyW2gtttelBsQC35vUi3rrik7a7/BY3I3
         bPHycNmsa9n68qXEpusCCe459HEDv8bmRRg26X5OvE+n8Vzg4OH3aLOat9fQbHBC6sLA
         Km+/zDSNtLBBFBZ+fSXo7VnwAunJowCYBqmAka9TBjrqtKkVuQfBSSmfpz/qsmgKM/oF
         HMOw==
X-Gm-Message-State: APjAAAWigGwe1KZzwibc3p7i6lAv+Tnqu2JBNuCqBAO7+kGZHqkVYzFV
        IWaO5lXaQ7gFDbnbZlMWlhJzOQ==
X-Google-Smtp-Source: APXvYqyv0vjPJPUvNISdkPJv6ynbAnHnqfJfWOSKb3UNAlPMLrDu25antychnsSKPUlj1hqZzb9psg==
X-Received: by 2002:a2e:9d83:: with SMTP id c3mr547577ljj.237.1571274105357;
        Wed, 16 Oct 2019 18:01:45 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id h25sm219626lfj.81.2019.10.16.18.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:01:45 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:01:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 1/7] net: mvneta: introduce
 mvneta_update_stats routine
Message-ID: <20191016180137.4700dd77@cakuba.netronome.com>
In-Reply-To: <e8888c37e1c397801e3aa8485ce4103811f6a655.1571258792.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
        <e8888c37e1c397801e3aa8485ce4103811f6a655.1571258792.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:03:06 +0200, Lorenzo Bianconi wrote:
> Introduce mvneta_update_stats routine to collect {rx/tx} statistics
> (packets and bytes). This is a preliminary patch to add XDP support to
> mvneta driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 41 +++++++++++++--------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index e49820675c8c..128b9fded959 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1900,6 +1900,23 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
>  	}
>  }
>  
> +static void
> +mvneta_update_stats(struct mvneta_port *pp, u32 pkts,
> +		    u32 len, bool tx)
> +{
> +	struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
> +
> +	u64_stats_update_begin(&stats->syncp);
> +	if (tx) {
> +		stats->tx_packets += pkts;
> +		stats->tx_bytes += len;
> +	} else {
> +		stats->rx_packets += pkts;
> +		stats->rx_bytes += len;
> +	}
> +	u64_stats_update_end(&stats->syncp);
> +}
> +
>  static inline
>  int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
>  {
> @@ -2075,14 +2092,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		rxq->left_size = 0;
>  	}
>  
> -	if (rcvd_pkts) {

nit: you're getting rid of this check in the new helper, perhaps worth
     mentioning in the commit message why its irrelevant

> -		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
> -
> -		u64_stats_update_begin(&stats->syncp);
> -		stats->rx_packets += rcvd_pkts;
> -		stats->rx_bytes   += rcvd_bytes;
> -		u64_stats_update_end(&stats->syncp);
> -	}
> +	mvneta_update_stats(pp, rcvd_pkts, rcvd_bytes, false);
>  
>  	/* return some buffers to hardware queue, one at a time is too slow */
>  	refill = mvneta_rx_refill_queue(pp, rxq);

