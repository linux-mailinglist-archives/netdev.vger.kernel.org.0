Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2D4353A23
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 01:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhDDXVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 19:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbhDDXVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 19:21:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2175EC061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 16:21:31 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y2so4844677plg.5
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 16:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3N3lcZcoPVF9OSnmjUV5xm+gbDhKBnsLuiEGMvjITqg=;
        b=WlIsADIR7WnNvyTA7904bWyy6vuO/3TuDq57/JAwp7vt5cPDPu2FvuOqgFFhDL83Yv
         6GdeWriH3BUkxGntxN/WpziS2ebIfMRYnbPixRHio05PwzJnhwYIyHtZktxN5gMuoZzn
         bRWcPBE0zflIuyZ14+7qKZMt4UBPIGBFOGDTdWy8RaN+NWcw0cf5hyd/hrRi/JYefD5u
         NsfGJWqAgTlYLlU6GAunNeo9Z3or+fH0O8jv18GkKwoQ0u9HWulhf09ed46PTsnNNojM
         gcKIEYM33pf5AxVmHwuIBBK38w8o+ufKA/GcmquDN4fHRHKpXzR135e/romY/Rq9LNeu
         HfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3N3lcZcoPVF9OSnmjUV5xm+gbDhKBnsLuiEGMvjITqg=;
        b=mbXEEmbWixJH4rP4iVhImiPz5cvOwzXqafPtAP012Eyqpp5iAm8POIEDgC2W2gnHux
         +0Lxojaf3PVKeq97/iFFMv/UOW2Y26BKXDAK0vvS2Elva05CpiemnkvvuQYM9zOXuj4D
         MxOpq1+guBdxTULyOfNx3KopN72wcxWT2HOaXwNN7MlrLIrcgCBCQlr5vbAr5SSJnODq
         BAK9Enx2d+j1ZcMmzHQRAkt66uhYvbXITurBllidAKgGXFIN1xUEl9gzvpQNkB/N3e/3
         V1yTk6AtzwaYX3+Oo/Bwz2avxGO/OdLjLTETjtCU+cHnNQBULpZaz9+zXSr+cCi7NdMC
         2XOA==
X-Gm-Message-State: AOAM531o1GmR8NxvdScxy6Vz9MCwlirwBNDbScP7E6yNIbY7EnjCLcL6
        EAUyevOAzzgP6QSKzC/yAxU=
X-Google-Smtp-Source: ABdhPJwf2ZSP6IeJN2QxzDrl5/0FnxTbiVBxihVGxBaL4ho3lvEGH7EiH998KanWdaxO5oEYQ0owGQ==
X-Received: by 2002:a17:90a:7444:: with SMTP id o4mr7102694pjk.205.1617578490469;
        Sun, 04 Apr 2021 16:21:30 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j188sm14079471pfd.64.2021.04.04.16.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 16:21:29 -0700 (PDT)
Date:   Sun, 4 Apr 2021 16:21:27 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
Message-ID: <20210404232127.GC24720@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-6-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:56:03AM -0700, Shannon Nelson wrote:

> +int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
> +{
> +	struct ionic *ionic = lif->ionic;
> +	struct hwtstamp_config config;
> +	int tx_mode = 0;
> +	u64 rx_filt = 0;
> +	int err, err2;
> +	bool rx_all;
> +	__le64 mask;
> +
> +	if (!lif->phc || !lif->phc->ptp)
> +		return -EOPNOTSUPP;
> +
> +	if (ifr) {
> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
> +			return -EFAULT;
> +	} else {
> +		/* if called with ifr == NULL, behave as if called with the
> +		 * current ts_config from the initial cleared state.
> +		 */
> +		memcpy(&config, &lif->phc->ts_config, sizeof(config));
> +		memset(&lif->phc->ts_config, 0, sizeof(config));
> +	}
> +
> +	tx_mode = ionic_hwstamp_tx_mode(config.tx_type);
> +	if (tx_mode < 0)
> +		return tx_mode;
> +
> +	mask = cpu_to_le64(BIT_ULL(tx_mode));
> +	if ((ionic->ident.lif.eth.hwstamp_tx_modes & mask) != mask)
> +		return -ERANGE;
> +
> +	rx_filt = ionic_hwstamp_rx_filt(config.rx_filter);
> +	rx_all = config.rx_filter != HWTSTAMP_FILTER_NONE && !rx_filt;
> +
> +	mask = cpu_to_le64(rx_filt);
> +	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) != mask) {
> +		rx_filt = 0;
> +		rx_all = true;
> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
> +	}
> +
> +	dev_dbg(ionic->dev, "config_rx_filter %d rx_filt %#llx rx_all %d\n",
> +		config.rx_filter, rx_filt, rx_all);
> +
> +	mutex_lock(&lif->phc->config_lock);
> +
> +	if (tx_mode) {
> +		err = ionic_lif_create_hwstamp_txq(lif);

This function NDE yet.  It first appears in Patch #6.  Please make
sure each patch compiles.  That way, bisection always works.

Thanks,
Richard
