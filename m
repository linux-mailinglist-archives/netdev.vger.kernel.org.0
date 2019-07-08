Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E8861C07
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbfGHI7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 04:59:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41642 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfGHI7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 04:59:41 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so16083220wrm.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 01:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6LNLQ1CQ/ooylpkl1l39qHsdPuVbJR9DRHfg8zODy/s=;
        b=XfUMdbIDbXSNE4Fb5l1pUzUldsyI1L00SyO2TWtNxUGH4GOs8BXFW2HA2AoGEuqtSo
         XfD4wwLTmVCOK6e/TXIJmPW3bN6t+pwbYJvhoX+tVJHfWwQ7VadhUExhVScRRvBZM2Py
         0/pFUw6zc+w2b4auMUgU25IU8wMVGJZQpT1uTCIxhM+mOY3g7J0jsVMvkCSvozbYcBqU
         Bgjxc6MNsaGJLDCLMOZUhqqJMPTIcX/X2c/FTm3oO5QPzeR16knWF+55pgSFW+5RK8bL
         uFXOxYbKkBdKZCIY1s7HA93MFfPKsc9QCBlKr5IX5wYeNx9pZGCIaElOVQQdH70GxQxa
         DrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6LNLQ1CQ/ooylpkl1l39qHsdPuVbJR9DRHfg8zODy/s=;
        b=L7W6aWO4rfCCl55XoRoCnuW09yxz9nrUBoqifOyxUrEG93tuPKo5i4WPHaaDB2yzbM
         yHausxdJ3vTf56/yQK3h7RyjEvJzA+XdZmtFfT2re2TrO/5pas86uKcNKrF8T5gzupRL
         B3+yVVw/4V3QQ13JcZJIzSWkyUMmFpPzjacaD3pMTiE5ngv0TInzHJvam5BTduk6YjfO
         /hqTECEZzxToRm+XhJxcmWeOmkKc61EsG4Mtv+y+wBw22/ghcSyOuIjrIie7TOp7wkvJ
         dO41E7l/WudJohBt+UueoSlYUC0LRw5F4PU5DfB0lR59BSU2cUHozIsNxNnrvEmjcyDd
         M31Q==
X-Gm-Message-State: APjAAAUg+dN3ckyLUJbBDSlf/dW/CCIAnuEdAIttSAa6arZr0VE/FNKI
        0s3FK9wg4lKHtjg9WiufbY0M3w==
X-Google-Smtp-Source: APXvYqxFUGnNUJOh7ZLwTz7iFbWyFTHe0c5XHSoVCkaQ5+/V8gaMKydddRSagtpcYr0+WlE+XvnuFw==
X-Received: by 2002:a5d:6783:: with SMTP id v3mr17664661wru.318.1562576379643;
        Mon, 08 Jul 2019 01:59:39 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id a67sm16205761wmh.40.2019.07.08.01.59.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 01:59:38 -0700 (PDT)
Date:   Mon, 8 Jul 2019 11:59:36 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        ast@kernel.org
Subject: Re: [PATCH net-next V2] MAINTAINERS: Add page_pool maintainer entry
Message-ID: <20190708085936.GA31260@apalos>
References: <156233140902.25371.7033961410347587264.stgit@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156233140902.25371.7033961410347587264.stgit@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 02:57:55PM +0200, Jesper Dangaard Brouer wrote:
> In this release cycle the number of NIC drivers using page_pool
> will likely reach 4 drivers.  It is about time to add a maintainer
> entry.  Add myself and Ilias.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
> V2: Ilias also volunteered to co-maintain over IRC

Would be glad to serve as one

> 
>  MAINTAINERS |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 449e7cdb3303..22655aa84a46 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11902,6 +11902,14 @@ F:	kernel/padata.c
>  F:	include/linux/padata.h
>  F:	Documentation/padata.txt
>  
> +PAGE POOL
> +M:	Jesper Dangaard Brouer <hawk@kernel.org>
> +M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
> +L:	netdev@vger.kernel.org
> +S:	Supported
> +F:	net/core/page_pool.c
> +F:	include/net/page_pool.h
> +
>  PANASONIC LAPTOP ACPI EXTRAS DRIVER
>  M:	Harald Welte <laforge@gnumonks.org>
>  L:	platform-driver-x86@vger.kernel.org
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
