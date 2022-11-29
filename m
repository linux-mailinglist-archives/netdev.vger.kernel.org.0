Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CB463C2DB
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbiK2Olh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiK2OlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:41:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CD750D7C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 06:41:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B475EB816AA
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 14:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7421FC433D7;
        Tue, 29 Nov 2022 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669732881;
        bh=0kkyyhSgLrI4rXSrQlPMlfywA33JrsHYrGTUvbEOzvo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ubeaUx38TLq5zH4QNYbc4JNyWakNiAV1jjJwAnHcW+R3TFej3Lu9bq45egxaNchFo
         gbTSEqBT/E630Xh07loIXZweoQGb+pggStMLeoxl3u0VbiCjIfopVCiBnOC2tmDqZ9
         rvHUWCTvhd75x6rnJERe16zhm/E5OWWbAsuCMvLNDQ9IB802s1prgLa8qb+MDzc065
         HU8RlpA2bk1U348SDlBtFXOGJjbSxMuyTqHWaEwcJ91mMAECXfftwo7JqGXYuPA/0D
         srW7ZAfdyW90ZKqrhbQYkWlHYhF4/k4x8+dreQmvCON+Kd37+Lrt935l6PTBHcEGSr
         RMixvQRWfKyMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60B11E21EF5;
        Tue, 29 Nov 2022 14:41:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] nfp: ethtool: support reporting link modes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166973288139.21597.1559559990332738453.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 14:41:21 +0000
References: <20221125113030.141642-1-simon.horman@corigine.com>
In-Reply-To: <20221125113030.141642-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, alexandr.lobakin@intel.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com,
        louis.peens@corigine.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 25 Nov 2022 12:30:30 +0100 you wrote:
> From: Yu Xiao <yu.xiao@corigine.com>
> 
> Add support for reporting link modes,
> including `Supported link modes` and `Advertised link modes`,
> via ethtool $DEV.
> 
> A new command `SPCODE_READ_MEDIA` is added to read info from
> management firmware. Also, the mapping table `nfp_eth_media_table`
> associates the link modes between NFP and kernel. Both of them
> help to support this ability.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] nfp: ethtool: support reporting link modes
    https://git.kernel.org/bpf/bpf-next/c/a61474c41e8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


