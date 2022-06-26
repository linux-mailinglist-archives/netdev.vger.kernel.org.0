Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D1255B31A
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 19:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiFZRaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiFZRaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 13:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A5BDF7E
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 10:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF6BAB80CA4
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 17:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E5BAC341CB;
        Sun, 26 Jun 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656264612;
        bh=OmwtmY/ORtMCDDqfn/o0fd7e3Yfr/hwbQcyon8+FdMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D1Cy948GXLL1neMg305/Dz3T6J7UWODlZtk1sVuf9RiJkkPikJ4KUq1hWLaG2mfMk
         hE2aBEXtStbv++MkiEsc66M0/XKs3agnBnekerRdBBCZzsZRXrEVSuPmh9zOodMSA4
         Ka+CbW9V6ar8ocUQKl8E34ccg0wLqBPreu8K0N3XBkIL2Vmh8Y19nwG3cq/d7qfaBu
         bpF25s8f+qlKb3vQaF1+VRRMjx+O90L2qgEmoEuXJvrZlzqmd2TZbyiKSPdhySAyT0
         aUihkKJ6c5ryTPHkLXeMezxAQg3HwtimPBdP4NShrwn4kEHmXho93qDMTAydj2Qinb
         6LKJoVTcIn54Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53C04FD99FF;
        Sun, 26 Jun 2022 17:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 iproute2-next] iplink: bond_slave: add per port prio support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165626461233.19413.17785288417791923235.git-patchwork-notify@kernel.org>
Date:   Sun, 26 Jun 2022 17:30:12 +0000
References: <20220621075105.2636726-1-liuhangbin@gmail.com>
In-Reply-To: <20220621075105.2636726-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, pabeni@redhat.com, dsahern@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 21 Jun 2022 15:51:05 +0800 you wrote:
> Add per port priority support for active slave re-selection during
> bonding failover. A higher number means higher priority.
> 
> This option is only valid for active-backup(1), balance-tlb (5) and
> balance-alb (6) mode.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv3,iproute2-next] iplink: bond_slave: add per port prio support
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a10a197d715d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


