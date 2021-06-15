Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D013B3A886A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhFOSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:22:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230349AbhFOSWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EC3D2613C2;
        Tue, 15 Jun 2021 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781210;
        bh=n+UcR8x2Z8xCcmkUUNep27j16Y6m9qipMBpgwbCQVSI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C7pCq6RT5W1wO1HmuAZYW66VWEMthMAbUgwc0JC56yfpmDFG9klLhjHWdRjhPswa6
         jGTM0oh7gDag2Pdk6OrXg5JUEFbwG/Nm8TYs34MGd14dGTMio7Y1Tond5BdGqY9wiE
         O2z2wWExNI7Rd5/YTSMJnE7tpoK+C1rlyq3IE0wrzazTMzwi7ZeqYlv/+JbQJVEicI
         Xc6sThmwqzsi1X+QwAP/9CYsoKPwlEbEYiwWliz3IGuTTV1ezSsAT6M1Wi3dt4hMos
         6OpgL/QDihxlKjSNL2JwJY4rI/eXJv58MlLmilIlAdMwtYIYIFiO4f9/AQgpb3+XgT
         hSfhzOObzx1CQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E3A0A6095D;
        Tue, 15 Jun 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Lag, refactor disable flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378120992.26290.2578213155194219033.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:20:09 +0000
References: <20210615040123.287101-2-saeed@kernel.org>
In-Reply-To: <20210615040123.287101-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        leonro@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 21:01:09 -0700 you wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> When a net device is removed (can happen if the PCI function is unbound
> from the system) it's not enough to destroy the hardware lag. The system
> should recreate the original devices that were present before the lag.
> As the same flow is done when a net device is removed from the bond
> refactor and reuse the code.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Lag, refactor disable flow
    https://git.kernel.org/netdev/net-next/c/8c22ad36eefa
  - [net-next,02/15] net/mlx5: Lag, Don't rescan if the device is going down
    https://git.kernel.org/netdev/net-next/c/8ed19471fdaa
  - [net-next,03/15] net/mlx5: Change ownership model for lag
    https://git.kernel.org/netdev/net-next/c/8a66e4585979
  - [net-next,04/15] net/mlx5: Delay IRQ destruction till all users are gone
    https://git.kernel.org/netdev/net-next/c/c38421abcf21
  - [net-next,05/15] net/mlx5: Introduce API for request and release IRQs
    https://git.kernel.org/netdev/net-next/c/3b43190b2f25
  - [net-next,06/15] net/mlx5: Provide cpumask at EQ creation phase
    https://git.kernel.org/netdev/net-next/c/e4e3f24b822f
  - [net-next,07/15] net/mlx5: Clean license text in eq.[c|h] files
    https://git.kernel.org/netdev/net-next/c/652e3581f248
  - [net-next,08/15] net/mlx5: Removing rmap per IRQ
    https://git.kernel.org/netdev/net-next/c/2de61538377c
  - [net-next,09/15] net/mlx5: Extend mlx5_irq_request to request IRQ from the kernel
    https://git.kernel.org/netdev/net-next/c/e8abebb3a48e
  - [net-next,10/15] net/mlx5: Moving rmap logic to EQs
    https://git.kernel.org/netdev/net-next/c/2d74524c0106
  - [net-next,11/15] net/mlx5: Change IRQ storage logic from static to dynamic
    https://git.kernel.org/netdev/net-next/c/fc63dd2a85be
  - [net-next,12/15] net/mlx5: Allocating a pool of MSI-X vectors for SFs
    https://git.kernel.org/netdev/net-next/c/71e084e26414
  - [net-next,13/15] net/mlx5: Enlarge interrupt field in CREATE_EQ
    https://git.kernel.org/netdev/net-next/c/3af26495a247
  - [net-next,14/15] net/mlx5: Separate between public and private API of sf.h
    https://git.kernel.org/netdev/net-next/c/c8ea212bfdff
  - [net-next,15/15] net/mlx5: Round-Robin EQs over IRQs
    https://git.kernel.org/netdev/net-next/c/c36326d38d93

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


