Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451396823BA
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjAaFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjAaFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0780C65E;
        Mon, 30 Jan 2023 21:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B40B613F7;
        Tue, 31 Jan 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A07BCC4339B;
        Tue, 31 Jan 2023 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675142417;
        bh=Ilm19g62Meqe/3IhhpbZ3ncbsmcML0MNvJRB4S69npk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oPHDunN7/gmd3HvRsFk/BxdB4gqfU+e01JEsRyRwYhsJIVewf4bUxk3vOWwJp3QkI
         ytQICGa8pH28bFByy8icgao2hYtb5mlml4p5rbKr2SJFVe351FURoAaVpiipfeHLKx
         VD9NNz+w83wMmIm6cMhobLtCJcjtEBcCYOQSYx8yX6xdAtEVRWFCargxoB0tF/JwZV
         vOaOANZYQ9y1DxG023MYdWJPxHvvqnHRanETu7Zc/Da9faN05t/wGAHar4QPgjR9pt
         Z5ez4QWSjs2c7RnWRospS0jtDw7dTPJb2VejLME3KMKnMV38aXk6QzrT4Qz6rNJOO/
         5mZktmZVEHOWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81CACC0C40E;
        Tue, 31 Jan 2023 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2023-01-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514241752.16180.14659503229725926088.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:20:17 +0000
References: <20230130095646.301448-1-stefan@datenfreihafen.org>
In-Reply-To: <20230130095646.301448-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 10:56:46 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree:
> 
> Only one fix this time around.
> 
> Miquel Raynal fixed a potential double free spotted by Dan Carpenter.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2023-01-30
    https://git.kernel.org/netdev/net/c/9b3fc325c2a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


