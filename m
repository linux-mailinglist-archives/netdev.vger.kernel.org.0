Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1314D598E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346303AbiCKEbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346282AbiCKEbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA94C1A58E7;
        Thu, 10 Mar 2022 20:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88141B82A72;
        Fri, 11 Mar 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4056BC340EF;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973013;
        bh=H1rcJqCUSrfR08eNMswFjeCf5pmE8EdMJYrBjScEuOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W9vfnAEVQYuR+7VS1U2PBdUPWN+c3PVZyJ/tJ97/hX1mxi1kZ63DT4+Z/m9U31V9w
         CeOqs58zuZRBe3Ojul6jXgSWKQtBTFTiAEYLlxufeoSBAvB5/POu7eAjSbXqUBPILo
         QER8JdqQ3NZ7ACbUByIK0Khs68Bm5AnaxMjAarzVhcFj5UJZj64NqGOGTsYbAPP0d/
         DxsjznAeloHu7Y712XLTzzqf3u3M7PPhLyHBoQjAqgcdtm2MB4BcCTjNV+dUPgYoUb
         ZEdOHjB/aWTdZv1d4S6GT1UGEKgXMGpfyfit2lUe5deFxT3miH7s4Kx6ENoOKpsKt8
         B/UD5o2Sj00xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 217C5F0383F;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: openvswitch: fix uAPI incompatibility with
 existing user space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697301313.12732.14395145202660656158.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:30:13 +0000
References: <20220309222033.3018976-1-i.maximets@ovn.org>
In-Reply-To: <20220309222033.3018976-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     kuba@kernel.org, roid@nvidia.com, davem@davemloft.net,
        pshelar@ovn.org, cpp.code.lv@gmail.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        johannes@sipsolutions.net, aconole@redhat.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 23:20:33 +0100 you wrote:
> Few years ago OVS user space made a strange choice in the commit [1]
> to define types only valid for the user space inside the copy of a
> kernel uAPI header.  '#ifndef __KERNEL__' and another attribute was
> added later.
> 
> This leads to the inevitable clash between user space and kernel types
> when the kernel uAPI is extended.  The issue was unveiled with the
> addition of a new type for IPv6 extension header in kernel uAPI.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: openvswitch: fix uAPI incompatibility with existing user space
    https://git.kernel.org/netdev/net-next/c/1926407a4ab0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


