Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E98638DE5B
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhEXAbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhEXAbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1BA8161168;
        Mon, 24 May 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816210;
        bh=q6mTJKyox5cRnqe1I41aBw/eygE+kXX2ctglQtQyLIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DfWsUb6vK7U9MO0Nl9vg4IRwkaImfJa8q3uGwdaqv3TafpmZCI9T4QLZM8jJJ0n9a
         CPc+UQG1Td230uQ8Ruv2BCGIZ6vuRcZsghSJrlYzyzU41AWiHVw7NcKdwzsTUSBhoZ
         RPaaTqMSlR/UebdubXzt1qLefKfDlmh0f2ciRQSiC2Rr0GxKnoU3s346mh0Mfmbn+u
         AuA28KpUWIaXwIY+fMMQbwNOY7Bj9cRUD+TfOew74y5A5jrQY3/DqcUGWMwgWDvT2V
         ITSLbghJlTkKY+JkDuqRcVoiFXEiQRiAc2cdBC/Q3HxKM0zK+nRWo+vdnM7bE5JaVL
         59OwiDoYebF2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0E81160BD8;
        Mon, 24 May 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: mt7530: fix VLAN traffic leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621005.30453.18294739015052454506.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:10 +0000
References: <20210523145154.655325-1-dqfext@gmail.com>
In-Reply-To: <20210523145154.655325-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        frank-w@public-files.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 23 May 2021 22:51:54 +0800 you wrote:
> PCR_MATRIX field was set to all 1's when VLAN filtering is enabled, but
> was not reset when it is disabled, which may cause traffic leaks:
> 
> 	ip link add br0 type bridge vlan_filtering 1
> 	ip link add br1 type bridge vlan_filtering 1
> 	ip link set swp0 master br0
> 	ip link set swp1 master br1
> 	ip link set br0 type bridge vlan_filtering 0
> 	ip link set br1 type bridge vlan_filtering 0
> 	# traffic in br0 and br1 will start leaking to each other
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: mt7530: fix VLAN traffic leaks
    https://git.kernel.org/netdev/net/c/474a2ddaa192

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


