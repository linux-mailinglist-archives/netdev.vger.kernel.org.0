Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB4133C8CE
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCOVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232070AbhCOVuH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 17:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8C3A364DE2;
        Mon, 15 Mar 2021 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615845007;
        bh=S2QT84KPzjb9r9yUjeNfbK5yrEsuvENvh6+59K0I4yI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y+h/AchySRppLcGd8UhFxHpkaOX5Z01xNS+wcjMq3fSTsoPq1roHdoDprjHOVbOJU
         zO1fNyXvEvqTXnecJABUVO4Z6vS1KRn8MG2CJpB8Ouusq7coXHv0okBVSDLsNTXfpY
         CVjv/7JvctIPlVtiCEbEUH0susXG2tHKJUJATyKXOiSZOVFWcdjIFQgaFwVnK+PKb4
         U6YGnSghvXyXTzjY+MpmrwXJqxuLPRN3+fjs3Qfe0MeMVrkijNA3qPhU2ge0GMy07/
         C14EwPjL5FExAmKZ7AGg+T1LxDEgLxDxrhEpJaHhnNRv4/LpY238nb/g8jj7ydpJs7
         FUQN5ho3eNAng==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B95960A19;
        Mon, 15 Mar 2021 21:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tcp: relookup sock for RST+ACK packets handled by obsolete
 req sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161584500750.10303.15152719298900638911.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 21:50:07 +0000
References: <20210315110545.111555-1-ovov@yandex-team.ru>
In-Reply-To: <20210315110545.111555-1-ovov@yandex-team.ru>
To:     Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        zeil@yandex-team.ru, dmtrmonakhov@yandex-team.ru,
        olegsenin@yandex-team.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 15 Mar 2021 14:05:45 +0300 you wrote:
> Currently tcp_check_req can be called with obsolete req socket for which big
> socket have been already created (because of CPU race or early demux
> assigning req socket to multiple packets in gro batch).
> 
> Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
> is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
> But if client sends RST+ACK immediatly after connection being
> established (it is performing healthcheck, for example) retry does not
> occur. In that case tcp_check_req tries to close req socket,
> leaving big socket active.
> 
> [...]

Here is the summary with links:
  - [v2] tcp: relookup sock for RST+ACK packets handled by obsolete req sock
    https://git.kernel.org/netdev/net/c/7233da86697e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


