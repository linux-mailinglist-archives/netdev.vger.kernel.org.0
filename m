Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EAE6C8A32
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 03:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjCYCUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 22:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjCYCUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 22:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D9E6EAD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 19:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E65B62D2F
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFF3FC433A4;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679710818;
        bh=rO7wTihAc7U2UFmsdbOqW9bnqjNqfvLtSw/SjMTfeac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJ7b/kp0fgAi9X2gX6+OGPCLHbpDMRnDfn9pAa0tTzYGJvRI0BvHz+lR4OBgjS15Y
         c747p5G4NluDIoGv945PiQNjNRXkSxAjznT3bE6DnucVuqVwxdIC2Jp/2ppTl26DXi
         7M78B4JemKMaDgu0tD7u0AE6GPP+eb6UGdgE24kGtKG4NaRpS94krr3dAikNZEpQOF
         Ftb2U44P/iioFQFOX8qSzv9iIYgY3m34Q0aeUwkoa76ipNTzkkHOSyMv1JB5LC0bi4
         97Nf6BX2PpdhotPj2VrUXyQN/N6sjR4/IJwFq8cMsH5ZLzDwYHYQEbEcqLBuERo6qc
         ev/7//eohbkfQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB11FE4D021;
        Sat, 25 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] tools: ynl: add the Python requirements.txt file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167971081882.20950.10790781298829482556.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Mar 2023 02:20:18 +0000
References: <20230323190802.32206-1-michal.michalik@intel.com>
In-Reply-To: <20230323190802.32206-1-michal.michalik@intel.com>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 20:08:02 +0100 you wrote:
> It is a good practice to state explicitly which are the required Python
> packages needed in a particular project to run it. The most commonly
> used way is to store them in the `requirements.txt` file*.
> 
> *URL: https://pip.pypa.io/en/stable/reference/requirements-file-format/
> 
> Currently user needs to figure out himself that Python needs `PyYAML`
> and `jsonschema` (and theirs requirements) packages to use the tool.
> Add the `requirements.txt` for user convenience.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] tools: ynl: add the Python requirements.txt file
    https://git.kernel.org/netdev/net-next/c/bc77f7318da8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


