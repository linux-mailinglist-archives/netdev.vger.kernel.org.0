Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B8068CA30
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjBFXBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjBFXBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:01:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C765430EA0;
        Mon,  6 Feb 2023 15:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1C1261053;
        Mon,  6 Feb 2023 23:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0646BC4339B;
        Mon,  6 Feb 2023 23:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675724418;
        bh=QG2YBrV/adBMQWEYvrCLms4K8cp/bkCC8oogOhxKCrs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DLmFIcEybLIfQKL56XNZI/5gyRyF52YRMOp9NE3TEXeyGCLc8ez0Vxpr6GegRyxxS
         w9ldk6KTlq5/rjjK6fRRKYp7E3RH5GMc14Y7pH9MA9Xt6jHfwVimiEYuNZOXrYzNkX
         JKOwTpCGE0G3G3zpyN68SO8RPd/Unn7ntjev2rxKqAg0XW+u5Ph24T4I8n2e8sJasI
         IKG90IIJ0s8dKmlaB0a6tmHh0wz5PoZ1nHKPwarqbLhAgb3YESpeBEhDvtyCFcOeGr
         oEyeoBErEDaZ4ncpMv1R95Hl4HsVD1jOGcfdlyBirADgXSmJkyb2HaKr51h7JdAux2
         OekTrquXNOvPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2D64E55F07;
        Mon,  6 Feb 2023 23:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] selftests/bpf: Fix spelling mistake "detecion" ->
 "detection"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167572441792.26837.8769229954804516382.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 23:00:17 +0000
References: <20230206092229.46416-1-colin.i.king@gmail.com>
In-Reply-To: <20230206092229.46416-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     lorenzo@kernel.org, shuah@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon,  6 Feb 2023 09:22:29 +0000 you wrote:
> There is a spelling mistake in a literal string. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/testing/selftests/bpf/xdp_features.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] selftests/bpf: Fix spelling mistake "detecion" -> "detection"
    https://git.kernel.org/bpf/bpf-next/c/8306829bf845

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


