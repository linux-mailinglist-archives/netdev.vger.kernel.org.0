Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 183B639387D
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhE0WBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234459AbhE0WBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 18:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 88DD9613D1;
        Thu, 27 May 2021 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622152803;
        bh=IIvWfozI/KDM2R2zVm13hiZSJWFOVs1U1NQ2rEoeghc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L1ZMY0W1ePSSqQuMOghB6M2UlEXsBLUr+Nu0vmlYx6M/jA2lD5eg8PAQU4XL+b7FK
         nuP+h3u6B872Qhxsp3gm7gZ1ezn0sRy+Hsz/sbxwxpBU+cBlsiqb+aRiu8dxyVyCWR
         8pVbxUz3jFJhK1FI2lCVXifQsNqHSEV4beHMvIFbO3YrAD1VqmjFp12s4dvHLxf2LA
         8MJ2z62plk48IqRxdvSF3LRwpIV9UNv/BmqyA/0kxVdrMur5toh8HX/A3I657eroSZ
         rYwygtkWpsYGbjlJ1FBKoE7fW9zAJwYGNSG6cyI9fqZ2BPehryH1NRVLKGMwwL9tZ+
         0KW1XaTx7Sb5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D1E7609F5;
        Thu, 27 May 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next 0/3] mlx*: devlink dev info versions adjustments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162215280350.25428.11680179973826185726.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 22:00:03 +0000
References: <20210526104509.761807-1-jiri@resnulli.us>
In-Reply-To: <20210526104509.761807-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 26 May 2021 12:45:06 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Couple of adjustments in Mellanox drivers regarding devlink dev
> versions fill-up.
> 
> Jiri Pirko (3):
>   net/mlx5: Expose FW version over defined keyword
>   mlxsw: core: Expose FW version over defined keyword
>   mlxsw: core: use PSID string define in devlink info
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/mlx5: Expose FW version over defined keyword
    https://git.kernel.org/netdev/net-next/c/2754125ebd33
  - [net-next,2/3] mlxsw: core: Expose FW version over defined keyword
    https://git.kernel.org/netdev/net-next/c/f55c998c274e
  - [net-next,3/3] mlxsw: core: use PSID string define in devlink info
    https://git.kernel.org/netdev/net-next/c/7dafcc4c9dfb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


