Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4E63B2175
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhFWUCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFWUCX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:02:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3637B61166;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624478405;
        bh=rVbncDEFVGhe2mhI+dvtaGzIBf9X+RlcWMI4IIPNTmM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ilApgzuua5PS9mPhx4yu8VhsaKTlWhQnrKrD4kgwyndZkJiNNecs4fSRxuVp/JfuW
         ZXRoIi6kzHI8aycfoT/j82XtmOn//5bdBtQPBg5l7TJ74SA9d6/ho6RA4yB2yHq7Ce
         smsS7+TY3FXbTTDBChssbarq5igLmDteocxw8K5+MAhwoJxUD4eniCxTgn96502Ig7
         6OgOqiRT2w20ld78lkoz80oHyTH6Ifh1m+y8GWQnVH0+041IY+kPp1p7FLHQE7x+BW
         25SOebHMzXDp4/KztYQijjl4EeNCH++ZQqFCsVUATgKq6k8j1FKd4u/AEuMmVcWqbM
         9r3NLVIHnBxEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 244606094F;
        Wed, 23 Jun 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1] ibmveth: Set CHECKSUM_PARTIAL if NULL TCP CSUM.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162447840514.26653.14841241495197479979.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Jun 2021 20:00:05 +0000
References: <20210622215215.1947909-1-dwilder@us.ibm.com>
In-Reply-To: <20210622215215.1947909-1-dwilder@us.ibm.com>
To:     David Wilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, cforno12@linux.ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 14:52:15 -0700 you wrote:
> TCP checksums on received packets may be set to NULL by the sender if CSO
> is enabled. The hypervisor flags these packets as check-sum-ok and the
> skb is then flagged CHECKSUM_UNNECESSARY. If these packets are then
> forwarded the sender will not request CSO due to the CHECKSUM_UNNECESSARY
> flag. The result is a TCP packet sent with a bad checksum. This change
> sets up CHECKSUM_PARTIAL on these packets causing the sender to correctly
> request CSUM offload.
> 
> [...]

Here is the summary with links:
  - [v1] ibmveth: Set CHECKSUM_PARTIAL if NULL TCP CSUM.
    https://git.kernel.org/netdev/net-next/c/7525de2516fb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


