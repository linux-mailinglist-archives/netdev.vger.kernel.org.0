Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136F444262D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 04:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhKBDxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 23:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhKBDw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 23:52:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4594C61075;
        Tue,  2 Nov 2021 03:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635825025;
        bh=vnvUfA1HCy5SyzmJj9QMW4rxolsLx+YQYNnEpCAD7+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rcNrvz6PtfYXCAz8cFJhQl7xWymWNFiYPLbxiupCnPwFfhKB0Kwy3yHL00Bifm7aR
         XRCgqKT4vyVFDwRLoOxYyypxShXkyLgr2wqZGceFOatommtzpLUyLfIs4wsqonUbY2
         4ayu4SW5vRArFuyj56kHdsVpLcw2GNQ8g+VSi+7idVkT84YldDdyyuNeP8/mo04LQA
         IynRgC7nVbAlK05mBenEx0jzt+rgAW2/cT4GX4MzbBK+f98eQmh2BBx1v4U4zZR37m
         qah/geam6/YG3OAHK1tylQnxG5QwZuGgbvdJ8h5vAxpxTdsAWkjakwxovufL5Bmr+P
         4hky+7lIp6ejw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 33EF460A0C;
        Tue,  2 Nov 2021 03:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2021-11-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163582502520.8113.559312179718011335.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Nov 2021 03:50:25 +0000
References: <20211102013123.9005-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20211102013123.9005-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Nov 2021 18:31:23 -0700 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 181 non-merge commits during the last 28 day(s) which contain
> a total of 280 files changed, 11791 insertions(+), 5879 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2021-11-01
    https://git.kernel.org/netdev/net-next/c/b7b98f868987

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


