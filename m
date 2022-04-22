Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75AB50B70D
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447267AbiDVMOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445865AbiDVMO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:14:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C621117E;
        Fri, 22 Apr 2022 05:11:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 788DD61FC0;
        Fri, 22 Apr 2022 12:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A49C385A4;
        Fri, 22 Apr 2022 12:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650629494;
        bh=H3Qej2YHR+TlaLMizz7+0fGPZ3Mtnj1GowHYNjqgcNQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YA0QT/RZtRQe3Fz37wzFITM8RhMzmyY0o4QKfeFMYl/dMhe2o5ULX1sqm2E3DWM34
         vkp633FqTdwW+cyxW8qJ5gld7X0nyy2LTpJP3AErBnC33NJnNKf16z7ReeEDEabr2+
         Ecx5Ph4AWW4epwvoZTQUIZA+dmXGgbVP6sDJUZzI=
Date:   Fri, 22 Apr 2022 14:11:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lungash <denizlungash@gmail.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org,
        outreachy@lists.linux.dev
Subject: Re: [PATCH] staging: qlge: Fix line wrapping
Message-ID: <YmKbc9Ib9vXgDnBg@kroah.com>
References: <YmJseHLyoAJWOGpc@kali-h6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmJseHLyoAJWOGpc@kali-h6>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 11:51:04AM +0300, Lungash wrote:
> This patch fixes line wrapping following kernel coding style.
> 
> Task on TODO list
> 
> * fix weird line wrapping (all over, ex. the ql_set_routing_reg() calls in
>   qlge_set_multicast_list()).
> 
> Signed-off-by: Lungash <denzlungash@gmail.com>

We need a "full" name here, whatever you sign legal documents with.

> ---
>  drivers/staging/qlge/qlge_main.c | 235 ++++++++++++++-----------------
>  1 file changed, 107 insertions(+), 128 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 113a3efd12e9..309db00e0b22 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -499,77 +499,57 @@ static int qlge_set_routing_reg(struct qlge_adapter *qdev, u32 index, u32 mask,
>  
>  	switch (mask) {
>  	case RT_IDX_CAM_HIT:
> -		{
> -			value = RT_IDX_DST_CAM_Q |	/* dest */
> -			    RT_IDX_TYPE_NICQ |	/* type */
> -			    (RT_IDX_CAM_HIT_SLOT << RT_IDX_IDX_SHIFT);/* index */
> -			break;
> -		}
> +		value = RT_IDX_DST_CAM_Q |	/* dest */
> +			RT_IDX_TYPE_NICQ |	/* type */
> +			(RT_IDX_CAM_HIT_SLOT << RT_IDX_IDX_SHIFT);/* index */
> +		break;

The original was fine, but yes, the {} can be removed, but that does not
have to do with the TODO item here.  Please only do one type of fixup at
a time.

>  
> -static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size, const char *str)
> +static int qlge_validate_flash(struct qlge_adapter *qdev, u32 size,
> +			       const char *str)

You just made this look worse, why?

> -static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset, __le32 *data)
> +static int qlge_read_flash_word(struct qlge_adapter *qdev, int offset,
> +				__le32 *data)

Same here, why change the original?

> @@ -2952,8 +2936,8 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
>  		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
>  	u64 shadow_reg_dma = qdev->rx_ring_shadow_reg_dma +
>  		(rx_ring->cq_id * RX_RING_SHADOW_SPACE);
> -	void __iomem *doorbell_area =
> -		qdev->doorbell_area + (DB_PAGE_SIZE * (128 + rx_ring->cq_id));
> +	void __iomem *doorbell_area = qdev->doorbell_area +
> +		(DB_PAGE_SIZE * (128 + rx_ring->cq_id));

This does not look better, why not put it all on one line?


thanks,

greg k-h
