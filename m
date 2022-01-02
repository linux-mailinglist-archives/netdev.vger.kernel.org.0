Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02924482B08
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiABMUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58628 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiABMUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8847060E8C;
        Sun,  2 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6EACC36AE7;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126011;
        bh=iipEGM2LvMNVEYvZMUkSwySFPYbb1N7Gu+B7pvNv4xE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aw+VjzzuCyhcy6hXIPqqJRTJN0d/BViFGt8Fn+NELZNfF0wFKK2mqx3pLcsAfTbNo
         ueliEytz/lPKIsJqA7w8zPsofBPbeE7fsJgZDBO8RS6aUyTuQ9hPnvBrm9yU3Mpact
         Iu/F/Fr6tkQj22olaUipyu/f2G7NOYA8YxHH+UQCXkkQxTjld2OfFZrvE5xBmn54Np
         SOkWJFLXn8Zgg52PBYvqI+0zzhOpCK74vfTED7OpVgPzui4CyTUeWttayI6MSNa9gT
         QVIuhwJBhvCuw77DWrK2SeXqpYxjOO/MS1mXqTE25wkrOTTW7aVGKE0IrhO5mpgEHM
         Zq1C5X8fOU7pQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFA74C32795;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] RDMA device net namespace support for SMC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112601084.23508.8833600236047838107.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:20:10 +0000
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211228130611.19124-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 21:06:08 +0800 you wrote:
> This patch set introduces net namespace support for linkgroups.
> 
> Path 1 is the main approach to implement net ns support.
> 
> Path 2 - 4 are the additional modifications to let us know the netns.
> Also, I will submit changes of smc-tools to github later.
> 
> [...]

Here is the summary with links:
  - [1/4] net/smc: Introduce net namespace support for linkgroup
    https://git.kernel.org/netdev/net-next/c/0237a3a683e4
  - [2/4] net/smc: Add netlink net namespace support
    https://git.kernel.org/netdev/net-next/c/79d39fc503b4
  - [3/4] net/smc: Print net namespace in log
    https://git.kernel.org/netdev/net-next/c/de2fea7b39bf
  - [4/4] net/smc: Add net namespace for tracepoints
    https://git.kernel.org/netdev/net-next/c/a838f5084828

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


