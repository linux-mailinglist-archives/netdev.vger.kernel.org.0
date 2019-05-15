Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6DE1F44E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 14:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfEOM0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 08:26:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42700 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfEOM0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 08:26:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1B6DC6072E; Wed, 15 May 2019 12:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557923178;
        bh=9MqGVcO6uYUQ2aNqwWZf4c/ySF737WfbAu840JeYXQE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=h+LrIjbWVYhw3DeNZQ3ebZLBfDoaCcSwaAkgVBr+WjcDi6/pdKVXYH/hDqwJr8wh6
         6/34sreNw60+j4YjrQzsE9t1rEej5Gg+Z/EeTPep8kEPD7hZVKUSFgGRo5flyhD6ZL
         qTzYz+ADMjkDjQVP/g+Nix1HohRAsnmdLFtBzADE=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from [10.204.79.15] (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: mojha@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37937607F4;
        Wed, 15 May 2019 12:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1557923177;
        bh=9MqGVcO6uYUQ2aNqwWZf4c/ySF737WfbAu840JeYXQE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=SfllZBh9wAj1akKJtLKrDfIvh8upprGZG7nEkfm+T67WrefhLWfdeXAnwBwndDmHB
         T4HKEhkJHBfAyjJXBd7c26dXsLtxVf2j+KyqyyqYm9Ip4M2bV0hsPU/G0079fZl3ml
         GuX/HBVcME0N78YkxKntfJgJaUt3+cjMN3KAcLFI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 37937607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=mojha@codeaurora.org
Subject: Re: [PATCH] libertas/libertas_tf: fix spelling mistake "Donwloading"
 -> "Downloading"
To:     Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190514211406.6353-1-colin.king@canonical.com>
From:   Mukesh Ojha <mojha@codeaurora.org>
Message-ID: <2661269b-7404-5534-05e1-b3b963dc2036@codeaurora.org>
Date:   Wed, 15 May 2019 17:56:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514211406.6353-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/15/2019 2:44 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> There is are two spelling mistakes in lbtf_deb_usb2 messages, fix these.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>

Cheers,
-Mukesh

> ---
>   drivers/net/wireless/marvell/libertas/if_usb.c    | 2 +-
>   drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
> index 220dcdee8d2b..1d06fa564e28 100644
> --- a/drivers/net/wireless/marvell/libertas/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas/if_usb.c
> @@ -367,7 +367,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
>   			     cardp->fwseqnum, cardp->totalbytes);
>   	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
>   		lbs_deb_usb2(&cardp->udev->dev, "Host has finished FW downloading\n");
> -		lbs_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
> +		lbs_deb_usb2(&cardp->udev->dev, "Downloading FW JUMP BLOCK\n");
>   
>   		cardp->fwfinalblk = 1;
>   	}
> diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> index a4b9ede70705..38f77b1a02ca 100644
> --- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> +++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
> @@ -319,7 +319,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
>   	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
>   		lbtf_deb_usb2(&cardp->udev->dev,
>   			"Host has finished FW downloading\n");
> -		lbtf_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
> +		lbtf_deb_usb2(&cardp->udev->dev, "Downloading FW JUMP BLOCK\n");
>   
>   		/* Host has finished FW downloading
>   		 * Donwloading FW JUMP BLOCK
