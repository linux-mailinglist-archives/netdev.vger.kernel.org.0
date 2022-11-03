Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D5861753E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiKCDu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiKCDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:50:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB28515717
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 20:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80FBEB8265D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 03:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23F81C43146;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667447419;
        bh=ICFVu2uHo/DtiEkpcANmV+ed8HUUbuUbAkyqJHTuESg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MfH+H3smEUwXawdIFkUqJASWB2IAGH2H0RQuB9dE4xaYirSFSQVei8WwemcAlK4rD
         NOFycd+VFd8zEI13Syvv8/gL9lbRnxJouVULNU4GIUVLfIu9MQQyc7Pp2252zMbVSb
         3WGItQXFKCNkdKRk7RpnCSTt2SxjgXj1EMcXwuLkgyJ7KuWDgkbPlQ/KVTaeznNaEo
         XGCspSpHTgu66zVuUnX9a/cMW3A2nBWhynji176wBYcsaBRo7xSBj1XJ+oiYY6xjQA
         Gq6iQPwVqnt6D8S17iIM5lsZo42TqBHSnZmUW5WW9VSMAA1yXqIzYGQ3gCZCbnVYI7
         9DXcx7c0WlaAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DB67E29F4D;
        Thu,  3 Nov 2022 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: broadcom: bcm4908_enet: report queued and
 transmitted bytes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744741905.12191.14956365180051788689.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:50:19 +0000
References: <20221031104856.32388-1-zajec5@gmail.com>
In-Reply-To: <20221031104856.32388-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Oct 2022 11:48:56 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This allows BQL to operate avoiding buffer bloat and reducing latency.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Rebase on top of skb handling fixes
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: broadcom: bcm4908_enet: report queued and transmitted bytes
    https://git.kernel.org/netdev/net-next/c/471ef777ec79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


