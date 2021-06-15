Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA8F3A878C
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 19:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFORcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 13:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230500AbhFORcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 13:32:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 153D8613FA;
        Tue, 15 Jun 2021 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623778204;
        bh=jseQiNiEpm2fzQGMQmDOj+wBfL9kqUelrgzLjqqDpsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ab/mTDAeALxmPKJZ6DiKFW/ZKhSQ6KaNeSbDcRfO/klz7faFxY1k/nprc23fVVMFo
         I/6H05wtimO/vFOaUIllECZTuK59iyeYiFWn6DX14Gi2xmRKIhRjKtB5ETitEEX9/e
         De8IWW2gV6+TI3PMXNVHR++oz1w5jxMzHv0asPmnNW20MTKL7/PzOP/wB1L2OygePA
         gSuGsDo5fRYNVFo6owh0zVmgkq6j4yBbbEi1dlNhgY7v4Z+WcN2nmFCTOXoLQRnmZQ
         4I9OLx9IXyhwrJjMo15tHS3noo4Cwswr0KmIQwtutJkq9Hc3xeCeD7kiOZekmJlbr9
         kXfPYCFZi/pgA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 04FD760A54;
        Tue, 15 Jun 2021 17:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: cls_flower: Remove match on n_proto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162377820401.32202.9735492010197517007.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Jun 2021 17:30:04 +0000
References: <20210614111322.26914-1-boris.sukholitko@broadcom.com>
In-Reply-To: <20210614111322.26914-1-boris.sukholitko@broadcom.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ilya.lifshits@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 14:13:22 +0300 you wrote:
> The following flower filters fail to match packets:
> 
> tc filter add dev eth0 ingress protocol 0x8864 flower \
> 	action simple sdata hi64
> tc filter add dev eth0 ingress protocol 802.1q flower \
> 	vlan_ethtype 0x8864 action simple sdata "hi vlan"
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: cls_flower: Remove match on n_proto
    https://git.kernel.org/netdev/net-next/c/0dca2c7404a9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


