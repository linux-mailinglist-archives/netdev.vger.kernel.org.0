Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D16C4663AF
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346926AbhLBMdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346625AbhLBMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:33:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66F3C061758
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 33EBFCE22B8
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5EE90C56747;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638448210;
        bh=jN02qi5jCVBpaq74LJdcaZVzuMfcBty45IWGvZA6D1o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q00iG+d32v6hvJXOP+jyYFTNGFm6ZjAA73nTj2+yRw3CMEhIhJbBA1b3y2yFDGL5D
         c0+ZzMaji3058JNih+OktS2qhqqh9qiWioAo87WK0RNoBNMSgUZeb4e8TvKrUcIgt6
         g4AEgGpOtN8yg9+bqCj0h/Q3Am7Y52A19AUDq6MzpEKShPyAUm4usS9ReixsFamCTT
         IwqV+84oI7TToFlbG78u9btPu5yjfJjOaAHmLlJSny6Fj07VmLMmoYMHmm+3+ArgkC
         8+zOYkUbFARQe/cJQsfEIpbYtAST87UjabllLsJ49RJCY/EfzbAD5/hhroQTqTtfQg
         8a71DraUhMH9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DD2360A88;
        Thu,  2 Dec 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][v2] qed: Enhance rammod debug prints to provide pretty
 details
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844821031.14016.14983197105837272875.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:30:10 +0000
References: <20211202104156.17380-1-palok@marvell.com>
In-Reply-To: <20211202104156.17380-1-palok@marvell.com>
To:     Alok Prasad <palok@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, pkushwaha@marvell.com, prabhakar.pkin@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Dec 2021 10:41:56 +0000 you wrote:
> From: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> Instead of printing numbers of protocol IDs and rammod commands,
> enhance debug prints to provide names. s_protocol_types[] and
> s_ramrod_cmd_ids arrays[] are added to support along with APIs.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Alok Prasad <palok@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2] qed: Enhance rammod debug prints to provide pretty details
    https://git.kernel.org/netdev/net-next/c/7e9979e36007

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


