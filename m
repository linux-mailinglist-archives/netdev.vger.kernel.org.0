Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61114390C39
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhEYWbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhEYWbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 18:31:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80F90613F5;
        Tue, 25 May 2021 22:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621981810;
        bh=ofNWTv6lLJ0tjyNLsLHZ5kdgltGQWV8/cSd4BWAnRjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JOWFUBwsHZkQZJq4/Fb1a/p0sRVya5AzzgKNzGZwVw4bnSYBiM3L4TEJnKDB8MImT
         hG6nHC1GePxQQ7zEUCp+8kcl2/dCnfjsfU85R2Hl0c+z2c99xhBqYCTLesjrxSgbxB
         OGCvruKyP5bNpyX5XkPo3x2oQqw1ewzwHFHXtXv0N0Vl+RaRLt6D56ltOoj35JKiOk
         q2KP9tgb6VhjS/e47PaoknyjJ4uFGhn5MAAyzqWWwYWyED1F1wk5eGWgSbbZ1eIifS
         V4Ubn9+rl90xPIHpu4S7/ZKKWY6p7OYMU1vt8kNiQEneEEV6QTNdyophk5IRtuRJsm
         sr6CRrVbDQHjQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 72E7B60BE2;
        Tue, 25 May 2021 22:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: Fix kernel-doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198181046.18500.8133647510456206495.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 22:30:10 +0000
References: <1621939967-67560-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1621939967-67560-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 18:52:47 +0800 you wrote:
> Fix function name in hns_ethtool.c kernel-doc comment
> to remove these warnings found by clang_w1.
> 
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:202: warning: expecting
> prototype for hns_nic_set_link_settings(). Prototype was for
> hns_nic_set_link_ksettings() instead.
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:837: warning: expecting
> prototype for get_ethtool_stats(). Prototype was for
> hns_get_ethtool_stats() instead.
> drivers/net/ethernet/hisilicon/hns/hns_ethtool.c:894: warning:
> expecting prototype for get_strings(). Prototype was for
> hns_get_strings() instead.
> 
> [...]

Here is the summary with links:
  - net: hns: Fix kernel-doc
    https://git.kernel.org/netdev/net/c/c1cf1afd8b0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


