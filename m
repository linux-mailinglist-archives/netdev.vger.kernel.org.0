Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8AD47E752
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 19:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349615AbhLWSAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 13:00:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39016 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349602AbhLWSAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 13:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D05EB82146
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 18:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C2BBC36AEB;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640282410;
        bh=/UAdiwVZBplVcykrNMoB9nqfM4pjlvLxPf/vfOm/onY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LBXpKnZjxpHD941aGG8WkG2BHmAKbMA0h+VMMcFhEaofLYs+37hXcGrs/gFKrBgVt
         vtF5ppyHSg7IXBRoeCG9ZEck08VVRjtEhiwU752yoXDsUbOuxfDwH74WmQYLk/UzgY
         izXXxjqrSPLfF3sWiS++hbvGKSEEx95hNBnMXFc9YtjAwTuxWAdC9V6EivRDZylGFo
         Fzp5vTvPg3Wx+oefVlhZVN3gONe/pMr7UGV6fkvvKUHj4fajnHIbrXsGNCV5NzMRKV
         T3L07OKPnrdwwZV3UqYie3XdVMrPQPF0RYEAXQ0BjfMCRaezc4bZn+FVbOfJ5G5nOe
         1fgzDXBgOB7UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11FA1EAC06C;
        Thu, 23 Dec 2021 18:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] veth: ensure skb entering GRO are not cloned.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164028241006.22568.8492617980266258015.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 18:00:10 +0000
References: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
In-Reply-To: <b5f61c5602aab01bac8d711d8d1bfab0a4817db7.1640197544.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, ignat@cloudflare.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Dec 2021 19:39:52 +0100 you wrote:
> After commit d3256efd8e8b ("veth: allow enabling NAPI even without XDP"),
> if GRO is enabled on a veth device and TSO is disabled on the peer
> device, TCP skbs will go through the NAPI callback. If there is no XDP
> program attached, the veth code does not perform any share check, and
> shared/cloned skbs could enter the GRO engine.
> 
> Ignat reported a BUG triggered later-on due to the above condition:
> 
> [...]

Here is the summary with links:
  - [v2,net] veth: ensure skb entering GRO are not cloned.
    https://git.kernel.org/netdev/net/c/9695b7de5b47

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


