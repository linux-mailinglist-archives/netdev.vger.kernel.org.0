Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6509967DEA5
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 08:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbjA0HkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 02:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjA0HkV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 02:40:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB8159E4F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 23:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7955B81FAB
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58DBFC433A0;
        Fri, 27 Jan 2023 07:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674805218;
        bh=0F0iobCOXGjIe5DssXUZbUvSGlBitG9slEzlyEDoCac=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHpVL3w9OcG5s8ZQ0Zmm9nfTTx2PAMzwUdjC3+aGl/NjhedRUmSulf1AxRgeVocBT
         wXwPAbEgSgu6/yjAdD92wUGVTie+xaZToP7RBo1Oi5oZmIBtlRk3QASbExizeR6+Ft
         WDG7VveVw7gLPCAwrPk5YnaCVqlKCM7QRcPn/xhYcAq/v5VQC+vs+nFjka/pmP5x8B
         dJ8PxvWt98oog0xqjmiBhsxsVIylv5fwiXj8Yy2zlcAmF4LWdEgnnkyFINqTLtKD1F
         AuW7a8tEBI1TYyrsnX/coFYoN5uO8KyFsC/4Dxpzz027HGJuXmeffZiB0Py0ljBxzD
         +oai02AfHwGFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44275E52508;
        Fri, 27 Jan 2023 07:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4][pull request] virtchnl: update and refactor
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167480521827.25138.15812033474138366168.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 07:40:18 +0000
References: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230125212441.4030014-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 25 Jan 2023 13:24:37 -0800 you wrote:
> Jesse Brandeburg says:
> 
> The virtchnl.h file is used by i40e/ice physical function (PF) drivers
> and irdma when talking to the iavf driver. This series cleans up the
> header file by removing unused elements, adding/cleaning some comments,
> fixing the data structures so they are explicitly defined, including
> padding, and finally does a long overdue rename of the IWARP members in
> the structures to RDMA, since the ice driver and it's associated Intel
> Ethernet E800 series adapters support both RDMA and IWARP.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] virtchnl: remove unused structure declaration
    https://git.kernel.org/netdev/net-next/c/3a6a9b3be290
  - [net-next,2/4] virtchnl: update header and increase header clarity
    https://git.kernel.org/netdev/net-next/c/43fc70a208ce
  - [net-next,3/4] virtchnl: do structure hardening
    https://git.kernel.org/netdev/net-next/c/4e4df55941f0
  - [net-next,4/4] virtchnl: i40e/iavf: rename iwarp to rdma
    https://git.kernel.org/netdev/net-next/c/2723f3b5d4ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


