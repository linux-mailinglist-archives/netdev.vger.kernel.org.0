Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5502AD51EB
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbfJLS4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:56:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36843 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729324AbfJLS4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:56:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so7695251pgk.3
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=G7sRTOz4xM0di9RoyN+nOlRtMJzCAvjRkmU6fGNk/+k=;
        b=M8ZXxQ4xI2ozNzgHrXE8HUW6RbPfz2mLZqSnh+7S7rnTtAjUNJKegd5l+Ioyjyl6ll
         o4TeQmq0kCMK8bjeLRoDk95pjCt1eoKV3chx4woGIzvqTCMOPAJQHYb9G12F5PoP8L26
         9sEpqyG/kuoj0MFF52IDpEiTyWR5p9wT7UrdMS+uP46HGsbHrU586FeziW+5fz0YSW5y
         0so76YkIangIOcSieKQ/jxQWmmAjTVpBLCNashnVdhOHme/crfHr5saKa3CNQ3OhS7Vt
         TGq+0DosHfQXTpvMsoM8rsn/mr83XGWrGxJNIF71tyltxdEbhLUGe1VApUXhWMK3aitn
         ITGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=G7sRTOz4xM0di9RoyN+nOlRtMJzCAvjRkmU6fGNk/+k=;
        b=Ydb2eHE/43+Qtr0F2zQ3hokuKodbtUVRr5dcp8vGJ5qaTQ+1OdGEznEPQ2FAxTuY/1
         cwJNkYAUZWgVh8hNpQyM8m0PV2qgAUnzPZmwEMWInTLJlkv/M7LVMPrOLaOmG9Ci0eES
         acswU4AiVhOMASo9QtrYTp64VcC1vZxBpM+Ea4drIqCr/teGb+tTpW9oB1w4O1J+Z9sA
         APD0Haj38IpMMqcp2e2muYJMFFDn27qiE8A/w5gBIPVG0HAD0YnL32V0AaOdO39MP/5r
         aLk6hHEvCOIowTC8rvyXGB5H3X4/pOCpU23YQDtaxTvjyjjLEL+lR21RCtKA7VaYOJk8
         uRZA==
X-Gm-Message-State: APjAAAUpDcIgQKwIFmkfs5MQF9b+yxtAKFDNuy1cXVKwDZzWh/vTEsC0
        X4IIl0CBWEjqL5YkYP1xAh8=
X-Google-Smtp-Source: APXvYqwi+IYdBUTpF9qtFfpa2sd2v7hUuT6UATcaxr7HbXtBramGIUUy5GE6JMma9bn0LM+rw2y8AQ==
X-Received: by 2002:a65:640a:: with SMTP id a10mr23321592pgv.270.1570906572729;
        Sat, 12 Oct 2019 11:56:12 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id v20sm14689081pgh.89.2019.10.12.11.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:56:12 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:56:09 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
Subject: Re: [PATCH v2 net-next 01/12] net: aquantia: PTP skeleton
 declarations and callbacks
Message-ID: <20191012185609.GJ3165@localhost>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
 <91d1e1181a01005ef04610241bffb9032f4669b8.1570531332.git.igor.russkikh@aquantia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91d1e1181a01005ef04610241bffb9032f4669b8.1570531332.git.igor.russkikh@aquantia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 08, 2019 at 10:56:36AM +0000, Igor Russkikh wrote:

> +static struct ptp_clock_info aq_ptp_clock = {
> +	.owner		= THIS_MODULE,
> +	.name		= "atlantic ptp",
> +	.n_ext_ts	= 0,
> +	.pps		= 0,
> +	.n_per_out     = 0,
> +	.n_pins        = 0,
> +	.pin_config    = NULL,
> +};

> +int aq_ptp_init(struct aq_nic_s *aq_nic, unsigned int idx_vec)
> +{
> +	struct hw_atl_utils_mbox mbox;
> +	struct ptp_clock *clock;
> +	struct aq_ptp_s *aq_ptp;
> +	int err = 0;
> +
> +	hw_atl_utils_mpi_read_stats(aq_nic->aq_hw, &mbox);
> +
> +	if (!(mbox.info.caps_ex & BIT(CAPS_EX_PHY_PTP_EN))) {
> +		aq_nic->aq_ptp = NULL;
> +		return 0;
> +	}
> +
> +	aq_ptp = kzalloc(sizeof(*aq_ptp), GFP_KERNEL);
> +	if (!aq_ptp) {
> +		err = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	aq_ptp->aq_nic = aq_nic;
> +
> +	aq_ptp->ptp_info = aq_ptp_clock;
> +	clock = ptp_clock_register(&aq_ptp->ptp_info, &aq_nic->ndev->dev);

You register a ptp_info with NULL pointers instead of callbacks.  That
means this patch will cause an Oops.  Incremental patch series are
nice, but be sure that every patch really works.  The patch that
introduces the call to ptp_clock_register() should come only when
ptp_info is populated with callbacks.

Thanks,
Richard
