Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69442379281
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhEJPXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235862AbhEJPXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:23:17 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDC4C04684B;
        Mon, 10 May 2021 07:55:19 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a10-20020a05600c068ab029014dcda1971aso9210368wmn.3;
        Mon, 10 May 2021 07:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LdzN4vabxAaywTUCUyKAN9CsvFqkJ9+cyxQ6LXEIgIg=;
        b=tEEP9K0KtsbmbCmehq7nnKT79txVrDofPfBNxwbH4AsT6HNkMFHArBaJhDCwcp4inB
         ay3uCvGqLbaodlFhGc7Gll7MUTCqLhYHB0ZKw9ww3xJsVXo2DwswW/AfPhbOyH1pAcPH
         4DXp+1/hnr+ziv7fNo2HzGfuQbykCWRHtQQAZnl0yDn8KqLuq/dte5K2evulvvLq04Bm
         6MQExnad/ZGusbGBgtyyKP5YLMwCpMdtx2zKaUWBsYYFTYY6tHNzcobVuXbYNFiHMuRC
         tyQE5qITL4RKOvFT0YfPYsbHA6btY8ty1Se6D5mN7AVVG+lFIELsvJdo3WS51dg8uatC
         TObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LdzN4vabxAaywTUCUyKAN9CsvFqkJ9+cyxQ6LXEIgIg=;
        b=MofI0ZuwITFDTlMBZOxxMTagSO5bicDKTW464CkaZhaqv4bMNvycb7D0POY07vPS8e
         lKiiHMy5sQNQ9Uz7gK3bglVIaBhiiabadtx1ozjC1CmDnqmWDHStqlskVoRrpcYoWBVO
         dZrSyA51nQhquO7AJg2oDUYiTzsz7bqiTeTEPuLEo20K2d95EVC4P8b3Wr7DoV0B2o69
         f4RKh2Lw+isqTL8OnjAw4sTjMpnhVPxm7Vfndq+ja8bLaLMEaQRcppJ+y+5w5XIL4KuO
         f2pWkLSgC6ZlQgnr13HXo6/SHMwsmiUlxRDcpu2q1TizMjfe9Wy/0/GJcWcAUSxLZ8zc
         wDMA==
X-Gm-Message-State: AOAM533V9KBkmGsyAm2EgZOCEBUOLwamLNjzJ4sR5iIVaLqXy9FvGPYx
        0oq4QOXUIQDj9+OtbABCpsE=
X-Google-Smtp-Source: ABdhPJyJGOksxuTa1I03eCfUNXSQXfSlP99bP4r9fmwr8UHi5oDDmGa7+XJW4+i2guA91NWX4yFBSQ==
X-Received: by 2002:a05:600c:1909:: with SMTP id j9mr21284358wmq.100.1620658518019;
        Mon, 10 May 2021 07:55:18 -0700 (PDT)
Received: from agape.jhs ([5.171.73.3])
        by smtp.gmail.com with ESMTPSA id i3sm26014413wrb.46.2021.05.10.07.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 07:55:17 -0700 (PDT)
Date:   Mon, 10 May 2021 16:55:14 +0200
From:   Fabio Aiuto <fabioaiuto83@gmail.com>
To:     Ashish Vara <ashishvara89@yahoo.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        coiby.xu@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] staging: qlge: removed unnecessary debug
 message to fix coding style warning
Message-ID: <20210510145513.GD4434@agape.jhs>
References: <eb4c5af2-2980-a0f1-4708-a48da9570225.ref@yahoo.com>
 <eb4c5af2-2980-a0f1-4708-a48da9570225@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb4c5af2-2980-a0f1-4708-a48da9570225@yahoo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ashish,

in your subject line there is one Subject: too many

On Mon, May 10, 2021 at 08:13:37PM +0530, Ashish Vara wrote:
> From: Ashish Vara <ashishvara89@yahoo.com>
> 
> removed unnecessary out of memory message to fix coding style warning.
> 
> Signed-off-by: Ashish Vara <ashishvara89@yahoo.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index c9dc6a852af4..a9e0bccc52d0 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -2796,12 +2796,8 @@ static int qlge_init_bq(struct qlge_bq *bq)
>  
>  	bq->base = dma_alloc_coherent(&qdev->pdev->dev, QLGE_BQ_SIZE,
>  				      &bq->base_dma, GFP_ATOMIC);
> -	if (!bq->base) {
> -		netif_err(qdev, ifup, qdev->ndev,
> -			  "ring %u %s allocation failed.\n", rx_ring->cq_id,
> -			  bq_type_name[bq->type]);
> +	if (!bq->base)
>  		return -ENOMEM;
> -	}
>  
>  	bq->queue = kmalloc_array(QLGE_BQ_LEN, sizeof(struct qlge_bq_desc),
>  				  GFP_KERNEL);
> -- 
> 2.30.2
> 

thank you,

fabio
