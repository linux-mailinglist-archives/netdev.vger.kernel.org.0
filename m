Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA86EA1DB
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjDUCuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233520AbjDUCuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CE9E75
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 19:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6644764D32
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC49AC433EF;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682045419;
        bh=juz8musyecxrXy/QijPCI70uAjJXblbuD5kvaDJYt0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eF7N9KTXv0OYdDdcUw3BQyGXGY0pIbgJkjLws+OQAsPCLn96Q9zReVA27H8uOOHDa
         keqUJjXWn9Fui6WWSWcnzpSpS762da52cqU+eEalGo0C01ORpOHS/E5OPxhx77BZf2
         +cPTV8N4Gv/Oktuy20mrhe/CEbs88FklPB7xuA5hsmj+tN+WEhmYgLca9z23y3/VIQ
         yz0cx63VAZwIqmdnkHTNltNDn9zE/qebX+XTaF9TfxP1Hii/jp7jkZkCUC8Jp3DNy7
         o+kdQvbGpbP2BhtrhC+kRd77IK0NIvc8x6foK5uXfUNw3cZrn1TPi3MpSQA3MSNgPS
         lPaGT+jw3u/yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D6EDE501E7;
        Fri, 21 Apr 2023 02:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] flow_dissector: Address kdoc warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168204541963.19656.10354720997104249307.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 02:50:19 +0000
References: <20230419-flow-dissector-kdoc-v1-1-1aa0cca1118b@kernel.org>
In-Reply-To: <20230419-flow-dissector-kdoc-v1-1-1aa0cca1118b@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 19 Apr 2023 13:34:35 +0200 you wrote:
> Address a number of warnings flagged by
> ./scripts/kernel-doc -none include/net/flow_dissector.h
> 
>  include/net/flow_dissector.h:23: warning: Function parameter or member 'addr_type' not described in 'flow_dissector_key_control'
>  include/net/flow_dissector.h:23: warning: Function parameter or member 'flags' not described in 'flow_dissector_key_control'
>  include/net/flow_dissector.h:46: warning: Function parameter or member 'padding' not described in 'flow_dissector_key_basic'
>  include/net/flow_dissector.h:145: warning: Function parameter or member 'tipckey' not described in 'flow_dissector_key_addrs'
>  include/net/flow_dissector.h:157: warning: cannot understand function prototype: 'struct flow_dissector_key_arp '
>  include/net/flow_dissector.h:171: warning: cannot understand function prototype: 'struct flow_dissector_key_ports '
>  include/net/flow_dissector.h:203: warning: cannot understand function prototype: 'struct flow_dissector_key_icmp '
> 
> [...]

Here is the summary with links:
  - [net-next] flow_dissector: Address kdoc warnings
    https://git.kernel.org/netdev/net-next/c/8c966a10eb84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


