Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4711D479056
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbhLQPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 10:50:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41130 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhLQPuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 10:50:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 678F2B828A1;
        Fri, 17 Dec 2021 15:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DCB4C36AE7;
        Fri, 17 Dec 2021 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639756219;
        bh=5db89TLrcxOzLB1ZRoBOcVkydUC+ZAuZYZ5v3VOZSF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvfkKrdsDyHuJKJNTPCRlZbh5YSE/kj1j2s9PudsTUpFo37SGE9gD9983nrLOsY2p
         dv+XfE58X8jWona8t0SdIAQXOvxjboI1fLoy/ND43sgt3pW7XNxtY+3JNODgkT75gV
         pOcDDbPkjeBaYT6alJ4op6A/LgdpZEZFHDdZFffKRS1SDjFYzHeT6RlMjBYdZ8HA3c
         67KbPCP1rqCVLGdASCxcWiJnSgey+mCPN0UkowSuCawtCRstvKiSt6tbgP1HDq1e4U
         TRZBgXdokeuIp0pVhhyZY+LC9fUMyiPOLDEXn75F4GeWIQGg64Du1J779h44tZnckm
         um6jbA/C2V4ig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F0E1760A39;
        Fri, 17 Dec 2021 15:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-12-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163975621898.29842.16396439740489235598.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 15:50:18 +0000
References: <20211217130952.34887C36AE9@smtp.kernel.org>
In-Reply-To: <20211217130952.34887C36AE9@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 17 Dec 2021 13:09:52 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-12-17
    https://git.kernel.org/netdev/net-next/c/f75c1d55ecba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


