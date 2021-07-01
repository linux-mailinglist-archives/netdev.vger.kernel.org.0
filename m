Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F733B9722
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhGAUWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:22:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233308AbhGAUWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 16:22:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 66F166141A;
        Thu,  1 Jul 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625170806;
        bh=uLBrEB3WYlCY6kVDTcI3QKa9q2JbdFEDWY/GYeIY4no=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=asdCrjDnHIvLlLtlSY+GzKjHSEifB+XotNF0UE35MGbFfGZ3atq4IKTarzZAa0hM5
         grPHn4yIkbUPU4EF+vFX5jaKnxKbCz8wn/rtHQl9uvFgRhL8zIWyY+KVD6J4MuZ5hQ
         sjG2vC2FVcyHouRu6yEANLDfRJyL6uevxP/+3qGhqIM8tDrH8dShJZU6aKTAl+fOAX
         3UV0p636Y4bv7hPaiQu6neGlCMJqa2Lg7rSZH32Q8VJrPq0pZPE8p2MCidVE6wBDvs
         +GHoiw5lobu9ynRWSXg3PZ2GUpiy+QWiF5inhSMraKAnpUweJx88X7C9bRs8BrHC9L
         YR7rqWfR/yiHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5905760CD0;
        Thu,  1 Jul 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] ibmvnic: retry reset if there are no other resets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162517080636.9938.2548233825825133465.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 20:20:06 +0000
References: <20210630183617.3093690-1-sukadev@linux.ibm.com>
In-Reply-To: <20210630183617.3093690-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com,
        brking@linux.vnet.ibm.com, ricklind@linux.vnet.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 30 Jun 2021 14:36:17 -0400 you wrote:
> Normally, if a reset fails due to failover or other communication error
> there is another reset (eg: FAILOVER) in the queue and we would process
> that reset. But if we are unable to communicate with PHYP or VIOS after
> H_FREE_CRQ, there would be no other resets in the queue and the adapter
> would be in an undefined state even though it was in the OPEN state
> earlier. While starting the reset we set the carrier to off state so
> we won't even get the timeout resets.
> 
> [...]

Here is the summary with links:
  - [1/1] ibmvnic: retry reset if there are no other resets
    https://git.kernel.org/netdev/net/c/4f408e1fa6e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


