Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF886E573D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjDRCAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjDRCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE2DA8
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA1D6296F
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A2ABC4339B;
        Tue, 18 Apr 2023 02:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681783218;
        bh=OZlu3KfsfT3YBL1OSen9nNGscQo5ESSrVa/hDqJA6p0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mEW7SEqrt0YxwO1kAYvE9cSr8yIFFQZAiIwpwTEX6yvxcdUKoNK5g20ywrOMLAvvJ
         Ju6uwRQ9KY6U1H3aOivQxp03LQbneajjr/S7fyafakcuaORAjzxSgLWfAwBMFbpoo7
         jQwDCNcVEc/TcocE0ZvfKZdlHr7Xfsk95VNQi5pOhUjhpGnX8BgKRuSrT9xb/jSwBz
         yXdpK4dcBudGUBl4VGXB6NgiHkupO0AzmfCZoy/ydK5awE2wpkdgnWCS6Yqx+hyFDo
         hTzJb5Kkd5CXRa2WsvWijdAaTNEYQwWoaaJjkh4HBfq+D4mE7Ovby0QWaJxAGtWP72
         pheM5Z7B+y+qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FDBDC40C5E;
        Tue, 18 Apr 2023 02:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ice: document RDMA devlink parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168178321832.31657.3459352937332973443.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 02:00:18 +0000
References: <20230414162614.571861-1-jacob.e.keller@intel.com>
In-Reply-To: <20230414162614.571861-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 14 Apr 2023 09:26:14 -0700 you wrote:
> Commit e523af4ee560 ("net/ice: Add support for enable_iwarp and enable_roce
> devlink param") added support for the enable_roce and enable_iwarp
> parameters in the ice driver. It didn't document these parameters in the
> ice devlink documentation file. Add this documentation, including a note
> about the mutual exclusion between the two modes.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> [...]

Here is the summary with links:
  - ice: document RDMA devlink parameters
    https://git.kernel.org/netdev/net/c/1a2bd3bd72e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


