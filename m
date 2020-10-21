Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C69F2954D2
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 00:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506738AbgJUWaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 18:30:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506724AbgJUWaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 18:30:24 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2AD241A6;
        Wed, 21 Oct 2020 22:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603319423;
        bh=cBtXpIIfhVm6w9APhIRH4zZW2n9okENfsHWwVXqkh9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uudD92JS8Rp5LZ+HGLEOwObocJh9sdHq6wjae/U14waD7vjJIC49BnBAMnaYgJ6C2
         zvYE/ITJsmbOHcWerZyV8CQ9PkiQoedVGgkG3D3pSZ0Od90psxiTWL28Wa3FfX6pi6
         AzhINpqA4vgAwHRChu3LrC31Tvq3yY5yeoah+WcY=
Received: by pali.im (Postfix)
        id 7537BA83; Thu, 22 Oct 2020 00:30:20 +0200 (CEST)
Date:   Thu, 22 Oct 2020 00:30:20 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 01/24] mmc: sdio: add SDIO IDs for Silabs WF200 chip
Message-ID: <20201021223020.btkgdo7cgzavxbpk@pali>
References: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
 <20201020125817.1632995-2-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201020125817.1632995-2-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 20 October 2020 14:57:54 Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Add Silabs SDIO ID to sdio_ids.h.
> 
> Note that the values used by Silabs are uncommon. A driver cannot fully
> rely on the SDIO PnP. It should also check if the device is declared in
> the DT.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Looks good!

Acked-by: Pali Rohár <pali@kernel.org>

> ---
>  include/linux/mmc/sdio_ids.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/mmc/sdio_ids.h b/include/linux/mmc/sdio_ids.h
> index 12036619346c..20a48162f7fc 100644
> --- a/include/linux/mmc/sdio_ids.h
> +++ b/include/linux/mmc/sdio_ids.h
> @@ -25,6 +25,11 @@
>   * Vendors and devices.  Sort key: vendor first, device next.
>   */
>  
> +// Silabs does not use a reliable vendor ID. To avoid conflicts, the driver
> +// won't probe the device if it is not also declared in the DT.
> +#define SDIO_VENDOR_ID_SILABS			0x0000
> +#define SDIO_DEVICE_ID_SILABS_WF200		0x1000
> +
>  #define SDIO_VENDOR_ID_STE			0x0020
>  #define SDIO_DEVICE_ID_STE_CW1200		0x2280
>  
> -- 
> 2.28.0
> 
