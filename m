Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E9055D69B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244458AbiF1FKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244423AbiF1FKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDE0A19E;
        Mon, 27 Jun 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104D46179B;
        Tue, 28 Jun 2022 05:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58B6CC341CD;
        Tue, 28 Jun 2022 05:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656393013;
        bh=/IpUtgE84LF5Tp1Ba3s8+JPpbDXqgbqnLSAezRyQKUM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D2FBeBMhn+BfZHvP5t8Y5zCGQt+pTVohGje06x8lylXrFjm/IPp92BhOQJslUeBP1
         FcfyO7oCpA74Q5Ito6DsGE783Cm6l6N3xLkG2/yik3rB/R89RA/8Jcuv1FD30qQeue
         QdTNXVUPnlKsRcyt2QgRwkdG92ikoIjayWnRjYMX3fHPJ4sd0c2o+n2c2lRrKpNMdr
         3XaIP9+a9HhxX60konW1d2Vow9rTiuRGy1mv+byxm+5k+jEKP1Iu3zGY1heNLwrovE
         SM90Z4yD2WOKBGmu3uXi80SRN6fGoQx/0Uc4QKajrj2L7tsuOvybWAGlImeouy6aPl
         0u/fPFyyjlZkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DD3FE49FA1;
        Tue, 28 Jun 2022 05:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeon_ep: use bitwise AND
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639301324.30025.4937002197818933977.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:10:13 +0000
References: <20220626132947.3992423-1-sshedi@vmware.com>
In-Reply-To: <20220626132947.3992423-1-sshedi@vmware.com>
To:     Shreenidhi Shedi <yesshedi@gmail.com>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sshedi@vmware.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 26 Jun 2022 18:59:47 +0530 you wrote:
> From: Shreenidhi Shedi <sshedi@vmware.com>
> 
> This should be bitwise operator not logical.
> 
> Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
> Signed-off-by: Shreenidhi Shedi <sshedi@vmware.com>
> 
> [...]

Here is the summary with links:
  - octeon_ep: use bitwise AND
    https://git.kernel.org/netdev/net/c/4bbfed9112ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


