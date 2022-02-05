Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825324AA9CE
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 17:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352957AbiBEQAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 11:00:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiBEQAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 11:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3485B80818
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 16:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58835C340F0;
        Sat,  5 Feb 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644076809;
        bh=oKFo0CaOLBoohESc+43drpjSF7nvbn/6O1B9WiPoutc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dgr6/RKTYnL63Fp72hwGh8/AVrJzi4H84cseSifhkG4chDTfP+8yMozKbyDRLUswp
         aSqw/sTvaEL3xG5XlCz7RPL4IdXXOdCprYWad/XwEgPn5fiw8Etc2U8VOoaELkwGF8
         lf5MwpqcXp36Yqn+wKXWw2oHSkVaWlbMwJjYK72bVtKioJxiBP8TuSGgnlfzQ0ll78
         J8icjVjPSu3YT8yWfvQq5mTC5iLw947ZwsJPeT9z/HLoEIC4bIdY9/DdyrYUscnDJi
         LtA5wS2vx6Ni6pVSt5MQsynNA16ONJWcHGsDxgEuDP5nXMxfkLPGblEaxLnkLJ/SJK
         OhIH2+Fc4s74g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 413E6E6D3DD;
        Sat,  5 Feb 2022 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] skmsg: convert struct sk_msg_sg::copy to a bitmap
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164407680926.4093.15356635864658025431.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Feb 2022 16:00:09 +0000
References: <20220205045614.3457092-1-eric.dumazet@gmail.com>
In-Reply-To: <20220205045614.3457092-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Feb 2022 20:56:14 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We have plans for increasing MAX_SKB_FRAGS, but sk_msg_sg::copy
> is currently an unsigned long, limiting MAX_SKB_FRAGS to 30 on 32bit arches.
> 
> Convert it to a bitmap, as Jakub suggested.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] skmsg: convert struct sk_msg_sg::copy to a bitmap
    https://git.kernel.org/netdev/net-next/c/5a8fb33e5305

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


