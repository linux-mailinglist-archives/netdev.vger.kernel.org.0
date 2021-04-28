Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF5536E0C8
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 23:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhD1VLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 17:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhD1VKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 17:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 20B7F61453;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619644210;
        bh=eBZcC2miXA7hP4qi8OCKKNh5j+8g6dMaw6cG4OtFkuw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CJa1fN8XK8iAI37Ap4oSgSwfuI3PcEu8v+EEk1qqFDXNvmw0RNQ2Qs6p8S9iieGOq
         x5ihMY8hcRCew5yAgRN0dNOzgfnn8C09keVN85Zw8lbIUxa1oWJOHswC5UE7BLNRNM
         iemHnpR28NaHO965Htv+h1Y0MYzPwskaEglVY2+jLosSgK3mrRi8iWnomvBrDR2MbS
         01vcjV3TQ2LJ0eTSMsccsSZzp18P7041e9qD/1MUg3VlX10Qf5btirZ809Ge0Tj68a
         u8rYxfRwcLu5VfoldJGuCMRG1LxAGiopG8TJBzE+wEX41KJzEPtb4JTcSetpG3QoRQ
         d6BahEkfNNiEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1B4FA60A36;
        Wed, 28 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net/sched: act_ct: Remove redundant ct get and
 check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161964421010.17892.12319943891469358829.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Apr 2021 21:10:10 +0000
References: <20210428060532.3330974-1-roid@nvidia.com>
In-Reply-To: <20210428060532.3330974-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, paulb@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Apr 2021 09:05:32 +0300 you wrote:
> The assignment is not being used and redundant.
> The check for null is redundant as nf_conntrack_put() also
> checks this.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net/sched: act_ct: Remove redundant ct get and check
    https://git.kernel.org/netdev/net-next/c/9be02dd38581

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


