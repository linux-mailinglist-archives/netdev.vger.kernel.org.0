Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9DE2C7B75
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 22:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgK2VrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 16:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgK2VrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 16:47:11 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC30AC0613CF;
        Sun, 29 Nov 2020 13:46:24 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k14so12841276wrn.1;
        Sun, 29 Nov 2020 13:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=7YuuUpD1H/Ss9wRJI+hJvm/XG5FPVasB4bqzQ2xCKhM=;
        b=A5Z4v78E/+UlXRUXPthb/z9FyyfBZMjvb/RvFGISh3j/bzRhkSCIjGIx04wWVJ+MlX
         VHiF61MvCt/PLHiYw5rK9Ki6VqPjQlE0c50JtCIuC72RQ2HhGxDaigVs/I+phekIeXPA
         qF97xYfJdxiznqUKbhXpPxCmwwxeKxB+eO+julMOHYigepvnz5/3ctHxY+Obr5aV29hm
         0gRmMzQ3hhxZh3y6Q7UeZOqei+xXYnyG+REGOUyDJObap6Syomm6to6srlYzXf06MIDI
         Cx0B27CS+o0z8liVnHKvV9U/Lzg4ckAkK1HzLPZlw1HQBT1YcAUMzB6d7zGgARCvYw40
         iJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=7YuuUpD1H/Ss9wRJI+hJvm/XG5FPVasB4bqzQ2xCKhM=;
        b=ULJYgih/CtWG0lstU9lIVZmkR16PYQar2WvY5a9VCSwLwTJPTaj6tanotdWj9LUwSI
         lWqUVRGRoENlfOOpR4AW/TA5H1ZzATBhLU0vR5Y44+x6q83ov25eI5CJD6mBXnqqwaoe
         Ggb6bu8FbV2yGpkFOI0K/xyBFonNIt1GjINkMplATyCE9YPFSk8Jp97992NylR0X0Llb
         cH6KWkNFQCzSrVUXjNku3WtDizLf6jigUSkR1kAmJAVrlisUcrWo6UYovvBt6Hm7PpwY
         8x19a3mn8dDzDLgi/tUGP1Xpkvx2WO6Siojt44By9VkKRXXjQ7IG81mdX5MZ3JwXEMSi
         wB1g==
X-Gm-Message-State: AOAM532VVngZDWzP8zpxTgkAoya83tvV/MTUluaB+eE43RwofdkRdPbc
        0b8BkPRC7YyDvuh/bF5Ioo1OXp7pmc9N6Q==
X-Google-Smtp-Source: ABdhPJzNp6/Lte6q9Mn1MG3OknuQlSEfQWGqQbydxTFa8PixtApBHz3BbxvXgd+D2brHpG+PXDyuZA==
X-Received: by 2002:adf:82cc:: with SMTP id 70mr24324155wrc.74.1606686383117;
        Sun, 29 Nov 2020 13:46:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:809d:4884:42fb:d0ca? (p200300ea8f232800809d488442fbd0ca.dip0.t-ipconnect.de. [2003:ea:8f23:2800:809d:4884:42fb:d0ca])
        by smtp.googlemail.com with ESMTPSA id d2sm24641085wrn.43.2020.11.29.13.46.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 13:46:21 -0800 (PST)
