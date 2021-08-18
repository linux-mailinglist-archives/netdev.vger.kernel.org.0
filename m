Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7142B3F0200
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbhHRKum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234418AbhHRKuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:50:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0315060FE6;
        Wed, 18 Aug 2021 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629283806;
        bh=jAGprjy7lnIT0fLgWXQfA/u/yXFzXLk5oPCebenv9tg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TZTafczHFHDgQBAVOYKR9utr+27ZLtqF/lzrbPJCa6tfenxHt66ofUHPn91X6a4LH
         P6ydMgt0dChrrqGbgvbBORwSh7p+0L1beXQVY5ZqBlMyyfFQftYq5QISKmNeDsoDtT
         AJEfVa8++IGU8hFJnuh/jF46E270F6d04RQ/PZs4nfAw/RvCCniVOgL04Q/YkdzWYc
         OZNGL2GcdQTwv1E7EeQNixVWBN13BnoUHHpJYygv+rkRYJKBYiCoqVzIRf+BhpwDeC
         DVbhQgtlas9QBzSwqK8jDErOiS6QtYyJJGt8hQdvnGrfgm/V+ZyJWaN5Da5lgo7MJG
         sZbBtqrWrXDGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFE4A609EB;
        Wed, 18 Aug 2021 10:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928380597.20153.6653369000646773823.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 10:50:05 +0000
References: <20210817194003.2102381-1-weiwan@google.com>
In-Reply-To: <20210817194003.2102381-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, guro@fb.com,
        edumazet@google.com, shakeelb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 12:40:03 -0700 you wrote:
> Add gfp_t mask as an input parameter to mem_cgroup_charge_skmem(),
> to give more control to the networking stack and enable it to change
> memcg charging behavior. In the future, the networking stack may decide
> to avoid oom-kills when fallbacks are more appropriate.
> 
> One behavior change in mem_cgroup_charge_skmem() by this patch is to
> avoid force charging by default and let the caller decide when and if
> force charging is needed through the presence or absence of
> __GFP_NOFAIL.
> 
> [...]

Here is the summary with links:
  - [net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
    https://git.kernel.org/netdev/net-next/c/4b1327be9fe5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


