Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021AE6AF801
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjCGVuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjCGVuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1FDA2C25
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 13:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B6B6159A
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B0C5C43444;
        Tue,  7 Mar 2023 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678225821;
        bh=jPOaP+3pdt+NZE0cIsUJtiOKW6nWsG6VGnSSAffGvPw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OinQ90QaiuOV2HlLA4Y9jNWyhCQt+Mc51gtdVdN4fCueVcsXcLAMOLi2h66Po+KZZ
         +QZE+scD70wHZ8L8RF6yBhCT57Tm70UGnGhGVEGgwMuguPHIn+ucuVa1O6D55cd6D0
         HwqBWq4vaAEKwQT9bB6beCz/YymzUkEtyvCOszdDXY65r5DfFPM8IHJZkmq4jyPNDb
         +F8vAaOY1zaAY81W+NVYPyDbO4dqxd+43hefDECcrLUJK2ameZgGmbUewE4v3leDwE
         v+bmBozJaNNwuFZtlIraFP710BsrvtmJJwyKDoBmQCS0J5xifucwov5TyfRUD231l0
         1q9i01wQ/L7UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E801FE61B64;
        Tue,  7 Mar 2023 21:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mailmap: add entry for Maxim Mikityanskiy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167822582094.6774.15369837477499999059.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 21:50:20 +0000
References: <20230306192018.3894988-1-kuba@kernel.org>
In-Reply-To: <20230306192018.3894988-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, maxtram95@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Mar 2023 11:20:18 -0800 you wrote:
> Map Maxim's old corporate addresses to his personal one.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: maxtram95@gmail.com
> ---
>  .mailmap | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net] mailmap: add entry for Maxim Mikityanskiy
    https://git.kernel.org/netdev/net/c/e7b15acdc10f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


