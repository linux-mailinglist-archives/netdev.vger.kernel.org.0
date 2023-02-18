Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FCB69BB2E
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjBRRMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBRRMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1605F1716C
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF855B80862
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 821A0C433A1;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676740353;
        bh=nz9yOWeNT+HC2SpYedx5AdbvXmRSwN9MpfORl6K7Y5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Oo29160/q6mx6K6DC6cgSmF/v/meuFr2nlT0yrfMyMJAIVwe/u+J0Eub6mvAET39q
         7u7LWD7xmCNeFiQjKD8jtiAEwe7AAvWXdVVmk3pe/2943+3tyBCq9+kdxJo9mztjx4
         A9aKKxTJAfJbsUc+NNg3+msldzhAOyQ2PDb/F5jLLzCjYJ2qFGw6HKr3rnl6CrFbZu
         GB1ijSTNAoTgQbaaAuUvTOo5QUUPiBmycUtM/vYKHk4RUgO1i/9/fSblQFHBdPmuz5
         ny4anvXZOueyt62dywkBClXGAPFm8yCfpa72uHPmUjTg7hAWAm8lLyT0L8BTfKe3Nw
         gv9N6/0Lyhs7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 604E7E49FA6;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 iproute2-next] tc: m_ct: add support for helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167674035338.11220.14814565960225989576.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 17:12:33 +0000
References: <d66f4a45b580f2b0d0b6f549be018ac31b260525.1676220092.git.lucien.xin@gmail.com>
In-Reply-To: <d66f4a45b580f2b0d0b6f549be018ac31b260525.1676220092.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, dcaratti@redhat.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Sun, 12 Feb 2023 11:41:32 -0500 you wrote:
> This patch is to add the setup and dump for helper in tc ct action
> in userspace, and the support in kernel was added in:
> 
>   https://lore.kernel.org/netdev/cover.1667766782.git.lucien.xin@gmail.com/
> 
> here is an example for usage:
> 
> [...]

Here is the summary with links:
  - [PATCHv2,iproute2-next] tc: m_ct: add support for helper
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4cdce041c3f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


