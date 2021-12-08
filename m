Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05C146CD7F
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 07:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhLHGNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 01:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237259AbhLHGNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 01:13:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4613EC061574;
        Tue,  7 Dec 2021 22:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FF05B81FBA;
        Wed,  8 Dec 2021 06:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9101C341CB;
        Wed,  8 Dec 2021 06:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638943809;
        bh=INhacVaG4P5HzQ777ODVJupf9ZDf/A1ZZhWB3yOJM8E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RZFN26Hk+TjOeGuMOaIydIfybrrvGDeBnyvTCE/oOyXmCiDhjp/NvrvqlHDFm/mb9
         pNh6xV7utvhGUQknLe/bHCcHbBwDOh3vhgH7mzzDZU9FnVwVZpjtN2QWL5MIyiJ+ia
         /2qvD309mO+c+F33ggk0FNLqbRGBOPYxW/7B6ITlVRMO5+PnaZor+VLBd6nxZJUJlr
         04TzZI4AySNj0cTDtHagMgXq254LESHrLU4PafWQEbPHKLYKy+EXrG8PHiEmRBdfZI
         w5s7ySIxJMl5nkLkF1RKc0wW8h9T4pPNstMgys1TTSA7+U2CQYk4rHrVyzC7WrxHsd
         gGi/NGg15C9GQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A9B3C60BCF;
        Wed,  8 Dec 2021 06:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hv_sock: Extract hvs_send_data() helper that takes only
 header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894380969.19666.8744296090351862087.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 06:10:09 +0000
References: <20211207063217.2591451-1-keescook@chromium.org>
In-Reply-To: <20211207063217.2591451-1-keescook@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 22:32:17 -0800 you wrote:
> When building under -Warray-bounds, the compiler is especially
> conservative when faced with casts from a smaller object to a larger
> object. While this has found many real bugs, there are some cases that
> are currently false positives (like here). With this as one of the last
> few instances of the warning in the kernel before -Warray-bounds can be
> enabled globally, rearrange the functions so that there is a header-only
> version of hvs_send_data(). Silences this warning:
> 
> [...]

Here is the summary with links:
  - hv_sock: Extract hvs_send_data() helper that takes only header
    https://git.kernel.org/netdev/net-next/c/c0e084e342a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


