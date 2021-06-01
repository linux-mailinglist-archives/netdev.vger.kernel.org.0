Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF26397C6C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhFAWbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234981AbhFAWbp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:31:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D8571613C0;
        Tue,  1 Jun 2021 22:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586603;
        bh=3FeK/vBaGwgy4cqqsERFnEM0IdY7ZYJ0rx1iybwJbs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RRzdlEx+L970eN0T58KWV1s26/VHOcu2fUWbtGIO2aOTrae+/j+K6be/QNA0tJmBt
         7xClb7ff4VhGYWhWj1dwrIb1cQtKb7fUQMz8beFf9WiKuz6CKqGQ9eHhTWL6VzgtSG
         OBSmN9I55dc3agPROnyZwM6vl5UrbD44KYG2UhWzT4iRRmlBnnmokeFGmD6oR+aO/a
         D77Ha9xz/xgxgTqSA4CzMXFusKQZlgrg6zD8LK1PxTRSZeMjKBj8wDkNlyfUbosbQD
         hYB29UH7pb0Q9qjG4PKLP0c8xmixzQS4mUl2ZBuKRAXaCLpjcFdCSwMlyd33Lc0HRQ
         6CeL4bR6MF8jg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CA49860BFB;
        Tue,  1 Jun 2021 22:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sock: fix in-kernel mark setting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258660382.12532.16045757761584580557.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:30:03 +0000
References: <20210531210030.1462995-1-aahringo@redhat.com>
In-Reply-To: <20210531210030.1462995-1-aahringo@redhat.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 31 May 2021 17:00:30 -0400 you wrote:
> This patch fixes the in-kernel mark setting by doing an additional
> sk_dst_reset() which was introduced by commit 50254256f382 ("sock: Reset
> dst when changing sk_mark via setsockopt"). The code is now shared to
> avoid any further suprises when changing the socket mark value.
> 
> Fixes: 84d1c617402e ("net: sock: add sock_set_mark")
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sock: fix in-kernel mark setting
    https://git.kernel.org/netdev/net/c/dd9082f4a9f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


