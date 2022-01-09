Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74BCA488CCB
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbiAIWKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiAIWKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD955C06173F;
        Sun,  9 Jan 2022 14:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97CCBB80E3D;
        Sun,  9 Jan 2022 22:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 619E5C36AED;
        Sun,  9 Jan 2022 22:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766210;
        bh=Ll8fgeDk3rE14AO0bU+MYiEneC6+sCsFeN6O7Yjhshg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=icdpJ3NTIQQptPY84VRbBhmGDq/loY40WoDaCs9gKey7c4wbNMVqa5qeLSFSCBDda
         8FBNGN32uLvZ3Eucz1VN+fiCNAOcSmgO8SGFWjyxCRP0Z++JernylWiSyhhnzEBjoV
         N1bSgEO9rab+aG8/baxlbbAIx3IMlitD10dR94Yg201ZLfiXXzKV0JXH2Ad9TpuQYy
         GGk/chw26uvZOpVJJtUsOBwfy9oicdulcfqtLnutveb7SqszosEl15IZeGM/0Q6ZEV
         8I/6/owVoPUASc9VdMkLm6ACvgFPYea5Zvtwt+xGDn+96U50dIOYuoaGBg1toSD/14
         zOPooN31wJCPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AD66F7940F;
        Sun,  9 Jan 2022 22:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] softingcs: Fix memleak on registration failure in
 softingcs_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164176621030.2545.5778062029291474217.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Jan 2022 22:10:10 +0000
References: <20220108092555.17648-1-linmq006@gmail.com>
In-Reply-To: <20220108092555.17648-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, dev.kurt@vandijck-laurijssen.be,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Sat,  8 Jan 2022 09:25:51 +0000 you wrote:
> In case device registration fails during module initialisation, the
> platform device structure needs to be freed using platform_device_put()
> to properly free all resources (e.g. the device name).
> 
> Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - softingcs: Fix memleak on registration failure in softingcs_probe
    https://git.kernel.org/netdev/net/c/ced4913efb0a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


