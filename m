Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E5D5A8B5F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 04:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbiIACUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbiIACUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE7A3D5A0;
        Wed, 31 Aug 2022 19:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B06A61DBA;
        Thu,  1 Sep 2022 02:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBD12C433D7;
        Thu,  1 Sep 2022 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661998814;
        bh=nyJI2z9EHK64mjYg4+Lo0rp+lglKWfRZqLuc/rI6Dmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TtXNvSak3H0rZyELWzRaj20KTXp3j5W1GTLV8yXMX156a+fqCgsFDBhhJribY2pzF
         47Qg+Yfctf5UKEpHF/qmxEtUtNVZ3YqFhfJIPhrGHnSZAxBcBtk09VB/uSKNaBb3UK
         vw4jKM+9XaUfZcwI7DyAc9kmrKMuBKgPDbOcyLm+n9z7QZ6zyhBWLoGfFF9mVqp1Bi
         oOeUMwH5qYHTvzQVW3ZBvvVLwNl6GwBFcD4ytgDAIRZifwhabsHtS2AznXXM4yRDmF
         u83DtL08lOdRR9EKMWAF4WJqYCyQpPGH9rLWr6pbMA7ODgoUJ4tS/CvImwBnsnNG5+
         TvTnhbXFmu+iQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF99CE924DA;
        Thu,  1 Sep 2022 02:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/rds: Pass a pointer to virt_to_page()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166199881471.11608.5977053963843063287.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 02:20:14 +0000
References: <20220829132001.114858-1-linus.walleij@linaro.org>
In-Reply-To: <20220829132001.114858-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        santosh.shilimkar@oracle.com, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
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

On Mon, 29 Aug 2022 15:20:01 +0200 you wrote:
> Functions that work on a pointer to virtual memory such as
> virt_to_pfn() and users of that function such as
> virt_to_page() are supposed to pass a pointer to virtual
> memory, ideally a (void *) or other pointer. However since
> many architectures implement virt_to_pfn() as a macro,
> this function becomes polymorphic and accepts both a
> (unsigned long) and a (void *).
> 
> [...]

Here is the summary with links:
  - [net-next] net/rds: Pass a pointer to virt_to_page()
    https://git.kernel.org/netdev/net-next/c/a60511cf1520

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


