Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2185B37FED3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhEMUV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232627AbhEMUVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 16:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 63C126143F;
        Thu, 13 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620937210;
        bh=5HqTLEOEOmhzp0qvdUz0eOD5lbMYDHbdZvdzg26Tmf4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bKsKXr4vzkrVw/Q9pJuzUbH00kyq/cPDH2Z1WrdqiDwiEXLehE75jO/GA1WDG4nLN
         7fpWvHescgZ5yhkZYFE9LYtb2mXIpGeD/IIRY9gFJAlasQLWJNz/GIaw8D/zklDr3t
         qHLm50BWzL+wPn3kiBZgq9/F5teWlPPRzc9rQUVPVTvI8LJNhxqwdoHKC5liiCtK3L
         XL91Fisu8EonzVxzjR+6oqm2AyqmBHGwqNLKewpf36ee2eHAiPSV/oJbZpB5E6Lqkt
         UAwLr+2ZIJ8CsBnYSLWfQu3xXkgYa74CRacGQl2prnrpEQv+DaSjwM8DS7/Sz1Fmgh
         KNsWcgJfTujaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F469609D8;
        Thu, 13 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] alx: use fine-grained locking instead of RTNL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162093721038.5649.7953627218741318690.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 20:20:10 +0000
References: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
In-Reply-To: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, zhubr.2@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 12 May 2021 12:19:50 +0200 you wrote:
> In the alx driver, all locking depended on the RTNL, but
> that causes issues with ipconfig ("ip=..." command line)
> because that waits for the netdev to have a carrier while
> holding the RTNL, but the alx workers etc. require RTNL,
> so the carrier won't be set until the RTNL is dropped and
> can be acquired by alx workers. This causes long delays
> at boot, as reported by Nikolai Zhubr.
> 
> [...]

Here is the summary with links:
  - [net-next] alx: use fine-grained locking instead of RTNL
    https://git.kernel.org/netdev/net-next/c/4a5fe57e7751

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


