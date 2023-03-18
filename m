Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA126BF7DE
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCRFAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjCRFAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1143113DE6;
        Fri, 17 Mar 2023 22:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3581B826CF;
        Sat, 18 Mar 2023 05:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E911C433A4;
        Sat, 18 Mar 2023 05:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679115618;
        bh=FZnujrGCp1B1CEc+INX4HbI+DIg2aKML9zdPExFTr2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rQ22Acr2mLqdmI68YY2zGJnc0xxq+GDrBto5oASbFEdkJRbrBkOPoN/3G1m0FkqC1
         TPuPoDI+Y3vtT1en2Qa3y/Si2OVaxcuZwsdgjzjUtibjzTKqgrgp6YX5Kygd8/EMpv
         H1Kh5f9uxFLyT7WeqiB10Iv/jCJ+OddmnlQVwMAruCWfZpds0PFPsDe4UsmZcx+VkC
         JagCrVZ4ZJS0+5k3GOaUbGowFOxvTv5BIWd/xl22wO6mZgwc6GreA9EEDGlxDH5RjD
         /pXrCXVrq6uklTRlkM9EorQ21FpTAK/bDW6uIDg5jchSsFDG8GGlO6hG4hVDbUqyMs
         /gBqUOfFx+5TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A73FE21EE5;
        Sat, 18 Mar 2023 05:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 RESEND] ptp: kvm: Use decrypted memory in confidential
 guest on x86
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911561836.25115.1462637997047748542.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:00:18 +0000
References: <20230308150531.477741-1-jpiotrowski@linux.microsoft.com>
In-Reply-To: <20230308150531.477741-1-jpiotrowski@linux.microsoft.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        richardcochran@gmail.com, hch@lst.de
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 15:05:31 +0000 you wrote:
> KVM_HC_CLOCK_PAIRING currently fails inside SEV-SNP guests because the
> guest passes an address to static data to the host. In confidential
> computing the host can't access arbitrary guest memory so handling the
> hypercall runs into an "rmpfault". To make the hypercall work, the guest
> needs to explicitly mark the memory as decrypted. Do that in
> kvm_arch_ptp_init(), but retain the previous behavior for
> non-confidential guests to save us from having to allocate memory.
> 
> [...]

Here is the summary with links:
  - [v2,RESEND] ptp: kvm: Use decrypted memory in confidential guest on x86
    https://git.kernel.org/netdev/net-next/c/6365ba64b4db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


