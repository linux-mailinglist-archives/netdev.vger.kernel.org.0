Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4EA2B2524
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgKMUJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgKMUJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:09:40 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BE7C0613D1;
        Fri, 13 Nov 2020 12:09:40 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id t16so11659938oie.11;
        Fri, 13 Nov 2020 12:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rXIlrbK8APZyS5ZGZmZQG+WKSGy8y97ez3A1XsZra2A=;
        b=E0uD916oZo3b4GKb8ZA6/Ch7CyxuilW7okGr02IeymP9VBinRfg+NhWK1p0uQRk7so
         IqeZuLMixxyXeVt0FTC1V7eDO5Ut7vtYhPEO9kz2CL4dbss+/kxvSxPC4wndOppCtWtY
         7tnn89fvvkSn8QlZTdM+Cx/H6Ub+xfYLK1xaQzZ5d7aRLr4E3XCRzaH9k2IT4oP/OjRI
         znM/lJ3ozykSXhaCkOo/X7e4RAjpax1Bu76RLtZVUVxKFxHqvZCK4Sh4mJ5CsiZnv5V6
         Ha+/L9atb5FPYlHdI4x6V6VZJfsvqWiIreKSjntEAOKJh9mwQqN+YG/Zz18ipL3LiNvG
         p5WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rXIlrbK8APZyS5ZGZmZQG+WKSGy8y97ez3A1XsZra2A=;
        b=mnLIH9zofUE+V4NJkYJjCaTZPOaL7PR1EGIQzqbWBephh1zvgGTB2giEguL3cIug5P
         dwBJHDcxXugFAsGHD1bG4gRFg6RWImM7Yf+T2fhHllHeoW742rlkj8MhhyasuSjJQlmE
         5bvFK4O74KOInwhZw0V51NBNxjAXewY9eyIedG/ymcPmOjNrlo/YwRkQXa78Y5ZLVkor
         NoMdIfCgUppY04C0qsAFzlwNzT0AHhjmSvp4+fCmgAfN5CFGBY+XlX9hke1pX/S5XJ5C
         5DQFAlZ48KueyFYyoGnF78zGVmWMkPlTfyDLcVFbbeZhNH+uTlcIiN6L1qofqIoH0+F1
         LMEg==
X-Gm-Message-State: AOAM532nNolQL4g3Cp/Ae/vXoCSvsqCPqRqdnQ3i002YoNwVaLsDYzmc
        OzF4CI/GTyxGW0kRVbGOM7s=
X-Google-Smtp-Source: ABdhPJzBxcnZ7IbYe0LipgtqPTC2flQDlj4eEYMBWQQX76RNx/DmggrtXWD0ouBYH5i6PpxkkQl9Lg==
X-Received: by 2002:a54:4681:: with SMTP id k1mr2744324oic.25.1605298177443;
        Fri, 13 Nov 2020 12:09:37 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j16sm2286769oot.24.2020.11.13.12.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:09:36 -0800 (PST)
Date:   Fri, 13 Nov 2020 12:09:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Message-ID: <5faee7f9d8972_d58320848@john-XPS-13-9370.notmuch>
In-Reply-To: <0b38c295e58e8ce251ef6b4e2187a2f457f9f7a3.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <0b38c295e58e8ce251ef6b4e2187a2f457f9f7a3.1605267335.git.lorenzo@kernel.org>
Subject: RE: [PATCH v6 net-nex 4/5] net: mvpp2: add xdp tx return bulking
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Convert mvpp2 driver to xdp_return_frame_bulk APIs.
> 
> XDP_REDIRECT (upstream codepath): 1.79Mpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 1.93Mpps
> 
> Tested-by: Matteo Croce <mcroce@microsoft.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index f6616c8933ca..3069e192d773 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -2440,8 +2440,13 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
>  				struct mvpp2_tx_queue *txq,
>  				struct mvpp2_txq_pcpu *txq_pcpu, int num)
>  {
> +	struct xdp_frame_bulk bq;
>  	int i;
>  
> +	xdp_frame_bulk_init(&bq);
> +
> +	rcu_read_lock(); /* need for xdp_return_frame_bulk */
> +
>  	for (i = 0; i < num; i++) {
>  		struct mvpp2_txq_pcpu_buf *tx_buf =
>  			txq_pcpu->buffs + txq_pcpu->txq_get_index;
> @@ -2454,10 +2459,13 @@ static void mvpp2_txq_bufs_free(struct mvpp2_port *port,
>  			dev_kfree_skb_any(tx_buf->skb);
>  		else if (tx_buf->type == MVPP2_TYPE_XDP_TX ||
>  			 tx_buf->type == MVPP2_TYPE_XDP_NDO)
> -			xdp_return_frame(tx_buf->xdpf);
> +			xdp_return_frame_bulk(tx_buf->xdpf, &bq);
>  
>  		mvpp2_txq_inc_get(txq_pcpu);
>  	}
> +	xdp_flush_frame_bulk(&bq);
> +
> +	rcu_read_unlock();
>  }
>  
>  static inline struct mvpp2_rx_queue *mvpp2_get_rx_queue(struct mvpp2_port *port,
> -- 
> 2.26.2
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
