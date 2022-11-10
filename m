Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD86623ABB
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 05:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiKJEAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 23:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKJEAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 23:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE1CC77E;
        Wed,  9 Nov 2022 20:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34CF761D6D;
        Thu, 10 Nov 2022 04:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86087C43141;
        Thu, 10 Nov 2022 04:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668052816;
        bh=WGSy2McO/RmZZ2NSZddm01Mbg6pV/8K6d2Vdk3cSOcc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BCOsycgF1natrdg+h3AJdoDgHl0hfuJ2rrOvaM0U5Hqw3aSRM4vgtSZg2J5/FfTCn
         kGdUAJf23LtX3P0nsRLJIOAKVx3wQEg/9U9nnCEnQxumqSHZpzH6V6GTT/N26ZHvQ3
         gX1R+yYGbeT9FtXYn7jom3qqJ8G2Wny9mNK8PtiK4F/DLLzmYKm/kgmZo4wglLotBC
         Zmb378AcTD01eAiMEnhfxcW3Pn5qKJf8nWA2MDquz0a7c4dt7smjkVRgXMfMiAURyT
         8jHOAJq0y6MuY9sreNOB58YxNa0NljxicH77y1ArGpX466ghNpsJ/+1VszH+OzNQEm
         toN6Z2AfYOmVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66034C395F6;
        Thu, 10 Nov 2022 04:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [resend,
 PATCH net-next v1 1/1] mac_pton: Don't access memory over expected length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805281641.8987.13644069334014062927.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 04:00:16 +0000
References: <20221108141108.62974-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20221108141108.62974-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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

On Tue,  8 Nov 2022 16:11:08 +0200 you wrote:
> The strlen() may go too far when estimating the length of
> the given string. In some cases it may go over the boundary
> and crash the system which is the case according to the commit
> 13a55372b64e ("ARM: orion5x: Revert commit 4904dbda41c8.").
> 
> Rectify this by switching to strnlen() for the expected
> maximum length of the string.
> 
> [...]

Here is the summary with links:
  - [resend,net-next,v1,1/1] mac_pton: Don't access memory over expected length
    https://git.kernel.org/netdev/net-next/c/21780f89d658

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


