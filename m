Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766676941E5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBMJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbjBMJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 316B946B8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92E14B80F62
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DBD8C43444;
        Mon, 13 Feb 2023 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281817;
        bh=PYTS70JDpyKaSBmJT56EJcxgIYwEWEyw3ftrzMwVaig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NN+/E1uke+sp9oRDLCJINNo0HLBh9msJP2vch/SUcb5sbHLyChlol3JIdzwCtaC4+
         OOFbotKUlsune7By16Y0Noj0OF5udaaECJNw57WKM2gLayx1IV5H+AkpZ9daMyOIQx
         o/kmnlU4fvtw7oXLG2CzMgOiv/RoGK/IdhB6KqdE9RHsbT76bhve4hIKyAPqvGD0fZ
         SyI8G3j3kCJL7SgNV942qC7Q/Tud/ltak0OcSHysRGReeKirhWvDuWumBUCDOeWxuV
         E9PiuySD42ja3kSYyxpIMN0Hwfkj2h5LWOSndEdcZgKD9jMXMaay6NL2SfHb2ccvXP
         rzZKBmXtdSTiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3805EC41676;
        Mon, 13 Feb 2023 09:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: ethtool: supplement nfp link modes supported
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628181721.13846.14916254768139194846.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:50:17 +0000
References: <20230210095319.603867-1-simon.horman@corigine.com>
In-Reply-To: <20230210095319.603867-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        yu.xiao@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 10:53:19 +0100 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for the following modes to the nfp driver:
> 
> 	NFP_MEDIA_10GBASE_LR
> 	NFP_MEDIA_25GBASE_LR
> 	NFP_MEDIA_25GBASE_ER
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: ethtool: supplement nfp link modes supported
    https://git.kernel.org/netdev/net-next/c/170677fee45b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


