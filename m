Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0D41F730
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355768AbhJAWBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355763AbhJAWBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 18:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A8AF61A8E;
        Fri,  1 Oct 2021 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633125609;
        bh=c27J3Ie3pXP5T+TSdXHozPWjHx2McQYnl/B/FPenw2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RZVeiE+qilWLEZFyZTOcoPdwlUWUEC+MTyTeTEDhCA6Ua2rXm8k/q0mzzn6myneua
         IUj+NfPiADC2IDCmXydLf/Bq4J1LXAJmdjBao1Zl9M05v13+aMp2X0hFo3KltEfUfE
         kjPPhvX8OwUZyg3CNq82EdMxIGHnrsQkDIeshkmBstpiR43Vfnhzw8lRHk0Iz0XqMp
         CBu4AMcRX/WkjaAQ9oTGP6nya17PKipGT3BKhFQpreosC1qtpc/ErkT471vErQvnx9
         S+/vhfbSJtXA13s4dbLS0QTEj0SDVxsxBLVl8KWnRm8WyaoKO6URfkrMOTeyL3MCrl
         VjZFDM8/q2r8g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F03960A69;
        Fri,  1 Oct 2021 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: DR, Fix vport number data type to u16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163312560931.29945.14744192927620358665.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Oct 2021 22:00:09 +0000
References: <20210930232050.41779-2-saeed@kernel.org>
In-Reply-To: <20210930232050.41779-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kliteyn@nvidia.com, muhammads@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 30 Sep 2021 16:20:36 -0700 you wrote:
> From: Yevgeny Kliteynik <kliteyn@nvidia.com>
> 
> According to the HW spec, vport number is a 16-bit value.
> Fix vport usage all over the code to u16 data type.
> 
> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
> Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: DR, Fix vport number data type to u16
    https://git.kernel.org/netdev/net-next/c/f9f93bd55ca6
  - [net-next,02/15] net/mlx5: DR, Replace local WIRE_PORT macro with the existing MLX5_VPORT_UPLINK
    https://git.kernel.org/netdev/net-next/c/7ae8ac9a5820
  - [net-next,03/15] net/mlx5: DR, Add missing query for vport 0
    https://git.kernel.org/netdev/net-next/c/dd4acb2a0954
  - [net-next,04/15] net/mlx5: DR, Align error messages for failure to obtain vport caps
    https://git.kernel.org/netdev/net-next/c/ee1887fb7cdd
  - [net-next,05/15] net/mlx5: DR, Support csum recalculation flow table on SFs
    https://git.kernel.org/netdev/net-next/c/c0e90fc2ccaa
  - [net-next,06/15] net/mlx5: DR, Add support for SF vports
    https://git.kernel.org/netdev/net-next/c/11a45def2e19
  - [net-next,07/15] net/mlx5: DR, Increase supported num of actions to 32
    https://git.kernel.org/netdev/net-next/c/1ffd498901c1
  - [net-next,08/15] net/mlx5: DR, Fix typo 'offeset' to 'offset'
    https://git.kernel.org/netdev/net-next/c/5dde00a73048
  - [net-next,09/15] net/mlx5: DR, init_next_match only if needed
    https://git.kernel.org/netdev/net-next/c/515ce2ffa621
  - [net-next,10/15] net/mlx5: DR, Add missing string for action type SAMPLER
    https://git.kernel.org/netdev/net-next/c/98576013bf28
  - [net-next,11/15] net/mlx5: Warn for devlink reload when there are VFs alive
    https://git.kernel.org/netdev/net-next/c/2b0247e22097
  - [net-next,12/15] net/mlx5: Tolerate failures in debug features while driver load
    https://git.kernel.org/netdev/net-next/c/f62eb932d857
  - [net-next,13/15] net/mlx5: Use kvcalloc() instead of kvzalloc()
    https://git.kernel.org/netdev/net-next/c/806bf340e180
  - [net-next,14/15] net/mlx5: Use struct_size() helper in kvzalloc()
    https://git.kernel.org/netdev/net-next/c/ab9ace34158f
  - [net-next,15/15] net/mlx5e: Use array_size() helper
    https://git.kernel.org/netdev/net-next/c/51984c9ee01e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


