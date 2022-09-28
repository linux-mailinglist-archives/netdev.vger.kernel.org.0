Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18705ED157
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 02:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiI1AAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 20:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiI1AAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 20:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58EFB4F66B;
        Tue, 27 Sep 2022 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E695461C32;
        Wed, 28 Sep 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52B85C433D6;
        Wed, 28 Sep 2022 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664323216;
        bh=ArdbH1IxmmTpIBhNoIUVX6yecZTrCF3CXVPoewnTKkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MRQ1fiwWpr9drm7pGC2EbemNIc/AUA0FcBxXVd9fCQr7klYES2NvMHMV8qf++Uo1E
         Xj/eOYjFEwi4Cb+3HIakPiNFlCUe8hLDoHFTFy7SbKUi+JdPr4y8BW1HVg8Kp0uTC5
         BPVLHjkppbg6vHW430FAlmQPVwPXSkGnr+1CANqfI3qFMubqfg4BCff2g8QwXZAxaV
         sMsgPHwBzvJJ9gViZhjBuPFcD+KqvCgviZ1dI3pPHoMBbjJ/GbiVLHHEdHLDC+8ON0
         9M5C+3fEU17xmA6lhv0U0kq/jDG1kbkGQUwKCBf4C1j3RNprmi+W6sMacRnMFWyf8t
         VcgjtQhRIdosw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35B4EC04E59;
        Wed, 28 Sep 2022 00:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2022-09-27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166432321621.4011.11228713870076371415.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 00:00:16 +0000
References: <20220927135923.45312-1-johannes@sipsolutions.net>
In-Reply-To: <20220927135923.45312-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 27 Sep 2022 15:59:22 +0200 you wrote:
> Hi,
> 
> So I was out for plugfest, and a couple of things accumulated.
> I know it's getting late, but these seem important, some are
> fixes for reported regressions, some are locking bugs, and a
> memory corruption with some drivers is also there ...
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2022-09-27
    https://git.kernel.org/netdev/net/c/44d70bb561da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


