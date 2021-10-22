Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E56437C17
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhJVRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233900AbhJVRmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:42:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 776D861284;
        Fri, 22 Oct 2021 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634924420;
        bh=/EJS3TF9gVY7Pi6y+njQOhFxAyKMcPyNPGfCBqpLUzs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U4QNTuwsIMJ1hvunJHfLtnIJg/RlN4E0JCTJFWsXI82kvT5zQBlKQV6LMEobIsfWk
         I5LegcTdrWlT7uK4X9qBwaLGIFbk71fbbN/iRa4lgezeC+og37/wFjET70amATUyz2
         mcvxyBq+3xIkY8mNc4ubmaOLFDCjeE01rhzt9Wy0P5LWbOhj/0ifQsjQGMa2L4leU+
         0nsHBwDv7vgiq/QLhL5vP+gkilQo59w2GC1py5EmyEMNd6lYmUmHQ3nx+t6jNE/jLP
         NyGjLYF6sVDb4ihMsxlTAUmiZFUxHQTp+ikzGQaErENRccow8+ytIfs21Z0iQSwEdn
         dCj5KszRrnXRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 623BB60A69;
        Fri, 22 Oct 2021 17:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-10-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163492442039.3618.11252532672255159542.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 17:40:20 +0000
References: <20211021154953.134849-1-johannes@sipsolutions.net>
In-Reply-To: <20211021154953.134849-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Oct 2021 17:49:52 +0200 you wrote:
> Hi,
> 
> Here's another pull request for net-next - including the
> eth_hw_addr_set() and related changes, but also quite a
> few other things - see the tag description (below).
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-10-21
    https://git.kernel.org/netdev/net-next/c/24f7cf9b851e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


