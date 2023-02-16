Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0233C698B1A
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 04:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBPDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 22:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBPDUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 22:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318AE1A4B3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 19:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4C9FB8232F
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 03:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C289C433EF;
        Thu, 16 Feb 2023 03:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676517617;
        bh=yfqzy3EU2KiH1d0N1+Ms3rlY626BGZ1PQE/BDfIiaog=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qZpKVw5mKJD5eZyxvJgxFtGpo6nrsHsiY9n3ziO5kr5tKEmEIgxJnR9uUGp1BNYsD
         4ozTy9I1R2HqDfvoemSX8TzxwZ2orzEeOlSxtlLVPJUph1oylIppplJhW8hmtvV2vn
         C8OZ9eRpiprKdD+b1IuDSsKQOQLGTN2ljY4jTeY27oQiSXUz00cTfxPR209RfCkJGR
         5/IWOaAW6nv88gVdXK9fINsBpbHjKN8gojp7WFK+CxVVNzp/WuISk4nVSDDDMpsSmR
         Ybszik6tja9Io+DsocjH3JDuOFXuMDpAJg6pEQG0FlPtgS9YqxF86IB0AiAORiJQ1S
         a/PdzWyCsZ1zA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 71292E68D2E;
        Thu, 16 Feb 2023 03:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] i40e: check vsi type before setting xdp_features
 flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167651761745.25163.6662453649144442284.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 03:20:17 +0000
References: <f2b537f86b34fc176fbc6b3d249b46a20a87a2f3.1676405131.git.lorenzo@kernel.org>
In-Reply-To: <f2b537f86b34fc176fbc6b3d249b46a20a87a2f3.1676405131.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, lorenzo.bianconi@redhat.com
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

On Tue, 14 Feb 2023 21:07:33 +0100 you wrote:
> Set xdp_features flag just for I40E_VSI_MAIN vsi type since XDP is
> supported just in this configuration.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] i40e: check vsi type before setting xdp_features flag
    https://git.kernel.org/netdev/net-next/c/9dd6e53ef63d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


