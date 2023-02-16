Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F9B698C67
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjBPFuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBPFuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A880A27D7B;
        Wed, 15 Feb 2023 21:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 610EAB825CB;
        Thu, 16 Feb 2023 05:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0607FC433D2;
        Thu, 16 Feb 2023 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676526617;
        bh=gAJ221uwCI4WaYxB4V6rKbAINzl+xXKN90Zc6du0RS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CupDsaf/VmPUOiCb9eQuQRwOjkLeoHHhNOWjHUMBEAx0eb9TnKVWTCLPXVBgicRP9
         +4UI4IiM2ILS3TLzoXewtG0AH7w0aID4Gs0HDzbf1Ru/fiQUlapc8mIcldqTMnaPjC
         I6688/KXktIvrQcYGgSPIkVBsfVh6Yz1z29RInR0Al3mbuF19ILNtaFp29Ljp3Ewyb
         zDP6I6DLuUqFCMSTU19GOwhldHpYoPDW46K5IhEv7bODa4Uww5WubPfWHxQVM0Cn8f
         7GpNgswu6mm/5J/t3yXtlQ9JenTkIeJj4PlwsVSCAn1WgIL5KeiAaOQckDwqCfO3Er
         uiMXNI75yqHzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCE2AE21EC4;
        Thu, 16 Feb 2023 05:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] Documentation: core-api: packing: correct spelling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167652661689.16004.757735594376834454.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 05:50:16 +0000
References: <20230215053738.11562-1-rdunlap@infradead.org>
In-Reply-To: <20230215053738.11562-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, olteanv@gmail.com,
        netdev@vger.kernel.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, quic_mojha@quicinc.com,
        daniel.m.jordan@oracle.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Feb 2023 21:37:38 -0800 you wrote:
> Correct spelling problems for Documentation/core-api/packing.rst as
> reported by codespell.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> 
> [...]

Here is the summary with links:
  - [v3] Documentation: core-api: packing: correct spelling
    https://git.kernel.org/netdev/net-next/c/1f26c8b7507c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


