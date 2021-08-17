Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9833EE0C6
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhHQAUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233008AbhHQAUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 20:20:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5211B60F46;
        Tue, 17 Aug 2021 00:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629159606;
        bh=fBrYglpdbewjkxLFOm/OwRxn1WAuf7LakyTuPe/hqhg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eSMqJTlF+vKwX7/YY3RmA+DdFj58JLsQe7F7zOQA+SzrZyk1sshL6mtgPksyOz8mu
         p1Ax/F9yrnTpr7B0+k7m+H+ft2bjG3nHswBaC3zU7YCwwInHQWltcyy53NmeMWybgG
         yjdzyhWJ9tCy+m7OQTAWbOhepjB4+S9o37VEbB5WLLJm+CP6+kG5nmHSniHci5i4Sl
         8LWrYYStjZcGtYO/kmiSLu5HWB1vqVfmylmMxtv64YjJqh6QkaOq5Ii/8WUciFzCPW
         Z4z/hCoVY4fgTH3Zwzazvj115m8+jWBWdSbqyDpEqLMKersyu7j0wvEwEQmt42Pgnj
         irzii28oISJEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4471060989;
        Tue, 17 Aug 2021 00:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND V2 net-next 0/4] net: hns3: add support ethtool
 extended link state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162915960627.13474.2235439664484161424.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 00:20:06 +0000
References: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1629080129-46507-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 16 Aug 2021 10:15:25 +0800 you wrote:
> This series adds support for ethtool extended link state in the HNS3
> ethernet driver to add one additional information for user to know
> why a link is not up.
> 
> change log:
> V1 -> V2:
> 1. fix missing a P for "-EOPNOTSUP".
> 2. delete unnecessary error log of this feature is not supported by
>    devices of earlier version.
> 
> [...]

Here is the summary with links:
  - [RESEND,V2,net-next,1/4] docs: ethtool: Add two link extended substates of bad signal integrity
    https://git.kernel.org/netdev/net-next/c/958ab281eb3e
  - [RESEND,V2,net-next,2/4] ethtool: add two link extended substates of bad signal integrity
    https://git.kernel.org/netdev/net-next/c/5b4ecc3d4c4a
  - [RESEND,V2,net-next,3/4] net: hns3: add header file hns3_ethtoo.h
    https://git.kernel.org/netdev/net-next/c/edb40bbc17eb
  - [RESEND,V2,net-next,4/4] net: hns3: add support ethtool extended link state
    https://git.kernel.org/netdev/net-next/c/f5c2b9f0fc07

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


