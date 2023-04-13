Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4282B6E15DC
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjDMUaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjDMUaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE252D44;
        Thu, 13 Apr 2023 13:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69D1264199;
        Thu, 13 Apr 2023 20:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90EE7C4339E;
        Thu, 13 Apr 2023 20:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681417820;
        bh=Nm03twnKWUqYLgu474+c6vJJZeQfY/k6KCPJB1Vn6uA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOfrHFJBTUHL5duHq0xpi/5oabxqcv5CLjR8SmVTvYaf9cba5GIEdEml3Zw3i80Uk
         j3SCaeRyx3tQmJbOAmlXTuN/c2uwYCTTksDZuStQHwyFwkHV0YQB9dn1kACH/mK/I7
         c/Kbf6KBYRVfKL8PZogRP+ZG5UDTf5DNRlFt8OxcRCef/AWfMzTDnNblHQKiPnQgu4
         p0q3LDRhTONJlnTNGIXKEcm/CL1uI434X4ijUt9CqqiMWzDpzfOFbUa5TNi6MqYtbD
         ARlZaDJPh+rzrdVCGZCSoMnE0TKb2yu4RGjTshdKjCg4/bcUgwQFAqji3/Ffagcy/+
         Z6JlSXUa68W7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 742C7E4D003;
        Thu, 13 Apr 2023 20:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2023-04-13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168141782046.3934.16956205725773584369.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Apr 2023 20:30:20 +0000
References: <20230413191525.7295-1-daniel@iogearbox.net>
In-Reply-To: <20230413191525.7295-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 13 Apr 2023 21:15:25 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 260 non-merge commits during the last 36 day(s) which contain
> a total of 356 files changed, 21786 insertions(+), 11275 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2023-04-13
    https://git.kernel.org/netdev/net/c/d0f89c4c1d4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


