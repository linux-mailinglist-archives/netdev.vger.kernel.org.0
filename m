Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE3E3D7EC5
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhG0UAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231213AbhG0UAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C5AC60F9E;
        Tue, 27 Jul 2021 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627416014;
        bh=DWxuwv9MrG9KyWhAm/nAR1pYgmx0UU4riGcmruIdOFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KKwn3Lxxb9ystuAqticq81hz2A+YvBCYA/fhsnguKXJ5/2Lv/F3N6XKWpB1LbkBsC
         bQJisElb5Q/ohsD5dvnI8lJ2h2+LbxBpWyrcJ+4JZ2o+RLh/Fl0xX/0RABrrKY8Z0W
         cNo1elQei2q0qN0BW4170dBaSVFQnYPHo29Ay3/QxNjS+bgsobw6AQnaE+oIXxJT4u
         AVePmv953SJ+WdqGc3KD8mY0aTw7MSMqt3SavWxAieuGOBD+toZoJ5CNqzk2hWraZ8
         4KF5YKLDrNHGzCStbbhn3r/KI1dXxxzH5l/AsbFarQ9vnyNGli7oJHJQm0fWkMnUFn
         6tCBBPKY0HqkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0414760A56;
        Tue, 27 Jul 2021 20:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] net: cipso: fix warnings in netlbl_cipsov4_add_std
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162741601401.17427.16591015519654450734.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 20:00:14 +0000
References: <20210727163530.3057-1-paskripkin@gmail.com>
In-Reply-To: <20210727163530.3057-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     paul@paul-moore.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 19:35:30 +0300 you wrote:
> Syzbot reported warning in netlbl_cipsov4_add(). The
> problem was in too big doi_def->map.std->lvl.local_size
> passed to kcalloc(). Since this value comes from userpace there is
> no need to warn if value is not correct.
> 
> The same problem may occur with other kcalloc() calls in
> this function, so, I've added __GFP_NOWARN flag to all
> kcalloc() calls there.
> 
> [...]

Here is the summary with links:
  - [RESEND] net: cipso: fix warnings in netlbl_cipsov4_add_std
    https://git.kernel.org/netdev/net-next/c/8ca34a13f7f9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


