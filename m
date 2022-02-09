Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8384AE93C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiBIF1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0033FC03C191
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACD93B81ED9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E315C340F1;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=qiOZ+wcxF+2V/Y2c1LH8aQtTeyvVHxoatc2wQ3f3UWk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JG8vFKibpq1FiUinQ2K5ex2cb4EXWzp0+bDk57KyQuwUVzC0vYUAHlGbwZWYRzgD/
         dLrCaWuHCDIQuds71bM/ybTY/Ir4UiaWilZehJZaOClsqftQ6/dA3zhOj0AiMT0BnM
         zyGXdso6Y17RSrCgCXxgg9YTmjcJroX3cDEQ7zR8JIX7TRH6O2MGzuylfCW1qOjWkY
         SWDW1juOMpPz90fybV4zM1kccdjS9SEUPQ71PONNcpDtcZA9iq1LWwRBnU2OeqB1MC
         +agOcpnHENe4LNQYwxIoq8gC14xbpMHgXWQyfAEjvfM+dJDFTX4no5R/cxotCM71EY
         ape1fULpzJWcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 56B6CE6D446;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Recording rx queue before sending to napi
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402834.12376.12588793749111120621.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220207175901.2486596-1-jeroendb@google.com>
In-Reply-To: <20220207175901.2486596-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        xliutaox@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  7 Feb 2022 09:59:01 -0800 you wrote:
> From: Tao Liu <xliutaox@google.com>
> 
> This caused a significant performance degredation when using generic XDP
> with multiple queues.
> 
> Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
> Signed-off-by: Tao Liu <xliutaox@google.com>
> 
> [...]

Here is the summary with links:
  - [net] gve: Recording rx queue before sending to napi
    https://git.kernel.org/netdev/net/c/084cbb2ec3af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


