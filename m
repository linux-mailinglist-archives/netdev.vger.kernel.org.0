Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB84540CB2E
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhIOQv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:51:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230240AbhIOQv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 12:51:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EE5E61216;
        Wed, 15 Sep 2021 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631724608;
        bh=C7kbwdyInn2IXoHnQOVideWnmo+LHkCufgW+RMpYnm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NRCXPM8N2GC1y8pqGJ2Xo3OPPkICapmvQunNI04XisNIy6NYiQ7a945lOxiYAAnpC
         OlH4Yc8Ljfq4XFc2Lk2l6DepGPuvuEqG7L9ocNg6b1rEQZtLvpd1Ui91DdmQxHbtET
         HD7BId6tGYOLTYdz937KTmpYbPKAcYZTxwSHVQujgqKt7X4oJC8k5P0wcwzlpxqmUK
         DSA4OFvzIZMV01rApRtdj09JVmxVjmppQjNi6pcXD+q763KnbfEG8WY2p/+l6I4gSh
         sVlNIYVPKtYlxSoP9S3r6fIwuS7sZ2TW9EBs2rOw3l+TIg86R16LdsY73/V0CMf0FU
         iZfiRTESpZk4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1AF260A9E;
        Wed, 15 Sep 2021 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool 0/5] ethtool: Module EEPROM fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163172460798.1498.3814310992246632915.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 16:50:07 +0000
References: <20210914112738.358627-1-idosch@idosch.org>
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, vladyslavt@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (refs/heads/master):

On Tue, 14 Sep 2021 14:27:33 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains fixes for various issues I noticed while working
> on the module EEPROM parsing code.
> 
> In addition to these fixes, I have the following submissions ready for
> the next branch [1]:
> 
> [...]

Here is the summary with links:
  - [ethtool,1/5] sff-8636: Fix parsing of Page 03h in IOCTL path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=769a50e66b11
  - [ethtool,2/5] cmis: Fix invalid memory access in IOCTL path
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=7e153a7da4f1
  - [ethtool,3/5] netlink: eeprom: Fallback to IOCTL when a complete hex/raw dump is requested
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=2ddb1a1f06e2
  - [ethtool,4/5] ethtool: Fix compilation warning when pretty dump is disabled
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=d02409cc1788
  - [ethtool,5/5] netlink: eeprom: Fix compilation when pretty dump is disabled
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=a7431bc5ab09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


