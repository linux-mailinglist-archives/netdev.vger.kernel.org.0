Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06348428B0E
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbhJKKwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 06:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235933AbhJKKwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 06:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 553B761039;
        Mon, 11 Oct 2021 10:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633949408;
        bh=+AW7L8NGATnDrCGe+Ayg/HCvfiJtoyarkUHiZfIm7P4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SoOyidCtM0vlBW1+C5uMIA62c4+TUVhj1+cz/cjrDJEpQEfOxDDN3Tr/rsw4qbIgj
         er5Lj0rkrzqRowawhP2UCn1Hyr9Mhq/NP5QW41jvAGvwoICqTcsRPgJxvRUTpFMYYS
         P6D/cuGPaQOWO89c3lEwfTfn4lCf1LKLQQNN8fuwLfPs4JHkGr8t1MIiZn1VbATYKw
         zuozWqF5s5qBhzpV9JtcW+Ms0bfK5z+bet3MPz3VuiDTQTqPNOSfBOvcktSWdVNUqq
         +vMZlT0XO7KBr1221IG3/+k9s799HM4Z+Cy3ID0IcH4ddH+UgaMWpHDAgNDDp0j+VP
         pTDp94T87JjoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C0B7600DF;
        Mon, 11 Oct 2021 10:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next v2 0/7] ethtool: Small EEPROM changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163394940830.24348.2630338340460854716.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Oct 2021 10:50:08 +0000
References: <20211001150627.1353209-1-idosch@idosch.org>
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz, popadrian1996@gmail.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (master)
by Michal Kubecek <mkubecek@suse.cz>:

On Fri,  1 Oct 2021 18:06:20 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains small patches for various issues I noticed while
> working on the module EEPROM parsing code.
> 
> v2:
> * Patch #1: Do not assume the CLEI code is NULL terminated
> 
> [...]

Here is the summary with links:
  - [ethtool-next,v2,1/7] cmis: Fix CLEI code parsing
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=2c2fa88b0578
  - [ethtool-next,v2,2/7] cmis: Fix wrong define name
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=1bad83c00b39
  - [ethtool-next,v2,3/7] cmis: Correct comment
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=001aecdb5119
  - [ethtool-next,v2,4/7] sff-8636: Remove incorrect comment
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=86e97841aca4
  - [ethtool-next,v2,5/7] sff-8636: Fix incorrect function name
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=7ff603badbbb
  - [ethtool-next,v2,6/7] sff-8636: Convert if statement to switch-case
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=128e97c5f6e5
  - [ethtool-next,v2,7/7] sff-8636: Remove extra blank lines
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=79cb4ab4787b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


