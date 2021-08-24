Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737D3F59D9
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235323AbhHXIaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233920AbhHXIat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 04:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B06E61265;
        Tue, 24 Aug 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629793805;
        bh=Nc+Jk7A4Dvrszf5SqvbSuE3rMGWWG+yKcwvSrjEfqXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uR9uo35N/bEQ+9OOU56e7IRUnDLGgZsinIVepufkfSDvLl9V091MWtCHbeKaSRdnj
         ZoOG/FgiJYU12gnviGVIHVYuNINqnYl3//Hb2vUT+CSeHdyg1givL7wxKZQOiP3mFc
         /HiIz/wa+RW9FL/z+wbhb7N2hQUU/5M68LzxS0/ipbOY6RbakobQO3Gbt6uOo/aKpD
         ZaI0+3YvTDU1h0oGImHPQzdWZi91IGx8d3+JycAock2X5WrAoDAJS3dnKMR7AzRGe2
         CwW+qEAlJYWboh3WlY9rKPtVIAfgsOX2Cta7oqBTTGMl8ZjiPGLV6Jq6OFxKnsu/Pu
         +oSohnBVOPtIQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E8C96096F;
        Tue, 24 Aug 2021 08:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Fix the VF msix vectors flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979380538.25178.5288848210577184493.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 08:30:05 +0000
References: <20210822192114.11622-1-smalin@marvell.com>
In-Reply-To: <20210822192114.11622-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com, pkushwaha@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 22 Aug 2021 22:21:14 +0300 you wrote:
> For VFs we should return with an error in case we didn't get the exact
> number of msix vectors as we requested.
> Not doing that will lead to a crash when starting queues for this VF.
> 
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - qed: Fix the VF msix vectors flow
    https://git.kernel.org/netdev/net/c/b0cd08537db8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


