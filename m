Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DE234F57F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbhCaAai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232644AbhCaAaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 915BC61957;
        Wed, 31 Mar 2021 00:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617150609;
        bh=q+WXx+BJxKM5k0jsFWPntZkityEm40gzi8SmkXVjGLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gLdJn4ue8JJZ1QO+rDh9O++PJeYeNsVuusDvLINR73ppdnS1fkwNmo6ahHtcqrFXz
         ibvkJQsFb/LI8/OLQ0gFYxPZyHLjR2iDgzpAnmTIeF8b9ausF5j7Kd/GehLldOrZbz
         67eNiNVeLe2CZaPS+sbepxM7McTpnSfoFLs5awj6+1zxW2ZWJ1dQ6oTiTAaU+KAJcn
         /VfqC8ZqLlecALmD62WNot3YcH6rsGcfmAghm4goHW4M3XvhBe/l/7kpsntISc46OC
         bWIZj5UYX3oObFsRJuTaGT5N3wOv4ZdqTAf/1JYyan5cscPX3KGeTic+uYVSJJv3R9
         SAfHkGynmrJHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 80DA160A6D;
        Wed, 31 Mar 2021 00:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] dpaa2-switch: add STP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715060952.8621.15388877653902975321.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:30:09 +0000
References: <20210330145419.381355-1-ciorneiioana@gmail.com>
In-Reply-To: <20210330145419.381355-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 17:54:14 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set adds support for STP to the dpaa2-switch.
> 
> First of all, it fixes a bug which was determined by the improper usage
> of bridge BR_STATE_* values directly in the MC ABI.
> The next patches deal with creating an ACL table per port and trapping
> the STP frames to the control interface by adding an entry into each
> table.
> The last patch configures proper learning state depending on the STP
> state.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] dpaa2-switch: fix the translation between the bridge and dpsw STP states
    https://git.kernel.org/netdev/net-next/c/6aa6791d1a0f
  - [net-next,2/5] dpaa2-switch: create and assign an ACL table per port
    https://git.kernel.org/netdev/net-next/c/90f071023529
  - [net-next,3/5] dpaa2-switch: keep track of the current learning state per port
    https://git.kernel.org/netdev/net-next/c/62734c7405b7
  - [net-next,4/5] dpaa2-switch: trap STP frames to the CPU
    https://git.kernel.org/netdev/net-next/c/1a64ed129cce
  - [net-next,5/5] dpaa2-switch: setup learning state on STP state change
    https://git.kernel.org/netdev/net-next/c/bc96781a8959

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


