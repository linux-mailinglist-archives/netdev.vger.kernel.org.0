Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4933FC19E
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 05:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhHaDlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 23:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239581AbhHaDlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 23:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 827986102A;
        Tue, 31 Aug 2021 03:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630381205;
        bh=kWPBeTEdTMu5YmcG0XC1GTCA4958z2Qgfg1w+SQLIvE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gskUGt04atwqYCiBVovR+LsfShgPktclLn9i8CAX6ESuB0uuCOoIMhgSCxsa4b71w
         7F50HEbQGNXRvIxEeZkikkNSwVQdOaFJG637o8glKDsgxEDPkSxDQ29xyF4VHmd9rb
         D72sadS8lA0LIMTU8tVaEg02Doaf6XBA/1fqBwa87YEyeV9A5ji0gpxppYPuMkBh1B
         2JL4KweTLbyHEksUWSbrAEZLQ60ohfHT9HXxG7cg0+qNs3QDQ2NKl49lvehzaTWK46
         SOrf/yczYyRcMDKAaowGsV8PksFOnPM1TbGzBCMO0glrw5wVtYiLvQqq3zv/v/RLZE
         7f+FE4aP+c0sw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7645A60A6F;
        Tue, 31 Aug 2021 03:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: Fix qdisc_rate_table refcount leak when get
 tcf_block failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163038120547.6773.16268744474325460002.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 03:40:05 +0000
References: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn>
In-Reply-To: <1630252681-71588-1-git-send-email-xiyuyang19@fudan.edu.cn>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 29 Aug 2021 23:58:01 +0800 you wrote:
> The reference counting issue happens in one exception handling path of
> cbq_change_class(). When failing to get tcf_block, the function forgets
> to decrease the refcount of "rtab" increased by qdisc_put_rtab(),
> causing a refcount leak.
> 
> Fix this issue by jumping to "failure" label when get tcf_block failed.
> 
> [...]

Here is the summary with links:
  - net: sched: Fix qdisc_rate_table refcount leak when get tcf_block failed
    https://git.kernel.org/netdev/net-next/c/c66070125837

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


