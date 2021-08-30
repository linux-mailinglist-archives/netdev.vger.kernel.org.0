Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF1F3FB499
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 13:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbhH3LbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 07:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236397AbhH3LbA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 07:31:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E978061139;
        Mon, 30 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630323007;
        bh=4tXTk/7KNC+gT+6ButRi4wIIyra4WmcdLPO4LXO3XQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ridLiZOTVJloHtE+lGqdGk6hc86ff2UKyawWxwFwCK4QSHKZnfeb2iMZZXwIUMUPY
         8Q/Q8+kpdfJmfxZ9zepYspzsEupC98yTkh1dTXse/1arlNmrISkbRur7wowMvauww2
         UiuXU7IYX+0JTtpLdwuGORRRkcV2LHU2dbjuVZ1PPN1z2Oyp7mVrqqm9TfneuY9iby
         EEHKRmlbc3Jueq8QT7p+CtD9xakhza4NMV7/IoMDZ1RZDkvbXtv6Hzpp6IOrxqHCHg
         +zFBs2T216Bq8+jqVHGd47yjFQP0XRkZXWp86wccTPGKkEqjlPXrk9xjLtGaIQxG5f
         oEcd7yUfk/UDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DDC7060A6F;
        Mon, 30 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: qrtr: make checks in qrtr_endpoint_post()
 stricter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163032300690.3135.17165027106916962159.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Aug 2021 11:30:06 +0000
References: <20210830083717.GU7722@kadam>
In-Reply-To: <20210830083717.GU7722@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     mani@kernel.org, loic.poulain@linaro.org,
        butterflyhuangxx@gmail.com, davem@davemloft.net, kuba@kernel.org,
        bjorn.andersson@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 11:37:17 +0300 you wrote:
> These checks are still not strict enough.  The main problem is that if
> "cb->type == QRTR_TYPE_NEW_SERVER" is true then "len - hdrlen" is
> guaranteed to be 4 but we need to be at least 16 bytes.  In fact, we
> can reject everything smaller than sizeof(*pkt) which is 20 bytes.
> 
> Also I don't like the ALIGN(size, 4).  It's better to just insist that
> data is needs to be aligned at the start.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: qrtr: make checks in qrtr_endpoint_post() stricter
    https://git.kernel.org/netdev/net-next/c/aaa8e4922c88

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


