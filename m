Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5F555A4F0
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbiFXXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiFXXkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609B889D18
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 16:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9C4162484
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 23:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ACBBC341C0;
        Fri, 24 Jun 2022 23:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656114014;
        bh=UUSxYZrEVKLIQUpAz0AZWlzW94ocbT/IqJyx4KY+djA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPyC4LVWlmf/KtMLmrBHFR/eFvKQCrYBrFbWfbPinkWSJHvURluCBmJK5uTSPTcey
         ykJko+fXhjSS7HRJLFtBGPACLJZHUtEzAKNK6geWn6qJn5NgKgPdrex1bg960MpC5g
         7ptNwqGgGT3StJ1d3VT9UIg556N7RO5nY7kuQXoXoTzIagFuyMGIRG/rz1LT4QC5SL
         SCqNt91vtF7xocjcEhxYcIkl0i+C3yeLyl9XU1qipz33jo/E4RXRRcgavJbtMLqSC9
         s/5ScYU3mR+pgzLBdHnXOzw8W4Xj3YHcS0teMZpU8slnR+k7WHQIIFpN3xf8sSQp5s
         7B8E4mm3zcYhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1057BE85DBE;
        Fri, 24 Jun 2022 23:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: tun: unlink NAPI from device on destruction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165611401406.14577.4130665115121315844.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 23:40:14 +0000
References: <20220623042039.2274708-1-kuba@kernel.org>
In-Reply-To: <20220623042039.2274708-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        pabeni@redhat.com,
        syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com,
        peterpenkov96@gmail.com, maheshb@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 21:20:39 -0700 you wrote:
> Syzbot found a race between tun file and device destruction.
> NAPIs live in struct tun_file which can get destroyed before
> the netdev so we have to del them explicitly. The current
> code is missing deleting the NAPI if the queue was detached
> first.
> 
> Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
> Reported-by: syzbot+b75c138e9286ac742647@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: tun: unlink NAPI from device on destruction
    https://git.kernel.org/netdev/net/c/3b9bc84d3111

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


