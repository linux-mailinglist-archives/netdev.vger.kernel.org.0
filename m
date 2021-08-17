Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E15B3EEA1A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbhHQJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:40:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236017AbhHQJko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B0B16044F;
        Tue, 17 Aug 2021 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629193211;
        bh=nBjnayCDrJSvaDw6jniWJZMyp6cFtHfKuGgkGOHszn8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hB21Xg2Q1mvHwHmXhqD8DYc8RK6hd4Dp380a4jkRdPPetxAcN64hPUNPnqdpY85hq
         A9LPuju1UJWyZI3jRdKnfaIzj7aBdiWotcA1WvzMpeJqggUqMpvObT9MoAd0Fynd46
         MZ/26GaIBt4QXQgwkVlrL1fbzUZi3/Lk3iYx40yGAHfjTfJCGSWBeQ0OKKWyFxWKV/
         pqsmpR5PfqjmOw5Y6o2d6S0h4tIRG5y5leRhoQ1tby+m16DqMi00G7OXfD6uZ2Gjal
         yjb8Wf0h8hhpq8LRdDqKP8KJfEyqkJB15s/7VWMjE+PzXJ3aEsQ4VXBTqMrJ6tzcRb
         tpBb1AO5nSRCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F24E60A25;
        Tue, 17 Aug 2021 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next V2 01/17] net/mlx5e: Do not try enable RSS when resetting
 indir table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162919321131.26227.2695843221921487661.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 09:40:11 +0000
References: <20210816232219.557083-2-saeed@kernel.org>
In-Reply-To: <20210816232219.557083-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tariqt@nvidia.com, leonro@nvidia.com, maximmi@nvidia.com,
        saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 16:22:03 -0700 you wrote:
> From: Tariq Toukan <tariqt@nvidia.com>
> 
> All calls to mlx5e_rx_res_rss_set_indir_uniform() occur while the RSS
> state is inactive, i.e. the RQT is pointing to the drop RQ, not to the
> channels' RQs.
> It means that the "apply" part of the function is not called.
> Remove this part from the function, and document the change. It will be
> useful for next patches in the series, allows code simplifications when
> multiple RSS contexts are introduced.
> 
> [...]

Here is the summary with links:
  - [net-next,V2,01/17] net/mlx5e: Do not try enable RSS when resetting indir table
    https://git.kernel.org/netdev/net-next/c/6e5fea51961e
  - [net-next,V2,02/17] net/mlx5e: Introduce TIR create/destroy API in rx_res
    https://git.kernel.org/netdev/net-next/c/fc651ff9105a
  - [net-next,V2,03/17] net/mlx5e: Introduce abstraction of RSS context
    https://git.kernel.org/netdev/net-next/c/713ba5e5f689
  - [net-next,V2,04/17] net/mlx5e: Convert RSS to a dedicated object
    https://git.kernel.org/netdev/net-next/c/25307a91cb50
  - [net-next,V2,05/17] net/mlx5e: Dynamically allocate TIRs in RSS contexts
    https://git.kernel.org/netdev/net-next/c/49095f641b69
  - [net-next,V2,06/17] net/mlx5e: Support multiple RSS contexts
    https://git.kernel.org/netdev/net-next/c/f01cc58c18d6
  - [net-next,V2,07/17] net/mlx5e: Support flow classification into RSS contexts
    https://git.kernel.org/netdev/net-next/c/248d3b4c9a39
  - [net-next,V2,08/17] net/mlx5e: Abstract MQPRIO params
    https://git.kernel.org/netdev/net-next/c/86d747a3f969
  - [net-next,V2,09/17] net/mlx5e: Maintain MQPRIO mode parameter
    https://git.kernel.org/netdev/net-next/c/e2aeac448f06
  - [net-next,V2,10/17] net/mlx5e: Handle errors of netdev_set_num_tc()
    https://git.kernel.org/netdev/net-next/c/21ecfcb83a85
  - [net-next,V2,11/17] net/mlx5e: Support MQPRIO channel mode
    https://git.kernel.org/netdev/net-next/c/ec60c4581bd9
  - [net-next,V2,12/17] net/mlx5: Bridge, release bridge in same function where it is taken
    https://git.kernel.org/netdev/net-next/c/4de20e9a1225
  - [net-next,V2,13/17] net/mlx5: Bridge, obtain core device from eswitch instead of priv
    https://git.kernel.org/netdev/net-next/c/a514d1735059
  - [net-next,V2,14/17] net/mlx5: Bridge, identify port by vport_num+esw_owner_vhca_id pair
    https://git.kernel.org/netdev/net-next/c/3ee6233e61a1
  - [net-next,V2,15/17] net/mlx5: Bridge, extract FDB delete notification to function
    https://git.kernel.org/netdev/net-next/c/bf3d56d8f55f
  - [net-next,V2,16/17] net/mlx5: Bridge, allow merged eswitch connectivity
    https://git.kernel.org/netdev/net-next/c/c358ea1741bc
  - [net-next,V2,17/17] net/mlx5: Bridge, support LAG
    https://git.kernel.org/netdev/net-next/c/ff9b7521468b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


