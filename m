Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F2F67F670
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbjA1Ikv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjA1Ikp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5FF8CC6A;
        Sat, 28 Jan 2023 00:40:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D78E60B50;
        Sat, 28 Jan 2023 08:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 920C0C433D2;
        Sat, 28 Jan 2023 08:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895231;
        bh=Nnrg0ei3dz5l7Jv8NloYF17hEFNA2j8FwDexmQNL1f4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nrKXMy9BFao62WD7KxKuleB2lizJaT2y16kjunUPy1nCFfm7BSBUvpdEvbD3Zxc9e
         esCCZK0STjWBxuL2ALuG2Tt9/8eBIQrew879F5e9ZlTEtitcjyGq1h0zYqyV5iyasf
         bNSuV/ex4MhGWaQqSSI3YX1Mp17cxUBigcU4YnggprrP0zq9OIvCsg0U+a2K7iBEzU
         4wxhUC4El2/yRcHycDsfoOusUe/5QjGu4tCimUc6vY6VY8L1IBRADuPFFQtUP8JmVZ
         u5+wVq7zrKRZ7HVM8mm+dGODaLmavzMq/VUh84OGUzAG4/SP3Rz8ImSDVfgkqVFnuh
         Pe+fSf4NDpmbw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E161F83ECD;
        Sat, 28 Jan 2023 08:40:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489523150.20245.11133734779189043314.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:31 +0000
References: <20230125185230.3574681-1-leitao@debian.org>
In-Reply-To: <20230125185230.3574681-1-leitao@debian.org>
To:     Breno Leitao <leitao@debian.org>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, leit@fb.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, linux-kernel@vger.kernel.org, rmikey@meta.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 10:52:30 -0800 you wrote:
> This patch removes the msleep(4s) during netpoll_setup() if the carrier
> appears instantly.
> 
> Here are some scenarios where this workaround is counter-productive in
> modern ages:
> 
> Servers which have BMC communicating over NC-SI via the same NIC as gets
> used for netconsole. BMC will keep the PHY up, hence the carrier
> appearing instantly.
> 
> [...]

Here is the summary with links:
  - [v3] netpoll: Remove 4s sleep during carrier detection
    https://git.kernel.org/netdev/net-next/c/d8afe2f8a92d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


