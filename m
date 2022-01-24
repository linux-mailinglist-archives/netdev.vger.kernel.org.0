Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE4E497E8C
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbiAXMKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:10:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34772 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238272AbiAXMKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36A32B80F9C
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB8C4C340ED;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643026211;
        bh=vDjZ3qdx7XMeAqDabNLP8VXd6qhwH5DOlPExzXJFPg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rb5Cw5bJAIPxRa9Gi8BCiPadvqRalFZo9+LxK1LMGWcvSPXdFJ0JMdKjP1a71QEWV
         F09RuaHUOqRKugs2XTHDtg55S5CcrKLLod+fbOicPhALqg96ouWM3MsqeRzMx7tZSb
         QKk+Ll3ZHNYo27hJUptMzHgLhiX12KCLBZnewVvkqX4QsuZv/bPGbCJEppIN+fbjm9
         RP5kAIWreZDh4xCPKK8yhHmSJncoOLTgNfS1O+RoBMsteAPM6ILoz6IvGJBdJUW2ec
         WbUm/Cn7x7bZ/HXEw6+goanfU6Bszpjj07Z0csNm3+j8br7bFdsXFH9xG/KKPpGps/
         NzDs7b735nxxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE0B6C6D4E4;
        Mon, 24 Jan 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: fix ip option filtering for locally generated
 fragments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302621083.19022.13176797373164334866.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:10:10 +0000
References: <20220122005731.2115923-1-kuba@kernel.org>
In-Reply-To: <20220122005731.2115923-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        pablo@netfilter.org, netdev@vger.kernel.org, ooppublic@163.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Jan 2022 16:57:31 -0800 you wrote:
> During IP fragmentation we sanitize IP options. This means overwriting
> options which should not be copied with NOPs. Only the first fragment
> has the original, full options.
> 
> ip_fraglist_prepare() copies the IP header and options from previous
> fragment to the next one. Commit 19c3401a917b ("net: ipv4: place control
> buffer handling away from fragmentation iterators") moved sanitizing
> options before ip_fraglist_prepare() which means options are sanitized
> and then overwritten again with the old values.
> 
> [...]

Here is the summary with links:
  - [net] ipv4: fix ip option filtering for locally generated fragments
    https://git.kernel.org/netdev/net/c/27a8caa59bab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


