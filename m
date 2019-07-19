Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21E0A6DCE8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 06:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389734AbfGSETR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 00:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388487AbfGSETP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 00:19:15 -0400
Received: from localhost (unknown [49.207.58.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A8D92084C;
        Fri, 19 Jul 2019 04:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509955;
        bh=pZgmxt2vofJkFOYwEbzop7NDM+n8v66Qs9syI1w3oH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c90VeSS8fADvSn3H3++1HIrz7cLIvt6NyMQ7KrJZIFboBZGx4vQPzLBEoDrugrzm4
         VuJYgYtBC1pp3xbnb/kHrwCOwZvlMDeDN9WExqrSosqghQR2YK1bvkeY/lKnDBb0FD
         YeZVbzflgbATmvadaKXCKWHjxWeUs7JDDwGSdLUo=
Date:   Fri, 19 Jul 2019 09:48:00 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     xiaofeis <xiaofeis@codeaurora.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        linux-arm-msm@vger.kernel.org, bjorn.andersson@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        niklas.cassel@linaro.org, xiazha@codeaurora.org
Subject: Re: [PATCH] qca8k: enable port flow control
Message-ID: <20190719041800.GK12733@vkoul-mobl.Dlink>
References: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563504791-43398-1-git-send-email-xiaofeis@codeaurora.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19-07-19, 10:53, xiaofeis wrote:
> Set phy device advertising to enable MAC flow control.

How about:

to Pause for enabling MAC flow control 
> 
> Change-Id: Ibf0f554b072fc73136ec9f7ffb90c20b25a4faae

Please remove this

> Signed-off-by: Xiaofei Shen <xiaofeis@codeaurora.org>
> ---
>  drivers/net/dsa/qca8k.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index d93be14..95ac081 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1,7 +1,7 @@
>  /*
>   * Copyright (C) 2009 Felix Fietkau <nbd@nbd.name>
>   * Copyright (C) 2011-2012 Gabor Juhos <juhosg@openwrt.org>
> - * Copyright (c) 2015, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2015, 2019, The Linux Foundation. All rights reserved.
>   * Copyright (c) 2016 John Crispin <john@phrozen.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -800,6 +800,8 @@
>  	qca8k_port_set_status(priv, port, 1);
>  	priv->port_sts[port].enabled = 1;
>  
> +	phy->advertising |= (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
> +
>  	return 0;
>  }
>  
> -- 
> 1.9.1

-- 
~Vinod
