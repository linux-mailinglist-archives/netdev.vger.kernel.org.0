Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CF458098C
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 04:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbiGZCkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 22:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiGZCkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 22:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F43ECE2A
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 19:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA6FDB81188
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 02:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D6BAC341C8;
        Tue, 26 Jul 2022 02:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658803213;
        bh=RuYKfal1ndK51BRNPweEMTVkUBtZe9waIMXtmJBM+1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ttnce67KJ6tSNDXb8FFLz7kkG11TX/gG13tSfrf0qCA+FtFfRc/lnte76KVCqtQxk
         7sg5BJ1/o4UYXxGi4l4cJD35TiCokfoKIiHBUKdVzFENTtMl8JFDCcEbh9KvRi6zyE
         rJfTxH3k9SZ9Nt4jXLhTLYCkzWpqac89KAs12WcmKEYioD5vBQx+4GkzRgX+y6XkNQ
         QY3M5XVbtj/w2IX1BMs6eq17Q88NvoykIUCib3Uq3dLQDw0ncxjcTNBO8lKaUyujJ+
         89RD1FQwQQDxf6sCbtlemGwE7+5Jm6o8VIkz1D9HoQSVutTFRlbD1vdgFTlgyxrypa
         RxcqSlsoMFOdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78625E450B4;
        Tue, 26 Jul 2022 02:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] i40e: Fix interface init with MSI interrupts (no
 MSI-X)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165880321348.6105.11833135924009497931.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jul 2022 02:40:13 +0000
References: <20220722175401.112572-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220722175401.112572-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michal.maloszewski@intel.com,
        netdev@vger.kernel.org, dawid.lukwinski@intel.com,
        david.switzer@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 22 Jul 2022 10:54:01 -0700 you wrote:
> From: Michal Maloszewski <michal.maloszewski@intel.com>
> 
> Fix the inability to bring an interface up on a setup with
> only MSI interrupts enabled (no MSI-X).
> Solution is to add a default number of QPs = 1. This is enough,
> since without MSI-X support driver enables only a basic feature set.
> 
> [...]

Here is the summary with links:
  - [net,1/1] i40e: Fix interface init with MSI interrupts (no MSI-X)
    https://git.kernel.org/netdev/net/c/5fcbb711024a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


