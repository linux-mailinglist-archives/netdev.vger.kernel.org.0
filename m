Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070C448C29F
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 11:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352661AbiALK7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 05:59:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42992 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiALK7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 05:59:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32049B81D6E;
        Wed, 12 Jan 2022 10:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE218C36AEA;
        Wed, 12 Jan 2022 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641985141;
        bh=CCz9TaBhzlxAUXt2zsk2hkuFbg2xBTs8dNBs1B2KDk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UznS4jwQpkrbFrZEuqaNLNNh/z0lhS02+fspB5UeJo49CjIt5Zck676z2fYlkQ/AT
         Z727URmzejxLbhgeT+MDTHS5+22oxYVEyAHrdvlI+LoSR9LIsaRDkrStrcT8fMRbjh
         hfWs0s77bzL0lAjcCFyeLLeqV7fY9C18d/z4bTOrK1o3BgQ9ZeO4I2eeMwvqLYj/+1
         +OW5THTBkefTeC4PeorM+TW6bDHQspdXvbcqDEJPMBcQ0uds1ttAQtntC/wpnk0VDP
         mlDWQApr0xVwXJr9O2HxGYP/xLcEAKnRJNOeauChgPNKksyNVdGqBYGABZLtxXdbHE
         FUlckO/TEucgA==
Received: by pali.im (Postfix)
        id 71E3E768; Wed, 12 Jan 2022 11:58:59 +0100 (CET)
Date:   Wed, 12 Jan 2022 11:58:59 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 08/24] wfx: add bus_sdio.c
Message-ID: <20220112105859.u4j76o7cpsr4znmb@pali>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111171424.862764-9-Jerome.Pouiller@silabs.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 11 January 2022 18:14:08 Jerome Pouiller wrote:
> +static const struct sdio_device_id wfx_sdio_ids[] = {
> +	{ SDIO_DEVICE(SDIO_VENDOR_ID_SILABS, SDIO_DEVICE_ID_SILABS_WF200) },
> +	{ },
> +};

Hello! Is this table still required?

> +MODULE_DEVICE_TABLE(sdio, wfx_sdio_ids);
> +
> +struct sdio_driver wfx_sdio_driver = {
> +	.name = "wfx-sdio",
> +	.id_table = wfx_sdio_ids,
> +	.probe = wfx_sdio_probe,
> +	.remove = wfx_sdio_remove,
> +	.drv = {
> +		.owner = THIS_MODULE,
> +		.of_match_table = wfx_sdio_of_match,
> +	}
> +};
> -- 
> 2.34.1
> 
