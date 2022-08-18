Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDA8598A98
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbiHRRkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345175AbiHRRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE7467475;
        Thu, 18 Aug 2022 10:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA9661727;
        Thu, 18 Aug 2022 17:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1801C43141;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660844436;
        bh=dhx9HrKlGUFYVgsBoFTlqHauQLHY8DsGHnvTarCNASA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IHoTq0qySSJVSYIWrpq7lGzuqyUwF5CHqq3cVTRK1IOLTYcgtpmjH/22DgGS8byhX
         P1kqd9C/Mm2wZWyFZYjemuHv+drtuMOBIlzUsXoTXloaJel4F3SWHrw50JTEF/UhaJ
         mjDm+bzf5u6uBRI63wK6U3McL7Vcy2a5E4wOk8Um47YfmejkIIQbGpWKoZntL4vI53
         PpNJiZ9aAzjmq2a1yG5WE9lDwR9LiqrX9OKLHxc5mDiOpISEE2aQGbRobseLL78vjI
         /SXN23yS8rB6vmOCGv0m4MnbFM5PsFIhUelKdSlATCfwVu6uTvz1sQ/1z9gLICiNVa
         ysrnKrB4mqk0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF2C2E2A04D;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: altera: Add use of ethtool_op_get_ts_info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084443671.19225.5767240093658511173.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 17:40:36 +0000
References: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20220817095725.97444-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        richardcochran@gmail.com, joyce.ooi@intel.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 11:57:25 +0200 you wrote:
> Add the ethtool_op_get_ts_info() callback to ethtool ops, so that we can
> at least use software timestamping.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  drivers/net/ethernet/altera/altera_tse_ethtool.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: ethernet: altera: Add use of ethtool_op_get_ts_info
    https://git.kernel.org/netdev/net-next/c/fb8d784b531e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


