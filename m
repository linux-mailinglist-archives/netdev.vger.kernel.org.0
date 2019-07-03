Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29945DDB4
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 07:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfGCFNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 01:13:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56180 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfGCFNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 01:13:01 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so733925wmj.5
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 22:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ErK/s1AhZDapR/jXTkATojMKSmJ3isYCmEYlNbhr9pg=;
        b=waPISSP+4jFVp/A9idw5xWwc2W4IADh6AufSCsX0pa+UPrjmYIszjF+MQAOcPWoh71
         VB94LEoGvQestKuiZvLyFzy/CSC3U4KFyd9Y6Zksua07BqU/+o/L5b78TO2sa4COXfwe
         EOIgOkh68dTTUZJdwfH5sOQzOHHPtxn8MXd6cqjqAjSx3EbPXadbS9XZHIqqSu8u0VfI
         OGEVZiWZSd9v3nVeZGlHm9UdnxAFJljmlG1JVZgcJfAUzaFHl6n1EQaRBQUTgxcmDmNz
         Y/9X7lpW2ZiHdG8Gmi9tTvjxsrfqL3d58YspzgiupCYyFwAtLmle2YyY4s6e3CNyqLdB
         E0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ErK/s1AhZDapR/jXTkATojMKSmJ3isYCmEYlNbhr9pg=;
        b=oXx3x59C0f1MB4ShT/2o1ajsNbRPqyta6IDOrtVrs4EtMTCaIEDnzFSRZvB0C4ETeq
         KUadP9m3AKc9q1+DRVN5eBRyB6nLTRRw0yD82RIT8UwttMyxDQiP4gdIE0Le4oh4fnOa
         QsgCiu4dWKId6rcFfIlEiHsygkVb2vHq67jp/qOMJAkFHRhIEbP43W/WGjZBS3+Bk6pv
         rxOBZybj1+rR0Zhjb8FFGscq2jQmLKoTTGg556v0NhB9ZbecbwGvdTKd6oQL31frScvg
         97eMKxADk9Ffq+yuNjezWqJyn8+C5mkMTaKlaMR1OJjZDYCeEa5bhuzBAWXiE/qHFzHW
         8o1Q==
X-Gm-Message-State: APjAAAVDcL/zQk7CgCD8zOUBf5aWsqcVKW+r3IY7cnHxMirpkqxgkccS
        DJ9O96kV/RyigQxbPjlr5qzT6g==
X-Google-Smtp-Source: APXvYqwX9E5IxrM5Xn/46XwSJtHfvKGq9sSvqlmGQU3MV6j07WTuau8duHBHywObSHdBwIypFqoCOg==
X-Received: by 2002:a1c:c289:: with SMTP id s131mr5921300wmf.115.1562130779124;
        Tue, 02 Jul 2019 22:12:59 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id t1sm1367207wra.74.2019.07.02.22.12.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 22:12:58 -0700 (PDT)
Date:   Wed, 3 Jul 2019 08:12:54 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Jassi Brar <jaswinder.singh@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: socionext: remove set but not used
 variable 'pkts'
Message-ID: <20190703051254.GA25517@apalos>
References: <20190703024213.191191-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703024213.191191-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 03, 2019 at 02:42:13AM +0000, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/socionext/netsec.c: In function 'netsec_clean_tx_dring':
> drivers/net/ethernet/socionext/netsec.c:637:15: warning:
>  variable 'pkts' set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit ba2b232108d3 ("net: netsec: add XDP support")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 5544a722543f..015d1ec5436a 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -634,7 +634,7 @@ static void netsec_set_rx_de(struct netsec_priv *priv,
>  static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
> -	unsigned int pkts, bytes;
> +	unsigned int bytes;
>  	struct netsec_de *entry;
>  	int tail = dring->tail;
>  	int cnt = 0;
> @@ -642,7 +642,6 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  	if (dring->is_xdp)
>  		spin_lock(&dring->lock);
>  
> -	pkts = 0;
>  	bytes = 0;
>  	entry = dring->vaddr + DESC_SZ * tail;
> 
> 
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
