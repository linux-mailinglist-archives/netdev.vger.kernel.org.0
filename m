Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F676EA8DF
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjDULKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDULKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E4DA253;
        Fri, 21 Apr 2023 04:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B459364FA4;
        Fri, 21 Apr 2023 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C6DAC4339B;
        Fri, 21 Apr 2023 11:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682075420;
        bh=GzRtt8+niVYDbAje/9BY1kw/Tle5l8+d6eUWBp+zJjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XGSy0kUc2IRhz4mlvdvsrvDOTbrRiVYBHqADaAm+PcK6ym03vQLmHj0yXRAV/m+57
         JuVu5Ipc9YWPohxSSZR7CMxKvJsN92Ivse4w7s2Xp63VcxOJW2vuVyLFW84d/MhgZD
         UZ8qssquMIjhlnsWwBzEPn/Iw6ZakxjWRVO7/CXOr/5kOKdlXPT8XjqH9hfEqCqYvM
         fWxe/+vGgvN88eUhLwuSjkDcBGKvxQYRuRTUBZYJ03onl1+RlSJu2HcE3zIc8nfKC+
         pazhhGOfUX760cssrua/y3iYdbOLxjYiJ6k7ZjNV7+10eWzr6J3maKPN89FmgISTb/
         5t7FakDlzuU4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03ACEC395EA;
        Fri, 21 Apr 2023 11:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v9] net/packet: support mergeable feature of virtio
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168207542000.21404.15938428984944516141.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 11:10:20 +0000
References: <20230419072420.315079-1-amy.saq@antgroup.com>
In-Reply-To: <20230419072420.315079-1-amy.saq@antgroup.com>
To:     =?utf-8?b?5rKI5a6J55CqKOWHm+eOpSkgPGFteS5zYXFAYW50Z3JvdXAuY29tPg==?=@ci.codeaurora.org
Cc:     linux-kernel@vger.kernel.org, henry.tjf@antgroup.com,
        willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Apr 2023 15:24:16 +0800 you wrote:
> From: Jianfeng Tan <henry.tjf@antgroup.com>
> 
> Packet sockets, like tap, can be used as the backend for kernel vhost.
> In packet sockets, virtio net header size is currently hardcoded to be
> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
> always the case: some virtio features, such as mrg_rxbuf, need virtio
> net header to be 12-byte long.
> 
> [...]

Here is the summary with links:
  - [v9] net/packet: support mergeable feature of virtio
    https://git.kernel.org/netdev/net-next/c/dfc39d4026fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


