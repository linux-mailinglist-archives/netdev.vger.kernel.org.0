Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5471864A8A4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 21:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbiLLUU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 15:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbiLLUU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 15:20:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EF82670;
        Mon, 12 Dec 2022 12:20:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BD8B61211;
        Mon, 12 Dec 2022 20:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA7D7C433F2;
        Mon, 12 Dec 2022 20:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670876424;
        bh=h/jRYsCXYY7+/lZzMDWtrQnCsIy0owko6XeDBt8jCcA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=noVBljFgtwg5DQfT2G7FKSZ0tOi7K6RJBFkuaBadrHMgHpCs9uTqae50hP5IEPT8L
         JkOxttbxoZDy/Kdgc/EdeXfx+8MsbaKyGnoic6jChkJ0y8h4RRHA3WJiA4OLYfEUae
         IDJ74tuN7vh/Z0wYa0xLma/mE91qrFJNd81cWGJinOxN3pljnBOrMqrZELoo3JGtqk
         fvk1cHEkrgNcupwhIITkvSnOqKogj0P7RCYtM/Qt5zZ/4LJrZRCxL1d/6SJOvNWEuX
         GSsMkK+XGXb8wm3oihEODQqpbTQrUxhspmi9M0LWBbHMW5tDlSLWtNSIVy4Zncbro5
         Fm9z2G7uLq7iA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1673C197B4;
        Mon, 12 Dec 2022 20:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-12-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087642465.1714.13161592634488078251.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 20:20:24 +0000
References: <20221212024701.73809-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20221212024701.73809-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, martin.lau@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 11 Dec 2022 18:47:01 -0800 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 74 non-merge commits during the last 11 day(s) which contain
> a total of 88 files changed, 3362 insertions(+), 789 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-12-11
    https://git.kernel.org/netdev/net-next/c/26f708a28454

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


