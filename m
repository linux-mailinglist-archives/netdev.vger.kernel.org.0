Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32DA699D14
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBPTkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:40:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBPTkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:40:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D081442FB;
        Thu, 16 Feb 2023 11:40:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB7D060ACE;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 478D4C433EF;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676576434;
        bh=YA0JHCkJPpiXEN11iVgBB68ZXgZqOuH0KMVewkmZlpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JayUMNFlBaHKR6x/jF7O+dpm0F2uiXCH1skFMRc8afhT3zfQmU15sas6LjIohOD4m
         fyqG/hr1tgrVvP592ec3GC/WDoWBX01mOwE7Tus5RWcxreYmnFFv+iRTR9PSYSLrWs
         rq42xuM5WI2PO9haSB7H0VgK1Wy5+5zhpHJ2K8tdbpa0vl0z2nYER0LpxSFyb/5jKv
         9f+oIp9f/bktWD5xjFwYRsDPOH8+VrXaFAWj5jQvk7QGPgx2WDpZXjbFhr27z0vpja
         B8GwzvjfdqVuxOoxV2bi1dv9f6hw+dKgigvxTEqKt90dbKs5diI6aem0n050//zu7z
         VYUJhK6L8IEcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29901E68D2E;
        Thu, 16 Feb 2023 19:40:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-03-16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167657643416.21159.16492102838822649238.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 19:40:34 +0000
References: <20230216105406.208416-1-johannes@sipsolutions.net>
In-Reply-To: <20230216105406.208416-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Feb 2023 11:54:05 +0100 you wrote:
> Hi,
> 
> Here's a last (obviously) set of new work for -next. The
> major changes are summarized in the tag below.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-03-16
    https://git.kernel.org/netdev/net-next/c/ca0df43d2110

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


