Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F040F5B07CD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiIGPAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIGPAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2C358B40
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E926B81DA8
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC76AC43143;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562819;
        bh=pno8yAONzwyJYrOzLGpxlIdYmaHhgHTi2J67eiCTlDY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QBTTKIhhtV1zO3h1LB1NEm2UbKKYPgEIUCO5DsC2Rmlp9zXRhKs+NDIYFz2K7Bcul
         yMN4nMFMOdsiwM7NpbSZAEirsL4s4CMLKKaOm3LuUI/OjpBM2XUniDpMpXvipY0Nud
         CUt/rAl1rNaP1b4ubdLtSPjHgChpnKlJKIi39CRgEWwDOOCVlMHGhuZOJjkTvwX9lt
         +3ojxT2CzIMp1qqtCmrmSV7n45ByOc6hpzHhnWLaRklwpS3cHglO4zaPurMivhnuR0
         WRHDhNuGyjWdYjI4LcciiegHkDFObnZmdEm95FYvzGFR1udmeH8VNAuCkD6Oe/mJF2
         cyjBOA9LNKRJg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D113EC73FF0;
        Wed,  7 Sep 2022 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2022-09-06 (i40e, iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281884.26447.12435996555475757377.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:18 +0000
References: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220906215606.3501995-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue,  6 Sep 2022 14:56:03 -0700 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Stanislaw adds support for new device id for i40e.
> 
> Jaroslaw tidies up some code around MSI-X configuration by adding/
> reworking comments and introducing a couple of macros for i40e.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] i40e: Add basic support for I710 devices
    https://git.kernel.org/netdev/net-next/c/6617be3c154c
  - [net-next,2/3] i40e: add description and modify interrupts configuration procedure
    https://git.kernel.org/netdev/net-next/c/50067bd0fc98
  - [net-next,3/3] iavf: Fix race between iavf_close and iavf_reset_task
    https://git.kernel.org/netdev/net-next/c/11c12adcbc15

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


