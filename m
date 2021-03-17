Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611DE33F844
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 19:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhCQSk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 14:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232996AbhCQSkH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 14:40:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B0D664EE7;
        Wed, 17 Mar 2021 18:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616006407;
        bh=F1YR0WM+ChOdr2QUbAXXPQFe4yxA4pnBD3TfR6czjQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pO1m5NBEiYyaICQpvoEVlCuPmZvNV6hA8DY3F6YUI8UapBnRynsqsj5ZlfAW1s0tB
         n7nr2eaJ2wDV7vAuDmksCyADtgKNmv8pu8vIxR1PyFe712lzx8mrqXOoDuhOJz3mBj
         sZy7z9BPYoTZhwpMnHyGXKeCTApjs+QgeIL+A4IJ2+s4A6vnHAEdLk35CduKObU0b0
         vYxeL4YELVvs9caFOVFpP4Jk9JjvF/hreZg3hFToIqb+N9SnbqsXXo4lTAlb/eL4cp
         cBLawg/Oz24zAn2QQ2mGXPcK6T0qCQ5Q2FiIPp429FksIgbS3sR5NyD9ceYGAaDoTS
         z5U4xUAK3cAgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8844160A60;
        Wed, 17 Mar 2021 18:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ionic: linearize tso skb with too many frags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600640755.30066.15546766690823580884.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 18:40:07 +0000
References: <20210317000747.27372-1-snelson@pensando.io>
In-Reply-To: <20210317000747.27372-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 17:07:47 -0700 you wrote:
> We were linearizing non-TSO skbs that had too many frags, but
> we weren't checking number of frags on TSO skbs.  This could
> lead to a bad page reference when we received a TSO skb with
> more frags than the Tx descriptor could support.
> 
> v2: use gso_segs rather than yet another division
>     don't rework the check on the nr_frags
> 
> [...]

Here is the summary with links:
  - [v2,net] ionic: linearize tso skb with too many frags
    https://git.kernel.org/netdev/net/c/d2c21422323b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


