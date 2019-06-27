Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED0758B64
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 22:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF0UGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 16:06:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41895 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfF0UGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 16:06:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id d17so3866453qtj.8;
        Thu, 27 Jun 2019 13:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s+ZWn/RCRJ3CsjrQtB3J8Syz+Z54G249wMsbVlPVU5Q=;
        b=N6Yl/Mhye5YzFjWqZiW8CQI03B/gz8aFoEQcUjO5cf3txvJBGsFNSU3EAwUlww2pKf
         rN7pcwAZoFZypLULgib8YuFzqXFVsSd0DuesHBIvHQCRzAU7m+ghVYBV4jLsNKLfMbbG
         +PHd0Z5xwtYgrK6RTJzlS049lW2melX3+8BG4xXdYZYKYIrVukTnSrm9PYnCXp3Xa0O1
         Hg1nzZg4Je3lPQkxX3aHOMA19K6KncMyMKT0T9iFECw9oG6dJ3/Q0VBF4E0Hi5A7Bl3d
         O/VwI1dHEPIdZjLpJvMU3v9NzYgqH0HMyTa16d0JQtxbfHDm1MV70Vxl5jW989Syjf9i
         BuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+ZWn/RCRJ3CsjrQtB3J8Syz+Z54G249wMsbVlPVU5Q=;
        b=RIP7Ax8/hMhxVXzwGgpv4Gd60sNunMvlwF93P5yABBqYhp0JXpB2LaH9puLqcVk+vB
         qpox8Tcmw9x66vc2xFGzCBzJq1HHiFKHZW12W2hl+lqrGKFfkG0JtTTuswLmGrGUGr5k
         zKaD4vXsColWcJ0a+p/cPVXH1wrH4X3NK26brLFDzDHfW6vmnAtTH5Xqqest7gcyYeG5
         HPVLCRHDW4X8Qx2VKMgskTNEeY+Y1gJDM3ORAkP2eQulMKjP2PCo3V/bYlpxp/zgGx6u
         MdJ9SFTBBMs64gdjaS8fnlO/dAZJKhBel+suuQjvUXQHfMQu3kXOsK0byWwR1xqI2d76
         PnzQ==
X-Gm-Message-State: APjAAAX5Po1Dvv4hrEk7foAcJxTHjnztvLr5uCj45K+X7WaHFy6Wor1N
        FePnMft9VYt4Gv/WwgqQPox1TdGTR+E=
X-Google-Smtp-Source: APXvYqzGB8WazRbgEhe3RfAs7LKvFr/dr1BJUpIop6eQJcUCYNXP+TZwedgFix67cRVLinUpIDiqBQ==
X-Received: by 2002:ad4:5405:: with SMTP id f5mr2478523qvt.242.1561665994589;
        Thu, 27 Jun 2019 13:06:34 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11c1::103b? ([2620:10d:c091:480::e001])
        by smtp.gmail.com with ESMTPSA id u26sm41319qkk.52.2019.06.27.13.06.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 13:06:33 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 80/87] net: hippi: remove memset after
 pci_alloc_consistent
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190627174452.5677-1-huangfq.daxian@gmail.com>
Message-ID: <518f3f6a-9d1b-11f8-e900-fcdc9e140110@gmail.com>
Date:   Thu, 27 Jun 2019 16:06:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190627174452.5677-1-huangfq.daxian@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 1:44 PM, Fuqian Huang wrote:
> pci_alloc_consistent calls dma_alloc_coherent directly.
> In commit af7ddd8a627c
> ("Merge tag 'dma-mapping-4.21' of git://git.infradead.org/users/hch/dma-mapping"),
> dma_alloc_coherent has already zeroed the memory.
> So memset is not needed.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>  drivers/net/hippi/rrunner.c | 2 --
>  1 file changed, 2 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@gmail.com>

> diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
> index 7b9350dbebdd..2a6ec5394966 100644
> --- a/drivers/net/hippi/rrunner.c
> +++ b/drivers/net/hippi/rrunner.c
> @@ -1196,7 +1196,6 @@ static int rr_open(struct net_device *dev)
>  		goto error;
>  	}
>  	rrpriv->rx_ctrl_dma = dma_addr;
> -	memset(rrpriv->rx_ctrl, 0, 256*sizeof(struct ring_ctrl));
>  
>  	rrpriv->info = pci_alloc_consistent(pdev, sizeof(struct rr_info),
>  					    &dma_addr);
> @@ -1205,7 +1204,6 @@ static int rr_open(struct net_device *dev)
>  		goto error;
>  	}
>  	rrpriv->info_dma = dma_addr;
> -	memset(rrpriv->info, 0, sizeof(struct rr_info));
>  	wmb();
>  
>  	spin_lock_irqsave(&rrpriv->lock, flags);
> 

