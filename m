Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDEE534A2A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 07:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbiEZFKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 01:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiEZFKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 01:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF3ABC6E4;
        Wed, 25 May 2022 22:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A641661A22;
        Thu, 26 May 2022 05:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCD25C34118;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653541812;
        bh=R0Ebxv8lXFQ/RVHZfkbBb9OGmHlz+FwVvB+dTGMmpTs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gq8SMsK3dCvgq7sff7Kf0evv143LX/6LZC8ms7BM4TbP7I/+3NJnGXM2ZkgGTL+1A
         IKPJNcTHhZXroapDLJkZrR5KohYU2aTuuxrK46iiCRxcStsxoyUUKze+33cs0TgPYU
         DwFY4XYmZ7lLMAAFwoVKpbL9fOI2KIgbURHZXJ4fJvKoBA/jP5tjQ3Sqvp8hl3LsP2
         7aQ3ZRDA2Vo6DRxYaoWoOfwbpqjml23/Jilew2N4x/gy3fWL57H97C4FMChBDe0Vq/
         kxLD/ilsKGfpg3BlryDHTa5CQX7M0RsiTaBRgj6vVDctwNA5SEh5isyRRqKrfyhiM5
         PsBPbYkkqKGMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2A70F03938;
        Thu, 26 May 2022 05:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is
 unavailable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354181272.23912.6206348269992645590.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 05:10:12 +0000
References: <20220525085408.812273-1-liuyacan@corp.netease.com>
In-Reply-To: <20220525085408.812273-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ubraun@linux.ibm.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 May 2022 16:54:08 +0800 you wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> In the process of checking whether RDMAv2 is available, the current
> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> smc buf desc and register rmb, but the latter may fail. In this case,
> the pointer should be reset.
> 
> [...]

Here is the summary with links:
  - [net] net/smc: set ini->smcrv2.ib_dev_v2 to NULL if SMC-Rv2 is unavailable
    https://git.kernel.org/netdev/net/c/b3b1a17538d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


