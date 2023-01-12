Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE4B666A9E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 06:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbjALFAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 00:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbjALFAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 00:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57DD496FA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 21:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD3B61F66
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E030AC43442;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673499617;
        bh=ZR4cvlqG3lET3ErBjMn1CNk7kRMYKQrkBwwGbfVEIqU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p1onlvp5mkRMj5jthUkkMqdDb0i2wqP1RMxCE07CzIjla8eKXff3kO+qn+pOI/9xv
         SuVDA+O8DEjzftsULxDak0+jmyOxMMVWc9YQ3i8s4iYHGC6nn+eS2QqQZfAiPHnlLV
         k4893RUmbwdGCGDhzKB2uWpOaObNwv7oZnPZsCyB/tCBZiAOzxIYqNTdHqnj4rE84y
         NyBz8UzPdDI2KGrBLx9idLsl3ktsNW+tQMnpIX1jVOCl5xHb1UdOpdbP0NcbRm7ZVm
         21NRCukGS6lib35A4N3d0z17/fLl4x+aRCAKeLZvf81Blmm1UnzryveAJBqOxFfRrd
         1xlLwxSAt3H4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA2D6C395C8;
        Thu, 12 Jan 2023 05:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: keep the instance mutex alive until
 references are gone
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167349961782.12703.14335268017706705701.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Jan 2023 05:00:17 +0000
References: <20230111042908.988199-1-kuba@kernel.org>
In-Reply-To: <20230111042908.988199-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@resnulli.us,
        syzbot+d94d214ea473e218fc89@syzkaller.appspotmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 Jan 2023 20:29:08 -0800 you wrote:
> The reference needs to keep the instance memory around, but also
> the instance lock must remain valid. Users will take the lock,
> check registration status and release the lock. mutex_destroy()
> etc. belong in the same place as the freeing of the memory.
> 
> Unfortunately lockdep_unregister_key() sleeps so we need
> to switch the an rcu_work.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: keep the instance mutex alive until references are gone
    https://git.kernel.org/netdev/net-next/c/93e71edfd90c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


