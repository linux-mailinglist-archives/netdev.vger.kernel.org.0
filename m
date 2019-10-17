Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80913DAC47
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405627AbfJQMaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:30:35 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52884 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfJQMae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 08:30:34 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so2378180wmh.2
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 05:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t1Ba4wZYqhXbKNbXR7PAqplG1Me61twoungxdZdLhMM=;
        b=zEzsqWNCT2iO5gtupQO15S4JTn/TyzyRHhzSlwWAAK9mmS2O6iIhiFWIrKfVYN81cQ
         0lUKtxrsYm0NjWYxmpBpmIXNnKHDeaYsl1FJ7QZ3dkhwhhpnDIHCNRINIzpoVyU6q9Hy
         f5lasjIFftoF98Dsp6wHTvLiC9V8r8aig5LhEouI4MIU8oqMY0xr9+I88VU5qL1wR4an
         E/zE3gk3xrrMlVwudwaF/wtV9ld1Lv/v5+WXlyHGSWCvDwfIUWTDWFdh0r/hCOnN7cA4
         O+PAprp6RzsPLu2sO1es3VHHYeBMO+oNEX0JQD0XTljFc+KkFu3wmAFz+X84jQJgyJPc
         9YaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t1Ba4wZYqhXbKNbXR7PAqplG1Me61twoungxdZdLhMM=;
        b=k0xkkqwWsMkSPgOTyx8hZ0E3ScRudv2W64h6PWdQUDcGMVxMtEysblt3yVfYPKA4yu
         GA93R0RZn2yYdv2XHoe+Zy4qCquTnJvw+voPUo0B89npebb2UP+feaUzgQrnkrtqQdwG
         Z8N6gNNuW6Y6N7JP7HU4XAe+5plW0auV1HLfmIFh6LsDDX6IIqD33G81LWVqWjaIWAAv
         Wuu3RrE94brR8faVDpJ7vCc3vZ0nbYYxl1OK55vn7FfrWpVt1zCZC2ua+TMhrIYSqWrx
         cszErd7MBcGDsL7MDUEAzSeFIaVGCTMCCNB+xX+2FXcS4m9n6TlbKb7V3ZO29KonVyNR
         FJFA==
X-Gm-Message-State: APjAAAXI59r9YxK8mIf7pUje31Rb7P+TxB1xiZZBLjhTp3D2vPo6UZ+3
        wXC7WfbHH9ZROLZwfLQQjUDGVQ==
X-Google-Smtp-Source: APXvYqx02ltE0vC1psOtehT+DjXbzla4xweav2v+ZEqIkBG2tmQLQE4UWz4bz/f+VWiW8u/lG9hVEw==
X-Received: by 2002:a1c:988b:: with SMTP id a133mr2590491wme.22.1571315433331;
        Thu, 17 Oct 2019 05:30:33 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id m18sm2328544wrg.97.2019.10.17.05.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 05:30:32 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:30:30 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: socionext: netsec: fix xdp stats
 accounting
Message-ID: <20191017123030.GA21206@apalos.home>
References: <50cf2bc622d81c8447713113c5c6a7d0fd4f5c95.1571315083.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50cf2bc622d81c8447713113c5c6a7d0fd4f5c95.1571315083.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Lorenzo,

On Thu, Oct 17, 2019 at 02:28:32PM +0200, Lorenzo Bianconi wrote:
> Increment netdev rx counters even for XDP_DROP verdict. Report even
> tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or TYPE_NETSEC_XDP_NDO).
> Moreover account pending buffer length in netsec_xdp_queue_one as it is
> done for skb counterpart
> 
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - fix BQL accounting
> - target the patch to next-next
> ---
>  drivers/net/ethernet/socionext/netsec.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index f9e6744d8fd6..c40294470bfa 100644
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
> @@ -858,6 +858,7 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
>  	tx_desc.addr = xdpf->data;
>  	tx_desc.len = xdpf->len;
>  
> +	netdev_sent_queue(priv->ndev, xdpf->len);
>  	netsec_set_tx_de(priv, tx_ring, &tx_ctrl, &tx_desc, xdpf);
>  
>  	return NETSEC_XDP_TX;
> @@ -1030,7 +1031,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
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

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
