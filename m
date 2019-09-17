Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF83B459B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 04:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390204AbfIQCpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 22:45:06 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35942 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729149AbfIQCpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 22:45:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id y22so1223144pfr.3
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 19:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=QJL+aqYGZOzi+1S1uVjyRsVzuSiyBunq1zPtSdS5Ngk=;
        b=Rz68VtLWPZve67DrfVuadUoQESUa/AG3FLXnc1mEM/oGiyx7RvQUip+zD8MQFeNf28
         VEhhRInbuOaFMUT31f7om6pr70JSKpzjFNnqn+dbYGgKZLNzCtE5/RHxLN0kA/dUv34R
         RgDXH/lF0ynANJsinx49g1DdmV5XA3Kv/RBykEeawam3G4HGo7tJEi1XoldqK7K+JQEp
         watvx1kvG/qJGKC76rWIdzqLJkUQ7MXqjZbbvSzV22xVXJPMd7fDIguidj4U3EGd/0Ny
         TUJBtLtmD25QrJvZZ3MoxipyDnQc0ZZeoT4AOKIQwXGfRv3Ckfqeii/LtepH3BJEC2xv
         sUyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=QJL+aqYGZOzi+1S1uVjyRsVzuSiyBunq1zPtSdS5Ngk=;
        b=GK9LMlIeBkZc6iPTJv44Gkt2+8wCfqrhCt6INdF+K3sPugXuZUoFgyododRRb7vMXd
         THD9n2Grt41gEjFDwUhQ/LmGn2uht2fzaf76mjB4+hMim0+s26t6VP71ahqELgK8HlEA
         /XVHXIS/E/lhldO+BRYbyZhgiFaC4w5GAZp+QlbZNKG80WPfPNlYYqhWDIc2muTsvkyi
         VuMA4I6rqHUnR0V8Ljo+W8iT4x+y8PdeokOQHoZbFHfp8FfNWg6U5tTeyxjWCAGSTTDH
         t+8C0mzpbfz75MUzELn/tfH0MRj44a4lzAPMsS8P+XsKxhvvmGcldBweHzUJ29pElqHw
         BGmA==
X-Gm-Message-State: APjAAAW8B6ivMnymzpa8L/7Ls1xxGjJoh6/roEqpfNatr1PULdjRF81T
        wndXykeAUlDrnXwhj/onNdWAfg==
X-Google-Smtp-Source: APXvYqygxI3Q793vEKcEk1D+2AuMLr4MRWVuReewvXty3D8SKVAy4S/PhGZVM9BVgvXrVUUMrtyi1w==
X-Received: by 2002:a17:90a:f48f:: with SMTP id bx15mr2543032pjb.75.1568688305762;
        Mon, 16 Sep 2019 19:45:05 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::2])
        by smtp.gmail.com with ESMTPSA id j10sm507304pjn.3.2019.09.16.19.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 19:45:05 -0700 (PDT)
Date:   Mon, 16 Sep 2019 19:45:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <kvalo@codeaurora.org>,
        <pkshih@realtek.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] nfp: Drop unnecessary continue in
 nfp_net_pf_alloc_vnics
Message-ID: <20190916194502.0c014667@cakuba.netronome.com>
In-Reply-To: <1567568784-9669-3-git-send-email-zhongjiang@huawei.com>
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
        <1567568784-9669-3-git-send-email-zhongjiang@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Sep 2019 11:46:23 +0800, zhong jiang wrote:
> Continue is not needed at the bottom of a loop.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
> index 986464d..68db47d 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
> @@ -205,10 +205,8 @@ static void nfp_net_pf_free_vnics(struct nfp_pf *pf)
>  		ctrl_bar += NFP_PF_CSR_SLICE_SIZE;
>  
>  		/* Kill the vNIC if app init marked it as invalid */
> -		if (nn->port && nn->port->type == NFP_PORT_INVALID) {
> +		if (nn->port && nn->port->type == NFP_PORT_INVALID)
>  			nfp_net_pf_free_vnic(pf, nn);
> -			continue;
> -		}

Ugh, I already nack at least one patch like this, this continue makes
the _intent_ of the code more clear, the compiler will ignore it anyway.

I guess there's no use in fighting the bots..

>  	}
>  
>  	if (list_empty(&pf->vnics))

