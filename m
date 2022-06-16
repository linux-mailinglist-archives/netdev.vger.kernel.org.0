Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C49A54D8C9
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 05:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357661AbiFPDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 23:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348243AbiFPDKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 23:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5EA5A16B
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B29B261408
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14156C3411F;
        Thu, 16 Jun 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655349013;
        bh=M+vi7ADH8KCymehA4adHocDHA5puxMWn3N0z17MAqeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rqhnXgOx50mX/ELpqBOS8lrjBlFqLfKnlLfCFxJj+8YsBk/I/c/b2NnJnw/vY18r6
         cneFp7WTsG0WYkmo3m5OC3T/9vpz3k4w6nhZXC1W8Iq8od2aM0zlDbJvpx095gmbqc
         zXRyef3rq/1zZolEGItXAaeSDzx0EYhHtBbcRPR0l1gEf696DQhWv7TrKq2vJsCp0a
         FpvgqOg+NkQJLZ+HYNtcfzwAkYscp4XTtb97TndN0MVTtysUzkJwUsDlOnmJ2jMzMB
         VA65T6MKoxzku8fmHh0HMTODP8tTNHmENHc+OpYuUggNcu36/8LOF/tmV9aiuRJ7cP
         cBDSuwA1ZBKfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDFA6E7385E;
        Thu, 16 Jun 2022 03:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] mlxbf_gige: remove own module name define and use
 KBUILD_MODNAME instead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165534901297.16616.11010417143271832019.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 03:10:12 +0000
References: <20220614212602.28061-1-davthompson@nvidia.com>
In-Reply-To: <20220614212602.28061-1-davthompson@nvidia.com>
To:     David Thompson <davthompson@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, limings@nvidia.com,
        brgl@bgdev.pl, chenhao288@hisilicon.com, cai.huoqing@linux.dev,
        asmaa@nvidia.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 14 Jun 2022 17:26:02 -0400 you wrote:
> This patch adds use of KBUILD_MODNAME as defined by the build system,
> replacing the definition and use of a custom-defined name.
> 
> Signed-off-by: David Thompson <davthompson@nvidia.com>
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next,v1] mlxbf_gige: remove own module name define and use KBUILD_MODNAME instead
    https://git.kernel.org/netdev/net-next/c/cfbc80e34e3a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


