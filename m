Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2854846B4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbiADRKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbiADRKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20226C061761;
        Tue,  4 Jan 2022 09:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B536061548;
        Tue,  4 Jan 2022 17:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2596DC36AF2;
        Tue,  4 Jan 2022 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641316209;
        bh=7yVVepDh6pnFXJnAK+SQccfhNvb/DjUYgiiRdGepa9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mh4Oa0sh44bf/2fCLhkRiS5J3/bGiZE0sUZpZZh5tsM005sIqEdf5pFjaUjRvzKBx
         uF6UL5seCOmA2gSgoRmNWO/kATQ7j/bptdglniX0HVTc2gyws2XEp6PwWR4G7PRD95
         9YAwut/TUHP7sBHamem2MhmjAEifzNGsbWq8NVWSuwximvmUSiQh9Eqb4bxyEOosVA
         dvzVwURUYCjGl1noZzf5W0mFDDFYZm+ScFbzGHvAywiMlErj6QzxwZG6jKmEiscG3p
         Nv6Osb4PtffvXOA9Skv6FcplCMd770HAARcx9ImLF2MD+I1TfbOaGlX8rRlGmRkLrI
         Lz1ORPIFCUmNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A0A4F79405;
        Tue,  4 Jan 2022 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: mac80211-next 2022-01-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164131620903.5102.6554918050777030500.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 17:10:09 +0000
References: <20220104153403.69749-1-johannes@sipsolutions.net>
In-Reply-To: <20220104153403.69749-1-johannes@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Jan 2022 16:34:02 +0100 you wrote:
> Hi,
> 
> And a couple of more patches for -next... I have more, but most
> of those are related to EHT (WiFi 7) and so not really relevant
> in the short term - not going to send them this time around, as
> I still need to review anyway.
> 
> [...]

Here is the summary with links:
  - pull-request: mac80211-next 2022-01-04
    https://git.kernel.org/netdev/net-next/c/18343b806915

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


