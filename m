Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A604742C8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 13:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhLNMkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 07:40:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55700 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhLNMkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 07:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A03B8196F
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 640B8C34618;
        Tue, 14 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639485610;
        bh=mgKdYDqn9wDxDSqn5Q0cxG6s1tx3f0RRHpeQ6ZOGLJM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IGcc/UMJ/hM6FQHy4MnetPMinQRHyfK/ZYSAmZxyGdcm11ex8p98GcuHvRgCZF6sV
         zAHGnPyq7AOvksjaCDOjoMtl4UVotxTFVPhb7irmp/5aXaE5RsXfkCGfz6sKLPlxeH
         yaHqV9SetkoA0Jfwu8Xf4XRH8/9dTSmalUmigAetrBjKFLqqTMdVpzu7HamwXsWc+i
         jod8YPq+m4/XBqouQ4bfdV5VtjY+3ZNjTaRhPp+QTfDmIumXUvgkt8vzSfM0t8e5RS
         kVVdOP9rDIEHw7BgP9u38tXAoS/A2GEBtS1u4HNuOsnrwBefTj8vioe5x2g0TjCs55
         Uoo51nYP8O26Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F3D160984;
        Tue, 14 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] flow_offload: return EOPNOTSUPP for the unsupported mpls
 action type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163948561032.12013.18199280015544778926.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 12:40:10 +0000
References: <20211213144604.23888-1-simon.horman@corigine.com>
In-Reply-To: <20211213144604.23888-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        oss-drivers@corigine.com, roid@nvidia.com,
        baowen.zheng@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 15:46:04 +0100 you wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> We need to return EOPNOTSUPP for the unsupported mpls action type when
> setup the flow action.
> 
> In the original implement, we will return 0 for the unsupported mpls
> action type, actually we do not setup it and the following actions
> to the flow action entry.
> 
> [...]

Here is the summary with links:
  - [net] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
    https://git.kernel.org/netdev/net/c/166b6a46b78b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


