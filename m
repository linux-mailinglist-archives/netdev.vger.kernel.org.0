Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7E15A86A4
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiHaTUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiHaTUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0EEA3B942
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EB366185C
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 19:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6511CC433D6;
        Wed, 31 Aug 2022 19:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661973614;
        bh=pxTRo1cg9/tEGHbuHO5+O0c1j+C9z548omVlaOL17Aw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A7XghiKD/5WaihpfB6G5EkxUyNzEND0SOAS1qmadcAYZBYne+AtTnBcuEt1vf/QG9
         Kjfqt2WxCsmgY6KAggFmpwIG9hCHXjfTgOp+N+/jW6ogrUh89N2M9xhpTeUz6BNeMC
         7N3twMF/9MtfzO6DdbyXMpd92YLVnczp1oFll55qiAoI4rzaYdy5IuBP9I5khzWON8
         75XHlsNnMCc+0ovJYdz4MZlIHcvg/TRutcapJCBdgH9vsdVPxbkUfh1ytKxaQG2rl6
         /9kQ5jmnd1bVePe+z4vgcLY2+Ir+QcqU1ANJsvkYUdRywjYQGi61IcHy1TKMV43d0U
         NdxbZd3lefRSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4AA4CE924DB;
        Wed, 31 Aug 2022 19:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v2] kcm: fix strp_init() order and cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197361429.5324.12479493190239298159.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:20:14 +0000
References: <20220827181314.193710-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20220827181314.193710-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        syzbot+9fc084a4348493ef65d2@syzkaller.appspotmail.com,
        syzbot+e696806ef96cdd2d87cd@syzkaller.appspotmail.com,
        kuba@kernel.org, tom@herbertland.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 27 Aug 2022 11:13:14 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> strp_init() is called just a few lines above this csk->sk_user_data
> check, it also initializes strp->work etc., therefore, it is
> unnecessary to call strp_done() to cancel the freshly initialized
> work.
> 
> [...]

Here is the summary with links:
  - [net,v2] kcm: fix strp_init() order and cleanup
    https://git.kernel.org/netdev/net/c/8fc29ff3910f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


