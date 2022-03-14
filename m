Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DFE4D8FA7
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245654AbiCNWlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237416AbiCNWlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:41:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99D83EAB6
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 15:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9463CB8108C
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37DEAC340F5;
        Mon, 14 Mar 2022 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647297610;
        bh=5J3TIsfnNpwyXeQtRAQUrNVXRwLVfW3//z+uEQL1N1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kZYFzpICtgFlbu8CY8lrDZQ1aOlTSggfVTP5t1r93AkSJ+Hshou4UbzbMgNJWgdkV
         dTETXpcJ/lpQO4MvrVc0bulDY4vtaq6o5cK11SfQWi1BUfA076ydJ2mUaZIm/o6fqv
         nGbGSqJjQxYZqq3rv8q+yoBSLd9psxkJzJqMphQ5c4iD6+Qey+lbe6TxofEXASeotz
         D+CgIaeixjLr/LTs6YKkVFagjPiTr1USJazJaTvFrnSIZoxWJRF4sWM7uNRMisCtj+
         s//KzXsfZMhpxbRbeQ1ImCHwM0+DelMWSSbAASH5rGQA0l8S5X6pAWIkfwY0yV1elF
         Urb01uBArf+dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1684BEAC09C;
        Mon, 14 Mar 2022 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] nfp: flower: avoid newline at the end of message in
 NL_SET_ERR_MSG_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164729761008.21557.12343235661075468997.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 22:40:10 +0000
References: <20220312095823.2425775-1-niklas.soderlund@corigine.com>
In-Reply-To: <20220312095823.2425775-1-niklas.soderlund@corigine.com>
To:     =?utf-8?q?Niklas_S=C3=B6derlund_=3Cniklas=2Esoderlund=40corigine=2Ecom=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, simon.horman@corigine.com,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 12 Mar 2022 10:58:23 +0100 you wrote:
> Fix the following coccicheck warning:
> 
>     drivers/net/ethernet/netronome/nfp/flower/action.c:959:7-69: WARNING avoid newline at end of message in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: flower: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
    https://git.kernel.org/netdev/net-next/c/bdd6a89de44b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


