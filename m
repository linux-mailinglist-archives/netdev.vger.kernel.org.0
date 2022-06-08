Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC77543AFB
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiFHSAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiFHSAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743011B7592
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DEC261BAC
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66CCEC341C8;
        Wed,  8 Jun 2022 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654711215;
        bh=+sWEH1DCa7cWuTA35KgeGCaFhAZkibYf7E1yV8HPKtg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QM0rTdkTnMmWlYnXikjpb8h+x64YvjorZZPBqh/iGId1IPzrsBRRcOXlbuCm015UJ
         eSoI18S1GkFEgV2HotqSLPiKnfeJU665qOGXeuqufS6McG2KDz24JjeCCIpQFqqXFd
         KU8sEvbsEkz9ZFBSAe5Hm0dfGGzQBgReYA2G3pxxnN4TARSFTqWXsH2isCP4tGoYT5
         BhDikvW3cMO+XA2yAegu76/Fa4dudoDKmGGlrosQ1Dnq72VnMdM6OcmZsnF0eGU3gL
         HU1Spp4vmoLVFJjB857wmKCrihw0JKV3Wu10vpX18snlbGHsxIGiNawdrtRWSxNmti
         Lq8EH9ZvDLutw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 537B7E737FA;
        Wed,  8 Jun 2022 18:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: constify some inline functions in sock.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165471121533.25792.15133661982389951325.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 18:00:15 +0000
References: <20220606113458.35953-1-pjlafren@mtu.edu>
In-Reply-To: <20220606113458.35953-1-pjlafren@mtu.edu>
To:     Peter Lafreniere <pjlafren@mtu.edu>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 07:34:58 -0400 you wrote:
> Despite these inline functions having full visibility to the compiler
> at compile time, they still strip const from passed pointers.
> This change allows for functions in various network drivers to be marked as
> const that could not be marked const before.
> 
> Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>
> 
> [...]

Here is the summary with links:
  - net: constify some inline functions in sock.h
    https://git.kernel.org/netdev/net-next/c/a84a434baf94

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


