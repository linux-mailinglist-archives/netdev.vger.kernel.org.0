Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFFF33C247
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhCOQi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbhCOQiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:38:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F7C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:38:12 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a13so479511pln.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 09:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7ommeHaQDyz4Z/WeuEPFCK86plIfICfSp9m108lanYA=;
        b=wcLQboA/cDMqN3tBAKBL+i/49YA9L/5/3qUfawZYvHcNMghAvwRSv8GY4e8LJTGJP/
         7gO0MLxwb6wXTBdNf/SzMk9SMatmFP/EFB1E4H3uPI2WXCETgbg1CesYHBjeA5TQQysl
         RocLDV1SfiP7bjZjSa8A+t1foWsvdJRVXyZy8O9NRrMNtnBHHUEM+N8X9uuH2qXcOdSE
         Vnj9c1dVS/aZRFFOu6F+hC8wnfHyePI17MIhMCbNq3NiuDFQzHKnKgoO2/mkyUgSnInv
         4sQZvFl9/YAeMeD8zraMpNuuvRaTNPBzSUyaMcp291tkkqFHIlCereJfUUmHNbM14J4g
         bGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7ommeHaQDyz4Z/WeuEPFCK86plIfICfSp9m108lanYA=;
        b=uXnTaA2nQKy1EENXq773F+wHDYPffjfXTeMxRzLK7X3Dhd9wef0jEJMd0kXMCbrEr4
         QSnOug/6/1YePN8TMXXtfYz8NmmCPE5jTzS2rP6htu7PG0AafOz2JmlVETyOBS0TlGQ+
         TNN25DKKeEu8ONWunFFhVwAPmInILi6l9vqVtZ06oRD1YwRsh35WyGSP9PR/WOohPQEJ
         t2V4CSpiY6x09aNRNin/aXaXRkjqEevBcr8G+AeH1zapsQh/U9NRo0NP8eCLeSYZftNx
         XB+Ih9mb/DX7WjUAw4R5YfTHjzRr1fsIfaY8fFbjAS1TWRRPipxkDbBPBxQTorgSR18F
         Lpgg==
X-Gm-Message-State: AOAM533yc0JBN3uGSFSr+G+T9gEAhjnO65qTy3zh7h+kwbSDy6/MSXAv
        Wp/zYkI6P2vbDQ4adbcedoOA
X-Google-Smtp-Source: ABdhPJwCUUts93OXJ3n2Y/V2Lm9Ghn0pgNJogbRZzskNp+B49O8ccSYpy3p8O0uiuZ8+jfER2O9Lcg==
X-Received: by 2002:a17:90a:c918:: with SMTP id v24mr13940988pjt.182.1615826291839;
        Mon, 15 Mar 2021 09:38:11 -0700 (PDT)
Received: from work ([103.66.79.72])
        by smtp.gmail.com with ESMTPSA id a15sm138240pju.34.2021.03.15.09.38.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 09:38:11 -0700 (PDT)
Date:   Mon, 15 Mar 2021 22:08:07 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: ipa: QMI fixes
Message-ID: <20210315163807.GA29414@work>
References: <20210315152112.1907968-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315152112.1907968-1-elder@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

On Mon, Mar 15, 2021 at 10:21:09AM -0500, Alex Elder wrote:
> Mani Sadhasivam discovered some errors in the definitions of some
> QMI messages used for IPA.  This series addresses those errors,
> and extends the definition of one message type to include some
> newly-defined fields.
> 

Thanks for the patches. I guess you need to add Fixes tag for patches 1,2 and
they should be backported to stable.

Thanks,
Mani

> 					-Alex
> 
> Alex Elder (3):
>   net: ipa: fix a duplicated tlv_type value
>   net: ipa: fix another QMI message definition
>   net: ipa: extend the INDICATION_REGISTER request
> 
>  drivers/net/ipa/ipa_qmi_msg.c | 78 +++++++++++++++++++++++++++++++----
>  drivers/net/ipa/ipa_qmi_msg.h |  6 ++-
>  2 files changed, 74 insertions(+), 10 deletions(-)
> 
> -- 
> 2.27.0
> 
