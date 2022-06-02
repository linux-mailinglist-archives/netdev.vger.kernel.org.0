Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3359953BBD5
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiFBPuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiFBPuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A6A2E09B;
        Thu,  2 Jun 2022 08:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAA926124C;
        Thu,  2 Jun 2022 15:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14F9CC3411E;
        Thu,  2 Jun 2022 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654185013;
        bh=wB/MEXAf/c0kGO3cPyTVqTrfCM+kgdsXTuQGvpftntI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wc9zwc9sIm3iry68zZ2UoKsXulPDc+lwLsSzLtvmUuVn1LgEU7QuT0MDccsntEr+R
         I+FbuGKanpMebKkSxFy4A2/l9kpGI+jh80EJjCQJBLwmnDzk7M1hc8cxPVynP+LCNJ
         w26BsnEZYAQ4oG66tsjypzF6kUYDQJJLQAZXI4nYcm8SXoVvr35FWe6FfoBEppvXQ2
         7WbPvgJ7DmA+LLe7AwBYnli8vH5BKrl4MCAU6eW4nHGIaEoErWI7qgpOnKfqwCWq/H
         M+cMPO9EXQKyOAvduyqnYx7M2zHjDvp79PJ6lIi27An/ZKEXXkcA3jNDAyk7BGYJaX
         NC0Eb+RzgwnjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EE707F03953;
        Thu,  2 Jun 2022 15:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Bluetooth: clear the temporary linkkey in hci_conn_cleanup
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165418501297.10758.2881771584555714145.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Jun 2022 15:50:12 +0000
References: <20220602151456.v2.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
In-Reply-To: <20220602151456.v2.1.I9f2f4ef058af96a5ad610a90c6938ed17a7d103f@changeid>
To:     Alain Michaud <alainmichaud@google.com>
Cc:     linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org, alainm@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, marcel@holtmann.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Thu,  2 Jun 2022 15:15:03 +0000 you wrote:
> From: Alain Michaud <alainm@chromium.org>
> 
> If a hardware error occurs and the connections are flushed without a
> disconnection_complete event being signaled, the temporary linkkeys are
> not flushed.
> 
> This change ensures that any outstanding flushable linkkeys are flushed
> when the connection are flushed from the hash table.
> 
> [...]

Here is the summary with links:
  - [v2] Bluetooth: clear the temporary linkkey in hci_conn_cleanup
    https://git.kernel.org/bluetooth/bluetooth-next/c/5a4e1528d840

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


