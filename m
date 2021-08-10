Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAB93E845D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 22:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhHJUbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 16:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233336AbhHJUa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 16:30:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5977461077;
        Tue, 10 Aug 2021 20:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628627407;
        bh=2AwFYQxJdwxq3i7RIcJRev+u9CYYBnmaGOexvJXWbKE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nFOupEXbIWFiDYeV0qARarqNqM3IDlp9n0iCntQZyn7K0nPCAOh22VTWXeurbqOF6
         q/S9CexK0QPeU0tBchDcOrbuXdPm9agBcYZlPcCKLoGk+neRhpY47kZO6ng4nhs562
         X5l4HQrffUmG/hbf20hlfL8f3YeJkIgCj04m5JOqyVwSKWCgDrP+IHe3eakvs+Elqu
         LGW3n4qLvy6Eh/FEtINjhJxHliDbB6YGaVPeME9hVM0Zu5PDa5Itm+/9me2fEoNHP0
         9bIBHnWCk1b/Ljdm3xEv1kJbyzpEVqrsCHfMyy+0i9lTcDSB5A0YWdTAlyQSAcpo10
         GZC8JPEgwvU8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52F4860986;
        Tue, 10 Aug 2021 20:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mlx5-next 2020-08-9
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162862740733.16281.6609347684228513996.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 20:30:07 +0000
References: <20210809202522.316930-1-saeed@kernel.org>
In-Reply-To: <20210809202522.316930-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@ziepe.ca, leonro@nvidia.com, jgg@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Mon,  9 Aug 2021 13:25:22 -0700 you wrote:
> Hi Dave, Jakub and Jason,
> 
> This pulls mlx5-next branch which includes patches already reviewed on
> net-next and rdma mailing lists.
> 
> 1) mlx5 single E-Switch FDB for lag
> 
> [...]

Here is the summary with links:
  - pull-request: mlx5-next 2020-08-9
    https://git.kernel.org/netdev/net-next/c/ebd0d30cc5e4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


