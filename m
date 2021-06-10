Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD5C3A3523
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbhFJUwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230304AbhFJUwF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E655361429;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358206;
        bh=vsHzK4s5AG0JTFJagkIiirN8+lz3jELSsMoR03gSfRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PpyDCOn0iV76mIxkFv9LyXmpy5JWFNakdX6l0EpIOvXgYw/OaVa5BLuJByRgB4Fot
         p/j8evJMESwrLyxTHVoixEH/b35WBmrXuXwm/PlN6G5TY23+w5zee/fSbCWSg6DM4n
         4zhppMMQli2K0eWS8bFxR5UVP4XuWSIMrwg6mVRd+vds8yHWhXFCKk2Ue/1744tBbo
         IJ9XNhIw5Mycoc2q9Un+3HR2EDb7g9Ci1Dpzg8sBOYRU4kp6DAEaWdSp8c3+0TgIAg
         f/BlFax/YNfwSmVNwBg+raP/fXd4jmB9Y3yMB29LsUYgRIMJNHfwOVxHBF2byw36pa
         YAOeipmj8cFWQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DCFCB60A6C;
        Thu, 10 Jun 2021 20:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc:subscr.c: fix a spelling mistake
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820690.975.16634510333070331192.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:06 +0000
References: <20210610062958.38656-1-13145886936@163.com>
In-Reply-To: <20210610062958.38656-1-13145886936@163.com>
To:     None <13145886936@163.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, gushengxian@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  9 Jun 2021 23:29:58 -0700 you wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix a spelling mistake.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/tipc/subscr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - tipc:subscr.c: fix a spelling mistake
    https://git.kernel.org/netdev/net-next/c/f1dcdc075617

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


