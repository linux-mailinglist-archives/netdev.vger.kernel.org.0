Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D01477E7C
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 22:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhLPVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 16:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbhLPVKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 16:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2583EC061574;
        Thu, 16 Dec 2021 13:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA02D61F85;
        Thu, 16 Dec 2021 21:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35050C36AE8;
        Thu, 16 Dec 2021 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639689011;
        bh=0AB3qc36AY+5e4ivCgJnAnMdQ1Z8mMA74RAEwe0xG6c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N2PMq4NBpmOxiFBDy5L3QNw1c+GnvIAWI9dttSn36rklW+ri9Hp9v2U5v4hmirqyH
         Q42wQHuuC2T3CGCYDw9XKRO2VClBJtc4x7xC8P7oDFwFPmZEQXJRvHFrIK1d1FYbNv
         yWjS+HCTioA1alZG4opL8wqK3+7C0uk1zXlJQ//0yxP2tjsP1V+K/jPiB9vyY6+Z+s
         vOKQJl5qtQDd4ixLkjvC0F2UrEiGO4D+yWGF1qJcd8XOVWBO6okb3Sz1USYKYgukOn
         HfjUcOPCgbrQQR+ZaCNNi0phkYmaeUFj+AqNFT04BmaYX2P4OM7HlOf+OFoOiqinWx
         aBS8M6yf+Q6og==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0D0DC60A39;
        Thu, 16 Dec 2021 21:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2021-12-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968901104.4805.15785107668172722484.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 21:10:11 +0000
References: <20211216210005.13815-1-daniel@iogearbox.net>
In-Reply-To: <20211216210005.13815-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 22:00:05 +0100 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 15 non-merge commits during the last 7 day(s) which contain
> a total of 12 files changed, 434 insertions(+), 30 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2021-12-16
    https://git.kernel.org/netdev/net/c/0c3e24746055

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


