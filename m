Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B1A41FCA5
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhJBPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 11:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233274AbhJBPLy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 11:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96B0861AFB;
        Sat,  2 Oct 2021 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633187408;
        bh=01AM/1cxuQUpeTxdSe8uKOE0YCvWnCrgZjn5APJs0Jg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sh9rL5iMUaavgPemZIcN8eTyLlOYjgLw9zQeYJpwBIs1/l9s6D0DHQgSCP4mbj84C
         uaEwOGIuzzYMoYyAe04UPfcGp+oLQ/zwQ6IWQ7rgQBiLhzbKrfIs0Dc8ud9u4XskRZ
         q42nJrEAg9BNLqXOW9JLW7JPBB1CxiH7Sgx6ENXoZhwmOjjVqBchj0kyYHXpIB1Jma
         xVscOna86qfRF5YzJZyk8OQVFpjACyPqFsclQ9QNKVhAoKAstbOFP5t9KZ3sgexNgS
         K+Bx95GS1Iqi9uAsyd7tYNgPXpEwMYmtIaZMJ1ydiIq7KU80Q352ajKTLHxJTkOQ20
         7uP8lLKjMF1pQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87A3360BCB;
        Sat,  2 Oct 2021 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] Use netdev->dev_addr write helpers (part 1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318740855.10513.12274093387926375607.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 15:10:08 +0000
References: <20211001213228.1735079-1-kuba@kernel.org>
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  1 Oct 2021 14:32:17 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> This is the first installment of predictably tedious conversion.
> It tackles:
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] arch: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/4e9b9de65cdd
  - [net-next,02/11] net: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/2f23e5cef314
  - [net-next,03/11] ethernet: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/a96d317fb1a3
  - [net-next,04/11] net: usb: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/168137176233
  - [net-next,05/11] net: use eth_hw_addr_set() instead of ether_addr_copy()
    https://git.kernel.org/netdev/net-next/c/e35b8d7dbb09
  - [net-next,06/11] ethernet: use eth_hw_addr_set() instead of ether_addr_copy()
    https://git.kernel.org/netdev/net-next/c/f3956ebb3bf0
  - [net-next,07/11] net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
    https://git.kernel.org/netdev/net-next/c/af804e6db9f6
  - [net-next,08/11] ethernet: chelsio: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/47d71f45902e
  - [net-next,09/11] ethernet: s2io: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/1235568b6d2e
  - [net-next,10/11] fddi: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/4d3d2c8dba36
  - [net-next,11/11] ethernet: use eth_hw_addr_set() - casts
    https://git.kernel.org/netdev/net-next/c/16be9a16340b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


