Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3B514081
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 04:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354133AbiD2CNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354118AbiD2CNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2073E4C424;
        Thu, 28 Apr 2022 19:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51B8C62228;
        Fri, 29 Apr 2022 02:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0AF4C385AA;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651198212;
        bh=K4HqasmbcBW+6+Fpei5RSbbzln03UK9Up/+VSen0q1E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TxT2B7bYdgnenhHtkKGeubItTiA9Zdrnn4BjaiXkdaXcVQ5bAGCFJHgvIcW+aHpxx
         fcL/uiyVyKsRps+9zh+Q6f+czGcflDvHh8MxXmKFbMmjbxObFuMxzTF35+zaWhWhKZ
         ec8ZAi3eHVaT8siQVeA1CEbKVbq/aG4d5MY9tOk16j8U8rJeZVAIe6WAhTvBKVT7qX
         cpEmjyfSMV+dJw8XLn5ikRXMqeLg/oJacxhT5Db6c1gtGO9RA1QHX5E1KDMi1hSCFN
         m1j1FVYS2Vbsg2/nCKEg4ZlMFLiFBniFaIq/R0bXZk2JzPTjZvlVXi6YcW7HzAd/o2
         vpF7JqNNSkBBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8717AE8DD85;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: prestera: add police action support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165119821254.31798.12575009523722700259.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 02:10:12 +0000
References: <1651061148-21321-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1651061148-21321-1-git-send-email-volodymyr.mytnyk@plvision.eu>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, taras.chornyi@plvision.eu,
        serhiy.pshyk@plvision.eu, tchornyi@marvell.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 27 Apr 2022 15:05:48 +0300 you wrote:
> - Add HW api to configure policer:
>   - SR TCM policer mode is only supported for now.
>   - Policer ingress/egress direction support.
> - Add police action support into flower
> 
> Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [net-next] net: prestera: add police action support
    https://git.kernel.org/netdev/net-next/c/dde2daa0a279

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


