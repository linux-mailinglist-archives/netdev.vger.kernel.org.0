Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1B93E9ABF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhHKWKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232454AbhHKWKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 44C03610A2;
        Wed, 11 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719806;
        bh=ObA499EowZE86zIjq4Tew8lZjDHMFvaUuFgskkIQcQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WPji2I2XzETwFtWFXM9Cuqrvewp1rrmhM8JlRPozzgi/pB7YNBTU70iSGT/W2PagN
         CDumR7SveRsOeraoY9d7EF8Y6qJaiHfAMnRxwJAT0MPx4vJ4OPLDMUaZbKa5thJIYN
         u/JKkdgmXRuoLBqK+qa2jEZDgicwxlXwe+9VY0iJXe89v1RSa/co4FHqN6e1u7zsAt
         Dkh39w+xoCOH1BbKr7nmaQfNC9279ArkmqZdq2bX8pGy/0LnVMH3MhiI1pePFQxy80
         QzkAWMywtqLcB2Eon8Xid2ASfjEocNCq95bHzyd7CzsiGlfIbfyv+KoYuQas2gCZNM
         jvmt5AC3kvLbw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F1F7609AD;
        Wed, 11 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns3: add support for triggering reset by
 ethtool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871980625.25380.12688842231562216208.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:10:06 +0000
References: <1628602128-15640-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1628602128-15640-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 21:28:48 +0800 you wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> Currently, four reset types are supported for the HNS3 ethernet
> driver: IMP reset, global reset, function reset, and FLR. Only
> FLR can now be triggered by the user. To restore the device when
> an exception occurs, add support for triggering reset by ethtool.
> 
> [...]

Here is the summary with links:
  - [net-next] net: hns3: add support for triggering reset by ethtool
    https://git.kernel.org/netdev/net-next/c/ddccc5e368a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


