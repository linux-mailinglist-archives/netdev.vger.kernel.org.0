Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA972415CEF
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 13:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240618AbhIWLli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 07:41:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238930AbhIWLli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 07:41:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CCC1060F44;
        Thu, 23 Sep 2021 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632397206;
        bh=l+eDmfjwXc/fUStFXaj/EJc3U4g+MvN7hFyRoe0CYTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q7NjBfYfzklESg2Q/5aSGFIAHTikbbbIaI+6Idz6bRJztjOXcsPYs0qaPPnk6Inqp
         Wg5tRjKhYm6USoOHuv2zZQq6n5NWWeT5FP/dSnk0Sp6jca4b/wstsaabfGG3YSNxsl
         PVyVxTMZyoinF+waskg0QgpSffoPlXQfY1wtaxS4DticsBomAMd7mJIPKd0341i9m4
         rkHYhGHhamh+FgbkAbb2qXwWuGoOmiVOjr0SMG4QlMRRT1YNP0DSjopDHz8rfz9y8K
         Jwa3iW6mJm+CMUjvjNRsgESvwyqli9+ON3kIG5wotpA/YE1Z3bcdpq89E2pnMZvzi4
         YmeXb6cghwRSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B886C60A3A;
        Thu, 23 Sep 2021 11:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nexthop: Fix memory leaks in nexthop notification chain
 listeners
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239720675.23835.8902416398362181123.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 11:40:06 +0000
References: <20210922102540.808211-1-idosch@idosch.org>
In-Reply-To: <20210922102540.808211-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dsahern@kernel.org, yoshfuji@linux-ipv6.org, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 13:25:40 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> syzkaller discovered memory leaks [1] that can be reduced to the
> following commands:
> 
>  # ip nexthop add id 1 blackhole
>  # devlink dev reload pci/0000:06:00.0
> 
> [...]

Here is the summary with links:
  - [net] nexthop: Fix memory leaks in nexthop notification chain listeners
    https://git.kernel.org/netdev/net/c/3106a0847525

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


