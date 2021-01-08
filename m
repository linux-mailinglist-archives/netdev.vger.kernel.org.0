Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0812EEB98
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbhAHDAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbhAHDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E46932368A;
        Fri,  8 Jan 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610074808;
        bh=kCuB/7uJZHOg94e3ct8vvQCklpn/WXKKPXlErn2JK8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PS1ZlYVAtfWcrnP16vg5f+0ItjXfKZ9pcNA9NV3S2ABkgyrv20lwvrOxLPx/1wTP5
         VGMOhKjfV/jM4MRkku3+G7B6vvN1yd9nlo1KmHUfsTF0L96k5XiTgVFBeaYlbk+O2e
         GmeKoniQ5bujEj7xHHAp4LHIW8OsBp0HeaT7I86G/ZAnOgNqZVWsn5YOwV9f4oS2iM
         tohji3ymJgLVOgJTqb/MMf7PkXXjK3Wdn7Byu5ngRDQaVzxSUsbkwQJVn4y6aFz2k5
         4FquX3d8BYGAhX10GGxksWst8Qpn7Gke5SKCt95sPmTxp9qXuYVlZ6aJlypm3mqatg
         7JRk1MXx5gjwA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D3D06605AC;
        Fri,  8 Jan 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] s390/qeth: fixes 2021-01-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161007480886.26739.12705141595571763670.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jan 2021 03:00:08 +0000
References: <20210107172442.1737-1-jwi@linux.ibm.com>
In-Reply-To: <20210107172442.1737-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  7 Jan 2021 18:24:39 +0100 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series to netdev's net tree.
> 
> This brings two locking fixes for the device control path.
> Also one fix for a path where our .ndo_features_check() attempts to
> access a non-existent L2 header.
> 
> [...]

Here is the summary with links:
  - [net,1/3] s390/qeth: fix deadlock during recovery
    https://git.kernel.org/netdev/net/c/0b9902c1fcc5
  - [net,2/3] s390/qeth: fix locking for discipline setup / removal
    https://git.kernel.org/netdev/net/c/b41b554c1ee7
  - [net,3/3] s390/qeth: fix L2 header access in qeth_l3_osa_features_check()
    https://git.kernel.org/netdev/net/c/f9c4845385c8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


