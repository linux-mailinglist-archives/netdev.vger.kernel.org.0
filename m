Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C486339A20D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhFCNUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFCNUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:20:47 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900B7C06174A;
        Thu,  3 Jun 2021 06:18:49 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id l1so5122207pgm.1;
        Thu, 03 Jun 2021 06:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+v05ddpVQjkM5FXwTZxTFsnl47TDALq4e3yWHYc9svs=;
        b=UyGTFGI2i/mJW0bnNarf5Jqn6FNiGbhVNG0yaeFz8qFb3oFXlgCi0DQxrOZ+vEh0oO
         HLBJyzbzatByzclxwH2hB3KKuO+LxkxiI6jHtyHnwPzfNV0aWnvs7GEO2kmLBvpUvQn8
         QdQzDGHiWRy2XWTvfqZatJhZ9NZD4XCyMYH3RB1DIzf3q71ZoxNAjvjJ5V0O2boF2Py8
         xplrCvG5zhspApy4K8ExkjIdDE/bEtbAraHblCoEeFtooshFqft5TfCXrxGH3+tCEyUv
         e7v4oedAt9eTcPAJo8ng4yeNTBzsdQ2IAvgk9tfYF0DFSBWpD/IENgNQCBsGWH7nAuHS
         bH6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+v05ddpVQjkM5FXwTZxTFsnl47TDALq4e3yWHYc9svs=;
        b=o9PYz1ugVDjdM74Rc1C1U4zqTrvt9KxZuAmxScCDY6wjHyPuEdkjyjHpxnlldv1acw
         H8mZmkDo1eFQuFBrWlWNODusMXT/khamUG/HDxoHNoIp9z2B38fHVIHvB7ChUFhAnR92
         ivi0fJo3lMVWCTCh/7TUMEBVFqSTP70xwoEbDr5R4TM24+QkuN0JUBW3oClSF+L55myN
         cHSPTTjIMtXBe5NBVUxRIGjMOE6kI28f8J21jquNA/Tyei84fymnIo7KqgVGoF5WCKHE
         4pMSVg2N5FhD+NFlh/N9+ayGck9lY4A4v8IUNmo/HxzgZgsrj97e6ujrpSmQT1Dfvw7/
         bN9Q==
X-Gm-Message-State: AOAM531sUK7n1q+VzyIVmT33K+A7k8IEmr/434Ks/Ynby2AGwJSqyfmz
        vfLqggwvAA8mtDkGl5tCy10=
X-Google-Smtp-Source: ABdhPJxwM7ck8TRJ0tUZqd2HiFvKRA9gKtxvJt4CzpThdhZVr3Ba1kkPC9nomnmxLyRiyz7xTN85tQ==
X-Received: by 2002:a63:78d:: with SMTP id 135mr12738665pgh.178.1622726329115;
        Thu, 03 Jun 2021 06:18:49 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k70sm2845444pgd.41.2021.06.03.06.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:18:48 -0700 (PDT)
Date:   Thu, 3 Jun 2021 06:18:46 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210603131846.GB6216@hoboy.vegasvil.org>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:

> +static int hclge_ptp_create_clock(struct hclge_dev *hdev)
> +{
> +#define HCLGE_PTP_NAME_LEN	32
> +
> +	struct hclge_ptp *ptp;
> +
> +	ptp = devm_kzalloc(&hdev->pdev->dev, sizeof(*ptp), GFP_KERNEL);
> +	if (!ptp)
> +		return -ENOMEM;
> +
> +	ptp->hdev = hdev;
> +	snprintf(ptp->info.name, HCLGE_PTP_NAME_LEN, "%s",
> +		 HCLGE_DRIVER_NAME);
> +	ptp->info.owner = THIS_MODULE;
> +	ptp->info.max_adj = HCLGE_PTP_CYCLE_ADJ_MAX;
> +	ptp->info.n_ext_ts = 0;
> +	ptp->info.pps = 0;
> +	ptp->info.adjfreq = hclge_ptp_adjfreq;
> +	ptp->info.adjtime = hclge_ptp_adjtime;
> +	ptp->info.gettimex64 = hclge_ptp_gettimex;
> +	ptp->info.settime64 = hclge_ptp_settime;
> +
> +	ptp->info.n_alarm = 0;
> +	ptp->clock = ptp_clock_register(&ptp->info, &hdev->pdev->dev);
> +	if (IS_ERR(ptp->clock)) {
> +		dev_err(&hdev->pdev->dev, "%d failed to register ptp clock, ret = %ld\n",
> +			ptp->info.n_alarm, PTR_ERR(ptp->clock));
> +		return PTR_ERR(ptp->clock);
> +	}

You must handle the case where NULL is returned.

 * ptp_clock_register() - register a PTP hardware clock driver
 *
 * @info:   Structure describing the new clock.
 * @parent: Pointer to the parent device of the new clock.
 *
 * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
 * support is missing at the configuration level, this function
 * returns NULL, and drivers are expected to gracefully handle that
 * case separately.

> +
> +	ptp->io_base = hdev->hw.io_base + HCLGE_PTP_REG_OFFSET;
> +	ptp->ts_cfg.rx_filter = HWTSTAMP_FILTER_NONE;
> +	ptp->ts_cfg.tx_type = HWTSTAMP_TX_OFF;
> +	hdev->ptp = ptp;
> +
> +	return 0;
> +}

Thanks,
Richard
