Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA94403802
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 12:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345766AbhIHKlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 06:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231684AbhIHKlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 06:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 015876115C;
        Wed,  8 Sep 2021 10:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631097608;
        bh=564Ht9LJCzcbN9wwxGFH9ijahu1AC7c19LHPIH4xJFw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQEo2dpkzW2pu+gF2WGXgWL2vmtthX7o4f4EFmnzh82H1R3ByRASqco+Eb/r2Yput
         udzYmoDfqQKCJ0vy5QYnBKuDtife6Pvu5e/BAmlnqxeI9Qvdn7ljNzcPRD2V+7y8FX
         NdhNNCuSR5T9Y//RlJ69/qCO2K4jYqMTtaY7+MBpuGY7KxYL3Fe99Fgaqmto/ptEv6
         cgFItXUeICsC6iu/e2ypycw+aYNqV87fKeoqQPIfiDeO751QZh/YiHPwTbjLmb7i31
         TGzAaDsv4XdjHysFBIW1AzoO8EWKUrwt1HMITA82QmU25C/tcsO2t8KV8NaFwrR9sL
         tMOtW/B1mDwQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB23560A6D;
        Wed,  8 Sep 2021 10:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ibmvnic: check failover_pending in login response
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163109760795.16056.13085828854467812065.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Sep 2021 10:40:07 +0000
References: <20210908050703.141363-1-sukadev@linux.ibm.com>
In-Reply-To: <20210908050703.141363-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, brking@linux.ibm.com, drt@linux.ibm.com,
        ricklind@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 22:07:03 -0700 you wrote:
> If a failover occurs before a login response is received, the login
> response buffer maybe undefined. Check that there was no failover
> before accessing the login response buffer.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v2,net] ibmvnic: check failover_pending in login response
    https://git.kernel.org/netdev/net/c/d437f5aa23aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


