Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9554B97D5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiBQEkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:40:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiBQEk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:40:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB0A28423D;
        Wed, 16 Feb 2022 20:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81B10B820FC;
        Thu, 17 Feb 2022 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A34DC340F3;
        Thu, 17 Feb 2022 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645072810;
        bh=w/kIBTH4wjDHcZO+nhzFDNec5Z5PrCVUpyBeTAQQ+88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMUwwK0JpTFaykp6MTpiUTt/T8o0z9aGTS/Gd0zoTvtwtquIWD8NDgIKg2Jv2DcxC
         1vOuKvr2dQINP5RvndX5K2YO4UZOdGwIi5rO+PHhI+kEl6+wwvhcHmNCK9qsARiZED
         5P71tAUQbY4D5ARGdTc1DfNYOtZKpbLCAk+irhqHXuMSXOAr7EXq0BhR0+NJKiXItg
         PjQg9bTHCfnLqY1RUI+KzrD8ZyQrWQduu+dnDAQPw4uJpD1DSmBf29hZVrLe/vHOzk
         qps11GSnDWLiSltSQA8bxr1SfnuVM4vn91rxfxzgbJmWQd+eERAQ92VkjO7xlVVfhi
         pumgm0BfHGfXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31CEDE6D447;
        Thu, 17 Feb 2022 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: altera: cleanup comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164507281019.19778.11154381791982996105.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 04:40:10 +0000
References: <20220215213802.3043178-1-trix@redhat.com>
In-Reply-To: <20220215213802.3043178-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     joyce.ooi@intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Feb 2022 13:38:02 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Replacements:
> queueing to queuing
> trasfer to transfer
> aditional to additional
> adaptor to adapter
> transactino to transaction
> 
> [...]

Here is the summary with links:
  - net: ethernet: altera: cleanup comments
    https://git.kernel.org/netdev/net-next/c/a5e516d026cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


