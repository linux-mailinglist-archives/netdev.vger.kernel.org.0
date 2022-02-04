Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 770804A94AF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 08:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349915AbiBDHmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 02:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234310AbiBDHmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 02:42:43 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD63C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 23:42:43 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w14so11424585edd.10
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 23:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mNB0uXbRx6RrP4p7QdPnNV+8AobSHh2Z4XoExjv5Kig=;
        b=nZFGiVuWoKSOJhEqehqY7oiTcoCfDKGlPTXcK5qrRUWks5V2xsOFuBMpotBPIKUiqS
         tTyofgu2tiEBXHEfyv5rwU3E9ESwVDcZ3VtbvLaabdAciIf+XhYSh452YLep6OPY3bPo
         NxWzbsVTgUpMdQgvFwsp0DXbyF1gIfjvO07eus9eFz5uQmiRAa7SLhAxk2diOLoXoxyY
         zXF0/Mk/MVeQ98CST7f0SsG3fH1F4gEVPjPQbEsCgMKBzg6jM3WZ1M6AgyMGqKZjbBYZ
         ua2uEdr+qMkOJZhuMi/vTmYpcjOHXY2L90SA6WdnSD/vneTLb9rM0CbUHeEWv4xPzeFX
         Cdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mNB0uXbRx6RrP4p7QdPnNV+8AobSHh2Z4XoExjv5Kig=;
        b=c7K3qaSk7lzX1ezPV/JX/24jHPGa8hTyggjP6uEybwNmB8b5Y27eA854hHYUdzdbMc
         Qx9UyWyRSp7MXi57z+G+Ts+CTxgjyCu8mKw1XtFpvg2sx3tg9q2xWuXPQ8JNeeJdXYrV
         qmmLKu2YB2hwDF1noyZjJRjCcFpD7cXoIuaDkv7hz2owftdOBAVaCFdShzqtDKkiDAgn
         ylAemg+/h5xVlKc6MkkIE15JfQCR/HxadFEQb9UMOaOIQf4isruTFycea7+ccwKqkgSY
         xQY0kxeDPG+JIXr/sFEiSmbmVI9xYtzo/NC+bseGaJjTKedRxjTGya+2NagEDTbaQEkS
         UOxg==
X-Gm-Message-State: AOAM530+NqEgCB3aOVmEHiB1LyEj1zplfPor7lKjZZZci6K+U/uyU0aB
        L0wdHczJlP67mlVdDj0TmsKhFw==
X-Google-Smtp-Source: ABdhPJyQKo6OKnBUp+6d0E322yiocjGgrUvYLIsF7PkojSSmrKpC37wUNYB9aiZLy+hz06pB4dJbhg==
X-Received: by 2002:a05:6402:4256:: with SMTP id g22mr1791448edb.78.1643960562182;
        Thu, 03 Feb 2022 23:42:42 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id gv36sm371634ejc.94.2022.02.03.23.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 23:42:41 -0800 (PST)
Date:   Fri, 4 Feb 2022 09:42:39 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com,
        brouer@redhat.com
Subject: Re: [net-next v4 01/11] page_pool: kconfig: Add flag for page pool
 stats
Message-ID: <YfzY780CPu6z09Ki@hades>
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com>
 <1643933373-6590-2-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643933373-6590-2-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 04:09:23PM -0800, Joe Damato wrote:
> Control enabling / disabling page_pool_stats with a kernel config option.
> Option is defaulted to N.
> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  net/Kconfig | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/Kconfig b/net/Kconfig
> index 8a1f9d0..604b3eb 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -434,6 +434,18 @@ config NET_DEVLINK
>  config PAGE_POOL
>  	bool
>  
> +config PAGE_POOL_STATS
> +	default n
> +	bool "Page pool stats"
> +	depends on PAGE_POOL
> +	help
> +	  Enable page pool statistics to track allocations. Stats are exported
> +	  to the file /proc/net/page_pool_stat. Users can examine these

There's no proc anymore

> +	  stats to better understand how their drivers and the kernel's
> +	  page allocator, and the page pool interact with each other.
> +
> +	  If unsure, say N.
> +
>  config FAILOVER
>  	tristate "Generic failover module"
>  	help
> -- 
> 2.7.4
> 

Regards
/Ilias
