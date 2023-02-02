Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFE2687430
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 05:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjBBEAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 23:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBBEAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 23:00:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C3974A52
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 20:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D2EA619EF
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77A0DC433AC;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675310418;
        bh=LvWnw8/WM02ok1VHHOTrLXo1fvqFmaaZS/tin6+qLzg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jT3RouQzEm+hfa1uZIfVSALHkP9l5yz1djzrvDBtnSdnNZ/TuKqPw0Yfl3UU46JRY
         02NIp9bZxZD2/K5E5w7UC0/OSvFNdzmrvk+XUnTu2SMoVQ4ddWRRsAT+tzMyIYm/qU
         VqBhuGmfLZCT5/gJ7YandkT8cxWZgwilM3MCFR6Sifr/4p3sfUaDHdiDCiYfiwvvHn
         jXolTTaQXrp6HXmJ4V19z5Yu4K7M4qCC67k9ZXk5wJqjaTnJSFDFa/g55rln4/XYwN
         T/XwWXiN8tgjDlIe0nne8GnND40PIZLCaQGoU3Nxcs9HLwbgnSbS1UUPucGCu2n22P
         gaBo98DaJIe3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61741C0C40E;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: correct cleanup related to DCB resources
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531041839.2562.5723503140322662448.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 04:00:18 +0000
References: <20230131163033.981937-1-simon.horman@corigine.com>
In-Reply-To: <20230131163033.981937-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        huayu.chen@corigine.com, niklas.soderlund@corigine.com
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

On Tue, 31 Jan 2023 17:30:33 +0100 you wrote:
> From: Huayu Chen <huayu.chen@corigine.com>
> 
> This patch corrects two oversights relating to releasing resources
> and DCB initialisation.
> 
> 1. If mapping of the dcbcfg_tbl area fails: an error should be
>    propagated, allowing partial initialisation (probe) to be unwound.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: correct cleanup related to DCB resources
    https://git.kernel.org/netdev/net-next/c/ca3daf437d9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


