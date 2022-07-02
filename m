Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBABC56411C
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbiGBPkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiGBPkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C209EDECE;
        Sat,  2 Jul 2022 08:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72C0FB803F5;
        Sat,  2 Jul 2022 15:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23B59C341C8;
        Sat,  2 Jul 2022 15:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656776412;
        bh=h6zk8KKZuPNdSZfQrkJS2ee0iyMeWcHf7oUhuZ1Ku1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XKcJMIn5ZT7xx4oRDJynHRo5okETXFCNO7/HngTPcgFdMx/FjU3JwUu89z9JhTDlU
         5aoPjD0ZuNB4tuqmHNVqXTCIyOCTUF1eySgvBa6SSTHg46E7wJj21Z83nJ7w57wHL4
         wL/rf+U1VCAfLAcaL85vdycYKHh9GihmZp3KWcGtbmgEm3f9lnr9uM4bbS1N1nBHf+
         HyJBulPX8ZuFrj+XClBneRVk82MKc2wyh3Mp7CnbE5iIo8hmYNhcxQ/KAOgWaZejMj
         brfnBU9TmSnZ5mV2rPJl8+DNy8szHy9WiezIyJnklt9Cf3Y+jAdZ/7rnr64+uQyoIa
         osznEe1ePSJOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08014E49BBA;
        Sat,  2 Jul 2022 15:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] MAINTAINERS: add Wenjia as SMC maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165677641202.21073.15223725238141900671.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 15:40:12 +0000
References: <20220701184143.1216274-1-kgraul@linux.ibm.com>
In-Reply-To: <20220701184143.1216274-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        wenjia@linux.ibm.com, wintera@linux.ibm.com
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 20:41:43 +0200 you wrote:
> Add Wenjia as maintainer for Shared Memory Communications (SMC)
> Sockets.
> 
> Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>
> Acked-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] MAINTAINERS: add Wenjia as SMC maintainer
    https://git.kernel.org/netdev/net/c/3d5a2a396f19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


