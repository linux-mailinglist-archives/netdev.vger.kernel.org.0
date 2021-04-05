Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87C5354511
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242340AbhDEQTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238813AbhDEQTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:19:50 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6DAC061756
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 09:19:43 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso1208993pje.0
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 09:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/tb2jlZ7+YuXI73kMhD8Jy9hH8fbTpZC6POGrk08Oow=;
        b=16oD33owJm3FjZtll8SwqbJQJVNYfH1wAidDOQiQ153aD+mxMchCL4/aogAYfbTpTd
         ufZeXirc+qME/XVd0M4qGaZdvYWmepJv73qFR/GUt6kMV8DyFhwbLM11cjwyJfVjF9QE
         EYiZLmSJQ2Prc+EpBvJj6dpye22+2AlPeDy0Bs9xtkYwuZss0Ij4JZnNsYTH/kNs4DKm
         4xk0Cw6R9xSvYYKsmUkRRLyk1HvQW0sdUfPndDlt2bN4sbWVALzuIeoOSYBCY2uzAram
         eebiOmfLzyGULjnFDy5mJIEuE2yBE29oKaYsAM7pF1PnIy0AuJexIyIShh+5bWie27+Z
         XGbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/tb2jlZ7+YuXI73kMhD8Jy9hH8fbTpZC6POGrk08Oow=;
        b=A4qnpf7PX9t+bevUJ7ZxerLDAtskkXxEXWZFzQajzHkTmhPlfgN53aUhzsExEN1exh
         CXTXahZK6aLQ+ZaJEU3umK5cd9zR4nzdZ2IcuUE88H5833WGmZL3m5eIetcA3geXv75M
         sgNFU3aumfPZTdMUv/BQk8Rj4ldQJzKEGW3X8/cIhBNO3nctJSbWhkoPPqQVDMV2Ue+W
         449GNtV15aPFUsjmT8GmeDl1wCVK2kv2Gn2wa5JhWaP0IzcAjFACiUUSTrDCcnRlQZXX
         ef+v3+rzPzzf3VF7TilH540T8K6ggiJjvLb2gZ5qXMpsiS+aX6OXKW9MxPDIdw/NJanq
         2v8w==
X-Gm-Message-State: AOAM532FFNaMrImm9iSbz1bo9/fSj2ixAEr1gjxzz+eDKbJEaE3YMhTI
        KAdC95ytaz+rYjCRBvB0b9kZkQ==
X-Google-Smtp-Source: ABdhPJzZtauT9RKtTiaoRBRofIciZEORUDkYDgkTLo51NURog43rFwEs5LNxseLm14iE83hGFMb0pQ==
X-Received: by 2002:a17:90a:fc95:: with SMTP id ci21mr7637891pjb.14.1617639583455;
        Mon, 05 Apr 2021 09:19:43 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r16sm16582844pfq.211.2021.04.05.09.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 09:19:42 -0700 (PDT)
Subject: Re: [PATCH net-next 05/12] ionic: add hw timestamp support files
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-6-snelson@pensando.io>
 <20210404232127.GC24720@hoboy.vegasvil.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <83978196-f5d8-e6b1-7493-a3e498633d6d@pensando.io>
Date:   Mon, 5 Apr 2021 09:19:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210404232127.GC24720@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/4/21 4:21 PM, Richard Cochran wrote:
> On Thu, Apr 01, 2021 at 10:56:03AM -0700, Shannon Nelson wrote:
>
>> +int ionic_lif_hwstamp_set(struct ionic_lif *lif, struct ifreq *ifr)
>> +{
>> +	struct ionic *ionic = lif->ionic;
>> +	struct hwtstamp_config config;
>> +	int tx_mode = 0;
>> +	u64 rx_filt = 0;
>> +	int err, err2;
>> +	bool rx_all;
>> +	__le64 mask;
>> +
>> +	if (!lif->phc || !lif->phc->ptp)
>> +		return -EOPNOTSUPP;
>> +
>> +	if (ifr) {
>> +		if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
>> +			return -EFAULT;
>> +	} else {
>> +		/* if called with ifr == NULL, behave as if called with the
>> +		 * current ts_config from the initial cleared state.
>> +		 */
>> +		memcpy(&config, &lif->phc->ts_config, sizeof(config));
>> +		memset(&lif->phc->ts_config, 0, sizeof(config));
>> +	}
>> +
>> +	tx_mode = ionic_hwstamp_tx_mode(config.tx_type);
>> +	if (tx_mode < 0)
>> +		return tx_mode;
>> +
>> +	mask = cpu_to_le64(BIT_ULL(tx_mode));
>> +	if ((ionic->ident.lif.eth.hwstamp_tx_modes & mask) != mask)
>> +		return -ERANGE;
>> +
>> +	rx_filt = ionic_hwstamp_rx_filt(config.rx_filter);
>> +	rx_all = config.rx_filter != HWTSTAMP_FILTER_NONE && !rx_filt;
>> +
>> +	mask = cpu_to_le64(rx_filt);
>> +	if ((ionic->ident.lif.eth.hwstamp_rx_filters & mask) != mask) {
>> +		rx_filt = 0;
>> +		rx_all = true;
>> +		config.rx_filter = HWTSTAMP_FILTER_ALL;
>> +	}
>> +
>> +	dev_dbg(ionic->dev, "config_rx_filter %d rx_filt %#llx rx_all %d\n",
>> +		config.rx_filter, rx_filt, rx_all);
>> +
>> +	mutex_lock(&lif->phc->config_lock);
>> +
>> +	if (tx_mode) {
>> +		err = ionic_lif_create_hwstamp_txq(lif);
> This function NDE yet.  It first appears in Patch #6.  Please make
> sure each patch compiles.  That way, bisection always works.
>
> Thanks,
> Richard

This patch simply gets the file into the repo, it isn't yet mentioned in 
the Makefile so there is no broken compile.  This was just as a way of 
making patch 6 a little smaller.

sln

