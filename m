Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6143AF810
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhFUVwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231625AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2CC3A61360;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312205;
        bh=QUhNGhTzHtQB/8upGm4Zp93Vz+9++5i93kcSk2wnrVs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CvBY9Wj/9TGAx5XLyDBCJBnO00aso5d4zyv9bUjwBZzXcU0O/PGv3/Y7HaI80gIsy
         u6lRZ813J9rn5W97FHLC8fVjpMZCR8RLEv92GDke27ogspZMP95OY7KGjibdkr36jX
         AYdGUTja36Pg3SOpriGJWzv5N89Bkrr/XCveaoSE8yJ8wVjczh0vXJ5A0QbBIayXy1
         /Hh6d1p26XNqihN0WNPoZbDjFVqoiYyN+SYSbl9uwspEJu/CUSClIpiAx60DIUYr5B
         oHO/dQ0d6/CWa32fLieIgsskY5Sv18K95ZH43hYcwnhQVIB+UBJGfw/B4sL7hr1BpR
         JvGpvilI6wgGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2434760A37;
        Mon, 21 Jun 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net/sched: cls_flower: Remove match on
 n_proto"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220514.17422.16259635300639529077.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:05 +0000
References: <20210621092429.10043-1-boris.sukholitko@broadcom.com>
In-Reply-To: <20210621092429.10043-1-boris.sukholitko@broadcom.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, davem@davemloft.net, kuba@kernel.org,
        olteanv@gmail.com, vadym.kochan@plvision.eu,
        ilya.lifshits@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 12:24:29 +0300 you wrote:
> This reverts commit 0dca2c7404a938cb10c85d0515cee40ed5348788.
> 
> The commit in question breaks hardware offload of flower filters.
> 
> Quoting Vladimir Oltean <olteanv@gmail.com>:
> 
>  fl_hw_replace_filter() and fl_reoffload() create a struct
>  flow_cls_offload with a rule->match.mask member derived from the mask
>  of the software classifier: &f->mask->key - that same mask that is used
>  for initializing the flow dissector keys, and the one from which Boris
>  removed the basic.n_proto member because it was bothering him.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net/sched: cls_flower: Remove match on n_proto"
    https://git.kernel.org/netdev/net-next/c/6d5516177d3b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


