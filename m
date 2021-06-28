Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A78E3B69CF
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237281AbhF1Un1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236572AbhF1UnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CB9C61CDF;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624912854;
        bh=L7XJtmlLX/psvTfOrdCovM2x6I8zDVua+ndjGrhBGVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+BVvWlJfFMvQ8Vr1FwwkZsr+NruBrR+zdEom8veKLmZyEVDhnTEd4+oArVopBfdY
         DOMOQJxGMZ+srdJvEno+AOPbFT23CLeHfv0zTh/1p9Qq1vdu4T/LAkSfxLIB+Vv1Z4
         Z/QXGXiguqZYqnUakWf5F807Px8his7VKV9yUfcsFctrOhzZqnz5vNPJV9HV7vpTOT
         O+588jj2Apkop326n58jPS7AReQLwb2KZmbxf96fU0HKIZQ8ysig8Ixf91HXPTZx9W
         aXHu2b8dY4pH/ymijAS0pP+gN59KNQ56xqZcOROeTzr0tUqHZOlCMXOcrC5tng1ZKu
         NuSMpSWc7blxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5483B60D34;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2021-06-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491285434.18293.5019013003644904509.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:40:54 +0000
References: <20210625215635.10743-1-johannes@sipsolutions.net>
In-Reply-To: <20210625215635.10743-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 23:56:34 +0200 you wrote:
> Hi,
> 
> Here's a bunch of new changes for -next. I meant to include
> another set of patches handling some 6 GHz regulatory stuff,
> but still had some questions so wanted to get this out now,
> so I don't miss the merge window with everything...
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2021-06-25
    https://git.kernel.org/netdev/net-next/c/007b312c6f29

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


