Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE9E47DC59
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhLWAuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbhLWAuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:50:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6A6C061574;
        Wed, 22 Dec 2021 16:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02B7CB81F47;
        Thu, 23 Dec 2021 00:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BABEAC36AEA;
        Thu, 23 Dec 2021 00:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640220609;
        bh=hMkExGW3xLUwd0qRah6sMhBW5wuhCL8RWHxF+ccCF70=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NBUjKFQXLUuCjL1uYrahsFFsYUJPqklyF0sahvX26hIwC7tzLcHtdvhxOU1Ic0iS1
         +5KPZB79VkNJZTdeoe6AoIqF6xDaNTMs6yGd7mj3KFVaNLZtReKYP+mdSBCdG/VHPg
         R2dB/nDodJ1CA9eSlgJv31MrjfJe0GGbnW3tOZoCr1PYED7T0XfCmjDQoDs8qBlUOk
         Ep+tsGfVAFGfDmwRjJQAZ+lO5F/0kGm14UqEFEqDKXnI9r7UYWBS7hxzSDDdTPWYv8
         6qz16BAaCVifHDIu/J2PH5ZwezynzuBwIdNs28+83gkwrrGZ5n1f5Hugon+IpZzJ5s
         4+g4zMwnELTrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2E8BFE55A6;
        Thu, 23 Dec 2021 00:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] codel: remove unnecessary sock.h include
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164022060966.21673.3814438675172430394.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 00:50:09 +0000
References: <20211221193941.3805147-1-kuba@kernel.org>
In-Reply-To: <20211221193941.3805147-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kvalo@kernel.org,
        pkshih@realtek.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 11:39:40 -0800 you wrote:
> Since sock.h is modified relatively often (60 times in the last
> 12 months) it seems worthwhile to decrease the incremental build
> work.
> 
> CoDel's header includes net/inet_ecn.h which in turn includes net/sock.h.
> codel.h is itself included by mac80211 which is included by much of
> the WiFi stack and drivers. Removing the net/inet_ecn.h include from
> CoDel breaks the dependecy between WiFi and sock.h.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] codel: remove unnecessary sock.h include
    https://git.kernel.org/netdev/net-next/c/15fcb1031178
  - [net-next,2/2] codel: remove unnecessary pkt_sched.h include
    https://git.kernel.org/netdev/net-next/c/e6e590445581

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


