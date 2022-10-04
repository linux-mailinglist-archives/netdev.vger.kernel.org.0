Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C7D5F3A40
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJDAAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJDAAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B1595B9;
        Mon,  3 Oct 2022 17:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1928C611E1;
        Tue,  4 Oct 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FCFBC433D6;
        Tue,  4 Oct 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841615;
        bh=o436ThbRfti45CB7PWHupiscFBYbUoSuCZASACkC23g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iYpnPS4GHEcpQaJL8AOzJppWBo+YAYS2UmzIWEWKBM467nKBNcr5E4puikJd1Lgyg
         MEBxgJWMit8hoFpLsf+ETj5REYYEOdQwktIh1ZfhKy3iY9UWVC6mzhettFgyL4p0jM
         7Hc4VeS8+Wz0xRR/CPhSFhb5suVra/Z/ox4hl1HZlQwc2Ge/JlBnnNqvEOp99Xzrct
         8PNgwBxi/MwSHglWBed+bQQH7RGrTdeYsb6dt9LylYXhYgUipXg+cPEBKj+4IK6vew
         gf+UDFLvP/Q+r+cnBIYGztH0XzvJHPvGGE3ELRW5TjX7J0C/YYS/CqaWN5XpGjADqS
         /VzWeoKJ3h6JQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5B963E4D013;
        Tue,  4 Oct 2022 00:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: update comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484161537.2431.9070338378744641097.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:00:15 +0000
References: <20220930224527.3503404-1-elder@linaro.org>
In-Reply-To: <20220930224527.3503404-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 30 Sep 2022 17:45:27 -0500 you wrote:
> This patch just updates comments throughout the IPA code.
> 
> Transaction state is now tracked using indexes into an array rather
> than linked lists, and a few comments refer to the "old way" of
> doing things.  The description of how transactions are used was
> changed to refer to "operations" rather than "commands", to
> (hopefully) remove a possible ambiguity.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: update comments
    https://git.kernel.org/netdev/net-next/c/ace5dc61620b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


