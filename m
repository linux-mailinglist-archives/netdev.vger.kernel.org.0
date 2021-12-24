Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E246047F16E
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 00:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhLXXKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 18:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbhLXXKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 18:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EABC061401;
        Fri, 24 Dec 2021 15:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2F27B82357;
        Fri, 24 Dec 2021 23:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BBCC8C36AEA;
        Fri, 24 Dec 2021 23:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640387409;
        bh=fOtEvItekIGynlFbMmscCsUBbIwCtg1msDtgUQVsbP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNVmo0mVFuwDhKzSd+lP8+dAvcgZ23BJ38G2NSLpB+4Hxo65i3mOjE4rnTu0mAq45
         hcqxtPktW3TMfOmmdgYTDSfsIHgACtF7Zl4VZqtBIskrUC91zFXiB7keKHR1+Hpzxo
         7oo2a/Kkl4uUcoN0s7OazsiLRNccFWtzIvk/kDmkRAjK/QMiv6Gobs71x54jfjqYsA
         jVGsc8Fb0kdUH6bixMrP81E8cOmUFCLAKCQ9BLZk8iBUfJp+7/vOf9mKJ7vD/60IPq
         SqahXnxMisrwrZJ9v80VEEeSFJYekwfKvaGOOyFt2NsoI5HKnByA6vtFNT9323HeZx
         6YHEsSRkwxTtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9A11EAC06B;
        Fri, 24 Dec 2021 23:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] lib: objagg: Use the bitmap API when applicable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164038740969.29055.3830657211085766968.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 23:10:09 +0000
References: <f9541b085ec68e573004e1be200c11c9c901181a.1640295165.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <f9541b085ec68e573004e1be200c11c9c901181a.1640295165.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Dec 2021 22:33:42 +0100 you wrote:
> Use 'bitmap_zalloc()' to simplify code, improve the semantic and reduce
> some open-coded arithmetic in allocator arguments.
> 
> Also change the corresponding 'kfree()' into 'bitmap_free()' to keep
> consistency.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - lib: objagg: Use the bitmap API when applicable
    https://git.kernel.org/netdev/net-next/c/7c63f26cb518

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


