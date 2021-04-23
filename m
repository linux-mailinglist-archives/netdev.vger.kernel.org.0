Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB91369B23
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243889AbhDWULF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229549AbhDWULF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 16:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3279361452;
        Fri, 23 Apr 2021 20:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619208628;
        bh=UWmAWC2tPQK+/jLuSr28NYJrUsePoE9Ilbuq5V7dFiw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oCeZjZETPlV++Wu7U6VGVroHOG5velueGx6I1FpF71W+s/XQjWbDB3zyoAWWy7otr
         x4N2FIn8FDswg2HWB82V48rMRsPJOcTsayOaF6nHQcXgqzDeiAMmv/OZKCw4O1oYbX
         FQ2xfpWxJlnqsrk3QQVl4SUM3IaUZibxZpA8h3cCU5GUehWmaLHnj4MHyrppFrjJiO
         n4TB/5CRjOKspdF1nORZ5PEGVJD4KgFBZ6J9Ql4tYxtxSgiJinTm2RK6cOKWOyvauQ
         7EZ0f3A/uhvgUWTzcmg7H3tRDH+i4AJRNhcQF3ZwFRodHnlsgWELDKH4CEqQctxcVK
         Qo3H0eWLSDplg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 27D3A60976;
        Fri, 23 Apr 2021 20:10:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: meter: remove rate from the bucket size
 calculation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161920862815.30338.13572609304102929067.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Apr 2021 20:10:28 +0000
References: <20210421135747.312095-1-i.maximets@ovn.org>
In-Reply-To: <20210421135747.312095-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        azhou@ovn.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@openvswitch.org,
        xiangxia.m.yue@gmail.com, u9012063@gmail.com,
        jean.tourrilhes@hpe.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 15:57:47 +0200 you wrote:
> Implementation of meters supposed to be a classic token bucket with 2
> typical parameters: rate and burst size.
> 
> Burst size in this schema is the maximum number of bytes/packets that
> could pass without being rate limited.
> 
> Recent changes to userspace datapath made meter implementation to be
> in line with the kernel one, and this uncovered several issues.
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: meter: remove rate from the bucket size calculation
    https://git.kernel.org/netdev/net/c/7d742b509dd7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


