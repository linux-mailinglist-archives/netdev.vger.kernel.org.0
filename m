Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C672E2A665C
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbgKDO2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgKDO2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:28:39 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2BC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 06:28:39 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so2528207wml.5
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uS1Dwg1aYslTIaBFyfj8BDPGNhq8ESzxJRnXjOw6Owo=;
        b=F+n8eKOv1dsO6cWpkSpoiT/VytYZppb9uCV8KPO/NGrX4wDp/1iOrI9CwdHmqLO5dm
         hBwxF4OeXFRgbF0/9H8m8YCEajYc1Wdux2wvF7AcDsqvZYlPeVtwo9Qm8i2CcNUHBrlz
         kzUJsN3t9PrO05TXRVz42qKOZYISyOvuCUsVYI3a09YmrndVzyFIUMJLcpAebZrozQKx
         RlqKbnGwgQugSRn5NcBc93xPFh2OGMC8/xSc0L26Ouu4eWHZyo1TSVJVfFeTBWzNpm3E
         Sc328XYGo3AaYCPaGXflcYbzlaR5qxjFAI7mk6WbtkPznZQS4EpExgZQ/cV7Jqo6zJQC
         D4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uS1Dwg1aYslTIaBFyfj8BDPGNhq8ESzxJRnXjOw6Owo=;
        b=WuMVPfsU/HQ/5U3jnbREb41f4SIehoBOuYYl+x/3k3k93QyPBzwiZONBNiriKqWYzP
         xPP02eYSne+3i6Cyt88FS34g//fIFiSXAcKFNpm4xyoOR58nviZJnvVGuODurDHal+2h
         Ai+nIW4/eJQYm8iQZUO0YWUgejen3oW9I7lTJznQOotczISRWnATe6bq6q7CCntxl9vE
         2CNS2lhvAdpLfwMpP4G2xkPuAo3IOt4irO2AYA//FsMd4dY1SUTLaJrdC7IjsYIL8+Iu
         iJM4lTuwBDxtCcX9Dxp3KIhZ0d8M2L+qTp+PqeapPGJpVegua6mZt4wCSkaC0oMUCMOB
         5TGw==
X-Gm-Message-State: AOAM531UEdWp+gQGHAYzwBU20g24j8aBd7mEgyH7TLXgaOAq/a22KdM9
        UQ4CSAEOWluUBxi9P61va6b8F12EqYFikAMn
X-Google-Smtp-Source: ABdhPJwUWy2efD8bbASTzJwu6IghpqMmjIBqiho40nOEnruO2uYCdXF9F9tBxbqZjYuOhTpp06v3nQ==
X-Received: by 2002:a1c:6508:: with SMTP id z8mr3354105wmb.80.1604500118057;
        Wed, 04 Nov 2020 06:28:38 -0800 (PST)
Received: from dell ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id e25sm2857736wrc.76.2020.11.04.06.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:28:37 -0800 (PST)
Date:   Wed, 4 Nov 2020 14:28:35 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 06/12] net: ethernet: ti: am65-cpsw-qos: Demote
 non-conformant function header
Message-ID: <20201104142835.GD4488@dell>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-7-lee.jones@linaro.org>
 <20201104133354.GA933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201104133354.GA933237@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 04 Nov 2020, Andrew Lunn wrote:

> On Wed, Nov 04, 2020 at 09:06:04AM +0000, Lee Jones wrote:
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'ndev' not described in 'am65_cpsw_timer_set'
> >  drivers/net/ethernet/ti/am65-cpsw-qos.c:364: warning: Function parameter or member 'est_new' not described in 'am65_cpsw_timer_set'
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> I _think_ these have got missed so far in the various cleanup passes
> because of missing COMPILE_TEST. I've been adding that as part of
> fixing these warnings. When your respin, could you add that as well?

Yes, no problem.

Just for this symbol?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
