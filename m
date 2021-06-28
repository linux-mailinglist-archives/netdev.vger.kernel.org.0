Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F54A3B69D4
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237512AbhF1Unf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236493AbhF1UnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4CBB661CDD;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624912854;
        bh=yhEZRFQiSw9S3Aif7Qz3l5vOqPa+yDWqL7UsZ1HLndY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J5XXAxevur0/HGavC3dearHr6NAJU9xc3cezr9e9/LW3QhpYp2GeBeHdWaBvFa/HK
         iAx+so5KF7LNlFFSwJl+QJcY2JNJYb2jsFUIF6r8YcyFNqgKaCQkyK7p8cb9pAh4cH
         L1w6urt4WmVkJiBQvN/a20u5d8HzeZsKIcKy6LZLyJ0ZajSu3N7y/qZ9h9b51VQZkV
         1H/GPKNkZqTMwhODC786fA1eW4x6F8OH7Oj56rrDJW7bPdU/r61UPA2rD9maubTo+Q
         eWBLb6YiRs/AOYEAAltx2nsJkqxthjzKmFo+AY+VatW79G/Qec5TvniTCAW/b89+/R
         5jcXA6600HqUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4140060D02;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/2] net: hns3: add new debugfs commands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491285426.18293.16987102070760656311.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:40:54 +0000
References: <1624669217-38264-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1624669217-38264-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 26 Jun 2021 09:00:15 +0800 you wrote:
> This series adds three new debugfs commands for the HNS3 ethernet driver.
> 
> change log:
> V1 -> V2:
> 1. remove patch "net: hns3: add support for link diagnosis info in debugfs"
>    and use ethtool extended link state to implement similar function
>    according to Jakub Kicinski's opinion.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/2] net: hns3: add support for FD counter in debugfs
    https://git.kernel.org/netdev/net-next/c/03a92fe8cedb
  - [V2,net-next,2/2] net: hns3: add support for dumping MAC umv counter in debugfs
    https://git.kernel.org/netdev/net-next/c/d59daf6a4cee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


