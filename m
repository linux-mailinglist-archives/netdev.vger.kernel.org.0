Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2D2FC06C
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 20:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730089AbhASTyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 14:54:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbhASTus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 14:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F099E2313C;
        Tue, 19 Jan 2021 19:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611085808;
        bh=uWwjHlqPpTQEXKr3KGCDhOzI8WrlBz6mOBJFoqXr/ZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=svX3zaUNyGI7YD7KTRzv/5n2vN2jpsXRNoqzi1Zr71tRDmUA2qNxgcnq8N3dzf19n
         Xobq9nU5L/65s/CdjEkAbplXkl5D5RklRsbkDTgtKRZMouNdCkAjMB9bXWBmbCUihL
         SD/gsmKVZmym8tY82oElB0l9cQeuQntcZ9K0LUTsK0Kicn0+ciq0xrR+oeIGjc1hOP
         TrDBfhDtVRByBSbC10HPTwEr0ExLh3ilu1RV+yqe0icELJA6TlXf+ZC2dktCbzeCqF
         7s5ucMt7XTMPKoTzTL5HbtB2qJMiO4K9zkNzQ9mBTAiiU399UztqX97aEKuZ5Rlavk
         ZElgYu3OSxI1w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E55E3605D2;
        Tue, 19 Jan 2021 19:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: core: devlink: use right genl user_ptr when
 handling port param get/set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161108580793.4898.2655899092848313604.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 19:50:07 +0000
References: <20210119085333.16833-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210119085333.16833-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, oleksandr.mazur@plvision.eu,
        parav@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 19 Jan 2021 10:53:33 +0200 you wrote:
> From: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> 
> Fix incorrect user_ptr dereferencing when handling port param get/set:
> 
>     idx [0] stores the 'struct devlink' pointer;
>     idx [1] stores the 'struct devlink_port' pointer;
> 
> [...]

Here is the summary with links:
  - [v2,net] net: core: devlink: use right genl user_ptr when handling port param get/set
    https://git.kernel.org/netdev/net/c/7e238de8283a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


