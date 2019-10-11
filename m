Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608B6D4282
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfJKOPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:15:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56146 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbfJKOPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:15:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so10583407wma.5
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qd+Vi7BRX9Orh2HCZHH6xUXX7Y/GlTf2dXrIi68QJVM=;
        b=fG7P8IzFow2iznucfVBsnzNypaEZeNWq2Y1w6COvrH41jkoLIXd1NIJ6oImcLcKUGi
         5nyNrzN08rNfVrU8LEANkdwdUF6Zl0kfFQpifcEPWrOUzp+0ONrnu+s66m0xGYgog0af
         jadgF+pCgTeD1+isQa+EtJ4O1HEOvPc2tYrKfZotzWbpej5EuYW0sc6e28s3tLuDNCnP
         gF6iaeXOpwtgxKYlYsvMULaCbwSjGDshHY9S4OWeGkARjLr2GfmdHfpjpQiMFHIr7hZz
         R22JCr+QOnpLNoFre8MaBWPuIB3u/NEohVtUCQhV7pjOPCYli58Va061bgCycRWHlEE2
         lO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qd+Vi7BRX9Orh2HCZHH6xUXX7Y/GlTf2dXrIi68QJVM=;
        b=MV2jZpeiDCySONDIEIRMDQwSC5+DqqhRccAJyARNlW29yZNPdodTtEb3FGtdwEv6y2
         +zeduvz2uxqVJuhQ/P1daMC8R0HjCA6ZaERhtSQOokrLAnUE7cwqkQZk4ZuwbWSFWLP6
         ksPBVAa2pjso5N70cC73wcOZDA9KmmdCxZiC2x9c3NvycctXNbodm1cuIo7RwEaIc2P5
         K4UQpnoAioW2r4VzbNr/0lSEl63GLyt/l6HXZK92NUU6vnbINvEPc3B8L/oBix/UZ/aW
         oQ7p1rRdnhC8V/k0CNQ8jX5lUNX+GK+h/WzVW5yDB+ffZM3GrkkHK2ldEZ46fNXlXT1q
         rO2Q==
X-Gm-Message-State: APjAAAXWP0Bxgrpsjgl+WmJsK/5+k47J1GuotmH9BfjHPQlDzmlsxPKa
        IeAGMDvbz8TaY5/r6EVxBjmFXw==
X-Google-Smtp-Source: APXvYqxnmBYbjs1iT3Nyar900t9sVILBk36PNSlh7x5O8SrVt7BxKvf1M6ZKok8XZ8ZqEotadV1dOA==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr3405452wmj.91.1570803306443;
        Fri, 11 Oct 2019 07:15:06 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id g11sm10038472wmh.45.2019.10.11.07.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 07:15:05 -0700 (PDT)
Date:   Fri, 11 Oct 2019 17:15:03 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: fix xdp stats accounting
Message-ID: <20191011141503.GA11359@apalos.home>
References: <40c5519a86f2c611de84661a9d1e136bda2cd78e.1570801159.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40c5519a86f2c611de84661a9d1e136bda2cd78e.1570801159.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Fri, Oct 11, 2019 at 03:45:38PM +0200, Lorenzo Bianconi wrote:
> Increment netdev rx counters even for XDP_DROP verdict. Moreover report
> even tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or
> TYPE_NETSEC_XDP_NDO)

The RX counters work fine. The TX change is causing a panic though and i am
looking into it since your patch seems harmless. In any case please don't merge
this yet

Thanks
/Ilias

> Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> just compiled not tested on a real device
> ---
>  drivers/net/ethernet/socionext/netsec.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index f9e6744d8fd6..b1c2a79899b3 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -252,7 +252,6 @@
>  #define NETSEC_XDP_CONSUMED      BIT(0)
>  #define NETSEC_XDP_TX            BIT(1)
>  #define NETSEC_XDP_REDIR         BIT(2)
> -#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_XDP_REDIR)
>  
>  enum ring_id {
>  	NETSEC_RING_TX = 0,
> @@ -661,6 +660,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  			bytes += desc->skb->len;
>  			dev_kfree_skb(desc->skb);
>  		} else {
> +			bytes += desc->xdpf->len;
>  			xdp_return_frame(desc->xdpf);
>  		}
>  next:
> @@ -1030,7 +1030,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  
>  next:
>  		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
> -		    xdp_result & NETSEC_XDP_RX_OK) {
> +		    xdp_result) {
>  			ndev->stats.rx_packets++;
>  			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
>  		}
> -- 
> 2.21.0
> 
