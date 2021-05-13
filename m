Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3D380095
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhEMXBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 19:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhEMXBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 19:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E1718613F5;
        Thu, 13 May 2021 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620946809;
        bh=dXZa4+5HpBk36KsyMXBDJN3Vm1RqYk9NeJdhmC003i8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aLP4Ywncm2LGkDgEWUdwGdLG0ggCpHDuCyY/zKSaDJLu+lqGUptU6rWFV/Y8gaECP
         jirLGYw2uyXsIO3jhxbOazZEJ6bHe8kjws5PQwpjMpaNtTd2GlkptN7MoXHcze1CRS
         aVNrfwT98woTA7epIn0vKOpXU/k3qV8lPic0fdRbwiz/kaMC6DhcaOuqUzXP0134GH
         L9tDjGJCPgpoJ1tLibmOpR/Jj1fj69/ntflgLtqp3U5KkK0ZzHZdxgqGRpu82WUfC0
         +te2Gc+1d1eGgkQNYMMaGrJq3PJKmr0lGEoi/PlnDZ6vZFK1jxNSxipYoewQ8Nd5AG
         6HbEJEWKw7lwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D4BB360A2C;
        Thu, 13 May 2021 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [ovs-dev] [PATCH net v2] openvswitch: meter: fix race when getting
 now_ms.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162094680986.5074.15163998908768388322.git-patchwork-notify@kernel.org>
Date:   Thu, 13 May 2021 23:00:09 +0000
References: <20210513130800.31913-1-thomas.liu@ucloud.cn>
In-Reply-To: <20210513130800.31913-1-thomas.liu@ucloud.cn>
To:     Tao Liu <thomas.liu@ucloud.cn>
Cc:     pshelar@ovn.org, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, i.maximets@ovn.org,
        jean.tourrilhes@hpe.com, kuba@kernel.org, davem@davemloft.net,
        wenxu@ucloud.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 13 May 2021 21:08:00 +0800 you wrote:
> We have observed meters working unexpected if traffic is 3+Gbit/s
> with multiple connections.
> 
> now_ms is not pretected by meter->lock, we may get a negative
> long_delta_ms when another cpu updated meter->used, then:
>     delta_ms = (u32)long_delta_ms;
> which will be a large value.
> 
> [...]

Here is the summary with links:
  - [ovs-dev,net,v2] openvswitch: meter: fix race when getting now_ms.
    https://git.kernel.org/netdev/net/c/e4df1b0c2435

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


