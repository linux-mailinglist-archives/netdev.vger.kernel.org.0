Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1C63B960F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbhGASWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:22:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233140AbhGASWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:22:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4EBC461420;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625163604;
        bh=EUEKoF+F60VGweVdT4ix5IbEZ6/+FqRuAtGIqaHLcos=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b9PyT7qPnI4IBt+SMUQ/PVyu7iLUnTC2F6y0IgRDehgEsSC1CT9q32cOEfUpiN1K6
         sW75SuqCApqCVpAYmcSbV74TGg93Ksz8OVqcOzS/qlMZy2YPR9Czf2fRNYtgVM2DK7
         YLRSjUc0YmpmB7K8s5WBZPwQzyn0S1Ux0AC/Ew+9+piEjVxv5lfddqEJh8H1oaZ9Sc
         1OUOc87MtcrAYe9nyYnJtC5s7VEH2JE+3d1vkiUIJJDZUJMoKKGtyt2DEcFbw1203c
         SnB4KLqLiyNSNxkQ2Ug51zG3Y0cYYIm48DRFYKtyqDHDBLJhaNBWWneLmvYrBLe/Ng
         CN+UMGgv5ARXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3EE6860A37;
        Thu,  1 Jul 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-net] openvswitch: Optimize operation for key comparison
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516360425.12749.9321876292870422857.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:20:04 +0000
References: <20210629072211.22487-1-simon.horman@corigine.com>
In-Reply-To: <20210629072211.22487-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, baowen.zheng@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 09:22:11 +0200 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> In the current implement when comparing two flow keys, we will return
> result after comparing the whole key from start to end.
> 
> In our optimization, we will return result in the first none-zero
> comparison, then we will improve the flow table looking up efficiency.
> 
> [...]

Here is the summary with links:
  - [net-net] openvswitch: Optimize operation for key comparison
    https://git.kernel.org/netdev/net/c/b18114476a14

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


