Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CCC6084C6
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 07:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVFuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 01:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJVFuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 01:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB26DC4D9F
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 22:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6591D60A4D
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C0088C433D6;
        Sat, 22 Oct 2022 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666417818;
        bh=Ed4rck0yBwtMD3DwtbpesWVeT2FUiPrROI7Zt9EnqSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s5V+5iw0t+v0ohnJ1uGr8g6D1ujS/bq8gLFl/TIVhGLRqNKuxS76OA6DmfbO/Wnf0
         lL4+a9DeQV37nXth8OcmIGeoADwDR8C8USmiF4WX3TZjAOh5Cp7UcfeiKz/P1pc7Wz
         WjHwjmhN46UGEiUtLOMtefGKy1CdsnqSPDwajaLR25EnnNE9dlQIlVvywruyARzCkK
         uRaR9SCZhqgGNfw3K18hXanLIFYlWC+DT4AYm2fcHY5fwD0QU7WTJHCNo1aahwM7S1
         hlyrKB08F0RRhcXqyECzCKs5I5YgO/Fa0VLLuEd5YPscL7FsGPXsTd12UoatM556Iw
         o9qADImRWpFWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1B8BC4166D;
        Sat, 22 Oct 2022 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: only clean `sp_indiff` when application firmware is
 unloaded
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166641781865.12745.11154802832887559310.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Oct 2022 05:50:18 +0000
References: <20221020081411.80186-1-simon.horman@corigine.com>
In-Reply-To: <20221020081411.80186-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yinjun.zhang@corigine.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Oct 2022 09:14:11 +0100 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Currently `sp_indiff` is cleaned when driver is removed. This will
> cause problem in multi-PF/multi-host case, considering one PF is
> removed while another is still in use.
> 
> Since `sp_indiff` is the application firmware property, it should
> only be cleaned when the firmware is unloaded. Now let management
> firmware to clean it when necessary, driver only set it.
> 
> [...]

Here is the summary with links:
  - [net] nfp: only clean `sp_indiff` when application firmware is unloaded
    https://git.kernel.org/netdev/net/c/0bda03623e6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


