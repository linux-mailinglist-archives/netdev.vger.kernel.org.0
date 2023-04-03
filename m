Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2CA6D52F4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbjDCU7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDCU7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC506272C;
        Mon,  3 Apr 2023 13:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 572BB62B2C;
        Mon,  3 Apr 2023 20:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCD5C433D2;
        Mon,  3 Apr 2023 20:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680555549;
        bh=Jko3afct/TAK0go9CJRFcu7GPZ8tu9HyhdEM/5yobtk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VmoPMGZz3nSoe/PAomr+63FMBfmlo8Z/0v0lm7Z1JmGqlFBoyFgIHjXH3azgsRsLm
         JRppQxER3A+seTUBt3Jd33GnfElM4RdTpI142nBmxIN1yOEAhwIN3JZQo7XfCmWgzQ
         1REpZYBMsWttJk1ktVYY29hcW2O7LIO3AiW2FDRKjVpJO8TFR4O1iCIHyAQ088EQDe
         V3hCzg8s7YJvEJroVeKGrffML/EBS5Eyaz2sUqpo62EsQOYrl5RNgBfraxvDVK5GCD
         6fdetDB/BARvngNt7N87pZtYoQRVtcMmuYiTSz61mzIdtqsuZLE2xdF7O/q0+wEJcS
         Rr0jxnVw5V0yA==
Received: by pali.im (Postfix)
        id 3BBC3772; Mon,  3 Apr 2023 22:59:06 +0200 (CEST)
Date:   Mon, 3 Apr 2023 22:59:06 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v4 6/9] mmc: sdio: add Realtek SDIO vendor ID and various
 wifi device IDs
Message-ID: <20230403205906.qtxefyx5k3nntozk@pali>
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-7-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403202440.276757-7-martin.blumenstingl@googlemail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 03 April 2023 22:24:37 Martin Blumenstingl wrote:
> Add the SDIO vendor ID for Realtek and some device IDs extracted from
> their GPL vendor driver. This will be useful in the future when the
> rtw88 driver gains support for these chips.
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Pali Rohár <pali@kernel.org>

> ---
> Changes since v3:
> - sort entries by their value for consistency as suggested by Pali
> - add Ping-Ke's reviewed-by
> 
> Changes since v2:
> - none
> 
> Changes since v1:
> - none
> 
> 
>  include/linux/mmc/sdio_ids.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 0e4ef9c5127a..66f503ed2448 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -112,6 +112,15 @@
>  #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
>  #define SDIO_DEVICE_ID_MICROCHIP_WILC1000	0x5347
>  
> +#define SDIO_VENDOR_ID_REALTEK			0x024c
> +#define SDIO_DEVICE_ID_REALTEK_RTW8723BS	0xb723
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821BS	0xb821
> +#define SDIO_DEVICE_ID_REALTEK_RTW8822BS	0xb822
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821CS	0xc821
> +#define SDIO_DEVICE_ID_REALTEK_RTW8822CS	0xc822
> +#define SDIO_DEVICE_ID_REALTEK_RTW8723DS	0xd723
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821DS	0xd821
> +
>  #define SDIO_VENDOR_ID_SIANO			0x039a
>  #define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
>  #define SDIO_DEVICE_ID_SIANO_NICE		0x0202
> -- 
> 2.40.0
> 
