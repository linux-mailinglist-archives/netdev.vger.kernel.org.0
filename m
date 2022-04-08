Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE54F8E11
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiDHECW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 00:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiDHECT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 00:02:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D75511BCC0
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF512B829B1
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 920F8C385A6;
        Fri,  8 Apr 2022 04:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649390413;
        bh=/J7lZjPmYAoPjV7+GRLfbrggDSKe5Ql4VikI+bgTRnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kn4YHFPekaYm74JNpTK/noHKGRp/Jb8hVt0sNRYGCz/eWX1DY2QWSjpsAnHjjQpby
         XrhNcVMfB/9cBKeuo3f32NV3y4wgm7Aexojwyieb5aZz+i8rncmgk134r2GEes82vi
         R+b0KFN+tdGn4oyYt6YR30JC/a1aml80nEpf/GVqWJBdMuphroUfGASWS/EA8+oknh
         DCdAKNknwaem4LecYcr6vIolomHPsbOQKpMsiQ0rqGygXLLOpE/3nz/OFHEigkpZEu
         jWW7kAuvBP8C4Fked9h1DzEtFySXiuCLr9eAkQpqPNmFjeZ3ZgbC3fLNuVB3QLC294
         1nHfpecNgvy6A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73A3FE8DBDD;
        Fri,  8 Apr 2022 04:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: create a net/core/ internal header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164939041346.25172.3549599788418547609.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 04:00:13 +0000
References: <20220406213754.731066-1-kuba@kernel.org>
In-Reply-To: <20220406213754.731066-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Apr 2022 14:37:51 -0700 you wrote:
> We are adding stuff to netdevice.h which really should be
> local to net/core/. Create a net/core/dev.h header and use it.
> Minor cleanups precede.
> 
> Jakub Kicinski (3):
>   net: hyperv: remove use of bpf_op_t
>   net: unexport a handful of dev_* functions
>   net: extract a few internals from netdevice.h
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: hyperv: remove use of bpf_op_t
    https://git.kernel.org/netdev/net-next/c/e416531f0459
  - [net-next,2/3] net: unexport a handful of dev_* functions
    https://git.kernel.org/netdev/net-next/c/2cc6cdd44a16
  - [net-next,3/3] net: extract a few internals from netdevice.h
    https://git.kernel.org/netdev/net-next/c/6264f58ca0e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


