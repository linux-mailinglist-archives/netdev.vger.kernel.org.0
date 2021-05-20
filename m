Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E5238A028
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 10:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhETIvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 04:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhETIvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 04:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79ACF61244;
        Thu, 20 May 2021 08:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621500580;
        bh=65pjwq/JFCapy4YKN5ajvzgm+wVaddM90MWHgJxJMHs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jOOtLyDPC2zegrvitUvcJFU3A8TVtaQDJCVL2UEOZGyUwSAiGRyP+4YDqdBHG1YOT
         SdfnKsmCFJMW1C2KURlAU3lAznwOczH2Besxs32LRoJ04Z78vvOPTN1FvpWOE+pIjJ
         EpoCe7P+SO/wPsCZGrqPQX0qIioWa2j4Ej09xo8i1aj06oMklir2s1iRhEug2qU1bt
         O6nqa71qAoo5YKeEQEGoubPwntTS9+ouapRG8tAa5PFvr3adhJ0jvTUbvGkc+x2yL8
         7FoEIdJr5etXRM0WKTaAq8kMTYRZ9T/v9gXYdOpDdbBngut/y8Q2BtVE4iu1+ooWzt
         3LXgPWJOXBtkg==
Date:   Thu, 20 May 2021 11:49:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] mISDN: Remove obsolete PIPELINE_DEBUG debugging
 information
Message-ID: <YKYioHWGxUrdMogL@unreal>
References: <20210520021412.8100-1-thunder.leizhen@huawei.com>
 <20210520021412.8100-2-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520021412.8100-2-thunder.leizhen@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:14:11AM +0800, Zhen Lei wrote:
> As Leon Romanovsky's tips:
> The definition of macro PIPELINE_DEBUG is commented more than 10 years ago
> and can be seen as a dead code that should be removed.
> 
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/isdn/mISDN/dsp_pipeline.c | 46 ++-----------------------------
>  1 file changed, 2 insertions(+), 44 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
