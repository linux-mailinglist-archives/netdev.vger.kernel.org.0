Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674943DE0E3
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhHBUmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhHBUmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 16:42:31 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAED2C06175F;
        Mon,  2 Aug 2021 13:42:21 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h14so35999014lfv.7;
        Mon, 02 Aug 2021 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yWNos4y2XTKd/qiBHjitrH5SCn6A1SHTx/LQoQqiDk8=;
        b=YoIBiA76lvQ4DD5wg4v9sV349pCwvCYsLadfoyZoQFpwk5f2VOm4aeVXp/cqWfrZvo
         XiT8IG7obvghGAUp+rHcAAly8qLivB4Pr4tHw/AVs9jCHIdlN1hiXXEVEJweI4kQif3y
         uor3bymaq/oWXbPdD7qlsc4G3OdqVxQadx0vKLDh/LLbHgNvsLops6O+MCg0nxluELCB
         anlFHOov+14FL6mkWeX9dV3qNc9XdoU6hw6j6m4+sz5utvPjNnSm+BdxDx4/YQVhh2jP
         qPyVvjfv7ERQo+Sn/NHqWUYLGLbubtI0p7bTF1QJ9DY97QeB2dDbyfd6GDzOrumWDZKd
         0+cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yWNos4y2XTKd/qiBHjitrH5SCn6A1SHTx/LQoQqiDk8=;
        b=X9eHehbF4kSGxSyuOMEFzk3KxXU0q5NTZP3GPmUc9Fg5SsNfKcl9Z0JBGVSp/Bm6sA
         zQo9seklgqI0SXvkueBjTo1ZTCGH+7JzW4ZPdVaF6hLRZYay1VZmT6kf2fzRrM2tMu2T
         ebSROunqeQZMd+9q+lh5tP1ioDpOkobhuV0WoVuVnQ15B0F5LHcT7FTZAhEgZ4AqvXaJ
         DmM7thSnq7U5EO4Afi9ir9oP7V5j7BZAICUxPD8Wri/bWBzoALJyZRkhH0QLKmVMO19q
         S2EP8voNUzd0TwcGrYPLVGSslKLbFNLAvCg6bOfprYsxKpy4yBwRRyQyAElv2hd/20eh
         Kkiw==
X-Gm-Message-State: AOAM533GcOEi7dAVe6lNwQQfshy4rNjn0e47IQNfyGtXR2bwGi1VkDHR
        q9r8AwfXFluB09F30MKA+gQ=
X-Google-Smtp-Source: ABdhPJwxRS7YWOMnqVOaWTRxq6b/1qrKOo7gqTChOm2JzyF4xExMwFidT9Y+FEhEyu9dDP4/B13LQA==
X-Received: by 2002:a05:6512:3a8:: with SMTP id v8mr12691275lfp.116.1627936940121;
        Mon, 02 Aug 2021 13:42:20 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.81.124])
        by smtp.gmail.com with ESMTPSA id u16sm682259lfi.45.2021.08.02.13.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 13:42:19 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <e740c0ee-dcf0-caf5-e80e-9588605a30b3@gmail.com>
Date:   Mon, 2 Aug 2021 23:42:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/21 1:26 PM, Biju Das wrote:

> The DMAC and EMAC blocks of Gigabit Ethernet IP found on RZ/G2L SoC are
> similar to the R-Car Ethernet AVB IP. With a few changes in the driver we
> can support both IPs.
> 
> Currently a runtime decision based on the chip type is used to distinguish
> the HW differences between the SoC families.
> 
> The number of TX descriptors for R-Car Gen3 is 1 whereas on R-Car Gen2 and
> RZ/G2L it is 2. For cases like this it is better to select the number of
> TX descriptors by using a structure with a value, rather than a runtime
> decision based on the chip type.
> 
> This patch adds the num_tx_desc variable to struct ravb_hw_info and also
> replaces the driver data chip type with struct ravb_hw_info by moving chip
> type to it.
> 
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> ---
> v2:
>  * Incorporated Andrew and Sergei's review comments for making it smaller patch
>    and provided detailed description.
> ---
>  drivers/net/ethernet/renesas/ravb.h      |  7 +++++
>  drivers/net/ethernet/renesas/ravb_main.c | 38 +++++++++++++++---------
>  2 files changed, 31 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index 80e62ca2e3d3..cfb972c05b34 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -988,6 +988,11 @@ enum ravb_chip_id {
>  	RCAR_GEN3,
>  };
>  
> +struct ravb_hw_info {
> +	enum ravb_chip_id chip_id;
> +	int num_tx_desc;

   I think this is rather the driver's choice, than the h/w feature... Perhaps a rename
would help with that? :-)

[...]

MBR, Sergei
