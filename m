Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186104FF5B3
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbiDMLcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbiDMLcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:32:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936A427162
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3133761DBA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 953BBC385AE;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649849412;
        bh=8sDcW5qT0Oeb3Nvu25uqQG9qgwiCGA84V5gic6khEh4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UZ4aScqNgU2W7iuueqQeEyK8sDvw+v4Lq8dKwLAGrAvReG5Kg24WWmXi7u3Zjr4oo
         l+r+vYYDIGE3SnxRi4sWL6J0P2GitJG1GL9wH0T6ZIdKFUzY31fFw/61QFkpV0T1KA
         HpJCu8KCSGRXim8TbK43DWNgAwRbdLgI/+CvWGvNdUC+C/AJdNJZR8YpB62QCWTF/P
         1a9H+L1qycrLJjrds+aq4G1SX+K2cAxq0b/AZZI0MVCc6c5STa5R8Q8UQ7A67I6J6d
         LqhWXCXP5VTV1e5rhencHYUV+3XDPvS3bfnQ/W3RPEN41H0K/FwPFJrwlQpBkCkgjU
         O/v6KYt06KrWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76569E7399B;
        Wed, 13 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] selftests: net: fib_rule_tests: add support to
 select a test to run
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164984941247.14313.16322981326733066908.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:30:12 +0000
References: <20220412020431.3881-1-eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <20220412020431.3881-1-eng.alaamohamedsoliman.am@gmail.com>
To:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com, roopa.prabhu@gmail.com,
        jdenham@redhat.com, sbrivio@redhat.com
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

On Tue, 12 Apr 2022 04:04:31 +0200 you wrote:
> Add boilerplate test loop in test to run all tests
> in fib_rule_tests.sh
> 
> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
> ---
> changes in v2:
> 	edit commit subject to be clearer
> 
> [...]

Here is the summary with links:
  - [net-next,v2] selftests: net: fib_rule_tests: add support to select a test to run
    https://git.kernel.org/netdev/net-next/c/816cda9ae531

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


