Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55D63A884D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhFOSMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhFOSMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 97C9D610A0;
        Tue, 15 Jun 2021 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623780604;
        bh=za7pM7LxON6lWiTqIs2NrczMbZvldsICqfPoEB9FeYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Axsq5aJ4uGN1QwaHiZ9cdkLlW4GmNuSVLfjCcs6dlmnxVjLaq9bvwXK0a4sv0lLA6
         NoM15sZyiO+fwpRPpU8RMbk34T74o97VPZh8xDayBnNEQZnnPmXdjO7WnAcM5Y52qy
         FBFjIx/IPHT2ztIiAVDOUgpz68Jcj8jB4cPyg2g+RVeltpFJEhzl6eCejxg5mPmdKR
         okqlYHCgES435dz44maiWenc2bpcZ7ed+sfvlnjk6zjsq4HSZFsA+ooVW+jNo7XMTm
         GAsyjrQBEwuJfzrP1JHzMKhXbAyrO/wLuHq9I7yc/AAz35JvxvQbjSxzvgyeOJZn0g
         qJY+rd2l3pXqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8614C6095D;
        Tue, 15 Jun 2021 18:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: inline function get_net_ns_by_fd if NET_NS is
 disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378060454.20077.922884133237684980.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:10:04 +0000
References: <20210614235243.51546-1-changbin.du@gmail.com>
In-Reply-To: <20210614235243.51546-1-changbin.du@gmail.com>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     viro@zeniv.linux.org.uk, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 15 Jun 2021 07:52:43 +0800 you wrote:
> The function get_net_ns_by_fd() could be inlined when NET_NS is not
> enabled.
> 
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> 
> ---
> v2: rebase to net-tree.
> 
> [...]

Here is the summary with links:
  - [v2] net: inline function get_net_ns_by_fd if NET_NS is disabled
    https://git.kernel.org/netdev/net/c/e34492dea68d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


