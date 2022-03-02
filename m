Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DCB4C9A69
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbiCBBax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:30:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiCBBax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:30:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F692F018;
        Tue,  1 Mar 2022 17:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A912E615E1;
        Wed,  2 Mar 2022 01:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 02445C340F2;
        Wed,  2 Mar 2022 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646184610;
        bh=Gd/v7jMqzhNMlzjp8Cu0nctbBVBjBErCeVwlzpT0EVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QkBL/AkoH6J9u6HSq3imjZaJLmYjQ1XFod+QLgihHpZk7jzWaqzzSI8M+QH4J+HY/
         qLFfBDtxRbkDAhVJzKxbuqL9UUNS5y4c2ac78oIfclIjZKQ8j9dYlCeBnthFjhi9rI
         Goq0AkCCaWTBg74YlZNdCYZyiz2pAkNTHz+JU/RZ7U9h77gMSom8xdCLZGWBAYNgBg
         YjXExBPbMZeONjH+PAc4FfPNkCb4b6FDqQenPIz5MsdATsBShkvQk//KaegfuLnBA8
         JdBqafrG1XjNjFIzsggzk7rvz0kVDt27YBO8bRIPpRkEj8i+FYMdyYQV6FEeY493M0
         GKYGL7leoVkUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB8CFEAC096;
        Wed,  2 Mar 2022 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-03-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618460989.17801.2466038458100822638.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 01:30:09 +0000
References: <20220302004330.125536-1-luiz.dentz@gmail.com>
In-Reply-To: <20220302004330.125536-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Mar 2022 16:43:30 -0800 you wrote:
> The following changes since commit caef14b7530c065fb85d54492768fa48fdb5093e:
> 
>   net: ipa: fix a build dependency (2022-02-28 11:44:27 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-03-01
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-03-01
    https://git.kernel.org/netdev/net/c/2e77551c6128

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


