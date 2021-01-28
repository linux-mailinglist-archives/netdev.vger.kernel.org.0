Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82EE306B54
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 04:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbhA1DAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 22:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229739AbhA1DAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 22:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C4FE64DD8;
        Thu, 28 Jan 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611802810;
        bh=6SDGcEbjBGqG6VYMkbpy2waAgECmWAJPfOj1EftlvqI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gjwwosIgTnBCjTmyORvl1dxS/5Eoy2TaMwQ627j6lNXeQh1TOiJoRtDlSx+LkX6lU
         PPI2/qU35NhCgP4Q0eEl4f7u0K6zZpH2mLuOz0AyUA4qun3uVMIyNZkOT2Ej7J+gtD
         43tpqyPvwDu43uzYfUPds/X/qKT0RqeLloQbUd2xTcDq0xXOYV9b2pX3UH5mYqZPOg
         sulvRXw8FLNw/4LtN/b/vIQZg56pBRoHdXwjWh9xCnTKu7xisO6x6VoMWc2Iu9bFym
         P7ugV/KCW4BtQa/yWajR2EsSJVVcJU9PVPadYVWx/rYkqUemAsABhmkZTRxAoM3zcd
         HFbUzz1rf9e6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C83F61E3D;
        Thu, 28 Jan 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tipc: remove duplicated code in tipc_msg_create
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161180281011.31409.6677091900188521723.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 03:00:10 +0000
References: <20210127025123.6390-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210127025123.6390-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, ying.xue@windriver.com, maloy@donjonn.com,
        jmaloy@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 27 Jan 2021 09:51:23 +0700 you wrote:
> Remove a duplicate code checking for header size in tipc_msg_create() as
> it's already being done in tipc_msg_init().
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/msg.c | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - [net-next] tipc: remove duplicated code in tipc_msg_create
    https://git.kernel.org/netdev/net-next/c/2a9063b7ffac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


