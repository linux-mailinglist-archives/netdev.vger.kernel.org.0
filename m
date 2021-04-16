Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6B7362B34
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbhDPWkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhDPWkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D7149613C0;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612810;
        bh=8goVJQUxcpgGQOGWf+xhc8/A6PiUHeDnIzDJ3htwIdo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNHQPHHcuwAbEAwrJ1P1Va9xW6BJ/Hm4LqnAPYRv2ssV2zBJwzv3bTWmwzItkIiNj
         FIvdgJqs9FkaaU58xGswqlJXAT6kXa/AwmRQzYOol224d44pofl+/NIcvcljs0c5jF
         l+TEgDyaEfz63KhlJtILI1+PaOCjCxktUC14mUbzPdq42jvcElnJDVKSEI7EGnLMKP
         r33M/hZcpCMdfBrHn//0IFPSKOTxuFGP/gUcJSy51LSJ6DezP0xpRA2NNZzOQtQcwt
         PFzgOWzd0M4O5V2w6U+mm2hKIntgQQHLRPs+PtKggzJfRWqZs6mTOE9jrjRCaGn7zV
         kjrIUOJPqY9hg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBCB260CD4;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] r8152: support new chips
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861281082.23739.2086228554864615182.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:40:10 +0000
References: <1394712342-15778-350-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-350-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 16:04:31 +0800 you wrote:
> Support new RTL8153 and RTL8156 series.
> 
> Hayes Wang (6):
>   r8152: set inter fram gap time depending on speed
>   r8152: adjust rtl8152_check_firmware function
>   r8152: add help function to change mtu
>   r8152: support new chips
>   r8152: support PHY firmware for RTL8156 series
>   r8152: search the configuration of vendor mode
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] r8152: set inter fram gap time depending on speed
    https://git.kernel.org/netdev/net-next/c/5133bcc74815
  - [net-next,2/6] r8152: adjust rtl8152_check_firmware function
    https://git.kernel.org/netdev/net-next/c/a8a7be178e81
  - [net-next,3/6] r8152: add help function to change mtu
    https://git.kernel.org/netdev/net-next/c/67ce1a806f16
  - [net-next,4/6] r8152: support new chips
    https://git.kernel.org/netdev/net-next/c/195aae321c82
  - [net-next,5/6] r8152: support PHY firmware for RTL8156 series
    https://git.kernel.org/netdev/net-next/c/4a51b0e8a014
  - [net-next,6/6] r8152: search the configuration of vendor mode
    https://git.kernel.org/netdev/net-next/c/c2198943e33b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


