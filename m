Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A65C519CCD
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348085AbiEDKYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348031AbiEDKXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEB8250
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C7B561AE0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85E6DC385AE;
        Wed,  4 May 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651659612;
        bh=wnhAgIC68NWjrammdCAXGlw+DL9iIKCg29klgLEc1dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k0nNdvZlitEKd6UnUY0FiVeu8BbltjsXz1uZePDoIAWa5cbZPC1qHfjCkMcb66xnG
         zfdP0RWyLlQ92JhdmXT5yjE1SVd1ZsKfyKnc8z2/Zfy3a9OvUftxXvxqlGCBU2fRlI
         ArVkk6j3US/GUWg1CIbRP0q8/WZm9u8Y4Q9pGQCvCRbmyEg0DUPO3JFPG6vSTFlsb4
         eI0/JI9GFwkp9iBJS4nPrJMKp+1948k1hKmaQyMOD3+8ZYKx8CmclLSH7xlyRCUZ0/
         9OjVICTVPK1cTUuTjOXcUAhUnHBKvkrgMFk1f2QYghwGI56EbknbqdvFpAlouvunnR
         dVHt7ohjc67zQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5D6C6F0384A;
        Wed,  4 May 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate subdirectory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165165961237.23467.13236982378468818467.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 10:20:12 +0000
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
In-Reply-To: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 04 May 2022 08:49:41 +0100 you wrote:
> The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> Most of these adapters have been remove from our test labs, and testing
> has been reduced to a minimum.
> 
> This patch series creates a separate kernel module for the Siena architecture,
> analogous to what was done for Falcon some years ago.
> This reduces our maintenance for the sfc.ko module, and allows us to
> enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/13] sfc: Disable Siena support
    https://git.kernel.org/netdev/net-next/c/0c38a5bd60eb
  - [net-next,v3,02/13] sfc: Move Siena specific files
    (no matching commit)
  - [net-next,v3,03/13] sfc: Copy shared files needed for Siena (part 1)
    (no matching commit)
  - [net-next,v3,04/13] sfc: Copy shared files needed for Siena (part 2)
    (no matching commit)
  - [net-next,v3,05/13] sfc: Copy a subset of mcdi_pcol.h to siena
    (no matching commit)
  - [net-next,v3,06/13] sfc/siena: Remove build references to missing functionality
    (no matching commit)
  - [net-next,v3,07/13] sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,08/13] sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,09/13] sfc/siena: Rename peripheral functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,10/13] sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,11/13] sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,12/13] sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,13/13] sfc: Add a basic Siena module
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


