Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5B153B5E1
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 11:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiFBJUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 05:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiFBJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 05:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6E6A76F1
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 02:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89831B81F09
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4996EC34119;
        Thu,  2 Jun 2022 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654161612;
        bh=PAzbuhkBNDD3CRcCiH253fQ5b1HtzOgWO5OQn1wOzuY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YlV0l9Y+wZaG0S5/PseM24BX28NeeXXGPILBOKHty0ZefK1rEstFnyfKRuiNSodXp
         ZrJI4h0ftUt4QJy8g9xT8MJb0atxJMXDADqvrfcWjIZW7EzD9++41iPh7AtdfDm1U/
         ODV0q8AH4Biwg0tI29iL98/NNB1eqyt+WprzOCzVZDuPmuBO8aCO2wtYOPXQ1z1bvY
         sHB3U3+nKxo+DSYI/2/JOwC9th+PNrN5SBuQWb8EWSR6Bw0hzKfJ0fdjdKj58tKlR2
         HsHNPjOJtxIa0R6q2vdNBxwjVzFY5rQknSK9ez74C8yWq3XVdWOIvVZ4IAS97cngcz
         b59KolJww4jkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DADBEAC09C;
        Thu,  2 Jun 2022 09:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: remove padding in nfp_nfdk_tx_desc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165416161218.32767.15113905894428510049.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 09:20:12 +0000
References: <20220601083449.50556-1-simon.horman@corigine.com>
In-Reply-To: <20220601083449.50556-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, fei.qin@corigine.com,
        yinjun.zhang@corigine.com, louis.peens@corigine.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  1 Jun 2022 10:34:49 +0200 you wrote:
> From: Fei Qin <fei.qin@corigine.com>
> 
> NFDK firmware supports 48-bit dma addressing and
> parses 16 high bits of dma addresses.
> 
> In nfp_nfdk_tx_desc, dma related structure and tso
> related structure are union. When "mss" be filled
> with nonzero value due to enable tso, the memory used
> by "padding" may be also filled. Then, firmware may
> parse wrong dma addresses which causes TX watchdog
> timeout problem.
> 
> [...]

Here is the summary with links:
  - [net] nfp: remove padding in nfp_nfdk_tx_desc
    https://git.kernel.org/netdev/net/c/c6fbbf1eae8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


