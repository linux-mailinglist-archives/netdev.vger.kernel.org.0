Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6096064D5FF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 06:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLOFAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 00:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOFAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 00:00:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C9441981
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF13B81698
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24AADC433F0;
        Thu, 15 Dec 2022 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671080417;
        bh=eAsbDMlek78n7MVGLDiStPltLVTAk8Y+6xnj7tY9mhM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y+YCnAanUsQQWXo3901pnH3DKr0JuwVCAh1bUwUCRislbkold/0DWkD/zFY+X9IGz
         qy1h1M7UOOoOsMnxiDVfgDnWSep0AP56cjlhqP/26t9wef2KtPuTraW2/e71YLAFk5
         D8vMECp27G4EkPhXjeU3k47yv1kx7YW2Ad4vdv3tS+PTjixF1vaEBDVy2yOWoKMjhx
         SKwmD4TtXoEheGsZaqNNx0CqZTmsePfWAfaKu3iOSOoOKSena78oj0S7v/iCffN9Mm
         63avV9j+xjl/rtCDOgd54IoEyEHcZ1by7G/f3zRsxfut6ptBp6cLtNHzZOw3bvPDoC
         Bj3It4KZJe9bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09A85E4D00F;
        Thu, 15 Dec 2022 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] nfc: pn533: Clear nfc_target before being used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167108041703.25534.13058218525708275805.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 05:00:17 +0000
References: <20221214015139.119673-1-linuxlovemin@yonsei.ac.kr>
In-Reply-To: <20221214015139.119673-1-linuxlovemin@yonsei.ac.kr>
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Dec 2022 10:51:39 +0900 you wrote:
> Fix a slab-out-of-bounds read that occurs in nla_put() called from
> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
> from an nfc_target in pn533, is too large as the nfc_target is not
> properly initialized and retains garbage values. Clear nfc_targets with
> memset() before they are used.
> 
> Found by a modified version of syzkaller.
> 
> [...]

Here is the summary with links:
  - [net,v3] nfc: pn533: Clear nfc_target before being used
    https://git.kernel.org/netdev/net/c/9f28157778ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


