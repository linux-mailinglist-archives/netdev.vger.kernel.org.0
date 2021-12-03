Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465124676B9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380535AbhLCLxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:53:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhLCLxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:53:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77879B825B7;
        Fri,  3 Dec 2021 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CBB9C53FCB;
        Fri,  3 Dec 2021 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638532210;
        bh=nz1rdy8mTg+6h44HhRn77M8064IfHx4IJ0EH7ACo3zc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D3Aa0f5NDP/obRqGxWrChpkcOw3pT7MyCABvZqWfjMqvshretW5FJb/QJzZ5NCZ01
         bOEDUtdF9z2niz6nsInvEkugtByfLU+A37avqx2XYU3oGW/CSU4sByX4XTFHx4TIui
         3oveAAYTJEQDAVBfes3MM03uF5p4h/0FS0FXr4bNzMDNmY70vnIoPfsPUlHnnwsxLr
         y0VNjCZ27rG8YM31pzMau/vV+GoVUdrMvteewjvQEnMQ4svRPDoF37L/o1yQfjXVXF
         8C/4zR8UDOTtA7/CRwzBYvCmSJXtm30t/jbb4gbdPilNuUzdAACGJIq96fR4NyRx1x
         HNalByG6p9mMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E8D0E60A5A;
        Fri,  3 Dec 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 1/3] selftests/tc-testing: add exit code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163853220994.27545.12950451952422618579.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 11:50:09 +0000
References: <20211203025323.6052-1-zhijianx.li@intel.com>
In-Reply-To: <20211203025323.6052-1-zhijianx.li@intel.com>
To:     Li Zhijian <zhijianx.li@intel.com>
Cc:     kuba@kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizhijian@cn.fujitsu.com, philip.li@intel.com, lkp@intel.com,
        dcaratti@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Dec 2021 10:53:21 +0800 you wrote:
> Mark the summary result as FAIL to prevent from confusing the selftest
> framework if some of them are failed.
> 
> Previously, the selftest framework always treats it as *ok* even though
> some of them are failed actually. That's because the script tdc.sh always
> return 0.
> 
> [...]

Here is the summary with links:
  - [v3,1/3] selftests/tc-testing: add exit code
    https://git.kernel.org/netdev/net/c/96f389678015
  - [v3,2/3] selftests/tc-testing: add missing config
    https://git.kernel.org/netdev/net/c/a8c9505c53c5
  - [v3,3/3] selftests/tc-testing: Fix cannot create /sys/bus/netdevsim/new_device: Directory nonexistent
    https://git.kernel.org/netdev/net/c/db925bca33a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


