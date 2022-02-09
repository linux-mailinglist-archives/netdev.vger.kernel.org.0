Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD46A4AE944
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbiBIF1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbiBIFUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282B8C03C1A8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C31B81EDA
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88B0DC340F0;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384033;
        bh=UBGy6kwi8/dePCwL4c2E8/tl8DzpaSLIGK6OSZrJS+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jG25TX6rteEoWnBMGsAJSZjzVstB16eMID4QcfddHQvZoOLXhZFQFmGiQAFO26WBs
         gTx+XDDRwRFexqNkjz40YEki44kcFI+UzJPN623svJbdnzcznaknOBWGrnSn0b+lfx
         RbW4OCIGdlEseCIleMXLvkeyKMlGEEu9fapmfCQP+kDLVlj+hxnJa59zMfvuErirp3
         Hu7wBw3iemvhHscwTL8GqF3lfIaJAAj4uk7Vg5wqVx2jJl3QbQ8VXqyzgfdTzkcrGo
         qiUW24dC1yDLINsAVtQPAT0SpL5k3CxIBSZ+CmBEhFn1/br/ntyf5Ec3E+Fx88G7MP
         FDJ+Hb7Jweaug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7763CE5D07D;
        Wed,  9 Feb 2022 05:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] et131x: support arbitrary MAX_SKB_FRAGS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438403348.12376.16261380897692368480.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:33 +0000
References: <20220208004855.1887345-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208004855.1887345-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Feb 2022 16:48:55 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This NIC does not support TSO, it is very unlikely it would
> have to send packets with many fragments.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] et131x: support arbitrary MAX_SKB_FRAGS
    https://git.kernel.org/netdev/net-next/c/99f5a5f2b948

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


