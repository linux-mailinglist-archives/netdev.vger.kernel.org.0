Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEED4FF5B9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiDMLch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiDMLcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EE427B30;
        Wed, 13 Apr 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34A0B61DBF;
        Wed, 13 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83276C385AB;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849412;
        bh=IPP2s41zsMxw53oivmfRNFS5UURzk5PQzUEv8C9Jgxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jOE6EDKt+5lxNZse2PKhrHOaPJjn1v0eGUZIW9B3uTHbVRUC/PoNZFfjIEsfzqkwD
         gkhx4VE1D3Lc+3Z7dd3OZqU+8FCnzXTwzgLNNsj4iR+xC6kWdoe2/vstNtlLeV3VMB
         DjwO5z52+Afvj7I8dvoK2hrbd1gTy0mA4jOXzEsiQpTWQvQ4pLIkZYjHndkgW/zF2R
         0GU5uCaO9dMy+8TfwYQT/awulF6Cw5hJPD+6FWVnuoKrkY/Yo6lPijfiZWevJ49Yuq
         ytFFr0CVT7DSHfuo4rInjKi5u2d6fJ4em+Um4uHhvToGXEV3tt00KtQ4MUtSwjnJi7
         fODEIksE/WbXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C6E6E8DD5E;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw-nuss: using
 pm_runtime_resume_and_get instead of pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941244.14313.3025406291776787942.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:12 +0000
References: <20220412090515.2533397-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220412090515.2533397-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 09:05:15 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: am65-cpsw-nuss: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/2240514cb644

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


