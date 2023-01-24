Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAE1679F5E
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjAXRAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjAXRAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333B749010;
        Tue, 24 Jan 2023 09:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8EE7612FB;
        Tue, 24 Jan 2023 17:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E43CC4339B;
        Tue, 24 Jan 2023 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674579617;
        bh=0mdBqOaGxrGpmdzYMLaDHhGtE93u/9sKj5cOcfbwmqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N6So2sNxv0pD+/xv+ezuLEL8Bx5Yta14R1cbueBYitrnxl7TrroMCMxjPd2Vm+HM/
         0cblVlN1boojmz998u1YWOhJ2qZudJu8c8GwvaNW6vLJxtlTKbWoniOgZ+urnby0q3
         9zew1esLPEUYLBWvNpU3Jr0i2y8BksAwRM4svR2vORTsVWckvRHOgc8+gMa0xpxwcv
         HdZuU2GMw7Sp9S5WUZmjecHBfFYhjQxAiDIL4KWlhCcmlNfq4mT6r/FVB2YZDH71fW
         aUHBQJyZL6CmMFJHydk4i7ut3M0/ejUN9hip1mhYxeWRriCxt/LyGcCmy+5xkEA02i
         aJLEEu57E7bmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EF1D9C04E33;
        Tue, 24 Jan 2023 17:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167457961697.3675.10110367704789296061.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 17:00:16 +0000
References: <20230124100249.5ec4512c@canb.auug.org.au>
In-Reply-To: <20230124100249.5ec4512c@canb.auug.org.au>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
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

On Tue, 24 Jan 2023 10:02:49 +1100 you wrote:
> Hi all,
> 
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> In file included from net/ethtool/netlink.c:6:
> net/ethtool/netlink.h:177:20: error: redefinition of 'ethnl_update_bool'
>   177 | static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
>       |                    ^~~~~~~~~~~~~~~~~
> net/ethtool/netlink.h:125:20: note: previous definition of 'ethnl_update_bool' with type 'void(bool *, const struct nlattr *, bool *)' {aka 'void(_Bool *, const struct nlattr *, _Bool *)'}
>   125 | static inline void ethnl_update_bool(bool *dst, const struct nlattr *attr,
>       |                    ^~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - linux-next: build failure after merge of the net-next tree
    https://git.kernel.org/netdev/net/c/d968117a7e8e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


