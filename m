Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEB56B223F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCILGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCILE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:04:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CBDEBAC7
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 735B061B07
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9250C4339C;
        Thu,  9 Mar 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678359618;
        bh=g3WzUKLsveh7tUVzJ7AvTpOp1csLjQenXHsL/HnUmMw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nI8KsCZ6Qyi5SqHRnpM5ZAyZegxYa6s1R5FO9p1GHp3IKy1IX4Kxv42PJcwzh+WKU
         3EdSMF5P1gvbKW/UurXjawISg3riQkCJXyNWH/JaYU3fIjk/WwS8F6jcYkhiA2FS6P
         EJKiQ8iMjPgQHkcZeE0V+DzPOukP67J68msXwEZ5f1YSfDJ7mj/DN0/c9vluuzBpYH
         StGRGah3IhadhDGCOqFMNadkocMzD3MOtqIdTbALTU+GtlAZvuGle9xjuf+GTOibAM
         ZKnaLqtnGDjkWmgq1gZPmLCGZX9yeV8xjeF7RX6iH7qAvtMuQbFsG3KC7Cnhq5YUdL
         bne15jth5z4hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9E33E61B60;
        Thu,  9 Mar 2023 11:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-07 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167835961869.26114.12268235898612114211.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 11:00:18 +0000
References: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230307220714.3997294-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  7 Mar 2023 14:07:11 -0800 you wrote:
> This series contains updates to ice driver only.
> 
> Dave removes masking from pfcena field as it was incorrectly preventing
> valid traffic classes from being enabled.
> 
> Michal resolves various smatch issues such as not propagating error
> codes and returning 0 explicitly.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ice: Fix DSCP PFC TLV creation
    https://git.kernel.org/netdev/net/c/fef3f92e8a42
  - [net,2/3] ice: don't ignore return codes in VSI related code
    https://git.kernel.org/netdev/net/c/c4a9c8e78aad
  - [net,3/3] ethernet: ice: avoid gcc-9 integer overflow warning
    https://git.kernel.org/netdev/net/c/8f5c5a790e30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


