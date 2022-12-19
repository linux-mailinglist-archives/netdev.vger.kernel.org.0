Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5EC650BE1
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbiLSMkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiLSMkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EAD3A9
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D51FBB80E07
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6526EC433F1;
        Mon, 19 Dec 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671453616;
        bh=8vdV2nx6l2gQaK8Hx5FTMX9EXb0TYVxsYIfg09AIV/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CQY0tXKjC6ga/vm9MijuvzCHenQPQkMyFJT1082unGbbkPggrRGkmFbRIvYcLSgbF
         XFKcBcU6JJktwPbFgYR3xNhJ3Qdz0L7ttpBXAoDxRxlNhtC8Af8PeqawhdZYxHf8/g
         LF/V6lL5hbjmMvyODZp1TFGOL+yM6BWrMrKuEFoIEtvLslt2LwxJvgKaX/VL2PIeJI
         j7XBLCklksdZ4qcSryy05yz8QZaUX2ghbBI9J/HUnqD1rKazYu9odKcB1CRsmh86hv
         /MeLVDgZNiJc0ojVj+/DG8PF5aUnP8cLa/YxQmvKI1OmJpUCAyEplsH9DfaXDjBXAd
         wEK+BWjZcSlyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A6E9E451B6;
        Mon, 19 Dec 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: fix unaligned io read of capabilities word
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167145361630.5637.8547309631313186045.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Dec 2022 12:40:16 +0000
References: <20221216143101.976739-1-simon.horman@corigine.com>
In-Reply-To: <20221216143101.976739-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        huanhuan.wang@corigine.com, niklas.soderlund@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Dec 2022 15:31:01 +0100 you wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> The address of 32-bit extend capability is not qword aligned,
> and may cause exception in some arch.
> 
> Fixes: 484963ce9f1e ("nfp: extend capability and control words")
> Signed-off-by: Huanhuan Wang <huanhuan.wang@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: fix unaligned io read of capabilities word
    https://git.kernel.org/netdev/net/c/1b0c84a32e37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


