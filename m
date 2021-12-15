Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83F47576D
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbhLOLKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236855AbhLOLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6ABC06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2689618A3
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A04DC3460E;
        Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566613;
        bh=xSMThtVkHQRnXb8DdYQH27Pv+yj3UkMiY+YFOlcrIVg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A2fGmByEm6gHLq5iQEqC73sIM0FO0J041lMZJwqT/DATqiEdgg3FWWkpOO/bzDM2t
         Jj+R1oBp1+cqoPaGsxf2fRGOuVH5X+nSE7Tfq69WYSYHI9wkYlyeVCodYVPt6hxXjl
         qtzyWMvqv1mPeC8N5K9DzSHFlJavdRHAB81gP/d8QV5d4/wDCPeE63OGlKgXCJZo5k
         LvXCOlZIlpB4VF+yem/kq3+iC+GjSgBlWk99Kp+3RtXwmDBpIqRfoTXM8mXQCTVXCK
         XcJnoMdXJby8Llp0YLzJv+oyqgkdeLXLLXnWIcCgxy3OQQfglsq1XXVBgCxs9pSqUP
         FhdVLDefbyScA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8E0660A7D;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: use ethnl_parse_header_dev_put()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956661288.16045.11011017274103822131.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:12 +0000
References: <20211214084230.3618708-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214084230.3618708-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 00:42:30 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It seems I missed that most ethnl_parse_header_dev_get() callers
> declare an on-stack struct ethnl_req_info, and that they simply call
> dev_put(req_info.dev) when about to return.
> 
> Add ethnl_parse_header_dev_put() helper to properly untrack
> reference taken by ethnl_parse_header_dev_get().
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: use ethnl_parse_header_dev_put()
    https://git.kernel.org/netdev/net-next/c/34ac17ecbf57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


