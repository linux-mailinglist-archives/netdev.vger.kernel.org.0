Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DF56076D1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJUMU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiJUMUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:20:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA08159942;
        Fri, 21 Oct 2022 05:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0103B82BCB;
        Fri, 21 Oct 2022 12:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86D1EC433D7;
        Fri, 21 Oct 2022 12:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666354817;
        bh=KcEoBm+IfbAhEsu+Yoow6II/ten/SYrINxEdlA3/eRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M34U+Sur7NmJnTdUgGo/6/FqWBAiZTwYuvGhL3VglrxyD5tUAQCZRjTczYaRd4mzn
         I043YFkwi8yWuKb3enqwPdEPxROsADsxqBb84zkCL4mFa5ZiUaR0gZoJqD2r9eliQz
         R1A025YwSorCWAZCTEefekS+LloRiy3wmHJNiMPG4+3opLXUL6xSg2D3i9efKjs8eQ
         wxI7vq7gJFxZFanK57uuzK0rx9aVsBYgppaNz3j68CDvCVb3WWMr7c1BL/ee26M71p
         KAEk3wfi/K6pvKMbv4MaUKJVgquvPQfmVDtZ+OoH+BiWQNv17JoyMflpBAds/mdME6
         iryjyvfmq6/Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6319FE270DF;
        Fri, 21 Oct 2022 12:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next] net: ipa: Make QMI message rules const
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166635481740.23176.9605046076231339926.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 12:20:17 +0000
References: <20221018211718.23628-1-quic_jjohnson@quicinc.com>
In-Reply-To: <20221018211718.23628-1-quic_jjohnson@quicinc.com>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     elder@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, elder@linaro.org,
        quic_sibis@quicinc.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 18 Oct 2022 14:17:18 -0700 you wrote:
> Commit ff6d365898d4 ("soc: qcom: qmi: use const for struct
> qmi_elem_info") allows QMI message encoding/decoding rules to be
> const, so do that for IPA.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Reviewed-by: Alex Elder <elder@linaro.org>
> Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: ipa: Make QMI message rules const
    https://git.kernel.org/netdev/net-next/c/c0facc045a14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