Subject: Re: [PATCH] mlxsw: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jiri@nvidia.com, idosch@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20201129211733.2913-1-christophe.jaillet@wanadoo.fr>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <a4fde87f-ea73-8ba4-e6cd-689f0f649eb4@gmail.com>
Date:   Sun, 29 Nov 2020 22:46:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201129211733.2913-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 29.11.2020 um 22:17 schrieb Christophe JAILLET:
> he wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'mlxsw_pci_queue_init()' and
> 'mlxsw_pci_fw_area_init()' GFP_KERNEL can be used because this flag is
> already used in the same function.
> 
> When memory is allocated in 'mlxsw_pci_mbox_alloc()' GFP_KERNEL can be
> used because it is only called from a probe function. The call chain is:
>   --> mlxsw_pci_probe
>     --> mlxsw_pci_cmd_init
>       --> mlxsw_pci_mbox_alloc
> 
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
> 
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
> 
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
> 
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
> 
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> ---
>  drivers/net/ethernet/mellanox/mlxsw/pci.c | 52 +++++++++++------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index 641cdd81882b..7519d3b6934e 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> @@ -323,8 +323,8 @@ static int mlxsw_pci_wqe_frag_map(struct mlxsw_pci *mlxsw_pci, char *wqe,
>  	struct pci_dev *pdev = mlxsw_pci->pdev;
>  	dma_addr_t mapaddr;
>  
> -	mapaddr = pci_map_single(pdev, frag_data, frag_len, direction);
> -	if (unlikely(pci_dma_mapping_error(pdev, mapaddr))) {
> +	mapaddr = dma_map_single(&pdev->dev, frag_data, frag_len, direction);
> +	if (unlikely(dma_mapping_error(&pdev->dev, mapaddr))) {
>  		dev_err_ratelimited(&pdev->dev, "failed to dma map tx frag\n");
>  		return -EIO;
>  	}
> @@ -342,7 +342,7 @@ static void mlxsw_pci_wqe_frag_unmap(struct mlxsw_pci *mlxsw_pci, char *wqe,
>  
>  	if (!frag_len)
>  		return;
> -	pci_unmap_single(pdev, mapaddr, frag_len, direction);
> +	dma_unmap_single(&pdev->dev, mapaddr, frag_len, direction);
>  }
>  
>  static int mlxsw_pci_rdq_skb_alloc(struct mlxsw_pci *mlxsw_pci,
> @@ -858,9 +858,9 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
>  		tasklet_setup(&q->tasklet, q_ops->tasklet);
>  
>  	mem_item->size = MLXSW_PCI_AQ_SIZE;
> -	mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
> -					     mem_item->size,
> -					     &mem_item->mapaddr);
> +	mem_item->buf = dma_alloc_coherent(&mlxsw_pci->pdev->dev,
> +					   mem_item->size, &mem_item->mapaddr,
> +					   GFP_KERNEL);
>  	if (!mem_item->buf)
>  		return -ENOMEM;
>  
> @@ -890,8 +890,8 @@ static int mlxsw_pci_queue_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
>  err_q_ops_init:
>  	kfree(q->elem_info);
>  err_elem_info_alloc:
> -	pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
> -			    mem_item->buf, mem_item->mapaddr);
> +	dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
> +			  mem_item->buf, mem_item->mapaddr);
>  	return err;
>  }
>  
> @@ -903,8 +903,8 @@ static void mlxsw_pci_queue_fini(struct mlxsw_pci *mlxsw_pci,
>  
>  	q_ops->fini(mlxsw_pci, q);
>  	kfree(q->elem_info);
> -	pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
> -			    mem_item->buf, mem_item->mapaddr);
> +	dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
> +			  mem_item->buf, mem_item->mapaddr);
>  }
>  
>  static int mlxsw_pci_queue_group_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
> @@ -1242,9 +1242,9 @@ static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
>  		mem_item = &mlxsw_pci->fw_area.items[i];
>  
>  		mem_item->size = MLXSW_PCI_PAGE_SIZE;
> -		mem_item->buf = pci_alloc_consistent(mlxsw_pci->pdev,
> -						     mem_item->size,
> -						     &mem_item->mapaddr);
> +		mem_item->buf = dma_alloc_coherent(&mlxsw_pci->pdev->dev,
> +						   mem_item->size,
> +						   &mem_item->mapaddr, GFP_KERNEL);
>  		if (!mem_item->buf) {
>  			err = -ENOMEM;
>  			goto err_alloc;
> @@ -1273,8 +1273,8 @@ static int mlxsw_pci_fw_area_init(struct mlxsw_pci *mlxsw_pci, char *mbox,
>  	for (i--; i >= 0; i--) {
>  		mem_item = &mlxsw_pci->fw_area.items[i];
>  
> -		pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
> -				    mem_item->buf, mem_item->mapaddr);
> +		dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
> +				  mem_item->buf, mem_item->mapaddr);
>  	}
>  	kfree(mlxsw_pci->fw_area.items);
>  	return err;
> @@ -1290,8 +1290,8 @@ static void mlxsw_pci_fw_area_fini(struct mlxsw_pci *mlxsw_pci)
>  	for (i = 0; i < mlxsw_pci->fw_area.count; i++) {
>  		mem_item = &mlxsw_pci->fw_area.items[i];
>  
> -		pci_free_consistent(mlxsw_pci->pdev, mem_item->size,
> -				    mem_item->buf, mem_item->mapaddr);
> +		dma_free_coherent(&mlxsw_pci->pdev->dev, mem_item->size,
> +				  mem_item->buf, mem_item->mapaddr);
>  	}
>  	kfree(mlxsw_pci->fw_area.items);
>  }
> @@ -1316,8 +1316,8 @@ static int mlxsw_pci_mbox_alloc(struct mlxsw_pci *mlxsw_pci,
>  	int err = 0;
>  
>  	mbox->size = MLXSW_CMD_MBOX_SIZE;
> -	mbox->buf = pci_alloc_consistent(pdev, MLXSW_CMD_MBOX_SIZE,
> -					 &mbox->mapaddr);
> +	mbox->buf = dma_alloc_coherent(&pdev->dev, MLXSW_CMD_MBOX_SIZE,
> +				       &mbox->mapaddr, GFP_KERNEL);
>  	if (!mbox->buf) {
>  		dev_err(&pdev->dev, "Failed allocating memory for mailbox\n");
>  		err = -ENOMEM;
> @@ -1331,8 +1331,8 @@ static void mlxsw_pci_mbox_free(struct mlxsw_pci *mlxsw_pci,
>  {
>  	struct pci_dev *pdev = mlxsw_pci->pdev;
>  
> -	pci_free_consistent(pdev, MLXSW_CMD_MBOX_SIZE, mbox->buf,
> -			    mbox->mapaddr);
> +	dma_free_coherent(&pdev->dev, MLXSW_CMD_MBOX_SIZE, mbox->buf,
> +			  mbox->mapaddr);
>  }
>  
>  static int mlxsw_pci_sys_ready_wait(struct mlxsw_pci *mlxsw_pci,
> @@ -1817,17 +1817,17 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		goto err_pci_request_regions;
>  	}
>  
> -	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));

Using dma_set_mask_and_coherent() would be better here.

>  	if (!err) {
> -		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
>  		if (err) {

This check isn't needed, see comment at definition of
dma_set_mask_and_coherent().

> -			dev_err(&pdev->dev, "pci_set_consistent_dma_mask failed\n");
> +			dev_err(&pdev->dev, "dma_set_coherent_mask failed\n");
>  			goto err_pci_set_dma_mask;
>  		}
>  	} else {
> -		err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
> +		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
>  		if (err) {
> -			dev_err(&pdev->dev, "pci_set_dma_mask failed\n");
> +			dev_err(&pdev->dev, "dma_set_mask failed\n");
>  			goto err_pci_set_dma_mask;
>  		}
>  	}
> 

