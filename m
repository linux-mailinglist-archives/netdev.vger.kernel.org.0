Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9882BB14F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgKTRVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgKTRVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 12:21:00 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34D3C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 09:20:59 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a65so10486017wme.1
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 09:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kcWBFZEGFlKqtofVth19PHCa2qne0PRI8NvJqrfnJ3s=;
        b=tM/gqn3HR30Xx4Zh0MOxET5AWOV5TrNIKsgShDoKOif7rt0KRQ1eA32AdIlYuSkp6k
         sHO5myUPaRK1FAvyGSanPs/ATOadrmCUeFjQuk5TQzFQqWbBXQw3QCva2TBklMw68eWo
         yQG2OnL9sMx8DuJSstbQ86zDnq0GEC/Re4RrYoo5FTsmyHAiWQae9PZ8OSwK+NJV8PPd
         hrqnaRgH16Rzc3CIeVc2CINbfRdQ3Y5zQCamepY3Rty2XHiYpZj/31h2QdiF7Q7mgucW
         wfT3dhbwODPEIYEPgmqGiTMGQQ03NzWhF76LWBUf+2vyLkHB9rspW/xk+psohqd/NJf+
         J9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kcWBFZEGFlKqtofVth19PHCa2qne0PRI8NvJqrfnJ3s=;
        b=aS9yE9kxzVvRv91a5fZiv5azRa2LSv2mP8Tn5/tLLGKkG+YNOmoMjlI3aoZDgAKOTQ
         j3lWUGKZafhyIMp6B6jHPEzTU/xm43b0SnT1WneXQKhTaqyXXTMIMJe+ihMTtOeRKbii
         67cZM+IGuTOsaJfLdgQU7YXF+BXBiQ0MdGtyYGCPVsQxsGnleuHP804katZK2xxjb1kP
         e2HvooHe33OaNB5VwLsAZw8fb8D2+ctCJwfNDCc2pUXCtL74DJRTLGZkR+Q/+HWqLLtY
         1qJ/ygWzj4nblXb87X86wAh7E+beDXlUrOBiokWzBbrNnPq/MraYxIIqmixVPesnY3OK
         vOMQ==
X-Gm-Message-State: AOAM531z7qbfQRykSy7UPzW1IyunPyKZ4mGcy5U81u4cMsiWvfuIyEKo
        fhJYQBKufauRxaME30A59g6uLA==
X-Google-Smtp-Source: ABdhPJxEkq71FI03+OdTbbERSUpd5Mpx4kwzBOqwkXLlIDpYTeC6cdImkomsITSHN9QJ5u1QqpowZA==
X-Received: by 2002:a1c:3d54:: with SMTP id k81mr11583038wma.144.1605892858434;
        Fri, 20 Nov 2020 09:20:58 -0800 (PST)
Received: from apalos.home (ppp-94-64-112-220.home.otenet.gr. [94.64.112.220])
        by smtp.gmail.com with ESMTPSA id 109sm5637339wra.29.2020.11.20.09.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 09:20:58 -0800 (PST)
Date:   Fri, 20 Nov 2020 19:20:55 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] MAINTAINERS: Update page pool entry
Message-ID: <20201120172055.GA790738@apalos.home>
References: <160586497895.2808766.2902017028647296556.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160586497895.2808766.2902017028647296556.stgit@firesoul>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:36:19AM +0100, Jesper Dangaard Brouer wrote:
> Add some file F: matches that is related to page_pool.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f827f504251b..efcdc68a03b1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13179,6 +13179,8 @@ L:	netdev@vger.kernel.org
>  S:	Supported
>  F:	include/net/page_pool.h
>  F:	net/core/page_pool.c
> +F:	include/trace/events/page_pool.h
> +F:	Documentation/networking/page_pool.rst
>  
>  PANASONIC LAPTOP ACPI EXTRAS DRIVER
>  M:	Harald Welte <laforge@gnumonks.org>
> 
> 
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
