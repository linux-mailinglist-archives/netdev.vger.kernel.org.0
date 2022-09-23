Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8005E791F
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 13:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIWLKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 07:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiIWLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3296A831E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 04:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8998FB8268E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BDBEC433B5;
        Fri, 23 Sep 2022 11:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663931415;
        bh=poCehO/dJQeA7JCNsn/vU3aJT5jstMCwXNY6Et3zuwc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZMayD/2VLHqEOnGjoHrGGmoMVFJG/pYZD/nRV3Dre7SWOoP6NPewa+Cr4pUBckBDM
         C2LyFYXztieSSlzrFZ9BNuybH6WPgx5dSzvWXETbKROwVxPdfff7FIEhwojSPlrTUo
         lfpAT0k6Jzm5cT0LkXlA+W4UJY9Ndu7b7xbp8SCGRsY/37rpDULKIQ/snzlbr4qbVB
         0/ZBivvYSffywHFyBgzHoNzeugj48yBs0VudeFI5MYk13qqaHeSDXQ/OddZLYuta6c
         +0Zq+FFXFXSNXhBE1sb3PUxaIyFLANp2edYobsgDxydGqXngL+Zw/OeMm3/TWbxQC1
         TRJub03lLlQ/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17601E50D69;
        Fri, 23 Sep 2022 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] tun: support not enabling carrier in TUNSETIFF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166393141508.14679.3924285675758726094.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Sep 2022 11:10:15 +0000
References: <20220920194825.31820-1-prohr@google.com>
In-Reply-To: <20220920194825.31820-1-prohr@google.com>
To:     Patrick Rohr <prohr@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, maze@google.com,
        lorenzo@google.com, jasowang@redhat.com,
        stephen@networkplumber.org, nicolas.dichtel@6wind.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 20 Sep 2022 12:48:25 -0700 you wrote:
> This change adds support for not enabling carrier during TUNSETIFF
> interface creation by specifying the IFF_NO_CARRIER flag.
> 
> Our tests make heavy use of tun interfaces. In some scenarios, the test
> process creates the interface but another process brings it up after the
> interface is discovered via netlink notification. In that case, it is
> not possible to create a tun/tap interface with carrier off without it
> racing against the bring up. Immediately setting carrier off via
> TUNSETCARRIER is still too late.
> 
> [...]

Here is the summary with links:
  - [v2] tun: support not enabling carrier in TUNSETIFF
    https://git.kernel.org/netdev/net/c/195624d9c26b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


