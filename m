Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC08F4F6683
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238292AbiDFQ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbiDFQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:56:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62463468CA
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 07:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 623BEB82426
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 14:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27F04C385A1;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649254813;
        bh=u7LHtAPMN998U5TtMI4Q4+dcEMZfeHC/425F5i01uXE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pjRzLCfBr9jCEtRHEHueus1GbRTlWOdjyj6/0U5TwGkZrdlhW5F19lQxmFbFBpOF7
         jJDJUZPSLN1CRX8FPJXsm9FN9oVlJHbYfNHZLzkD9YG8JTZjDQY99ViT6ZLj4Pgwg8
         0nDh1nkKJMnpEii4EJClZtQvgOpY/kZORqM5ny5eqAyzvsjp0r76dwwpQqMiMDsD2F
         5MBJjMxca5l1H6z2oi1Dxf6CxRWcGZCUpeXFgHYzHrUrGvhyIojsbBrbRTiSAiZj2m
         +lkpinnvM/4eU8ybZvqiFPGUKur8bBpMySR9SF6oCZbYKqFmDWx8SPq0Y/ZcxtZp3Q
         ItsYMSXbVEW4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00ED9E4A6CB;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipv6mr: fix unused variable warning with
 CONFIG_IPV6_PIMSM_V2=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925481300.16469.13664217837970948827.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:20:13 +0000
References: <20220406100445.23847-1-fw@strlen.de>
In-Reply-To: <20220406100445.23847-1-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 12:04:45 +0200 you wrote:
> net/ipv6/ip6mr.c:1656:14: warning: unused variable 'do_wrmifwhole'
> 
> Move it to the CONFIG_IPV6_PIMSM_V2 scope where its used.
> 
> Fixes: 4b340a5a726d ("net: ip6mr: add support for passing full packet on wrong mif")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net] net: ipv6mr: fix unused variable warning with CONFIG_IPV6_PIMSM_V2=n
    https://git.kernel.org/netdev/net/c/a3ebe92a0f2d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


