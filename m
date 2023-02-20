Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648A369C8FC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjBTKuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjBTKuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A764FBBBC;
        Mon, 20 Feb 2023 02:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BA1FB80C68;
        Mon, 20 Feb 2023 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E4AAC4339E;
        Mon, 20 Feb 2023 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676890217;
        bh=fkE/tCEHY8MUYu9SmsvKs0Adj+VFvuGQSd3ylZhAUQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c6iflmHfeQdSQYeiQuD1+5rJj4X4biV6wEFlt2EjY7wAs0447t5yom4vE/6BqJ7ee
         Ymgvh4Hh4+HTpo23nf2+dtvRFaKzxq9fY9kT5OwQzlLqEnnYPWTQD8U27QYyM8xTpA
         ZXjgqRcaxHkux0A53ZmVQPVyG73oO7Eb3G9Y/ZEvwr0GQCJWWpfe1BiZmZVZFRFYwj
         uTMuNq93xivF9XmtUyMvKN0c1ppaDzMkVqtBbkF5qqkcbnAlNWPT9Tu0/qD7JdcPwI
         Qw+BXh3XV8D4LbtxK5WbjA352zT+fkEIy57gqhgdd9Kpi7ydDIkgVF+zFfdT1MSNLG
         /ndgmEsUgFeDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E9666C59A4C;
        Mon, 20 Feb 2023 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next][V2] sfc: Fix spelling mistake "creationg" -> "creation"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167689021695.13054.3399599919959341923.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:50:16 +0000
References: <20230217143753.599629-1-colin.i.king@gmail.com>
In-Reply-To: <20230217143753.599629-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, alejandro.lucero-palau@amd.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Feb 2023 14:37:53 +0000 you wrote:
> There is a spelling mistake in a pci_warn message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Reviewed-by:  Alejandro Lucero <alejandro.lucero-palau@amd.com>
> ---
> V2: Fix subject to match the actual spelling mistake fix
> 
> [...]

Here is the summary with links:
  - [next,V2] sfc: Fix spelling mistake "creationg" -> "creation"
    https://git.kernel.org/netdev/net-next/c/0d39ad3e1b04

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


