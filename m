Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA734F6666
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238442AbiDFRHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238529AbiDFRGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F58123211D;
        Wed,  6 Apr 2022 07:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C282FB82436;
        Wed,  6 Apr 2022 14:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7102FC385A8;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255413;
        bh=icIJTMtIxjoHsHy/UFVMz3ivUvtOztilnj6bZ6ZdNwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TOMeDQa+oCyCD1c6W54vR/9FZPMfrb+dd7KvXbXnfuUM9cnBccWWr58+q3KjM8cSi
         B5LBok5SuXl8JNP6d5PckBNjX5Z1tv3RQ/LOQTaCglwvc2R3XeXsdKLj/tdKuuzv00
         rvCNZKwdz3OCUXIJIRbrz5JTOpskIIn//ddXoBX2sfJjnI8XeDEXb503xIbjEW+8LM
         sB4/7MVTANzBs99aZf3kd/jBPT5uMbso9JqRAJSddGgchgy9To0SslvteQ39tvDgsv
         YCCr8nYwIFLz8OFBhIJkLNb8x6OmmLAiJcla3hIPPyJieQ+bRBJ4FtS7bXiOer36ga
         ufPAs918Wf/Xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 58D1BE4A6CB;
        Wed,  6 Apr 2022 14:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND] net: ethernet: xilinx: use of_property_read_bool()
 instead of of_get_property
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925541335.21938.2629519087642040461.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:30:13 +0000
References: <1649236646-4257-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1649236646-4257-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 02:17:26 -0700 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> "little-endian" has no specific content, use more helper function
> of_property_read_bool() instead of of_get_property()
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] net: ethernet: xilinx: use of_property_read_bool() instead of of_get_property
    https://git.kernel.org/netdev/net-next/c/be8d9d05271c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


