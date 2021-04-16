Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98AE3616A0
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 02:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhDPAAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 20:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235758AbhDPAAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 20:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0E5496113D;
        Fri, 16 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618531210;
        bh=cTWhLwlKN5SbYegAzzuMlHvtJawlIe+RTfxzH90NYso=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UR390hdqRIEfH2YBp2Eb++LZT+IP85Fh9jpq9lKe3iJvWkn7GaevyqNRDLHqrzxg5
         LDKonuDYJtz6u7ERIsLXBc4sqpupgFYp+JhPZ2VH0HoQJ9p5G05Z+nLWxFj18tNuot
         ZsMQazpllDqU64kcDgUHApJUrOSkQ+xZlAqZf5c10rRRKPwofwpSeFLBM30uWylJ39
         4I7zDV/9b9hri/CRkUqWtWDOlZc3v7l1FayGxlnwLRtioIwf737BV/2Zff+LjD9V9s
         sqyzleojmyc3DzrLeGwdsAmZPcWIb6uDOts8cL+HQwIz+g+ejDIzbmj+di0ctcJx8z
         XEJyLSiYhYXXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08B5260A0D;
        Fri, 16 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next 0/2] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161853121003.2137.949633143176457701.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 00:00:10 +0000
References: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1618453239-10451-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 15 Apr 2021 10:20:37 +0800 you wrote:
> This series adds support for pushing link status to VFs for
> the HNS3 ethernet driver.
> 
> Guangbin Huang (2):
>   net: hns3: PF add support for pushing link status to VFs
>   net: hns3: VF not request link status when PF support push link status
>     feature
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/2] net: hns3: PF add support for pushing link status to VFs
    https://git.kernel.org/netdev/net-next/c/18b6e31f8bf4
  - [RESEND,net-next,2/2] net: hns3: VF not request link status when PF support push link status feature
    https://git.kernel.org/netdev/net-next/c/01305e16ebe7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


