Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2BF4DE4DC
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbiCSAbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbiCSAbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1F42A4FA0;
        Fri, 18 Mar 2022 17:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33F46B825FB;
        Sat, 19 Mar 2022 00:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF164C340EF;
        Sat, 19 Mar 2022 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647649811;
        bh=S4AnXF5p02eCG90WhCe33UMKg6ppEJ5vacZW4cvY050=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fBi0ys2H+4vOVoFPuwRaAFW04XiigRqnFMu2N/UNix0WyIp/pN6XhP8vmk4eOTjhX
         gGoHbfzOkKuhc2AQI6mr25qrlDUFbpdXRlor3gGovnaqtPvCyyN5CbHPL9nvjNkzET
         bzb1KukBB2pq61HYD+YNTRakTgirpTR1dRkmUbJNjSKVQmfJ3AO3N3DvDjNeHZTcIA
         fO1DWf8FheLHhhDH2Eb/P64nfD2FIqOr4ERwsMW0qP6cahkCXwsiIpfF7rI1yixsJT
         /O2B5gOwBhK0qIr9YJqAZRie0u6VDPXmhZ7sUcvRhrjT/VnGGHYkXwZQweru+aPbWu
         UWZWb2L21W4WQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C504DEAC09C;
        Sat, 19 Mar 2022 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth-next 2022-03-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164764981180.8965.16255347824798264642.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 00:30:11 +0000
References: <20220318224752.1477292-1-luiz.dentz@gmail.com>
In-Reply-To: <20220318224752.1477292-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Mar 2022 15:47:52 -0700 you wrote:
> The following changes since commit e89600ebeeb14d18c0b062837a84196f72542830:
> 
>   af_vsock: SOCK_SEQPACKET broken buffer test (2022-03-18 15:13:19 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git tags/for-net-next-2022-03-18
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth-next 2022-03-18
    https://git.kernel.org/netdev/net-next/c/53fb430e2070

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


