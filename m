Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D783CFC74
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbhGTN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbhGTNt0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 899E061208;
        Tue, 20 Jul 2021 14:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626791404;
        bh=OPHmHnyJ0nP1961Kc9LAota8nk5vdGTzoapkgpL+TpI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p9E1s3S6Pz88gNjQKQ+/bL92wuqKts9qGjhvfeNFPYPgY37AH2DnCN2SNJ1HgLJqt
         bBcE8yDHpjrtPie+bUSkhKEDdv/M0SjJQwvqowYYcqY/fpjkMpTbR/b6EZ0lttZezo
         EArXMlNE558lM3oBXoi217B5vEJx/qdbgMfLD5m7AgDR7vDNIo/+t1z8noas521vZ5
         Q82UqtoxzU9d7QHiw1j+3cEnSy+plQMgbuWl57KY97X3FpmUifLA5v0AoP5EGQ3+q8
         X2ohPatFCnjiw+Avk64OHEv5qJEoIXeI2W8YiCI+EKgxVhXAbrjY4SGrfz+GW1gAzi
         4dM0quZDkyjEg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7823B60CD3;
        Tue, 20 Jul 2021 14:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] Revert "qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162679140448.23944.13061540500790783692.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 14:30:04 +0000
References: <20210720132655.4704-1-justin.he@arm.com>
In-Reply-To: <20210720132655.4704-1-justin.he@arm.com>
To:     Jia He <justin.he@arm.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, nd@arm.com, pkushwaha@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Jul 2021 21:26:55 +0800 you wrote:
> This reverts commit 6206b7981a36476f4695d661ae139f7db36a802d.
> 
> That patch added additional spin_{un}lock_bh(), which was harmless
> but pointless. The orginal code path has guaranteed the pair of
> spin_{un}lock_bh().
> 
> We'd better revert it before we find the exact root cause of the
> bug_on mentioned in that patch.
> 
> [...]

Here is the summary with links:
  - [net,v2] Revert "qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()"
    https://git.kernel.org/netdev/net/c/91bed5565bba

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


