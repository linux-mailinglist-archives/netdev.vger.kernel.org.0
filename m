Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A817386D0E
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbhEQWle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhEQWl1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 18:41:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9FC64611CA;
        Mon, 17 May 2021 22:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621291209;
        bh=0ilneqf8ZsGndIyeA4Py/b5HTnbhrBOzM3IqiPm10vg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H/oNu8UYP/QoFL3iGTQcRpP9S0Qw4dnTmqA53ci3LAHcNxRf7mVS57mM+Sela7I5t
         x2Pj2pIVvmw2EJMEjq0FCQJaUbxk6FkoIx8aSYtmhs7FlpLjs4f0ak1vAyHWz8WTj5
         j5NwelYlLwc81ikCz8O+T9/rFC0Kd/HbXGHMD12JZjYNW8XYAlCFSmdOvmGtFthNmE
         JPmxUVFzuLAMNPSqkY1Z2W2uuNPJZr6iyxa4q4XZu6EF3dL2M6QLZZFHMs8K1z6gdj
         6kVC/Al7Zk1uXt1lIqWN4Zy9SjmFhNjtyoixot8kuAT6Gb4WeKkL8cdaguDRLkLk4r
         TPqaxjLaylu5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96DD660963;
        Mon, 17 May 2021 22:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netlink: disable IRQs for netlink_lock_table()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162129120960.10606.6632218946410253940.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 22:40:09 +0000
References: <20210517163807.4d305e53c177.Ic19a47c0690e366ee84e3957b73ec6baddffad8a@changeid>
In-Reply-To: <20210517163807.4d305e53c177.Ic19a47c0690e366ee84e3957b73ec6baddffad8a@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        johannes.berg@intel.com,
        syzbot+69ff9dff50dcfe14ddd4@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 17 May 2021 16:38:09 +0200 you wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Syzbot reports that in mac80211 we have a potential deadlock
> between our "local->stop_queue_reasons_lock" (spinlock) and
> netlink's nl_table_lock (rwlock). This is because there's at
> least one situation in which we might try to send a netlink
> message with this spinlock held while it is also possible to
> take the spinlock from a hardirq context, resulting in the
> following deadlock scenario reported by lockdep:
> 
> [...]

Here is the summary with links:
  - [net] netlink: disable IRQs for netlink_lock_table()
    https://git.kernel.org/netdev/net/c/1d482e666b8e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


