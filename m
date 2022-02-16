Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFA24B84EB
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbiBPJvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:51:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiBPJvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:51:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF6A2B521C;
        Wed, 16 Feb 2022 01:51:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9D87616FE;
        Wed, 16 Feb 2022 09:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E9FC004E1;
        Wed, 16 Feb 2022 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645005062;
        bh=0bBP7O0XYxaCF8Oh+43Ozdh5BeoEzCfjshF6waVQ+Z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qiTQeEptSGPhGAmMwAq5weoKundd9sfyhN+N0YuW+E2XJRjI+hGiVcu7/jN+JFamV
         wGQ7U/pkpUUF/IGwRwXnzeJLN4A9qdlPNrD7scXVQ9SPRLBWUdypgqTdF77JJK78NA
         dma6fFibmgbGMDed0l2rs98/DkcxdCZR745MtkcKX5nykDbW88s7f5blDzsStPRdQK
         NeX8ceRdo9p8G/8PFaj7TCCKyB7w2h/T64DLuTw/fMYEljoOadrvdroUPmvK6wVJQi
         e3p/LZT/f8nsdv1zvkqQGfusmIH3DkuoyXvZfzc6Oaf5Iztm+Odq5/uIfhiJgUCT3Y
         2GYUSWfiWsjEQ==
Received: by pali.im (Postfix)
        id CDC1B7F4; Wed, 16 Feb 2022 10:50:59 +0100 (CET)
Date:   Wed, 16 Feb 2022 10:50:59 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/2] staging: wfx: WF200 has no official SDIO IDs
Message-ID: <20220216095059.how2bexndwenhs6h@pali>
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
 <20220216093112.92469-2-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216093112.92469-2-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 16 February 2022 10:31:11 Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Some may think that SDIO_VENDOR_ID_SILABS / SDIO_DEVICE_ID_SILABS_WF200
> are official SDIO IDs. However, it is not the case, the values used by
> WF200 are not official (BTW, the driver rely on the DT rather than on
> the SDIO IDs to probe the device).
> 
> To avoid any confusion, remove the definitions SDIO_*_ID_SILABS* and use
> raw values.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
>  drivers/staging/wfx/bus_sdio.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wfx/bus_sdio.c b/drivers/staging/wfx/bus_sdio.c
> index bc3df85a05b6..312d2d391a24 100644
> --- a/drivers/staging/wfx/bus_sdio.c
> +++ b/drivers/staging/wfx/bus_sdio.c
> @@ -257,10 +257,9 @@ static void wfx_sdio_remove(struct sdio_func *func)
>  	sdio_release_host(func);
>  }
>  
> -#define SDIO_VENDOR_ID_SILABS        0x0000
> -#define SDIO_DEVICE_ID_SILABS_WF200  0x1000
>  static const struct sdio_device_id wfx_sdio_ids[] = {
> -	{ SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> +	/* WF200 does not have official VID/PID */
> +	{ SDIO_DEVICE(0x0000, 0x1000) },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> -- 
> 2.34.1
> 
