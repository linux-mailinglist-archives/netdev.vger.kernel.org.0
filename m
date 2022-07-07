Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DED569872
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbiGGDAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234880AbiGGDAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66A02F66A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 20:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4305D62154
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94DC8C341CA;
        Thu,  7 Jul 2022 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162813;
        bh=hyOFysqIq5/4O0E1SplOOFrjG+3bJVNSCk27OTHBhgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U5xvNbcfn8kIfZkNQ5ooD9yJ++WBrHKQYrK7AWhpXCBpeekVP14V4mu9f/xzNaHOR
         wv9hwSrp1L3bpG60uvTMLeI3gDsVsnH6ztFdUkfC3nBGJ+vxeGaSv5TbkZa1Sje+FY
         tdPPCJqFX+E9C+H2TNToanhkmVWRJ5vR/lIXutOG7TLhKeW+i4Ilci3T1Dq06LAra/
         CZNMw6SjMJz4I17qsCGIedb96aVHxpqRbMzQRgjP5UO6i+N/M7kuwzaT7jYeJ9AarR
         3sniedGL1iX1DT80NTlZpBLfeT+fGXfcKPMvwJFXBFWyhJKFG/n5JxPhsMw6LZnFol
         SW55HhJyGVQbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76B79E45BDF;
        Thu,  7 Jul 2022 03:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] r8169: fix accessing unset transport header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281348.11165.7112653671884631678.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:13 +0000
References: <1b2c2b29-3dc0-f7b6-5694-97ec526d51a0@gmail.com>
In-Reply-To: <1b2c2b29-3dc0-f7b6-5694-97ec526d51a0@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, erhard_f@mailbox.org
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

On Tue, 5 Jul 2022 21:15:22 +0200 you wrote:
> 66e4c8d95008 ("net: warn if transport header was not set") added
> a check that triggers a warning in r8169, see [0].
> 
> The commit referenced in the Fixes tag refers to the change from
> which the patch applies cleanly, there's nothing wrong with this
> commit. It seems the actual issue (not bug, because the warning
> is harmless here) was introduced with bdfa4ed68187
> ("r8169: use Giant Send").
> 
> [...]

Here is the summary with links:
  - [v2,net] r8169: fix accessing unset transport header
    https://git.kernel.org/netdev/net/c/faa4e04e5e14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


