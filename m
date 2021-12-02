Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D11D8466BB9
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243810AbhLBVnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242456AbhLBVne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:43:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D98C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 13:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7518BB824FF
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 21:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09CA0C53FCD;
        Thu,  2 Dec 2021 21:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638481209;
        bh=6csmV9+q+37LCh/DMJMs16ciAlCKYUJFtiBwrkEzTmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KzkYiqZfJklhKyRL/E9MikQrA7OT+xVz/vAE0ewUq+eg4qGVrz55hTeS+38Ge8g2h
         +1YGPaYmSL3aFOcyQIAYg7yjTWw90f8SA3b9zWc+TYfAulQ71usrUcFTl9kdKIBDDZ
         gLDp+eitzX05SvQu/5joPZft0WVGrJn+unwT3hV3/3uTeFO+vix8GZpzuaFOUq30mq
         3GGFMlt4//7v+8i9d5OU8vnRFnlOxkUom/I0/tLQND7YZgNyo0qIpI4QNpkpWbNXN9
         L7HkgKhKqbx2/zN9QcKwnKMk9fW9MVJhHqnXroS8CR9vvHRxjQ1LTaFqk2yLIf5io8
         jg96PMhpA42Iw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D841460A88;
        Thu,  2 Dec 2021 21:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] cable-test: Fix premature process termination
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163848120888.21394.592061584283598099.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 21:40:08 +0000
References: <20211124121406.3330950-1-idosch@idosch.org>
In-Reply-To: <20211124121406.3330950-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, andrew@lunn.ch,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Wed, 24 Nov 2021 14:14:06 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Unlike other ethtool operations, cable testing is asynchronous which
> allows several cables to be tested simultaneously. This is done by
> ethtool instructing the kernel to start the cable testing and listening
> to multicast notifications regarding its progress. The ethtool process
> terminates after receiving a notification about the completion of the
> test.
> 
> [...]

Here is the summary with links:
  - [ethtool] cable-test: Fix premature process termination
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=c5e713341160

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


