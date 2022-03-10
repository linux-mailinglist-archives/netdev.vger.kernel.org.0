Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226B34D4039
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbiCJEVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239427AbiCJEVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:21:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F2B11863B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE4C617E1
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6080EC36AE3;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886011;
        bh=EvW76vOkInP7Z8e0KePQiK0p+89GiLHaUNKwSh0XVvc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ud0Ar7vFeKvEhXiHZB9Hb7cBzX0U34mhRU1ECio4nwbf9wqjnHQiXrnociClHCSOW
         3tcZXRoO36fFZLrZrdNyXxKTublE//XLumO0rE++TIxajaDPor5wf0iiRwhXJDYlgV
         84SCMGdgAWRQlZOZ5uyYqQiqw49NSZt4DrKrLkiTZmD3nvYSuoNsddqhvS+eth/PoN
         IROzSR77tXMojOkao9u4F+STpm6ZR8HWoTRuUrvNfH70QA1OMhf0H3puCQ4uI1s3c9
         gTDs4L0XxrIdfYqonRAi9+p5YF2BLORoiz02pqKaMJR73YKBPquv4nSXcYHBXMc+O3
         Wvr93syP6cVaA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49D76F0383F;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net/fungible: fix errors when
 CONFIG_TLS_DEVICE=n
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688601129.11305.324459189637319013.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:20:11 +0000
References: <20220309034032.405212-1-dmichail@fungible.com>
In-Reply-To: <20220309034032.405212-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        rdunlap@infradead.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 19:40:30 -0800 you wrote:
> This pair of patches fix compile errors in funeth when
> CONFIG_TLS_DEVICE=n. The errors are due to symbols that are not defined
> in this config but are used in code guarded by
> "if (IS_ENABLED(CONFIG_TLS_DEVICE) ..."
> 
> One option is to place this code under preprocessor guards that will
> keep the compiler from looking at the code. The option adopted here is
> to define the offending symbols also when CONFIG_TLS_DEVICE=n.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/tls: Provide {__,}tls_driver_ctx() unconditionally
    https://git.kernel.org/netdev/net-next/c/77f09e66f613
  - [net-next,2/2] net/fungible: fix errors when CONFIG_TLS_DEVICE=n
    https://git.kernel.org/netdev/net-next/c/b23f9239195a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


