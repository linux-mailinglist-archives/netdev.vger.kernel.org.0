Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413FB69D7B9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 01:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjBUAuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 19:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjBUAuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 19:50:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652531DB89;
        Mon, 20 Feb 2023 16:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2ADA60F5E;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57062C4339B;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676940620;
        bh=gfs8S9NACaUEPcxaAoym/juXLhMVfF4vdANoBCtZTFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YwszNHkj2OxGwBVcRJurx4BDTwB1GetGh9K653/3d+/ufV3j++obOr36+GIlpSjt6
         qWLNIdM0JxP5706IwnjQ8KJy66xDSxfjLdgw+al5VbBii6r5doABXzd5xmvWkNzhze
         OIf1zQvdCqQB6fatnkTD99NsGW0dMKBrEc667SI8EZXnGFrxyU6xF4brb9w188S0eo
         ndKRcWQ0bg/lM0DUpkjshd5CvEY4XTujWEtMbvtkFrEWF8e+qORRWzHNStwONv81WW
         +XdCOOSObz4QnT+WK/bcfDysVMpmc+W/MDy1nkGsnQLlesdynE1PrZtwl05RIEZV2T
         s9YK2gB7FTxoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37F9EC59A4C;
        Tue, 21 Feb 2023 00:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] sfc: clean up some inconsistent indentings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167694062022.10450.1663212162904892856.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Feb 2023 00:50:20 +0000
References: <20230220065958.52941-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230220065958.52941-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Feb 2023 14:59:58 +0800 you wrote:
> Fix some indentngs and remove the warning below:
> drivers/net/ethernet/sfc/mae.c:657 efx_mae_enumerate_mports() warn: inconsistent indenting
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4117
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [-next] sfc: clean up some inconsistent indentings
    https://git.kernel.org/netdev/net-next/c/5feeaba10631

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


