Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69AA3194DC
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhBKVK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:59922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhBKVKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 16:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 19C6164E42;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613077810;
        bh=7HO3+lFJ9iqgejRJos+zHXfdjtExEhuj3Zyybdpxz1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XwpZdOyZr2ShRtNeHneunjGwcPbSagisb9MolqiixOCigung0tF9zc/MQlf635j1p
         EtQQCsmV06B7PA30AQYnYMMGYTPaO76IK4gZq6M5WbJ+QUWogNiUcWtu8mMX4MZheX
         n149D/59Ih4iVFOyXqY0lCeJYg1uhWEHhwLdMgOKJE+S8ACEIErPoQ2UBUZtlUmoCu
         x3Lo8QCmatTB20atvfRnqxC3Q4FJnBr9036Bk9DsLPUlKqnDGt3hYb2lip+8hUB+QH
         22LmagSjMEwDwztstkFmvJTrC/Uh6nTeknPgJGbtQo8ZiLPINIz2fGR++yiAIiVvzd
         Twecc1XTWCxoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07F6B60A2A;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8] a set of fixes of coding style
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161307781002.4804.7034883194654161142.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 21:10:10 +0000
References: <20210211064325.80591-1-lijunp213@gmail.com>
In-Reply-To: <20210211064325.80591-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 00:43:17 -0600 you wrote:
> This series address several coding style problems.
> 
> v2: rebased on top of tree. Add the Reviewed-by tag from v1 reviews.
>     patch 8/8 is new.
> 
> Lijun Pan (8):
>   ibmvnic: prefer 'unsigned long' over 'unsigned long int'
>   ibmvnic: fix block comments
>   ibmvnic: fix braces
>   ibmvnic: avoid multiple line dereference
>   ibmvnic: fix miscellaneous checks
>   ibmvnic: add comments for spinlock_t definitions
>   ibmvnic: remove unused spinlock_t stats_lock definition
>   ibmvnic: prefer strscpy over strlcpy
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] ibmvnic: prefer 'unsigned long' over 'unsigned long int'
    https://git.kernel.org/netdev/net-next/c/429aa36469f9
  - [net-next,v2,2/8] ibmvnic: fix block comments
    https://git.kernel.org/netdev/net-next/c/bab08bedcdc3
  - [net-next,v2,3/8] ibmvnic: fix braces
    https://git.kernel.org/netdev/net-next/c/f78afaace636
  - [net-next,v2,4/8] ibmvnic: avoid multiple line dereference
    https://git.kernel.org/netdev/net-next/c/914789acaaae
  - [net-next,v2,5/8] ibmvnic: fix miscellaneous checks
    https://git.kernel.org/netdev/net-next/c/91dc5d2553fb
  - [net-next,v2,6/8] ibmvnic: add comments for spinlock_t definitions
    https://git.kernel.org/netdev/net-next/c/a369d96ca554
  - [net-next,v2,7/8] ibmvnic: remove unused spinlock_t stats_lock definition
    https://git.kernel.org/netdev/net-next/c/4bb9f2e48299
  - [net-next,v2,8/8] ibmvnic: prefer strscpy over strlcpy
    https://git.kernel.org/netdev/net-next/c/8a96c80e2774

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


