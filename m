Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F55485E07
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344326AbiAFBUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344312AbiAFBUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:20:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C6AC061201
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 17:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C02061A08
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04F6BC36AF4;
        Thu,  6 Jan 2022 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641432010;
        bh=7qArC+IyKUn7OOFIxt3pCtXeDE4nYeXIrwP++tbraV4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U0hpkr+r7J7XlJapYPzVzBXJEiRgf9ABZsEzQzBJMMt8P22Sp9BZqa26QYmiM8Ual
         rsDdtg5N1xZGQ87wvqvj0TlyaKFeOarQUmRVFVSzdRAXuoOazthWxXmwFjP6p87S5m
         Y/XmbkyiYjSxb5X25t4VZqWBnH1YoMrdIrWmmEpJhiNq0SBTO+9Txbwu6UF85jA/LH
         rGPB3Qu184FzIua8lvSOBhUWMv7Umx0iv1a6jcoRQkmEJgWCKOlqvvKwuFAcBV2qYg
         qCTtqvVHJGbbmra9ET6s8s1SVPxxhwbr7euBbUqgCwT9r/M4ymQ5U7uq91pFFlddDG
         sAiw9WZ7cBDjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7B16F79401;
        Thu,  6 Jan 2022 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] testptp: set pin function before other requests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164143200994.6490.16252057284548367434.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 01:20:09 +0000
References: <20220105152506.3256026-1-mlichvar@redhat.com>
In-Reply-To: <20220105152506.3256026-1-mlichvar@redhat.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Jan 2022 16:25:06 +0100 you wrote:
> When the -L option of the testptp utility is specified with other
> options (e.g. -p to enable PPS output), the user probably wants to
> apply it to the pin configured by the -L option.
> 
> Reorder the code to set the pin function before other function requests
> to avoid confusing users.
> 
> [...]

Here is the summary with links:
  - [net-next] testptp: set pin function before other requests
    https://git.kernel.org/netdev/net-next/c/87eee9c5589e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


