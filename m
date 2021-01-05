Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827892EAA39
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 12:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbhAELwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 06:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbhAELwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 06:52:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC90C061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 03:51:52 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id w1so40792956ejf.11
        for <netdev@vger.kernel.org>; Tue, 05 Jan 2021 03:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FO3/cs03K5ytxQ01IiMbpcu2P7pBdKvUo0TqIJ6j1Y8=;
        b=LKm3l2/iTCeFZFkGvcWeejJgTr0TlDpp168JQ5vq5MwcrNmypQ+y+5SxituW+ppnlr
         eod+9t/7mA209hfKjnWTE90Pxa9xrb0iPxZLTHyIq5f7nOlilFYS6ZHk61RPdpdBsvrf
         NHSxHEbYdXYZj6BInb5NYQwVuT0hPEtq+pUNEtO6lH5ojInAkv1GALxBzkW0Jshnw1X0
         eqYJoRvgxWGfiqSirTCcYavoYKQtVJLM2HJzmKPBE1G1W06ZdCIF6XMPOxlcmLeI8L7i
         jegrUEERF9CohslUOkL2ldeaCoiK7tpx7c8MJLHbFL9xFVf/5qFQ8bvASy1e5r+HI3Hr
         yHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FO3/cs03K5ytxQ01IiMbpcu2P7pBdKvUo0TqIJ6j1Y8=;
        b=J1HopeMuogeakzbEVZ4809anuS+45CUsqTUw5gm1ZZab6NhBaIAPstgVC8nEg7CTPB
         x+Si79+oOZkmLhpfuLlnJcIUIZC6uZ6f3X4+BGXUPZrsrPnGpvNzw57m9Fu6Wo/cVmSB
         h/KjHmseUxSRPXV91ez5303G1nDS4zNcuZtmdQFz4HOs1wgmOirxZg+FYvE05XewozQ/
         fmbtvlmr0rX9XsW9/z4BPnuX+eyFLJQaTmkqIC/rXvu8KqU3/UFSY5MzQ8/7LK90PjXb
         Q2gR0lcZfjVR59OLnn0zdVHML6fcSsdDpl79ZCZaMCPQ8Uh8k60tG1fvS7MY7Bt0Z4ma
         RuFg==
X-Gm-Message-State: AOAM531zawSgryVBj3PKKIkkHpM5/oXFGcjkWr+vd3GyVfMwJysxH2ka
        nLDCrbW8DMtinTQzeUU0cgV1WRN1bpM=
X-Google-Smtp-Source: ABdhPJxbpW3jrD7w2pmWc7YEB/U+nDNWKs1rD9Oh5LbA+Q+bCX5P/YCl+wN4/piwMhavbFlSNbZzbA==
X-Received: by 2002:a17:906:3401:: with SMTP id c1mr72160098ejb.156.1609847510896;
        Tue, 05 Jan 2021 03:51:50 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r24sm44899213edo.4.2021.01.05.03.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:51:50 -0800 (PST)
Date:   Tue, 5 Jan 2021 13:51:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] docs: net: fix documentation on .ndo_get_stats
Message-ID: <20210105115149.f64yqrup6rxte4dh@skbuf>
References: <20210105012224.1681573-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105012224.1681573-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 05:22:24PM -0800, Jakub Kicinski wrote:
> Fix calling context.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdevices.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
> index 5a85fcc80c76..e65665c5ab50 100644
> --- a/Documentation/networking/netdevices.rst
> +++ b/Documentation/networking/netdevices.rst
> @@ -64,8 +64,8 @@ struct net_device synchronization rules
>  	Context: process
>  
>  ndo_get_stats:
> -	Synchronization: dev_base_lock rwlock.
> -	Context: nominally process, but don't sleep inside an rwlock
> +	Synchronization: rtnl_lock() semaphore, dev_base_lock rwlock, or RCU.
> +	Context: atomic (can't sleep under rwlock or RCU)
>  
>  ndo_start_xmit:
>  	Synchronization: __netif_tx_lock spinlock.
> -- 
> 2.26.2
> 

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
