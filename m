Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2EE67A9AC
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 05:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbjAYEk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 23:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjAYEkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 23:40:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2B353B2E
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 20:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0886BCE0B7D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 04:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03BA6C433AA;
        Wed, 25 Jan 2023 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674621617;
        bh=lVhwaQiw3BM7Tb57hML00lcH+5A5iESV016o6mt6x6E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhJdRB4tUR1BdUNPDQL3pFTzjU2arz/B1Vf+lOTqPwzcWsmoZSPHV4iYA1Rc6dVmK
         syVwcWDwxmYZ9MXSqkxrOgvRZe/sSPQSs4hoQjoF+8KsZLz0Tj7Cq9vERUFy5LQcVw
         FL+ZBwLtwzwlCwBUYQdaZB1Qxbr7QuYRSeRqYBlqj/P7CnkqFs1xBOC6IhLV3yOurn
         mo9WdmZsBqnlchkYZPq5avfTawm4OKqEQYx8KLAbgnisIAsRZN7vyQRhZrDkyHTste
         2qCAIKFT9BhhWIHVcqAsRkoFUUNRHRYT4lVzHQJ+OlZAPt0u7eRRbAdl+VeHiqHAT2
         uHMtIRr5vOeXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3C05F83ECD;
        Wed, 25 Jan 2023 04:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: remove a dubious assumption in fmsg dumping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167462161692.8470.18180390730034530253.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 04:40:16 +0000
References: <20230124035231.787381-1-kuba@kernel.org>
In-Reply-To: <20230124035231.787381-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 19:52:31 -0800 you wrote:
> Build bot detects that err may be returned uninitialized in
> devlink_fmsg_prepare_skb(). This is not really true because
> all fmsgs users should create at least one outer nest, and
> therefore fmsg can't be completely empty.
> 
> That said the assumption is not trivial to confirm, so let's
> follow the bots advice, anyway.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: remove a dubious assumption in fmsg dumping
    https://git.kernel.org/netdev/net-next/c/4373a023e038

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


