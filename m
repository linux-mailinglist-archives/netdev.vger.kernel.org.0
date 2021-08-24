Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 133043F6847
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhHXRmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242747AbhHXRjt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D6C9A6135F;
        Tue, 24 Aug 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629826205;
        bh=q0QinuTsrW5CCEIrotK3HgEuAxYDV88+b1gwHgdOyAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gBNgwhv/FDZOxe46BpWJ+pfO0nR7jQ2MAmesq0ppmkOAuxzmLLXad2sLpK2SfD//T
         bOQ3dv938X2BBnBPKgMyDAQ1350SZ+ROpRVXA0gPAuPwSITCfx5ocFlylQc5XFYBzF
         K3Sj8XXbRUflgE4QBCRSDfNuCEeZAoBPI3CUqRJYQta2n+HIDqfldNxchp6R+faN7E
         ahiqiFUzLHp0a1gi8We9ZEBYDLYY1Czx81tUwDe3ZTDASjkqBKojMZXVPg2rfG1YpY
         rgdMTbLTn0zE6tkfrkLXr6UiDnb8AqTDypKqt8Nqh1ZOSpFVpCtND/AzUAcIEzjLUA
         0mxOjXPXOKRBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBD346097B;
        Tue, 24 Aug 2021 17:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool 0/3] ethool: make --json reliable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162982620583.13896.7493187620591622123.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 17:30:05 +0000
References: <20210813171938.1127891-1-kuba@kernel.org>
In-Reply-To: <20210813171938.1127891-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     mkubecek@suse.cz, andrew@lunn.ch, netdev@vger.kernel.org,
        dcavalca@fb.com, filbranden@fb.com, michel@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (refs/heads/master):

On Fri, 13 Aug 2021 10:19:35 -0700 you wrote:
> This series aims to make --json fail if the output is not
> JSON formatted. This should make writing scripts around
> ethtool less error prone and give us stronger signal when
> produced JSON is invalid.
> 
> Jakub Kicinski (3):
>   ethtool: remove questionable goto
>   ethtool: use dummy args[] entry for no-args case
>   ethtool: return error if command does not support --json
> 
> [...]

Here is the summary with links:
  - [ethtool,1/3] ethtool: remove questionable goto
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=6cf8d25c5be4
  - [ethtool,2/3] ethtool: use dummy args[] entry for no-args case
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=444f36546f53
  - [ethtool,3/3] ethtool: return error if command does not support --json
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=9a935085ec1c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


