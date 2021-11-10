Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BBB44C2F4
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhKJOc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:32:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhKJOc4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:32:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9362D61107;
        Wed, 10 Nov 2021 14:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636554608;
        bh=Y5tNTXBw5v8jZusqMsW1ANBlY5U4Ik9/H+BSPK/jB5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hnfXy6Vl/UbochV4b5pgmus3w7h7K8tED7GbnOfqa7xbF9pTZ1b6+gkC5Q1C6JtwE
         xTEhQytCVkhEmM1/rIOP7GfYmZx6N1np+j3FmZLcoScGwg8v9HiJ9B1zPjQh/tbiOc
         Yq9HtQK2oH7j6PeDbfgKxiQzy8qmOprRnq/XcTm3rzVaIbB7kZJzBpcQyJ0MgGeIrI
         0tl7+QxOvxebljoiB305VhWkDynncfMG3PDWr3MEcqj2mlqYFb2PALZ+YJGHM+ziLQ
         +8QZYEtY4P2Cr3FI74eZGs/eVE5gLKNNTz05H1lVz6Suc2QbFPQz8NzpB/lM8l6bt2
         OIFmV0bW/96Wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85E7860A6B;
        Wed, 10 Nov 2021 14:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655460854.14356.13696488352742404658.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:30:08 +0000
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, wangjie125@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Nov 2021 21:42:48 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (4):
>   net: hns3: fix failed to add reuse multicast mac addr to hardware when
>     mc mac table is full
>   net: hns3: fix some mac statistics is always 0 in device version V2
>   net: hns3: remove check VF uc mac exist when set by PF
>   net: hns3: allow configure ETS bandwidth of all TCs
> 
> [...]

Here is the summary with links:
  - [net,1/8] net: hns3: fix failed to add reuse multicast mac addr to hardware when mc mac table is full
    https://git.kernel.org/netdev/net/c/3b4c6566c158
  - [net,2/8] net: hns3: fix ROCE base interrupt vector initialization bug
    https://git.kernel.org/netdev/net/c/beb27ca451a5
  - [net,3/8] net: hns3: fix pfc packet number incorrect after querying pfc parameters
    https://git.kernel.org/netdev/net/c/0b653a81a26d
  - [net,4/8] net: hns3: sync rx ring head in echo common pull
    https://git.kernel.org/netdev/net/c/3b6db4a0492b
  - [net,5/8] net: hns3: fix kernel crash when unload VF while it is being reset
    https://git.kernel.org/netdev/net/c/e140c7983e30
  - [net,6/8] net: hns3: fix some mac statistics is always 0 in device version V2
    https://git.kernel.org/netdev/net/c/1122eac19476
  - [net,7/8] net: hns3: remove check VF uc mac exist when set by PF
    https://git.kernel.org/netdev/net/c/91fcc79bff40
  - [net,8/8] net: hns3: allow configure ETS bandwidth of all TCs
    https://git.kernel.org/netdev/net/c/688db0c7a4a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


