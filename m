Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11967389540
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 20:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhESSZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 14:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhESSZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 14:25:24 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3BFC06175F;
        Wed, 19 May 2021 11:24:03 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id di13so16464098edb.2;
        Wed, 19 May 2021 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F3/b6P5ifO3kCPBFhOamAiH+IaZSU5+7shSR+V6Rqts=;
        b=kQXJlr51eO24SJiTLmvFG7M2Mzd0BpvAVPhSuAogYEeiaWYU48gv1wExd00E+55klx
         Fh4U3/uEvzhwQxX5Nu54tD2i2vUK/1QKIkk1cyUtPvt7viJhJXi5+6A9qll3LEQ4Pic1
         CZlYhFw9eAPov62RENd6+FSa6/PiDqCYGlIjmIHufQytoYE9UGJxKXHdCAwwUqQZooGu
         tZ4tksb/4t8f8p2O+OdZ2OoCSmgmwTilDlUXvaw7TF4GLqDbBWawm1nh7gEN5gutECQ1
         MyIofHsPBl9SK/yyTeAkt32tyIvze+pE+ZywPO/zhaklQDgjP9VT/xzrsg7gfXZB5MDF
         xWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F3/b6P5ifO3kCPBFhOamAiH+IaZSU5+7shSR+V6Rqts=;
        b=l0C8cEq0HpoMnl7N9N7EGC/wyg+cPspmw2SzARE/T3P33n2eREkRL43SQqjFW7+5ko
         wKlWTuqkPoTuWzmC6MZAgR1IacbNsFCc55QStkT58N3w5JwPMQKXocDQL1jyqfuZ+WIz
         yi8VkqVt9HNgKdaqXFuklEFLLcXy1nE3nc0E4TKJ45ik7+9jwrxezT4QHSVmC59GoWfW
         lEimVUINA5tvCVT8N4oCd1cCf6YjApKlg/h3jUNRuwP+xiTtoWFkrggI21pam9SWP8YL
         s4o0WWvxKD8BulADafemsXw2NTJztWO3gmFmYOAdaMn8SnwD2OgmbqJOSPHwSPaNgQWv
         oO9Q==
X-Gm-Message-State: AOAM533Y+9G+v5YPfi46Y/2SZ84l9dE1FktOpPy1Qq8LUR3Tb8c/1wZA
        f9BHVFsnGBVTZMVEiQsxl4BRWSnCpjo=
X-Google-Smtp-Source: ABdhPJyNcwXODxPM6976t0K6zKP86Qcds1WenIHYPnf5OgbjQZMy0dkcftuZhPjNrFSQr00h/D9DQQ==
X-Received: by 2002:a50:cc0c:: with SMTP id m12mr372801edi.141.1621448642506;
        Wed, 19 May 2021 11:24:02 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id v24sm278757eds.19.2021.05.19.11.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 11:24:01 -0700 (PDT)
Date:   Wed, 19 May 2021 21:24:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: Remove unsigned expression compared with zero
Message-ID: <20210519182400.nnek4dp5wwvabnwf@skbuf>
References: <1621421391-36681-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621421391-36681-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiapeng,

On Wed, May 19, 2021 at 06:49:51PM +0800, Jiapeng Chong wrote:
> Variable val is "u32" always >= 0, so val >= 0 condition are redundant.
> 
> Clean up the following coccicheck warning:
> 
> ./drivers/net/dsa/qca8k.c:732:5-8: WARNING: Unsigned expression compared
> with zero: val >= 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/dsa/qca8k.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index 4753228..7b38b8d 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -729,8 +729,7 @@
>  
>  	mutex_unlock(&bus->mdio_lock);
>  
> -	if (val >= 0)
> -		val &= QCA8K_MDIO_MASTER_DATA_MASK;
> +	val &= QCA8K_MDIO_MASTER_DATA_MASK;
>  
>  	return val;
>  }
> -- 
> 1.8.3.1
> 

The qca8k driver has some problems with the handling of signed/unsigned
return values. I would suggest a better approach to be to make
qca8k_mii_read32 to return an int value, and keep this check as is.
