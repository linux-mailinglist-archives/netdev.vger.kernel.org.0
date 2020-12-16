Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C4E2DBFE5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 12:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgLPL4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 06:56:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43588 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgLPL4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 06:56:01 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kpVOp-00057S-Nd; Wed, 16 Dec 2020 11:55:19 +0000
Subject: NAK: [PATCH] wilc1000: fix spelling mistake in Kconfig "devision" ->
 "division"
From:   Colin Ian King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201216115425.12745-1-colin.king@canonical.com>
Message-ID: <3ae68497-ddee-c494-cb4a-66dda7818806@canonical.com>
Date:   Wed, 16 Dec 2020 11:55:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201216115425.12745-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2020 11:54, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in the Kconfig help text. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/ni/Kconfig                 | 2 +-
>  drivers/net/wireless/microchip/wilc1000/Kconfig | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ni/Kconfig b/drivers/net/ethernet/ni/Kconfig
> index 01229190132d..dcfbfa516e67 100644
> --- a/drivers/net/ethernet/ni/Kconfig
> +++ b/drivers/net/ethernet/ni/Kconfig
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  #
> -# National Instuments network device configuration
> +# National Instruments network device configuration
>  #
>  
>  config NET_VENDOR_NI
> diff --git a/drivers/net/wireless/microchip/wilc1000/Kconfig b/drivers/net/wireless/microchip/wilc1000/Kconfig
> index 80c92e8bf8a5..7f15e42602dd 100644
> --- a/drivers/net/wireless/microchip/wilc1000/Kconfig
> +++ b/drivers/net/wireless/microchip/wilc1000/Kconfig
> @@ -44,4 +44,4 @@ config WILC1000_HW_OOB_INTR
>  	  chipset. This OOB interrupt is intended to provide a faster interrupt
>  	  mechanism for SDIO host controllers that don't support SDIO interrupt.
>  	  Select this option If the SDIO host controller in your platform
> -	  doesn't support SDIO time devision interrupt.
> +	  doesn't support SDIO time division interrupt.
> 

Messed this up. V2 coming soon.

