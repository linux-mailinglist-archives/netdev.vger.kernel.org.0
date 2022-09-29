Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20065EF860
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbiI2PK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbiI2PKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:10:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F83F9C2EC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D52066134C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 15:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A1A1C433C1;
        Thu, 29 Sep 2022 15:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664464216;
        bh=UG+gh2HkfxsDjAigdHLkyXUPOgNM3RqLC4IiWCYZb1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZKjsYR2DJhI4zFb3SusfUcVSpzv+Fx4gtVG0ubVTevWCqQxyzJTlH2MjBdc5qjyRR
         b68653KkEpI4PK4Ntyt3oLPgVXNXRRNQBk1sGGj8Uxd6VEhqwqF3RHsA0mflc/G6WB
         3hlU25Y9U559fKWmcKCzgG+dBO0HlD/T9RDm+4+cELGnZ+T9aqWovzzbbKFJpkrJSi
         Z0dIvqmndfZkPIXG/FNj7bJUZNR23i/sSWgga+lodaoc3kKefA/xXbqLI7VkqrYS9z
         RKvBSb7Imrij2v/qP1aG4XNA5mCZbOPVdGjwwFdL/LUsyn2F+HKLa0aGQtZOu2JYL7
         qqhfphwC3J+fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F03F2C395DA;
        Thu, 29 Sep 2022 15:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 iproute2-next] rtnetlink: add new function rtnl_echo_talk()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166446421597.28586.1027612094861280553.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 15:10:15 +0000
References: <20220929081016.479323-1-liuhangbin@gmail.com>
In-Reply-To: <20220929081016.479323-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, gnault@redhat.com, dsahern@kernel.org,
        stephen@networkplumber.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 29 Sep 2022 16:10:16 +0800 you wrote:
> Add a new function rtnl_echo_talk() that could be used when the
> sub-component supports NLM_F_ECHO flag. With this function we can
> remove the redundant code added by commit b264b4c6568c7 ("ip: add
> NLM_F_ECHO support").
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv3,iproute2-next] rtnetlink: add new function rtnl_echo_talk()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=6c09257f1bf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


