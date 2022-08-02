Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8895B58788E
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 10:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiHBIAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 04:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiHBIAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 04:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C37FE4;
        Tue,  2 Aug 2022 01:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C341561468;
        Tue,  2 Aug 2022 08:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27BC2C433B5;
        Tue,  2 Aug 2022 08:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659427214;
        bh=vi8rmU/UnEIHRCSFSG7YgXVQCZZeFIzq638X8Qjzbjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fCHTyiNJS5ME2SnuU5l7CdB5X/5h1EHhjMt6qljvynDMszyw5cE47NCkHAgfLa3lp
         enIZyKLjjYqfWrk1SWeQo1u9JgFQAbJBb2zC3ZLy7cj1rMpH5v4MCDEca7R2I4DiaG
         lwb5ke2SU2zD2GNt3jNSnu770nTzPBmKBoVD85WfBQuR3QhqMLEVQcXr8539Aftq7o
         PYj3mf38vW46KyPB/+eF0Q0yJeIXFt0GDrM+8TTUOWLvdC6oWR2OOWVeGZQHT3T6nX
         Pml6kvCyhMA4fqcFmU+jA8OcXzfxfvMpopcEoojHc11yny+snC7WSdkrj+ivJee2sJ
         LjK+ntEfYHahg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DD13C43143;
        Tue,  2 Aug 2022 08:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] selftests: net: fix IOAM test skip return code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165942721405.6972.11037268506015977032.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 08:00:14 +0000
References: <20220801124615.256416-1-kleber.souza@canonical.com>
In-Reply-To: <20220801124615.256416-1-kleber.souza@canonical.com>
To:     Kleber Sacilotto de Souza <kleber.souza@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, justin.iurman@uliege.be, kuba@kernel.org,
        davem@davemloft.net, shuah@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  1 Aug 2022 14:46:15 +0200 you wrote:
> The ioam6.sh test script exits with an error code (1) when tests are
> skipped due to lack of support from userspace/kernel or not enough
> permissions. It should return the kselftests SKIP code instead.
> 
> Reviewed-by: Justin Iurman <justin.iurman@uliege.be>
> Signed-off-by: Kleber Sacilotto de Souza <kleber.souza@canonical.com>
> 
> [...]

Here is the summary with links:
  - [RESEND] selftests: net: fix IOAM test skip return code
    https://git.kernel.org/netdev/net-next/c/1995943c3f2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


