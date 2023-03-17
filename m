Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680DC6BDDC1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCQAkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjCQAkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C26660AB4;
        Thu, 16 Mar 2023 17:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F361A62171;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 490DBC433AC;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013618;
        bh=kLF5REoq5KTLCkWsgxOg2WtQwQnz3Yh1YZnJcKwZASQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EgjX4BrPFVqJ4tsfyZUPdVOrNh2OOeAIzl14nHr/w46hdqiy9zOnpPVvyLfnOKfdA
         mgbEEl0Juup1mT6JGcFQVaMW1L0bwlfHQTrP3VkgjsHoOtpq26Ewh23Zl4Rdl4LR3t
         hqHUH5Uv6KN0mECpX+1A+bRoyf3qQLiB7SuqgLhUHxKDlBHl9Cb8FcsLBVPQL0n2DM
         yk7ebvZot8Y7WnjRN7ctI/QJzD1fA7IKc36kr0jMbqO4nNBMW2ng2X9qY5VdCsGmo3
         W16JW/JxZZXWVh1PMpQoJt93dBGLAEbRCLeKeabGdO1PkxbqVb7if98B6cOGQGYOJk
         i/+p1QOGU+JAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AF1FE4D002;
        Fri, 17 Mar 2023 00:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/iucv: Fix size of interrupt data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901361817.32704.5118349866497069446.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:40:18 +0000
References: <20230315131435.4113889-1-wintera@linux.ibm.com>
In-Reply-To: <20230315131435.4113889-1-wintera@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 14:14:35 +0100 you wrote:
> iucv_irq_data needs to be 4 bytes larger.
> These bytes are not used by the iucv module, but written by
> the z/VM hypervisor in case a CPU is deconfigured.
> 
> Reported as:
> BUG dma-kmalloc-64 (Not tainted): kmalloc Redzone overwritten
> 
> [...]

Here is the summary with links:
  - [net] net/iucv: Fix size of interrupt data
    https://git.kernel.org/netdev/net/c/3d87debb8ed2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


