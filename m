Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46CDB2BC279
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 23:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbgKUWkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 17:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbgKUWkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 17:40:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605998406;
        bh=7kJkwQdGZG1kh6JwinI1VNPFdfsmjTrZyHUsgEddo/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RudMpXG6xM+XtpVyWgTTbT/d/qNv5o4k8YEq0sdYB4zI86FKvlvtfBEsg4GDFJMI5
         GsGledQ5QkxQmdEnF4uA9AwfWAG2VyLlEnOsMnC8aEqtlJvsSXCzgNkbT2uQkT/W3K
         bBnJcswRY6KF8RdckRLfUZiwT8Jm/NcjSY5EtzJI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: hns3: misc updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160599840626.17366.1453634275952630580.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Nov 2020 22:40:06 +0000
References: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1605863783-36995-1-git-send-email-tanhuazhong@huawei.com>
To:     tanhuazhong <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, linuxarm@huawei.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 20 Nov 2020 17:16:18 +0800 you wrote:
> This series includes some misc updates for the HNS3 ethernet driver.
> 
> #1 adds support for 1280 queues
> #2 adds mapping for BAR45 which is needed by RoCE client.
> #3 extend the interrupt resources.
> #4&#5 add support to query firmware's calculated shaping parameters.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: hns3: add support for 1280 queues
    https://git.kernel.org/netdev/net-next/c/9a5ef4aa5457
  - [net-next,2/5] net: hns3: add support for mapping device memory
    https://git.kernel.org/netdev/net-next/c/30ae7f8a6aa7
  - [net-next,3/5] net: hns3: add support for pf querying new interrupt resources
    https://git.kernel.org/netdev/net-next/c/3a6863e4e8ee
  - [net-next,4/5] net: hns3: add support to utilize the firmware calculated shaping parameters
    https://git.kernel.org/netdev/net-next/c/e364ad303fe3
  - [net-next,5/5] net: hns3: adds debugfs to dump more info of shaping parameters
    https://git.kernel.org/netdev/net-next/c/c331ecf1afc1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


