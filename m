Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C014D644191
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbiLFKuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbiLFKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:50:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B700DCE31
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BDC961597
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 920B4C43470;
        Tue,  6 Dec 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670323815;
        bh=1P1z/RGA9nWM8J8O5PVzwDI4DuzHZyn7GZc8FquR6cA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Er4Pl8YO4IIa04k4T2CAyZ0LR5a/ZnsoNIq8kXsm5HjUzDYZp3FsXIfu20PFWw4vy
         dSE5nl95bVErVu1s99rZeg5rxZ82yuNtCzuFQP27om7gnuWQRbQzpcPAJrmR5oYgpv
         gDhQHhGeru0dtOqGuyKY30NLgt3htQGviVqjyepbJL3ihGa5riZim8EuyfI2wmAw8/
         lbezipDuvbbWGO1XxXPxpetQ5YiYi4GqF1ZTHgbQzhR7zbhVu2vBzcpU/VDcMpOl8a
         FbsHNIxWZzircSXcJjVSAR+WU2qtqRk3R9m3pMPWJbp1Gqt7h681oL5gonxEunUDlu
         VlUuQb7Gsc29w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DE77E56AA1;
        Tue,  6 Dec 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net] ip_gre: do not report erspan version on GRE interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032381544.8282.9586872626910300440.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 10:50:15 +0000
References: <20221203032858.3130339-1-liuhangbin@gmail.com>
In-Reply-To: <20221203032858.3130339-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        u9012063@gmail.com, jishi@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat,  3 Dec 2022 11:28:58 +0800 you wrote:
> Although the type I ERSPAN is based on the barebones IP + GRE
> encapsulation and no extra ERSPAN header. Report erspan version on GRE
> interface looks unreasonable. Fix this by separating the erspan and gre
> fill info.
> 
> IPv6 GRE does not have this info as IPv6 only supports erspan version
> 1 and 2.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net] ip_gre: do not report erspan version on GRE interface
    https://git.kernel.org/netdev/net/c/ee496694b9ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


