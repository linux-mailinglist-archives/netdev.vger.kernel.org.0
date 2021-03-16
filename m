Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2343A33DC76
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239929AbhCPSUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236524AbhCPSUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 14:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EBA5C65116;
        Tue, 16 Mar 2021 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615918809;
        bh=J3OR9N0ctT7xz6A44ivFgdAbe09GRtaPmAqDBTkVu+U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lJqHKSMIFITW1Wc/+Wf3zWZ4Wq+Y5EwiZrM819MNYyjpWrTUyoP7KR4z7Sbp1Q4Uh
         h7CvgU/VjKeTzR0b+vu6yjJjd7GJdWBvVEImSGrD9uKbXEOEGTNQR3HUt7j3X6oe9E
         t90+Rw4a1l6cmpkTpcRvJ2qLcJcD+meiz2a8lIlGkJ7yHIasop6Aclnbf88TuURCLM
         5GxsChFAXrA4MUbelnIAqH7Cd8MDggkVASPcuadqBcSrNkMw5i4FWXkP1wHEz3ab7b
         0EY90LJMswWNN5AniEIyN/i7fIJd0R3MhKfE0lBiZRH8kCYrXoukdpnNGTzplv2laz
         6jz/bNJL8A/jQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2EDE60A45;
        Tue, 16 Mar 2021 18:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] ionic Tx updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161591880892.7330.8694036031230320538.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 18:20:08 +0000
References: <20210316023136.22702-1-snelson@pensando.io>
In-Reply-To: <20210316023136.22702-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 15 Mar 2021 19:31:32 -0700 you wrote:
> Just as the Rx path recently got a face lift, it is time for the Tx path to
> get some attention.  The original TSO-to-descriptor mapping was ugly and
> convoluted and needed some deep work.  This series pulls the dma mapping
> out of the descriptor frag mapping loop and makes the dma mapping more
> generic for use in the non-TSO case.
> 
> Shannon Nelson (4):
>   ionic: simplify TSO descriptor mapping
>   ionic: generic tx skb mapping
>   ionic: simplify tx clean
>   ionic: aggregate Tx byte counting calls
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] ionic: simplify TSO descriptor mapping
    https://git.kernel.org/netdev/net-next/c/5b039241fe3a
  - [net-next,2/4] ionic: generic tx skb mapping
    https://git.kernel.org/netdev/net-next/c/2da479ca0814
  - [net-next,3/4] ionic: simplify tx clean
    https://git.kernel.org/netdev/net-next/c/19fef72cb4ba
  - [net-next,4/4] ionic: aggregate Tx byte counting calls
    https://git.kernel.org/netdev/net-next/c/633eddf120ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


