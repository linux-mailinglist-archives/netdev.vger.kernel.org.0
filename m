Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9040052A047
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiEQLUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiEQLUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B376349256;
        Tue, 17 May 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C59EB8182D;
        Tue, 17 May 2022 11:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E045BC34113;
        Tue, 17 May 2022 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652786412;
        bh=CVxttAFmO9EwuPVTa/T0dZ6kSHLrNOwxh2WheZw3SRE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YmH86uXSZjoxW59/EbrvGy8lfFSQpVHDRNsJ8BWgTo4FdbBwJCv82ZiMU80Q+EBMP
         O1nhpp2I18dY8DvplmeShWILXYYbB/MhPXMcQhM8bmGRpG9CkNvm+nmAVcUCN9i2pB
         PAS1IMgq3F0I6TyAr2OKV2grhzQuU+bU525X2fHRArx/6GmwVCYAwM/456HLCE6aLc
         H/NEzIHIbaDPACNX13AjDWth8H2W7gmQC5Y6MC1zLkWg2+BBNOfTVnRNy8kKZfEx7m
         /VTK7md1jlMmWBOv2YspRLjodALcX9vWNQsemVdSXblgtJC3QS8bv74MjQNZAoxaD4
         nS9ecvPusGMxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8EC6F0393B;
        Tue, 17 May 2022 11:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Remove unnecessary synchronize_irq() before free_irq()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165278641175.14620.8454368700251217393.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 11:20:11 +0000
References: <20220516072646.1651109-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220516072646.1651109-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 May 2022 07:26:46 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Calling synchronize_irq() right before free_irq() is quite useless. On one
> hand the IRQ can easily fire again before free_irq() is entered, on the
> other hand free_irq() itself calls synchronize_irq() internally (in a race
> condition free way), before any state associated with the IRQ is freed.
> 
> [...]

Here is the summary with links:
  - qed: Remove unnecessary synchronize_irq() before free_irq()
    https://git.kernel.org/netdev/net-next/c/29fd3ca1779f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


