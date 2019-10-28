Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8823EE7625
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 17:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391024AbfJ1QaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 12:30:24 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42927 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732957AbfJ1QaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 12:30:24 -0400
Received: by mail-pg1-f194.google.com with SMTP id f14so7209560pgi.9
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 09:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SQuBb1DCXEr8h1ECCdUIOg6XQFl3p+ONu+5Oivf+rCw=;
        b=TZgFUJfk5s8fMqvLgcfoSfoH5/QODG8LGopHISdASnARo4nD5nanqf1siljcA53hK2
         vJV+9nCLl0JOol9OWtGW3dmp1E7ZDBU0UEuiti6O/DqNrFSqJ77V0D3IEYEtKDcnK9Um
         QGEeQDx4e6qmmuWaIINHFTEbknU1vbikTO+mRvMgYxMuy3yZaHEtfeVlJddlIByq/prL
         799VU5HYR/o4NpDliCg+aylRupNiBLgPSypRvBKwYSsE6CRaVMKoaqc8TJNTvyOhaXFE
         EN/RcKC8UUtXz5aJSwfkCKgSnPJuKEFnV3x7+pKGwJXLIWyxJ0k3Rs2Hp/eAWkBEeWeh
         Wj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SQuBb1DCXEr8h1ECCdUIOg6XQFl3p+ONu+5Oivf+rCw=;
        b=GHD6MV4hlvUn5ZmEOkMIvMxTSLjAjzKNH915ZMl5PocN5HKhSfGpyD6S6tXiIYYTEq
         WhBrQYY0si8DPmM3M9izYsUI6s9eQa2UZOVHjggJGJRjv9+NH/aTXpCPzbWSSy14c3pW
         0iWpK6CXbGWn5CUR6IPnesgXoxXA2QYyiE3BfXo7J29V5HLDOFIIy4hpslOEM7gDw5MO
         dZI9G+jrmeb9EGXtRViDBAqKuRSoZ1HKICE/lk/VgAPw65z4156caNQ0cgBn+sGPqPs1
         5Lrr8Z7Q+pma2mnmc5wqZiQjK1mkqUJuWyR7S+zqk0R+nPogHsrbZc2AlVuUjSwfPw56
         rhjA==
X-Gm-Message-State: APjAAAWlIiinpAbdxZdxtt6vqxi7JYE0eIoHmJ9IbLfXLOrHUX61P4fw
        49VqAaD1rVANE2Kn7USHgV6yWuufu4b07w==
X-Google-Smtp-Source: APXvYqy36OBf3DTn/iAU+tRcnAOHj5pMGpTO3ypHFAqBrCmS9Alu7BSIuIlAMijtuMScIJF29o1VQA==
X-Received: by 2002:a62:8704:: with SMTP id i4mr21102540pfe.15.1572280223335;
        Mon, 28 Oct 2019 09:30:23 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id s7sm11329948pgq.91.2019.10.28.09.30.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Oct 2019 09:30:22 -0700 (PDT)
Subject: Re: [PATCH net-next] ionic: Remove set but not used variable
 'sg_desc'
To:     YueHaibing <yuehaibing@huawei.com>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191028120121.20743-1-yuehaibing@huawei.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a9acbf5c-a6d7-0115-2ca9-53368ba12508@pensando.io>
Date:   Mon, 28 Oct 2019 09:30:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191028120121.20743-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/19 5:01 AM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/ethernet/pensando/ionic/ionic_txrx.c: In function 'ionic_rx_empty':
> drivers/net/ethernet/pensando/ionic/ionic_txrx.c:405:28: warning:
>   variable 'sg_desc' set but not used [-Wunused-but-set-variable]
>
> It is never used, so can be removed.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Shannon Nelson <snelson@pensando.io>


> ---
>   drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> index 0aeac3157160..97e79949b359 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
> @@ -402,7 +402,6 @@ static void ionic_rx_fill_cb(void *arg)
>   
>   void ionic_rx_empty(struct ionic_queue *q)
>   {
> -	struct ionic_rxq_sg_desc *sg_desc;
>   	struct ionic_desc_info *cur;
>   	struct ionic_rxq_desc *desc;
>   	unsigned int i;
> @@ -412,7 +411,6 @@ void ionic_rx_empty(struct ionic_queue *q)
>   		desc->addr = 0;
>   		desc->len = 0;
>   
> -		sg_desc = cur->sg_desc;
>   		for (i = 0; i < cur->npages; i++) {
>   			if (likely(cur->pages[i].page)) {
>   				ionic_rx_page_free(q, cur->pages[i].page,
>
>
>

