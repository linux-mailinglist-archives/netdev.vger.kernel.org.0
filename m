Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F16A66A97E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 06:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjANFub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 00:50:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjANFu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 00:50:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A723AAA
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A1DDB82313
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2128C43396;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673675418;
        bh=1FtQ9PaZYK7m94OV0vl3OkuQtNBlLDh7hv4lV0CRkmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nsCvd6wSm0GDCdJoTypOBBPS8ht9cMI45KSlBcfsm9vPCLduPXamvtM94wjLC1NUi
         PXqY/jhRYbzeM9mXEif+4Dt3JlU5U5IEXItmPcnTpis9w3cd+L/DX00ysbH2yl99HG
         yl85hiOrB1hhcsI79v3K2gpRVoSymNEwFZOVPg0TD4Em4tRBX24tPMCvhsaebIoTn/
         aJzXTAg3Q/RLpIpaXCPe2LyT8AD/RQ8ThJuNY/M6/LTVi/xBvvFdIih5tXi+MW14R3
         rMvvDbXeYbc+KkgZlxIs71iPnoqAvQYE5+ag6NxqDSoaipdPPvbg4cuyv6wrsqLsq3
         mitMkVKPpim8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 927DBE270DE;
        Sat, 14 Jan 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] nfp: add DCB IEEE support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367541859.15756.16385132152590185218.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 05:50:18 +0000
References: <20230112121102.469739-1-simon.horman@corigine.com>
In-Reply-To: <20230112121102.469739-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        bin.chen@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 13:11:02 +0100 you wrote:
> From: Bin Chen <bin.chen@corigine.com>
> 
> Add basic DCB IEEE support. This includes support for ETS, max-rate,
> and DSCP to user priority mapping.
> 
> DCB may be configured using iproute2's dcb command.
> Example usage:
>   dcb ets set dev $dev tc-tsa 0:ets 1:ets 2:ets 3:ets 4:ets 5:ets \
>     6:ets 7:ets tc-bw 0:0 1:80 2:0 3:0 4:0 5:0 6:20 7:0
>   dcb maxrate set dev $dev tc-maxrate 1:1000bit
> 
> [...]

Here is the summary with links:
  - [v2,net-next] nfp: add DCB IEEE support
    https://git.kernel.org/netdev/net-next/c/9b7fe8046d74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


