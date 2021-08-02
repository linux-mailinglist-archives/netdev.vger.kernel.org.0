Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9501B3DD451
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233243AbhHBKuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:50:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhHBKuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 06:50:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5E7EB60F9F;
        Mon,  2 Aug 2021 10:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627901405;
        bh=qMpIlCb76so5E2aR131CSIQc7+/eDrKdcM7fOCsG/38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HxPp5q7EXHeFJqw/nclGXiQ17++qbES7FcFhzrdRT8V1xNTx8og+b02hqpNsv2Tli
         qexor95KnZGR+PmSB55/lWXDqlQpuEpmkTv9n2mTPk/1t144u6LfE9MbgxT1AAywxN
         clrU8d2jw1HoR0lkab0tNVcI2TjpWYZte0VQG3C9Y2q3tG2voRubMdSCcDIygr/hFU
         xGmfdxTzmTUOUN8S/TxdNm8MF/BuMAp9LacxCCj9wrm4QXG/H+AARhGIqvSBegRnWW
         2q3KZJpxCN8gkdOfaeXh45rLgKRHQPvIa8xuz411I3vo4ybdYO4phsNLnbz9m4HKZY
         BkW66UDIQCqsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 51EA060A2F;
        Mon,  2 Aug 2021 10:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: taprio: Fix init procedure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162790140532.10250.7097847427032850126.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 10:50:05 +0000
References: <20210730165321.1179952-1-yannick.vignon@oss.nxp.com>
In-Reply-To: <20210730165321.1179952-1-yannick.vignon@oss.nxp.com>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     sebastien.laveze@oss.npx.com, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, olteanv@gmail.com,
        xiaoliang.yang_1@nxp.com, yannick.vignon@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Jul 2021 18:53:21 +0200 you wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> Commit 13511704f8d759 ("net: taprio offload: enforce qdisc to netdev queue mapping")
> resulted in duplicate entries in the qdisc hash.
> While this did not impact the overall operation of the qdisc and taprio
> code paths, it did result in an infinite loop when dumping the qdisc
> properties, at least on one target (NXP LS1028 ARDB).
> Removing the duplicate call to qdisc_hash_add() solves the problem.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: taprio: Fix init procedure
    https://git.kernel.org/netdev/net/c/ebca25ead071

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


