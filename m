Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9D3A886D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhFOSWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231423AbhFOSWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 14:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 02E2A613DA;
        Tue, 15 Jun 2021 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623781210;
        bh=GcCXwcvSUjLX1JqIeIleB7iKOFnXSSfdKCnGtBh/eDo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XDB66wQbSlAvKFMw5IelCxe4SdGRyQ7I+yVl8jg06w/LXeBCgH2RdDgP7s9Dkyhah
         /i8hNN1yL4ItZ0CnBug8VoALihFmOGEYSmWll9I7Lvmfd7jT1oNjB8YoKCH07W8cU5
         1F0yG1zK2UsUUJZTxjlwZNfAuM763V0k6zO4cV/euPMCG2KZ3XP6xMGFkum/emNnsv
         vqgGwmc+GZvAzY0Bfwf6xy4/f6EI66/FEO2T42JtcDo98T7iAOX3DXzDBDPfiWl4em
         bbZ4iRI+fi97oib1OPztlQdk5XO4b2JIGkkzQN6c2dWUPQ1H/VJUd5HnMhpvr1zmOw
         vkv6ms5979QPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EC69B60CAA;
        Tue, 15 Jun 2021 18:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: pci200syn: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162378120996.26290.17043108995062336206.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 18:20:09 +0000
References: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
In-Reply-To: <1623765263-36775-1-git-send-email-lipeng321@huawei.com>
To:     Peng Li <lipeng321@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huangguangbin2@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 21:54:17 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (6):
>   net: pci200syn: remove redundant blank lines
>   net: pci200syn: add blank line after declarations
>   net: pci200syn: replace comparison to NULL with "!card"
>   net: pci200syn: add some required spaces
>   net: pci200syn: add necessary () to macro argument
>   net: pci200syn: fix the comments style issue
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: pci200syn: remove redundant blank lines
    https://git.kernel.org/netdev/net-next/c/bbcb2840b007
  - [net-next,2/6] net: pci200syn: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/f9a03eae2850
  - [net-next,3/6] net: pci200syn: replace comparison to NULL with "!card"
    https://git.kernel.org/netdev/net-next/c/b9282333efff
  - [net-next,4/6] net: pci200syn: add some required spaces
    https://git.kernel.org/netdev/net-next/c/2b637446685f
  - [net-next,5/6] net: pci200syn: add necessary () to macro argument
    https://git.kernel.org/netdev/net-next/c/8e7680c10284
  - [net-next,6/6] net: pci200syn: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/6855d301e9d3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


