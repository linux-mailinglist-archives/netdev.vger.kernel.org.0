Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C42B251E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKMUGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgKMUGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:06:37 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C3EC0613D1;
        Fri, 13 Nov 2020 12:06:37 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id i18so10072066ots.0;
        Fri, 13 Nov 2020 12:06:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vGK0RT5QcdhHOfj1KcxY7Dq+ZvRahrwVzJzrJjM3btM=;
        b=DUdIzIMiV7FO2Y4KwrngjhUZ2n8IpcoPPouVDUFHYcxUU7edAgA1LW5W6X9kLuxuo5
         BqEKpZ0sriJOQASkfbA//37irPhdvMVEBlNFZvu8YlemAg7V8M9+Dpa0hAcb55yXz8uN
         n1dz3fLfoqAH1oVxY6nx5bENRsJbFoWLhCyPysIqpBZEdDJTdiRRwJd6O1s8F2J+/p57
         OxSxR7umPLa8iPhMPslBMsFWxbKXaLIU0TADPhSv7Kz+QvP2MWGfT0ddTbQ2bENsgSL5
         dVp35R6mUT27XVvF4uS60URU3KNTCfNDOzy6KSxrQ/LEM5q3+3V5QpTNzQ55999tXfew
         qt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vGK0RT5QcdhHOfj1KcxY7Dq+ZvRahrwVzJzrJjM3btM=;
        b=J//XuW6XL7rrWUy/hxccK02yxKVehIA8FL3pnhNS7AOBBf7SPphLXHeuD72Guy+wZr
         As7FaT/7bJeJHtAYjjEoXHLFwNzbdzijxiTzvjK0WPmQ0leiafE8T0pOcw2yNDjd7dgR
         FfC6HA7tg7z96Znl/PdqaBZ4xQ0fCXfcxblmKptloXd7ozOOXXx4bh9WHXjvexLKRVqe
         ktPCyNy4ZWR7KxVTX5D9w6LdCzcHoqSZiemqr3/EZusCw48gZjmi5621ra2NmDWXXXop
         kchtvltSGTDGu34t4ql0PHeBpy6dCS1ykbe7Arix2kzg+W1vffR1NvXT7DxeqlYoBeDW
         EQuQ==
X-Gm-Message-State: AOAM5336DYw/P3m+H7DcSlHKwRmUPHm+y8X2QUV3rqwO5Eb1x9FQIE8+
        ubAXq37RHSxUNd6iwrg0ZYCLUAL8JkxdKQ==
X-Google-Smtp-Source: ABdhPJzG2vlgzOWavLPpwWWg24slaFi/HBOLhB3ELUMdd31s7pgyifbQJTr8PjjvMBsBxspkW/Er9A==
X-Received: by 2002:a05:6830:1210:: with SMTP id r16mr2611967otp.57.1605297997015;
        Fri, 13 Nov 2020 12:06:37 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o135sm2223419ooo.38.2020.11.13.12.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:06:36 -0800 (PST)
Date:   Fri, 13 Nov 2020 12:06:30 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org, john.fastabend@gmail.com
Message-ID: <5faee746e1a30_d58320821@john-XPS-13-9370.notmuch>
In-Reply-To: <9af8014006d022fc0fec78cdaa71beb56999750d.1605267335.git.lorenzo@kernel.org>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <9af8014006d022fc0fec78cdaa71beb56999750d.1605267335.git.lorenzo@kernel.org>
Subject: RE: [PATCH v6 net-nex 3/5] net: mvneta: add xdp tx return bulking
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Convert mvneta driver to xdp_return_frame_bulk APIs.
> 
> XDP_REDIRECT (upstream codepath): 275Kpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 284Kpps
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 54b0bf574c05..183530ed4d1d 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -1834,8 +1834,13 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  				 struct netdev_queue *nq, bool napi)
>  {
>  	unsigned int bytes_compl = 0, pkts_compl = 0;
> +	struct xdp_frame_bulk bq;
>  	int i;
>  
> +	xdp_frame_bulk_init(&bq);
> +
> +	rcu_read_lock(); /* need for xdp_return_frame_bulk */
> +
>  	for (i = 0; i < num; i++) {
>  		struct mvneta_tx_buf *buf = &txq->buf[txq->txq_get_index];
>  		struct mvneta_tx_desc *tx_desc = txq->descs +
> @@ -1857,9 +1862,12 @@ static void mvneta_txq_bufs_free(struct mvneta_port *pp,
>  			if (napi && buf->type == MVNETA_TYPE_XDP_TX)
>  				xdp_return_frame_rx_napi(buf->xdpf);
>  			else
> -				xdp_return_frame(buf->xdpf);
> +				xdp_return_frame_bulk(buf->xdpf, &bq);
>  		}
>  	}
> +	xdp_flush_frame_bulk(&bq);
> +
> +	rcu_read_unlock();
>  
>  	netdev_tx_completed_queue(nq, pkts_compl, bytes_compl);
>  }
> -- 
> 2.26.2
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
