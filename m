Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C4C474317
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbhLNNAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:00:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbhLNNAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBD96614DA;
        Tue, 14 Dec 2021 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 208FEC34607;
        Tue, 14 Dec 2021 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639486811;
        bh=wMbtMwRQda/mkHpaJRyWUm9kA69JJvZrpxVZpmcvn2A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ByaD6x4S2H+3MxZR8JQogYifbS4LydUWGw2BP44cNCdnBN8TyoocuX4jcLZfrOLuY
         lYkiDeFhk6o7f6pxGtvjRVa1BRix06TpIqyy4qWx0fnlmrdy5Dy03tXuJX4ti2Rnzd
         S1gNyN/GCrbQmtJwYLtOQk9kIVChDczBUmPWXD/37vJcc9wbkvLh7p0YFzJBFSy5gn
         X/2zjbW+e7tiC3cG80/dhwIEPwmZBoAdUGdyO5Ssv5LtEYflC9oWFmtlpYTE96Slr0
         YDQrOTdcs1Gv0OkNn39zJYa2eSTjGUH6IT3RSH0s8Gz/pkd4pQVfA/GiVvCTXS9SKM
         e4eaROnlJivHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EF47D60A39;
        Tue, 14 Dec 2021 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211 2021-12-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948681097.21223.671784001796985551.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 13:00:10 +0000
References: <20211214104537.16995-1-johannes@sipsolutions.net>
In-Reply-To: <20211214104537.16995-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 11:45:36 +0100 you wrote:
> Hi,
> 
> Sorry - I accumulated more stuff than I'd like due to
> various other competing priorities...
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211 2021-12-14
    https://git.kernel.org/netdev/net/c/d971650e17a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


