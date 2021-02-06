Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BEE311ABA
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhBFEMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:12:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231354AbhBFEKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 23:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 27E9664F05;
        Sat,  6 Feb 2021 04:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612584608;
        bh=wNYQu/XGEnEp/U0vSlR2d/tI2XllSHqm5QJmAMSR/Hc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZPA7h8UNjLg4JMlI7m2dAXpCKlIgftzuGnojlniUkUWHScnyeKc5xIDBvIsixKTyy
         TUGEHISiTglTrM6NBLpson4PWSG42qqy6GmcrEs/c5iMBxedLCgwvpKC95Uh2ZHo5f
         QvBQPhcHeFljn8I8rYF+phoqZCuhfS8diziSq7DTmsBInkrz2Go6F7/fYpsB4JkEG1
         JD0yOE4CFKIU3rxSZBK25t5d0J5Mv+FNw8S9OyTSvuOCbgONAfW0uI9BVl3ynuB7cT
         PKgk+vXgOGzq2ZRpGzj6ZEJy3XuGUUJNJkzri56iuS+GTPyylais1LGWwaD8UkKD9i
         6sry15QYibZ0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F677609F6;
        Sat,  6 Feb 2021 04:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] net: stmmac: set TxQ mode back to DCB after disabling
 CBS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161258460805.22008.14706374158148847125.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 04:10:08 +0000
References: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
In-Reply-To: <1612447396-20351-1-git-send-email-yoong.siang.song@intel.com>
To:     Song Yoong Siang <yoong.siang.song@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, weifeng.voon@intel.com,
        vee.khee.wong@intel.com, vinicius.gomes@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Feb 2021 22:03:16 +0800 you wrote:
> From: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
> 
> When disable CBS, mode_to_use parameter is not updated even the operation
> mode of Tx Queue is changed to Data Centre Bridging (DCB). Therefore,
> when tc_setup_cbs() function is called to re-enable CBS, the operation
> mode of Tx Queue remains at DCB, which causing CBS fails to work.
> 
> [...]

Here is the summary with links:
  - [net,1/1] net: stmmac: set TxQ mode back to DCB after disabling CBS
    https://git.kernel.org/netdev/net/c/f317e2ea8c88

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


