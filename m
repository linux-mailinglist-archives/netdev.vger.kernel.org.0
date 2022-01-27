Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57C49DD55
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiA0JIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiA0JIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:08:55 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2304C061714
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 01:08:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id l5so2697843edv.3
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 01:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HvQQAVsg0dJfEy7+zBgccu7UF4q0F9lxjqMhsu9XVTw=;
        b=yTaQQrKm/0wkI2eOTdwMYvbKgVWw38IViFwrI6+bKgOXJJwGIAjAAwj7yQ8f7vNI+V
         +SCyrv5Z+fZgWxVLniHDHRE+FlIffitLpxDHZniL+gmmFCiHHvC78ZcfWJOjD9UAZaUO
         T8ItZ65273U7FnNSXJcAuziq2v5FC39MfMRUZxU1It31HLibGyySnIZRbIURvg9Kb3kz
         nLyGxO+5d45s/nq0pK+lWZ+Rm6lhJUS9aDmZIgK7BQ8AWVUKwDsPN5t6/S17RqqrmBFA
         bFxs5XkN0gCB8qzLH9oczGGHhFMMNQrLa4zQTrj+Q8MKHZKh8CPyLMYGMl6jWwmRUxe9
         wAqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HvQQAVsg0dJfEy7+zBgccu7UF4q0F9lxjqMhsu9XVTw=;
        b=DuSyGzkewmebnl67oUGo1pwZZQImb2vT7+kutRMyJ86FZ797wMTJY3bAS0L5Iq/7mb
         uu8ojckqbBIZbi+RlrboTMTaWCSmWoOrOknnMgT5LYUYUQMN5reyRqLI5trIXr+82ZAz
         shjoKsqJLA2fKKAhesNPHNEFoAfidS5SXdN4Cn6jHSoubU2gG40KhDUulSXPdmIW9F/X
         W7dS8GJsuS9tZnfcT5gulLVWEToIile6EW7fNtP5HWJKf6JEiU2/OVeTBHHDlJGVTmiQ
         sSG5UI+fyYOXjx68IFOT6tRQ1Hf7I9mda5ZBQ6MzqYZWU+7SDs8C+iNBzmN9vlXPpcp1
         1Dng==
X-Gm-Message-State: AOAM532O0Ibl3rYBCXUskB+i9XCQC2hF16ZFjtUu1eLhC+RsH6gKmQ25
        +y2ouKR6+pIRvNCig6o9rJjgqDP8C8NxqBZl
X-Google-Smtp-Source: ABdhPJxGCZGoeoF6jF/ap9b4i9q2R9ZntZ2rlfOK99IjDTIwVg9xqFNyZhrJJnv5w6AlWC4tXcGqeA==
X-Received: by 2002:a50:d70e:: with SMTP id t14mr2710589edi.19.1643274533188;
        Thu, 27 Jan 2022 01:08:53 -0800 (PST)
Received: from hades (athedsl-4461669.home.otenet.gr. [94.71.4.85])
        by smtp.gmail.com with ESMTPSA id bv2sm8385727ejb.154.2022.01.27.01.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:08:52 -0800 (PST)
Date:   Thu, 27 Jan 2022 11:08:50 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Joe Damato <jdamato@fastly.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
Message-ID: <YfJhIpBGW6suBwkY@hades>
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe, 

On Wed, Jan 26, 2022 at 02:48:14PM -0800, Joe Damato wrote:
> Greetings:
> 
> This series adds some stat counters for the page_pool allocation path which
> help to track:
> 
> 	- fast path allocations
> 	- slow path order-0 allocations
> 	- slow path high order allocations
> 	- refills which failed due to an empty ptr ring, forcing a slow
> 	  path allocation
> 	- allocations fulfilled via successful refill
> 	- pages which cannot be added to the cache because of numa mismatch
> 	  (i.e. waived)
> 

Thanks for the patch.  Stats are something that's indeed missing from the
API.  The patch  should work for Rx based allocations (which is what you
currently cover),  since the RX side is usually protected by NAPI.  However
we've added a few features recently,  which we would like to have stats on. 

commit 6a5bcd84e886("page_pool: Allow drivers to hint on SKB recycling"),
introduces recycling capabilities on the API.  I think it would be far more
interesting to be able to extend the statistics to recycled/non-recycled
packets as well in the future.  But the recycling is asynchronous and we
can't add locks just for the sake of accurate statistics.  Can we instead
convert that to a per-cpu structure for producers?

Thanks!
/Ilias

> Some static inline wrappers are provided for accessing these stats. The
> intention is that drivers which use the page_pool API can, if they choose,
> use this stats API.
> 
> It assumed that the API consumer will ensure the page_pool is not destroyed
> during calls to the stats API.
> 
> If this series is accepted, I'll submit a follow up patch which will export
> these stats per RX-ring via ethtool in a driver which uses the page_pool
> API.
> 
> Joe Damato (6):
>   net: page_pool: Add alloc stats and fast path stat
>   net: page_pool: Add a stat for the slow alloc path
>   net: page_pool: Add a high order alloc stat
>   net: page_pool: Add stat tracking empty ring
>   net: page_pool: Add stat tracking cache refills.
>   net: page_pool: Add a stat tracking waived pages.
> 
>  include/net/page_pool.h | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
>  net/core/page_pool.c    | 15 +++++++--
>  2 files changed, 94 insertions(+), 3 deletions(-)
> 
> -- 
> 2.7.4
> 
