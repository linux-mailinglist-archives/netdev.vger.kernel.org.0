Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B9049364C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 09:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352426AbiASI0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 03:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 03:26:48 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1BCC061574;
        Wed, 19 Jan 2022 00:26:47 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id e9-20020a05600c4e4900b0034d23cae3f0so4206680wmq.2;
        Wed, 19 Jan 2022 00:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OJqfjkc7grksCnSg/3JnGJQ3LuEV4ZfXzF6Rc4piP3w=;
        b=CUKUQdDv8/ynrbgu8Ww/bTmlcj/BiH5Bby/13t2PdAtjxJ/JC1Q9w0TUbjPeX3yrvA
         zxVFgUgMAk8FRjbGLeTv48cu++AuLwnJsCK0j3PP2Ig3fhhkdywpCm4dbFU79E2Nthki
         cvWROpQbgG/ybC8SN9LzmUmR5x8U1PwqNOPkXsrajN8hrzYquChHlIQdAfYUZnwSjehF
         2L5QGLXYN64UUnrWQSBsCD7CzuxYiI+1+reG0EzqDr/uD6xJZeT4ivqWuZB70Kso0RYX
         jKKQH44R1hlHcIvdoWsRZYXSm/PTx0/Y7uBS17jAV6XoqJPglufLwsEnIMkS1mBS2AZG
         BGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=OJqfjkc7grksCnSg/3JnGJQ3LuEV4ZfXzF6Rc4piP3w=;
        b=c/Wjs5dLUUGgislgsaqEwNmaLE/eG9JEW3cOHYcoTv6Zj/Rtbn91/C5xNfsSSbvAsj
         rf9LjIwVaIMGt7CPo97pKeq9JwuImtn9DKEUd3WiqyAqOpBqIPBuI7p6asBzxXoUCnSN
         7EVUIaHmg7usRbIQSNgVrb+wZCJSGUjAwrkBAUVwHH0KxSi5+P1aDg/QbRmGoYDOKsvm
         KnGq/wM5YdVeOFpNM4/0j00PLiaQZd3+W8yeBVkZ/6UQlL3d13tZ6+wXu/vJi+dvqvVm
         nsOQqkzuCTVP13TzbKfleM+0FkaJBlfZFcahy6To3rbvp8p3P8rxs1nl4sJ9VpRr7jMd
         EdYw==
X-Gm-Message-State: AOAM533l1lDjz7bk7MJXZ10s+o5MVxOJ+zHb+37IRCj+LYF7NU/348Wo
        /SWN7J7pFvSawUXv24K+Pdo=
X-Google-Smtp-Source: ABdhPJyGrBaxmjbgviSCXOJnLDcmWI9cikBU8AG58dSMzxDuPImuBoB3M1r4hpvWq4GqhrqduRB3CA==
X-Received: by 2002:a05:600c:3c92:: with SMTP id bg18mr2330907wmb.106.1642580806428;
        Wed, 19 Jan 2022 00:26:46 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id a4sm7837403wri.9.2022.01.19.00.26.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Jan 2022 00:26:46 -0800 (PST)
Date:   Wed, 19 Jan 2022 08:26:43 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     cgel.zte@gmail.com
Cc:     ecree.xilinx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] sfc/ef10: remove unneeded rc variable
Message-ID: <20220119082643.mod7g7ikoviks22r@gmail.com>
Mail-Followup-To: cgel.zte@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220118075616.925855-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118075616.925855-1-chi.minghao@zte.com.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 07:56:16AM +0000, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return value from efx_mcdi_rpc() directly instead
> of taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index cf366ed2557c..991758292b7c 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -3627,7 +3627,6 @@ static int efx_ef10_rx_disable_timestamping(struct efx_channel *channel,
>  					    bool temp)
>  {
>  	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_TIME_EVENT_UNSUBSCRIBE_LEN);
> -	int rc;
>  
>  	if (channel->sync_events_state == SYNC_EVENTS_DISABLED ||
>  	    (temp && channel->sync_events_state == SYNC_EVENTS_QUIESCENT))
> @@ -3646,10 +3645,8 @@ static int efx_ef10_rx_disable_timestamping(struct efx_channel *channel,
>  	MCDI_SET_DWORD(inbuf, PTP_IN_TIME_EVENT_UNSUBSCRIBE_QUEUE,
>  		       channel->channel);
>  
> -	rc = efx_mcdi_rpc(channel->efx, MC_CMD_PTP,
> +	return efx_mcdi_rpc(channel->efx, MC_CMD_PTP,
>  			  inbuf, sizeof(inbuf), NULL, 0, NULL);

Looks good, but indent the continuation line to align with the ( above
it.

This sort of cleanup is for net-next, which is closed at the moment.
See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt

Martin

> -
> -	return rc;
>  }
>  
>  static int efx_ef10_ptp_set_ts_sync_events(struct efx_nic *efx, bool en,
> -- 
> 2.25.1
