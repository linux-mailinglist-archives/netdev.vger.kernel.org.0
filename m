Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6183256950C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 00:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiGFWKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiGFWKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 18:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7355D24097
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 15:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 280A7B81F1C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 22:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2B15C341C6;
        Wed,  6 Jul 2022 22:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657145413;
        bh=DOEcK554ykF3UcKWHcH0ZfA17V1fao05KB1SV64uoJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BYAlb0iGc1czr4DZThnFClDHjWKQ6oISr6VLTrc7lVXxM3dxfNTnTdgik8gGq6lO1
         J9oCjeQrDS43t2ZhvTPZUDSjXIFv6pi6BS76mvFTYljiz20HJkOSJ4OxU4q7Vm4lSO
         pw5NiC8wCWkrFvRSPydV3zhV8lx9EIWyEH/vWPJZiRKhf/P9Ki+uszzo72saZHYzYS
         gS9iiNaS61w/VgG8fztb//kuQcPlWoPWQ451LNy63BThl6MxQq/9rJIxvjIbMi76Pb
         xRJEYErVQIL5XkHpQcwvcdtjE5++cSSyVzryyomHfNB5Sln1Cz8dYY+6EybYm3MtUo
         7zsChYWcizwVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFEB3E45BDC;
        Wed,  6 Jul 2022 22:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "tls: rx: move counting TlsDecryptErrors for sync"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165714541371.11403.8303573011858062289.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Jul 2022 22:10:13 +0000
References: <20220705110837.24633-1-gal@nvidia.com>
In-Reply-To: <20220705110837.24633-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maximmi@nvidia.com, tariqt@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 5 Jul 2022 14:08:37 +0300 you wrote:
> This reverts commit 284b4d93daee56dff3e10029ddf2e03227f50dbf.
> When using TLS device offload and coming from tls_device_reencrypt()
> flow, -EBADMSG error in tls_do_decryption() should not be counted
> towards the TLSTlsDecryptError counter.
> 
> Move the counter increase back to the decrypt_internal() call site in
> decrypt_skb_update().
> This also fixes an issue where:
> 	if (n_sgin < 1)
> 		return -EBADMSG;
> 
> [...]

Here is the summary with links:
  - [net] Revert "tls: rx: move counting TlsDecryptErrors for sync"
    https://git.kernel.org/netdev/net/c/a069a9055416

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


