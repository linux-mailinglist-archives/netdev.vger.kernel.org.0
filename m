Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B73813B2
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbhENWVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233897AbhENWV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F343C61457;
        Fri, 14 May 2021 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030814;
        bh=XWMFXnIGbH0Nty6jtkOVklpTDobDDTZf4ji9hquvGKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oklCr/orI4PjgW0GuO/dUmmuG9/Zddd7v2VWiZv1w/8HMcjXvBs8Xm4678OuPfe8C
         vvjpBblkol766uaJ+Az1pWk7f6X/FkMCaxFFlADomWFdvcu+PYZQ7p+Ize8215cjiO
         v8ayaAB64zEZQV4CBOT8KhQqLFsFcB88/EO764w4EwvtvyYUCKsYweXJeRTYnh2xqh
         m4d5tKKsnvXhdp3sj5d65hz+LIrWb+F8Ny2Uu5hstJZ7W8MaFGMTx0GaScTv3lrnRg
         UJxqWczsYXRk/98mXG022H0wsRnf9bHCJ4gZojvQOOBabNe03nbYlQdPc05P6cN3xE
         EgwHLKqO6pLlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE01760A0A;
        Fri, 14 May 2021 22:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/12] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081397.6483.10010295607926094289.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:13 +0000
References: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1620962720-62216-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 11:25:08 +0800 you wrote:
> This series adds some updates for the HNS3 ethernet driver.
> #1&#2 add support for a new RXD advanced layout.
> #3~#12 refactor the debugfs procedure and some commands.
> 
> Huazhong Tan (4):
>   net: hns3: support RXD advanced layout
>   net: hns3: refactor out RX completion checksum
>   net: hns3: refactor dump bd info of debugfs
>   net: hns3: refactor dump mac list of debugfs
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] net: hns3: support RXD advanced layout
    https://git.kernel.org/netdev/net-next/c/796640778c26
  - [net-next,02/12] net: hns3: refactor out RX completion checksum
    https://git.kernel.org/netdev/net-next/c/1ddc028ac849
  - [net-next,03/12] net: hns3: refactor the debugfs process
    https://git.kernel.org/netdev/net-next/c/5e69ea7ee2a6
  - [net-next,04/12] net: hns3: refactor dev capability and dev spec of debugfs
    https://git.kernel.org/netdev/net-next/c/c929bc2ac36e
  - [net-next,05/12] net: hns3: refactor dump bd info of debugfs
    https://git.kernel.org/netdev/net-next/c/77e9184869c9
  - [net-next,06/12] net: hns3: refactor dump mac list of debugfs
    https://git.kernel.org/netdev/net-next/c/1556ea9120ff
  - [net-next,07/12] net: hns3: refactor dump mng tbl of debugfs
    https://git.kernel.org/netdev/net-next/c/8ddfd9c46ef4
  - [net-next,08/12] net: hns3: refactor dump loopback of debugfs
    https://git.kernel.org/netdev/net-next/c/d658ff34dd7f
  - [net-next,09/12] net: hns3: refactor dump intr of debugfs
    https://git.kernel.org/netdev/net-next/c/9149ca0f115a
  - [net-next,10/12] net: hns3: refactor dump reset info of debugfs
    https://git.kernel.org/netdev/net-next/c/1a7ff8280b16
  - [net-next,11/12] net: hns3: refactor dump m7 info of debugfs
    https://git.kernel.org/netdev/net-next/c/0b198b0d80ea
  - [net-next,12/12] net: hns3: refactor dump ncl config of debugfs
    https://git.kernel.org/netdev/net-next/c/e76e6886646b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


