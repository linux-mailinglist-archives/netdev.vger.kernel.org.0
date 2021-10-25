Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5AA6439A52
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhJYPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232785AbhJYPW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 92EDA60F9D;
        Mon, 25 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635175207;
        bh=H5c19qCnC0mihsAfxtmhgJd5n/YGqRw0uLHtyWOe0Os=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MkJQVLkGXfwZq0KcuLa/EvfGP/fdhzouauu3QvNN2h7CXqL9k+C8mFjFLQxdlrX6B
         uWOk/2Zc1ds7TsD52Uan7yTtyOnVlLA6Nytymdd45hzpRXuoQESAYrUWRWEdZ9TJIP
         MmCDXwWYxzQZUfAKj75IBn4JxHCh8EyKa4E5q/e9zvRDO7KVckU7j9ZjC2Css01509
         nO7CeldJ+sBLr5+c5IpG7bmRzeHsslp2iuL0qOUwNGt0NSJbc4YMukvlGDQ3sjEGGb
         NA8kqJVrNIGrE/aV7ItvfeldrX+R7Sv70oBiYDTMvJ7AoOajfTwu5QsVRQ5IXOENf3
         PsRPnJqeUzWRA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80A1F60A21;
        Mon, 25 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net-sysfs: initialize uid and gid before calling
 net_ns_get_ownership
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517520752.28215.6589044097050566121.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 15:20:07 +0000
References: <a1d7fda6a8e54a766fc9922e3abec8411120c3ac.1635143508.git.lucien.xin@gmail.com>
In-Reply-To: <a1d7fda6a8e54a766fc9922e3abec8411120c3ac.1635143508.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, christian.brauner@ubuntu.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 02:31:48 -0400 you wrote:
> Currently in net_ns_get_ownership() it may not be able to set uid or gid
> if make_kuid or make_kgid returns an invalid value, and an uninit-value
> issue can be triggered by this.
> 
> This patch is to fix it by initializing the uid and gid before calling
> net_ns_get_ownership(), as it does in kobject_get_ownership()
> 
> [...]

Here is the summary with links:
  - [net] net-sysfs: initialize uid and gid before calling net_ns_get_ownership
    https://git.kernel.org/netdev/net/c/f7a1e76d0f60

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


