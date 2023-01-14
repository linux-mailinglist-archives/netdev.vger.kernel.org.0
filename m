Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D87066A973
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjANFk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjANFkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8F13A90;
        Fri, 13 Jan 2023 21:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C54CB822D9;
        Sat, 14 Jan 2023 05:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C15E7C433D2;
        Sat, 14 Jan 2023 05:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673674816;
        bh=riDHRRZIXAVOQRC0kftpaNw9qgUv5ftVi3KjpAu4yRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NYOeQx8sFJDX5pqc5wkLxO3o23ZtB5y7bM87008/5oHdkvrZzUnD8YUr3xc/TzjCB
         PCl/JHw2m+FO8uVJ80gvvnkNZFg18b7L2Y8bcc6SevsNyNVsZKuu1Ty4AXJBeHoS1a
         Lhd3+a+g2gSCELFiPnrA6qm8CB3TZZmPCBvVQVis0OZRwaoo0M9h2VTxY2waTZ9gAE
         uPvAza6uUhPjLZaSh6bLkKMBDlafDTL2ZPVZZRMyiD7rowBmeMz1mFfmKuiCB+vRgA
         duKK/kCvX4f/GmpTZPjoruF/YXgN1Dp9Tj/4sJwQN5IoeaONNpG8JghBM0tdruYI3g
         2kb8aFEgYEVPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A565BE21EE0;
        Sat, 14 Jan 2023 05:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5] net: wan: Add checks for NULL for utdm in
  undo_uhdlc_init and unmap_si_regs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367481667.11900.5215482730586989034.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:40:16 +0000
References: <20230112074703.13558-1-eesina@astralinux.ru>
In-Reply-To: <20230112074703.13558-1-eesina@astralinux.ru>
To:     Esina Ekaterina <eesina@astralinux.ru>
Cc:     qiang.zhao@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 10:47:03 +0300 you wrote:
> If uhdlc_priv_tsa != 1 then utdm is not initialized.
> And if ret != NULL then goto undo_uhdlc_init, where
> utdm is dereferenced. Same if dev == NULL.
> 
> Found by Astra Linux on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [net,v5] net: wan: Add checks for NULL for utdm in undo_uhdlc_init and unmap_si_regs
    https://git.kernel.org/netdev/net/c/488e0bf7f34a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


