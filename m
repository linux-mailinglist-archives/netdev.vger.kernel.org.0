Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5BF572BFD
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbiGMDkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiGMDkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584EFD8609
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 20:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4DA061AF5
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 03:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C4DAC341C8;
        Wed, 13 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657683614;
        bh=OhC4PYLHSbajqMcmbiKV4uxDrsTBolmU+gffwBp4Gsw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O+KAx284Hb30Qrc+EpSlTsf8mnOx/MFgcN0SEvvPJhbILreRh09NMrErUopY+DzDg
         y9TEyy2b0tzH4gWgYheg3moyA4LfgfYZG4T/hjG+caJZenimuHYEqcb3Qiw2ZRYbxw
         wOhdR760l4FhBwUfLERJlNzV5cKumTIbvXoWCh/8v8EHYrQLoIzw3wV2jxQEV7Qo+u
         PmmVFbPEGvhZiBXWnu+xEtPGZE1WhrcLlenb6t0ZLdJ+KCXkpqiEPp/vys4QNtYKA4
         YDN7T6SHW3UT/6ia7tFd64auBevrCXSM/9+zx8C9hnpnIAUei2F+uSESvsntHa6g84
         J4O8oVOQhBD3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1CF18E4522F;
        Wed, 13 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] bnxt_en: 5 Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165768361411.7782.8803187175389482103.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 03:40:14 +0000
References: <1657592778-12730-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1657592778-12730-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Jul 2022 22:26:13 -0400 you wrote:
> This patchset fixes various issues, including SRIOV error unwinding,
> one error recovery path, live patch reporting, XDP transmit path,
> and PHC clock reading.
> 
> Kashyap Desai (1):
>   bnxt_en: reclaim max resources if sriov enable fails
> 
> [...]

Here is the summary with links:
  - [net,1/5] bnxt_en: reclaim max resources if sriov enable fails
    https://git.kernel.org/netdev/net/c/c5b744d38c36
  - [net,2/5] bnxt_en: Fix bnxt_reinit_after_abort() code path
    https://git.kernel.org/netdev/net/c/4279414bff8a
  - [net,3/5] bnxt_en: fix livepatch query
    https://git.kernel.org/netdev/net/c/619b9b1622c2
  - [net,4/5] bnxt_en: Fix and simplify XDP transmit path
    https://git.kernel.org/netdev/net/c/53f8c2d37efb
  - [net,5/5] bnxt_en: Fix bnxt_refclk_read()
    https://git.kernel.org/netdev/net/c/ddde5412fdaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


