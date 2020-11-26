Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63442C4CB9
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730963AbgKZBkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgKZBkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 20:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606354805;
        bh=f45noq/6aeVZ+pkyrr7FEBvGHL3z2UcDTLtgUYb6q9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tgsI0nsFI5v7f+MW+HxL31xI3glpRGjK2hddwt6R9hkU+SyLo28Yp9O7PZgHhY0Um
         XzNSlrxd7nYR8CcjhA+k8ZHJG9oQ8zNohNfzWgk2j/PanqW0psKISDlCaX0h8OXHhv
         lWjanR/v+St5URoR2Z/z7OfJSWAGk8QWkifBTmg8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] devlink port attribute fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160635480500.18564.1509055832037956105.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Nov 2020 01:40:05 +0000
References: <20201125091620.6781-1-parav@nvidia.com>
In-Reply-To: <20201125091620.6781-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 25 Nov 2020 11:16:18 +0200 you wrote:
> This patchset contains 2 small fixes for devlink port attributes.
> 
> Patch summary:
> Patch-1 synchronize the devlink port attribute reader
>         with net namespace change operation
> Patch-2 Ensure to return devlink port's netdevice attributes
>         when netdev and devlink instance belong to same net namespace
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] devlink: Hold rtnl lock while reading netdev attributes
    https://git.kernel.org/netdev/net/c/b187c9b4178b
  - [net,v2,2/2] devlink: Make sure devlink instance and port are in same net namespace
    https://git.kernel.org/netdev/net/c/a7b43649507d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


