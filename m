Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A28E33F8A3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhCQTAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232875AbhCQTAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9E71464F57;
        Wed, 17 Mar 2021 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616007608;
        bh=6+7f23ZhslJFmsAdx9Rx5vXOPB9zuyWpTXp5X6eZUMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DT1GNVY+L/gf069dRZ5kTck8MyOTO+dF8KbfcONySqiTrvrwSbBXr+4wQOlkHRCXt
         q/bXD38OLj3Ii8puPTHt5suy0iyO4gEJ9GhLUWqElR9wyT3KHJlOsbToYO0flIMABL
         qGt5rT39w9MK0N+wzrDRFJ0uqZnw5b1bafGjixTWWiLTC9S1qW2e8DGWfBZiRsTxh+
         tUe0Di6knanismjtpJuo8GHRLKGgGlwoQy0sgcsnnjLTBQ15o97JZP+1j2dsxjYJwM
         OG3C41Xm3MNBpzX7u3WTm76hRo3GQzGrKzVW5KU2Onh4QhGqcqC1XG3JMnDXI3o2hJ
         +U23EXM4Mcmag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 943F760A60;
        Wed, 17 Mar 2021 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: cls_flower: fix only mask bit check in the
 validate_ct_state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600760860.6499.10040446965116978579.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:00:08 +0000
References: <1615953763-23824-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1615953763-23824-1-git-send-email-wenxu@ucloud.cn>
To:     wenxu <wenxu@ucloud.cn>
Cc:     kuba@kernel.org, mleitner@redhat.com, netdev@vger.kernel.org,
        jhs@mojatatu.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 17 Mar 2021 12:02:43 +0800 you wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The ct_state validate should not only check the mask bit and also
> check mask_bit & key_bit..
> For the +new+est case example, The 'new' and 'est' bits should be
> set in both state_mask and state flags. Or the -new-est case also
> will be reject by kernel.
> When Openvswitch with two flows
> ct_state=+trk+new,action=commit,forward
> ct_state=+trk+est,action=forward
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: cls_flower: fix only mask bit check in the validate_ct_state
    https://git.kernel.org/netdev/net/c/afa536d8405a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


