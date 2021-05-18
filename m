Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AED138816A
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 22:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbhERUbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 16:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236628AbhERUb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 16:31:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A2B5E61261;
        Tue, 18 May 2021 20:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621369809;
        bh=ZeKosbWMFv7MOEaMsIeqFwQyxkjxh6qNv1hKk5Cv5Bo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Of4Yk4/j2AQQqkczgZsl4rE40YrNfg0kcsuOWjgQWcIMhQjzSsyJ1AswEwcVudAcP
         BS7yDMn1C5N8iTCAQlJV41zpLDmjlRYEmNkNgIkVlgcG3Y2N/iv+Ak3fTZ37I+hZQs
         t8437QhfTmxCnvIux5PWIA6vHdNjr1uQerh/pf6QeEMhhSl87aTXYph/LxiTkTZjTE
         xMfJOL+vYSopz9vtFXXWugfMmVe0qA7+IziYhpg56Tl94zRw8y67yiswAQuFpcT2U6
         tnRr4Zi7alHkakiHwWYh5HGDyrLk+y7lfB2l/sE5Qmhm1IsFdB6ir6d9J3VzUM1ynB
         FGOWJuIYruZUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9625A60A4F;
        Tue, 18 May 2021 20:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: simplify the finalize work queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162136980960.4677.9044417345810076193.git-patchwork-notify@kernel.org>
Date:   Tue, 18 May 2021 20:30:09 +0000
References: <1a2933d589a238682010510102d74a38b962025a.1621303748.git.lucien.xin@gmail.com>
In-Reply-To: <1a2933d589a238682010510102d74a38b962025a.1621303748.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net, jmaloy@redhat.com,
        ying.xue@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 18 May 2021 10:09:08 +0800 you wrote:
> This patch is to use "struct work_struct" for the finalize work queue
> instead of "struct tipc_net_work", as it can get the "net" and "addr"
> from tipc_net's other members and there is no need to add extra net
> and addr in tipc_net by defining "struct tipc_net_work".
> 
> Note that it's safe to get net from tn->bcl as bcl is always released
> after the finalize work queue is done.
> 
> [...]

Here is the summary with links:
  - [net] tipc: simplify the finalize work queue
    https://git.kernel.org/netdev/net/c/be07f056396d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


