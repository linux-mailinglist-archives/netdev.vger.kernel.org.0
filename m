Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C98005F5AD1
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 22:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiJEUKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 16:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiJEUKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 16:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B741929B
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 13:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82DC4617B6
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 20:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5AF5C433D7;
        Wed,  5 Oct 2022 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665000614;
        bh=QBhohusAdbm19ntcZpkW75O2QiVruMDfqq4J7FzRTQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DhLU1ouy+SsgBREiaCn4WbpSPyeVuSREBcnxtqi6sQSwU1E7vdPjuaPNB22qhJ4Kp
         c4v4ZT5sFdhRMLoUfVOLt6KoikrrEELqj+B3BPNa1KHohuZJ8N+vXNFaE38AN3jri8
         6+2xstWI0VaFMxerK6BECn1tfQnpH6ISwsAm1bvUCeMIjLU2UQfb1hNGQgPTxyKuRb
         zRXId0uRi6oWcojmDBuCAzWXKIU+GR+O1p4TRV7Co3Fha8Ow/aFh5JdICHC1NYVKCD
         TI2dWNbT419c4YCilTvcmHVnGl7S1IFZloGC7NsYRV1jq4rHnPjIssP+hkgCp+NZgs
         PpbtX0O3v4sfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA9DDE21ED4;
        Wed,  5 Oct 2022 20:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] man: ss.8: fix a typo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166500061475.26723.17899051683476873723.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Oct 2022 20:10:14 +0000
References: <7febff04089ef0a6ea47515178c74462f088a1f1.1664893492.git.aclaudi@redhat.com>
In-Reply-To: <7febff04089ef0a6ea47515178c74462f088a1f1.1664893492.git.aclaudi@redhat.com>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Tue,  4 Oct 2022 16:25:03 +0200 you wrote:
> Fixes: f76ad635f21d ("man: break long lines in man page sources")
> Reported-by: Prijesh Patel <prpatel@redhat.com>
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  man/man8/ss.8 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - man: ss.8: fix a typo
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=e0bbdb08de6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


