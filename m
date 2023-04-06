Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF06D8BE5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbjDFAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjDFAaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:30:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565C66A41
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B912064246
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13F54C433D2;
        Thu,  6 Apr 2023 00:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680741019;
        bh=Ap/gg2rUxuPLRxxxySW80H9j3RPYH93794k1F9745WI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ucs/ZEFcNPIwgSqFGc62YlkC1bQQWmhzrc3g2ZZsvq8FJiApnpUezfCrR8yGooH9Q
         7GvOrpJmvkcu+cqvjyCm0EFPNHxv2Gp3qjWefmI5lPTVygICu9rQTuaIXGO0ZxHoAP
         Fxa5Xa4AzIB2anHCfgkF+PLNkKGBR5Qut0gzzrb8irM+JJTPGKviMfxyaW2AjR2yHT
         rKH6Qe6iO16BZtiFfnb+Ukd0cY5oWGoikjJH/xOxMiC0N8julixK8r0+b8CWD4QJGN
         GAKFe+EGmHiVINbNuyUDJk9gTJdJg1lysjFVzSUWw4liMwmbHxtDCxAv6n0KcVdQro
         7GW1R8v8vyEuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7506E2A033;
        Thu,  6 Apr 2023 00:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-04-04 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074101894.1850.14977603187683251401.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 00:30:18 +0000
References: <20230404172306.450880-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230404172306.450880-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  4 Apr 2023 10:23:04 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Simei adjusts error path on adding VF Flow Director filters that were
> not releasing all resources.
> 
> Lingyu adds setting/resetting of VF Flow Director filters counters
> during initialization.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: fix wrong fallback logic for FDIR
    https://git.kernel.org/netdev/net/c/b4a01ace20f5
  - [net,2/2] ice: Reset FDIR counter in FDIR init stage
    https://git.kernel.org/netdev/net/c/83c911dc5e0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


