Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8D692E2F
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 05:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBKEAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 23:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjBKEA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 23:00:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE97D7FEE5;
        Fri, 10 Feb 2023 20:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EA76B825DF;
        Sat, 11 Feb 2023 04:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC7CBC4339B;
        Sat, 11 Feb 2023 04:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676088024;
        bh=BIOwoFFEyE0fql2wRTnno5IsnE1PUXsCgYgbEeyrOZI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=du/bZS1NWSPfgdAQvseMTqH1IBhXLiVjWbIIbWragbxsX6uopViEttr7YkGauyqRH
         mnSadiy03uQzgaeGMVcgRR+w8J1dohr4lrqE+zYNyiCmtRFRjUG0iEZ140VcCVTvee
         J54WXQsuKC1aIdep4GHZt8XlJp6s/935bh6WgFqYo925dzqfGrmDXzZCF7rCGuXu+G
         PCwJNA+Rqn7kuKxGCwVoG5/ynldnRYwHpY+y/TX7/a59v5YRfO6EJ2uPBHapjZ+ugH
         xZ8vic5euoCKqqZQSsZPQJHITqYje1RI17as1CfiFFxx3qn3iqzlpcZEL4zECc6dm1
         oW30Hm8mhjy4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CDBBEE21EC9;
        Sat, 11 Feb 2023 04:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] s390/net: updates 2023-02-06
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608802383.32607.10231428417543515199.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 04:00:23 +0000
References: <20230209110424.1707501-1-wintera@linux.ibm.com>
In-Reply-To: <20230209110424.1707501-1-wintera@linux.ibm.com>
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Feb 2023 12:04:20 +0100 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net-next
> tree.
> 
> Just maintenance patches, no functional changes.
> If you disagree with patch 4, we can leave it out.
> We prefer scnprintf, but no strong opinion.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] s390/ctcm: cleanup indenting
    https://git.kernel.org/netdev/net-next/c/dd4e356c387c
  - [net-next,v2,2/4] s390/qeth: Use constant for IP address buffers
    https://git.kernel.org/netdev/net-next/c/180f51317432
  - [net-next,v2,3/4] s390/qeth: Convert sysfs sprintf to sysfs_emit
    https://git.kernel.org/netdev/net-next/c/dde8769b1211
  - [net-next,v2,4/4] s390/qeth: Convert sprintf/snprintf to scnprintf
    https://git.kernel.org/netdev/net-next/c/74c05a3828fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


