Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9203C6C94EE
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 16:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjCZOCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjCZOCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 10:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796CF7EF5;
        Sun, 26 Mar 2023 07:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDE76B80CA1;
        Sun, 26 Mar 2023 14:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CE7C4339C;
        Sun, 26 Mar 2023 14:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679839360;
        bh=6UjvC4vhYxQxNMue1HYv9yzXbIQLEgQPzyEiOjLkqFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TMAAwTApQMKdTwoGA0IfW9u7L4NQmFDA20ay2WvLWxp2Xu+vgVrE/M6EBlgfi8caH
         /RXar0PujO9g0vV/xBQtmFuBtU5E3NtuR2RJFu3EdM0498npfbN/p7vVEKS4cPNx/r
         MOBwUlw8Gj8Foub8sOYab4bi6GwBVR08YmjxR6d3759PsptwIRL69EXOyi4eg6G+ez
         qW/KXCR3PcayRCTBc7qjVndMhxMUo2TZ7L7TgnOo3lpB3OR43eG2Uo7i71Afn4LsJX
         MbQscsTLmTSrlIY7FstA0uUBi/I8B0O7trKB+lUMHlSxXFCuNDQs/LLcKqPj4VwFHZ
         rC93Y4rOJq0Tg==
Received: by pali.im (Postfix)
        id 703A578E; Sun, 26 Mar 2023 16:02:37 +0200 (CEST)
Date:   Sun, 26 Mar 2023 16:02:37 +0200
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
Subject: Re: [PATCH v3 6/9] mmc: sdio: add Realtek SDIO vendor ID and various
 wifi device IDs
Message-ID: <20230326140237.mjj37si7hqbx5xds@pali>
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-7-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320213508.2358213-7-martin.blumenstingl@googlemail.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 20 March 2023 22:35:05 Martin Blumenstingl wrote:
> Add the SDIO vendor ID for Realtek and some device IDs extracted from
> their GPL vendor driver. This will be useful in the future when the
> rtw88 driver gains support for these chips.
> 
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
> Changes since v2:
> - none
> 
> Changes since v1:
> - Add Ulf's Acked-by (who added: "I assume it's easier if Kalle picks
>   up this patch, along with the series")
> 
> 
>  include/linux/mmc/sdio_ids.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 0e4ef9c5127a..d7cd39a8ad57 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -112,6 +112,15 @@
>  #define SDIO_VENDOR_ID_MICROCHIP_WILC		0x0296
>  #define SDIO_DEVICE_ID_MICROCHIP_WILC1000	0x5347
>  
> +#define SDIO_VENDOR_ID_REALTEK			0x024c
> +#define SDIO_DEVICE_ID_REALTEK_RTW8723BS	0xb723
> +#define SDIO_DEVICE_ID_REALTEK_RTW8723DS	0xd723
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821BS	0xb821
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821CS	0xc821
> +#define SDIO_DEVICE_ID_REALTEK_RTW8821DS	0xd821
> +#define SDIO_DEVICE_ID_REALTEK_RTW8822BS	0xb822
> +#define SDIO_DEVICE_ID_REALTEK_RTW8822CS	0xc822

Hello! Could you sort lines by values, like it is in all other sections?

Also it would be nice to put these ids into sdioids database at:
https://github.com/sdioutils

> +
>  #define SDIO_VENDOR_ID_SIANO			0x039a
>  #define SDIO_DEVICE_ID_SIANO_NOVA_B0		0x0201
>  #define SDIO_DEVICE_ID_SIANO_NICE		0x0202
> -- 
> 2.40.0
> 
