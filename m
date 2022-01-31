Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6404A44A9
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359305AbiAaLb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379419AbiAaLaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:30:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F38BC06173D;
        Mon, 31 Jan 2022 03:20:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF07CB82A60;
        Mon, 31 Jan 2022 11:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E7D9C340F3;
        Mon, 31 Jan 2022 11:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643628035;
        bh=slJQhhIF1yugtff6Mq8MOTUVyIvIlTYUiNSbLsEt32c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U5H/J6gyB5De+L98jmh8CMbi4gVmNLyY6i8vVCCYLCg1qj7/PLvmwWcgzifLq9dL7
         Vl7dLQ0s1XLeqKWB1iEzmKD+Qe6khLUqUN7CXnHbDBYbDL6Vk8+uS9CrHSI9/m6heV
         QM5prsznIE+qjTazj7+CXQSahpc7WEsWWAfNvTyO3lzmvf/W45k13EP0G5OOtmvG3r
         ao3cNTjD0RMNU8gFP3cfuAaD0FY+YyBYyzciSHEGk0394CmHVwBEZU3Ebhc27RkXGn
         OJ+yepN90m89vMgDjBUrHYPqx6TmZ4uwQVje/qsooStS4xg1WcfVQESCy47GszvZIm
         HzJReDVFmAZkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 89005E6BAC6;
        Mon, 31 Jan 2022 11:20:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Forward wakeup to smc socket waitqueue after
 fallback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362803555.29436.10145818429007332261.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:20:35 +0000
References: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 23:33:04 +0800 you wrote:
> When we replace TCP with SMC and a fallback occurs, there may be
> some socket waitqueue entries remaining in smc socket->wq, such
> as eppoll_entries inserted by userspace applications.
> 
> After the fallback, data flows over TCP/IP and only clcsocket->wq
> will be woken up. Applications can't be notified by the entries
> which were inserted in smc socket->wq before fallback. So we need
> a mechanism to wake up smc socket->wq at the same time if some
> entries remaining in it.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: Forward wakeup to smc socket waitqueue after fallback
    https://git.kernel.org/netdev/net/c/341adeec9ada

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


