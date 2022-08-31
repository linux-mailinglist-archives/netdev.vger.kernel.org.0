Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8325A86F8
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiHaTuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiHaTuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837BD4599C;
        Wed, 31 Aug 2022 12:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A1CCB82296;
        Wed, 31 Aug 2022 19:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 478B9C433B5;
        Wed, 31 Aug 2022 19:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661975415;
        bh=1Hqj9cGQMvdM0HK2rNbmJyNsJ4gxVRMh3qEmfemnL00=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tgD9JEKdkV1FuTJxKtVGSCHNmta4SQ3HTzwtbH8PBIp4sAJttvgHjWIux3teb1AFR
         b0DpfmDQwyaGeTXHujteZh4i86qMUFjntBQi+P3axZ9o+Q7zrrGMktXpPcX7cSipUK
         93JjpFUTVGWfqkzzT7SFfM0uqjs/20/2ZlgDydyjzWEDCPZY8D4n0lp1RNvoSiaM3Y
         2qDy+hCFe7NryddMEwF/92BjijtDlby1G0DBRP2AXtA8/DRqaPHRs9VDsMyFJBEa4C
         oYdkWKT7qqz70jIsSFzotDL3nJQF3ZTtdBMhYI6CjodC/9jbCELSwPOOGkvbGSGisA
         sU0KefdtT/r5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2FB38E924DC;
        Wed, 31 Aug 2022 19:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: sort .gitignore file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197541519.20889.18175493740792064843.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:50:15 +0000
References: <20220829184748.1535580-1-axelrasmussen@google.com>
In-Reply-To: <20220829184748.1535580-1-axelrasmussen@google.com>
To:     Axel Rasmussen <axelrasmussen@google.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Aug 2022 11:47:48 -0700 you wrote:
> This is the result of `sort tools/testing/selftests/net/.gitignore`, but
> preserving the comment at the top.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  tools/testing/selftests/net/.gitignore | 52 +++++++++++++-------------
>  1 file changed, 26 insertions(+), 26 deletions(-)

Here is the summary with links:
  - selftests: net: sort .gitignore file
    https://git.kernel.org/netdev/net/c/5a3a59981027

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


